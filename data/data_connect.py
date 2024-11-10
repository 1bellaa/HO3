import mysql.connector
import json

# Load the cleaned JSON data
with open('cleaned_bank_data.json') as f:
    data = json.load(f)

# Connect to MySQL
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='user',
    database='isolation_demo'
)
cursor = conn.cursor()

# Insert data into the table
for entry in data:
    cursor.execute(
        """
        INSERT INTO Accounts (account_no, withdrawal_amt, deposit_amt, balance_amt)
        VALUES (%s, %s, %s, %s)
        """, (entry['account_no'], entry['withdrawal_amt'], entry['deposit_amt'], entry['balance_amt']))

# Commit and close
conn.commit()
cursor.close()
conn.close()