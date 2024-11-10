-- THIS VERSION USES THE FOLLOWING:
-- a. balance_amt in setting the changes
-- b. account_no = 409000611074
-- c. set change to 123456.50

-- 1. READ UNCOMMITTED with Dirty Read

-- Transaction A: Uncommitted update with delay
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
UPDATE Accounts 
SET balance_amt = balance_amt + 123456.50 
WHERE account_no = '409000611074';
SELECT balance_amt AS "1 Transaction A (Uncommitted Update)" 
FROM Accounts 
WHERE account_no = '409000611074'
LIMIT 10; -- a limit was put so it's easier to see the results, remove if you want to
DO SLEEP(5);
ROLLBACK;

-- Transaction B: Dirty read before Transaction A rolls back
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
DO SLEEP(1);
SELECT balance_amt AS "1 Transaction B (Dirty Read)" 
FROM Accounts 
WHERE account_no = '409000611074'
LIMIT 10; -- a limit was put so it's easier to see the results, remove if you want to
COMMIT;

-- 2. READ UNCOMMITTED with Non-Repeatable Read

-- Transaction A: Commit an update after initial read
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
UPDATE Accounts 
SET balance_amt = balance_amt + 123456.50
WHERE account_no = '409000611074'
LIMIT 10;
DO SLEEP(5);
COMMIT;

-- Transaction B: Initial and repeated reads to observe non-repeatable effect
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
SELECT balance_amt AS "2 Transaction B (Initial Read)" 
FROM Accounts 
WHERE account_no = '409000611074'
LIMIT 10;
DO SLEEP(2);
SELECT balance_amt AS "2 Transaction B (Post-Update Read)" 
FROM Accounts 
WHERE account_no = '409000611074'
LIMIT 10;
COMMIT;

-- 3. READ UNCOMMITTED with Phantom Read

-- Transaction A: Insert new row
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
INSERT INTO Accounts (account_no, balance_amt) 
VALUES ('409000611074', 123456.50);
DO SLEEP(5);
COMMIT;

-- Transaction B: Count rows before and after insert
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
SELECT COUNT(*) AS "3 Transaction B (Initial Count)" 
FROM Accounts 
WHERE balance_amt > 1000;
DO SLEEP(2);
SELECT COUNT(*) AS "Transaction B (Post-Insert Count)" 
FROM Accounts 
WHERE balance_amt > 1000;
COMMIT;