import pandas as pd
import os

# File was downloaded from Kaggle: Bank Transaction Data
# Link: https://www.kaggle.com/datasets/apoorvwatsky/bank-transaction-data

# Current working directory; change as needed
os.chdir(r'C:\Users\Lenovo\OneDrive\Documents\DLSU\TERM_7\STADVDB\HO3-Isolation')

# Load the Excel file into a DataFrame
excel_file_path = 'data/bank.xlsx'   
data = pd.read_excel(excel_file_path)

# Check the structure of the DataFrame (optional)
print("Initial Data Preview:")
print(data.head())

# Remove unnecessary columns
columns_to_remove = ['DATE', 'TRANSACTION DETAILS', 'CHQ.NO.', 'VALUE DATE', '.']
data = data.drop(columns=columns_to_remove)
print("Unnecessary columns removed.")

# Handle missing values for specific columns
columns_to_fill = ['WITHDRAWAL AMT', 'DEPOSIT AMT', 'BALANCE AMT']
data[columns_to_fill] = data[columns_to_fill].replace(['', ' '], 0).fillna(0)

# If there are non-numeric columns with NaN values, drop them 
data = data.dropna(subset=['Account No'])  # Drop rows where Account No is missing

# Clean the 'Account No' column by removing the unwanted apostrophe
data['Account No'] = data['Account No'].astype(str).str.replace("'", "", regex=False)
print("Cleaned apostrophes from 'Account No' column.")

# Standardizing column names
data.columns = data.columns.str.strip().str.lower().str.replace(' ', '_')
print("Column names standardized.")

# Display the cleaned data
print("Cleaned Data Preview:")
print(data.head())

# Save the cleaned data back to JSON with explicit control over formatting
cleaned_json_path = 'cleaned_bank_data.json'

# Ensure we use orient='records' and lines=True for correct JSON formatting
data.to_json(cleaned_json_path, orient='records', indent=4)

print(f"Cleaned data saved to {cleaned_json_path}")

# Load the cleaned JSON data back into a DataFrame to confirm it’s properly saved
cleaned_data = pd.read_json(cleaned_json_path)

# Display the cleaned DataFrame to confirm it's loaded correctly
print("Final Cleaned DataFrame:")
print(cleaned_data.head())