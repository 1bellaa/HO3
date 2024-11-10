-- 4. READ COMMITTED with Dirty Read

-- Transaction A: Uncommitted update with rollback
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
UPDATE Accounts 
SET balance_amt = balance_amt + 1000 
WHERE account_no = '409000611074';
DO SLEEP(5);
ROLLBACK;

-- Transaction B: Attempt to read uncommitted data
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
DO SLEEP(1);
SELECT balance_amt AS "4 Transaction B (Read Attempt)" 
FROM Accounts 
WHERE account_no = '409000611074'
LIMIT 10;
COMMIT;

-- 5. READ COMMITTED with Non-Repeatable Read

-- Transaction A: Commit update to cause non-repeatable read
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
UPDATE Accounts 
SET balance_amt = balance_amt + 500 
WHERE account_no = '409000611074';
DO SLEEP(2);
COMMIT;

-- Transaction B: Initial read, delay, re-read
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT balance_amt AS "5 Transaction B (Initial Read)" 
FROM Accounts 
WHERE account_no = '409000611074'
LIMIT 10;
DO SLEEP(5);
SELECT balance_amt AS "5 Transaction B (Post-Update Read)" 
FROM Accounts 
WHERE account_no = '409000611074'
LIMIT 10;
COMMIT;

-- 6. READ COMMITTED with Phantom Read

-- Transaction A: Insert new row
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
INSERT INTO Accounts (account_no, balance_amt) 
VALUES ('409000611075', 5000);
DO SLEEP(5);
COMMIT;

-- Transaction B: Count rows before and after insert
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT COUNT(*) AS "6 Transaction B (Initial Count)" 
FROM Accounts 
WHERE balance_amt > 1000
LIMIT 10;
DO SLEEP(2);
SELECT COUNT(*) AS "6 Transaction B (Post-Insert Count)" 
FROM Accounts 
WHERE balance_amt > 5000
LIMIT 10;
COMMIT;
