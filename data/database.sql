-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS isolation_demo;

-- Switch to the database
USE isolation_demo;

-- Create the Accounts table (adjust column types as needed)
CREATE TABLE IF NOT EXISTS Accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_no VARCHAR(20),
    withdrawal_amt DOUBLE,
    deposit_amt DOUBLE,
    balance_amt DOUBLE
) ENGINE=InnoDB;
