-- String Manipulation Functions

-- 1. CONCAT(str1, str1, str3, ...) : Combine multiple strings together
-- Task: Concatenate Firstname and country into one column
SELECT 
	firstname,
	country,
	CONCAT(firstname, '-' , country) AS name_country
FROM customers

-- 2. UPPER(str) : Converts a singleton string into uppercase
-- Task: Convert the firstname to uppercase
SELECT 
	firstname,
	UPPER(firstname) AS Uppercased_names
FROM customers

-- 3. LOWER(str) : Converts a singelton string into lowercase
-- Task: Convert the country to lowercase
SELECT 
	country,
	LOWER(country) AS lowercase_country
FROM customers

-- 4. TRIM(str): Removes leading and trailing whitespaces
-- Task: Find an customer whose name has an whitespace
SELECT 
	first_name
FROM customers
WHERE first_name != TRIM(first_name)

-- 5. REPLACE(Value_to_change, oldstr, newstr): replaces an specific character with an new character
-- Task: Remove dashes from a phone number (123-456-7890)
SELECT 
'123-456-7890',
REPLACE('123-456-7890', '-', '')
-- Task: Remove an files extension from report.txt to report.csv
SELECT
'report.txt' AS filename,
REPLACE('report.txt', '.txt', '.csv') AS replaced_filename


-- String calcultion Functions

-- LENGTH(str): Returns the character length of an string or any other datatype like number or even datetime.
-- Task: Let's calculate the length of firstname for customers
SELECT 
first_name,
LENGTH(TRIM(first_name)) AS firstname_length
FROM customers


-- String Extraction Functions

-- 1.LEFT(str_value, no_of_characters): Extracts part of string starting from the left
-- Task: Extract the firstname from a person's full name like 'Prashant Sunil Marathe'
SELECT
'Prashant Sunil Marathe' AS full_name,
LEFT('Prashant Sunil Marathe', 8) AS first_name

-- 2.RIGHT(str_value, no_of_characters): Extracts part of string from the end (right)
-- Task: Extract the lastname from a person's fullname like 'Prashant Sunil Marathe'
SELECT 
'Prashant Sunil Marathe' AS full_name,
RIGHT('Prashant Sunil Marathe', 7) AS last_name

-- 3. SUBSTRING(string, start_position, no_of_characters): Extracts a specific piece of text from any position within a string. You give it a starting point and tell it how many characters forward to grab.
-- Task: Extract Middle name from a person's name like 'Prashant Sunil Marathe'
SELECT 
'Prashant Sunil Marathe' AS full_name,
SUBSTRING('Prashant Sunil Marathe', 10, 5) AS middle_name

-- Do it all in one go
SELECT 
'Prashant Sunil Marathe' AS full_name,
LEFT('Prashant Sunil Marathe', 8) AS first_name,
SUBSTRING('Prashant Sunil Marathe', 10, 5) AS middle_name,
RIGHT('Prashant Sunil Marathe', 7) AS last_name