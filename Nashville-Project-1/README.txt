This is a brief explanation of all the steps that were taken during the Nashville Data Cleaning Project.

The main goal of this project is to exercise the abilies using SQL to clean and modify data within a table using SQL.

====================

Table of Contents (TOC)
1. Data Source
2. SQL Queries + Changes
3. Query Output

====================

1. Data Source

- The source of the data is a generic Nashville Housing Data Set available online.
- Base data before manipulation located in NashvilleHousing.xlsx

====================

2. SQL Queries + Changes

- Multiple SQL queries were ran to modify the data within the table.
- Tasks completed include:
	* Standardize Date Format
	* Populate Property Address Data
	* Breaking Address into Individual Columns (Address, City, State)
	* Change 'Y' and 'N' to 'Yes' and 'No' in "Sold as Vacant"
	* Remove Duplicates
	* Delete Unused Columns
- Queries can be found in NashvilleHousingQuery.sql

====================

3. Query Output

- Saved output of the queries from step 2 as a .csv file.
- Output can be found in NashvilleHousingFinal.csv

====================

**
NOTE:
Steps including removing duplicates and deleting unused columns are performed as part of this project. Under normal circumstances, these types of actions are advised against in order to uphold data integrity.