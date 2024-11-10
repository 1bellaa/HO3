# Pre-Condition

Go to `data_cleaning.py` and change the 8th line of code with the file path of your folder
`os.chdir(r'file path')`

`pip install pandas` to install pandas
`pip install openpyxl` for import os
`pip install mysql-connector-python`

# Extensions

download the following extensions on vscode
SQLTools
Link: https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools

SQLTools MySQL/MariaDB/TiDB
Link: https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools-driver-mysql

go to database_connection.png to input the details
click test connection to test the connection. if it shows successfull connection, then save connection

# Running on Terminal

`cd experiments` to go to the folder of the experiments

`mysql -u root -p` to use mysql in terminal
password: user

`SHOW DATABASES;` to check the list of databases 

`USE isolation_demo;` to select database
`SELECT DATABASE();` to check if `isolation_demo` is the active database

`DESCRIBE Accounts` to show the columns or fields

`SELECT * FROM Accounts LIMIT 10;` to show 10 rows of the data

`SELECT SLEEP(5);` to check if your environment supports the sleep() function

`SOURCE name.sql`

-- a. balance_amt in setting the changes
-- b. account_no = 409000611074
-- c. set change to 123456.50