-- 10. SERIALIZABLE with Dirty Read

-- Transaction A: Update balance with delay, no commit
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
UPDATE Accounts 
SET balance_amt = balance_amt + 900.20 
WHERE account_no = '409000611074';
SELECT balance_amt AS "10 Transaction A (Uncommitted Update)" 
FROM Accounts 
WHERE account_no = '409000611074'
LIMIT 10;
DO SLEEP(5);  -- Simulate a delay before committing or rolling back
ROLLBACK;

-- Transaction B: Attempt to read, but will be blocked until Transaction A completes
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
DO SLEEP(1);
SELECT balance_amt AS "10 Transaction B (Dirty Read)" 
FROM Accounts 
WHERE account_no = '409000611074'
LIMIT 10;
COMMIT;

-- 11. SERIALIZABLE with Non-Repeatable Read

-- Transaction A: Update balance and commit
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
UPDATE Accounts 
SET balance_amt = balance_amt + 123456.50 
WHERE account_no = '409000611074';
DO SLEEP(2);  -- Delay before committing
COMMIT;

-- Transaction B: Read twice, expecting the same value due to SERIALIZABLE constraints
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT balance_amt AS "11 Transaction B (Initial Read)" 
FROM Accounts 
WHERE account_no = '409000611074'
LIMIT 10;
DO SLEEP(3);  -- Delay before the second read
SELECT balance_amt AS "11 Transaction B (Second Read)" 
FROM Accounts 
WHERE account_no = '409000611074'
LIMIT 10;
COMMIT;

-- 12. SERIALIZABLE with Phantom Read

-- Transaction A: Insert a new row, will be blocked if Transaction B has started
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
INSERT INTO Accounts (account_no, balance_amt) 
VALUES ('409000611074', 100000000);
DO SLEEP(5);  -- Delay before committing the insert
COMMIT;

-- Transaction B: Count rows before and after delay, expecting no phantoms
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT COUNT(*) AS "12 Transaction B (Initial Row Count)" 
FROM Accounts 
WHERE balance_amt > 1000000
LIMIT 10;
DO SLEEP(3);  -- Delay to allow potential phantom insert
SELECT COUNT(*) AS "12 Transaction B (Second Row Count)" 
FROM Accounts 
WHERE balance_amt > 1000000000
LIMIT 10;
COMMIT;
