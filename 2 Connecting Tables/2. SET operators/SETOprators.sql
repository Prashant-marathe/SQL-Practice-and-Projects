-- SET Operators 
/* SET Operators in SQL are used to combine two or more tables vertically. 
They work on rows and stack rows one over the other.

There are 4 types of SET Operators:
1. UNION
2. UNION ALL
3. INTERSECT
4. EXCEPT (or MINUS)
*/

/* #1 RULE | SQL CLAUSES
- SET Operators can be used almost in all clauses [WHERE, JOIN, GROUP BY, HAVING] but the ORDER BY clause can only be used at the end of the query only once */

/* #2 RULE | EQUAL COLUMN COUNTS 
- The number of columns in each query must be the same 
- Example: 			*/
SELECT 
	customerid,
	firstname,
	lastname
FROM customers

UNION

SELECT
	firstname,
	lastname
FROM employees

-- ERROR:  each UNION query must have the same number of columns

/* #3 RULE | DATA TYPES
Data types of columns in each query must be compatible
Example : Let's try to break this rule. Change the firstname column to customerid which is an int. Now the SQL will try to convert and int to string to match the second table and we will get an error */
SELECT 
	customerid,
	lastname
FROM customers

UNION

SELECT
	firstname,
	lastname
FROM employees

-- ERROR:  UNION types integer and character varying cannot be matched
-- As we can see its not enough to have same number of columns we also need same datatypes for columns of both tables

/* #4 RULE | ORDER OF COLUMNS
The order of columns on both queries must be the same
Example: Lets break this rule by changing the places of firstname and customerid for customers table*/
SELECT 
	customerid,
	firstname
FROM customers

UNION

SELECT
	firstname,
	employeeid
FROM employees

-- ERROR:  UNION types integer and character varying cannot be matched
/* Here its more about the type conversion then order. If we had switch the order of columns which have same datatypes then we will see no errors. but if we switched the order of tables which have different data types than we will get an conversion error since sql uses first table columns as reference for the second it tries to convert the customerid which is an INTEGER to an VARCHAR to match the firstname*/

/* #5 RULE | COLUMN ALIASES
The column names in the result set are determined by the column named specified in the first query.
Example: The column names of the table customers will be the once that get displayed in the result */
SELECT 
	firstname AS customersfirstname,
	lastname AS customerslastname
FROM customers

UNION

SELECT 
	firstname AS employeesfirstname,
	lastname AS employeeslastname
FROM employees

-- Notice despite providing aliased for both tables we only get aliases for the first table customers in our result.

/* #6 RULE | CORRECT COLUMNS
Even if all the rules are met and SQL shows no errors, the result may be incorrect.
Incorrect column selection leads to inaccurate results.
Example: Remember in data type section we said that if we switch the columns that have same data types like 'Firstname' and 'Lastname' we will still get the result. But that result will be incorrect because 
both columns will have values mixed into them from another column. */
SELECT 
	firstname,
	lastname
FROM customers

UNION

SELECT 
	lastname,
	firstname
FROM employees

-- And we get wrong result where we have lastnames like 'Baker' and 'Brown' inside the firstname column and firstnames are inside lastname column.

-- 1. UNION 
/* The UNION operator combines the result sets of two or more SELECT queries into a single list and 
automatically removes duplicate rows. The database engine performs an internal 
sorting and filtering pass to ensure every returned record is completely unique.*/
/* Task: Combine the data from customers and employees in one table */
SELECT 
	firstname,
	lastname
FROM customers

UNION

SELECT 
	firstname, 
	lastname
FROM employees


-- 2. UNION ALL
/* Returns all rows from both queries including duplicates.
Task: Combine the data from the table employees and customers into one table, including duplicates */
SELECT 
	firstname, 
	lastname
FROM customers
UNION ALL
SELECT
	firstname, 
	lastname
FROM employees


-- 3. EXCEPT
/* Returns all the distinct rows from first query that are not found in the second query
It is the only one where the order of queries effects the final result.	
Task: Find the employees who are not customers at the same time */
SELECT 
	firstname,
	lastname
FROM employees
EXCEPT
SELECT 
	firstname,
	lastname
FROM customers

-- Here, we need to pay attention to the order. If we switch the tables we will get the customers who are not employees
SELECT 
	firstname,
	lastname
FROM customers
EXCEPT
SELECT 
	firstname,
	lastname
FROM employees


--- 4.INTERSECT
/* Returns only the rows that are common in both queries. Its similar to an INNER JOIN. The order of the queries does not matter but the first queries columns will be used as names for the resultant table columns
Task: Find the customers who are also employees. */
SELECT 
	firstname,
	lastname
FROM customers
INTERSECT
SELECT 
	firstname,
	lastname
FROM employees

-- Task : 
/* Orders data are stored in separate tables (Orders and OrdersArchive).
Combine all orders data into one report without duplicates. */
SELECT *
FROM orders
UNION
SELECT * 
FROM ordersarchive

/* Note: When combining tables never use asterisk (*) to combine tables; list needed columns instead. */
SELECT 
'Orders' AS SourceTable,
	orderid,
	productid,
	customerid,
	salespersonid,
	orderdate,
	shipdate,
	orderstatus,
	shipaddress,
	billaddress,
	quantity,
	sales, 
	creationtime
FROM orders
UNION
SELECT
'OrdersArchive' as SourceTable,
	orderid,
	productid,
	customerid,
	salespersonid,
	orderdate,
	shipdate,
	orderstatus,
	shipaddress,
	billaddress,
	quantity,
	sales, 
	creationtime
FROM ordersarchive
ORDER BY orderid