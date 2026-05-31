-- CASE STATEMENT
/* The CASE statement in PostgreSQL is a conditional expression that allows you to add 'IF-THEN-ELSE' logic directly inside your SQL queries.
It evaluates a list of conditions and returns a specific value as soon as the first condition is met.

If no conditions are met, it returns the value specified in the ELSE clause.
If there is no ELSE clause and no conditions match, it returns NULL.

In postgreSQL, there are two primary ways to write a CASE statement: the General CASE and the simple CASE.*/

-- 1. General CASE Statement (Evaluates Multiple Conditions)
/* This is the most powerful and flexible form. It allows you to evaluate completely different columns, use comparison
operators (<, >, <=, >=), or continue multiple criteria using AND and OR.
- Syntax: 
CASE 
	WHEN condition1 THEN result1
	WHEN condition2 THEN result2
	[ELSE resultN]
END

- Example:    */
SELECT 
	orderid,
	sales,
	CASE 
		WHEN sales >= 90 THEN 'High'
		WHEN sales >= 60 THEN 'Medium'
		WHEN sales >= 40 THEN 'Low'
		ELSE 'Bad' 
	END AS sales_summary
FROM orders

-- Simple CASE Statement (Evaluates a Single Expression)
/* The simple CASE matches the expression against a list of specific, fixed values. It is cleaner and 
more concise, but only checks for strict equality (=). You cannot use operations like 'greater then' or check for
NULL using this method.
- Syntax:
CASE expression
	WHEN value1 THEN result1
	WHEN value2 THEN result2
	ELSE resultN
END

- Example:    */
SELECT 
	orderid,
	orderstatus,
	CASE orderid
		WHEN 1 THEN 'Delivered'
		WHEN 2 THEN 'Shipped'
		WHEN 3 THEN 'Delivered'
		ELSE 'Unknown Status'
	END AS shipping_Status
FROM orders

SELECT * FROM orders

-- 3. Advanced Use Cases of CASE
/* Main purpose of an CASE statement is Data Transformation Where we derive new information and create new 
columns based on existing Data 

-- A. Categorizing Columns
Group the data into different categories based on certain conditions. 
Task: Create a report showing total sales for each of the following categories: High (sales over 50),
Medium (sales 21-50), and low (sales 20 or less). Sort the categories from highest sales to lowest. */
SELECT
	categories,
	SUM(sales) AS total_sales
FROM (
SELECT
	orderid,
	sales,
	CASE 
		WHEN sales >= 50 THEN 'High'
		WHEN sales >= 21 AND sales <= 50 THEN 'Medium'
		WHEN sales <= 20 AND sales >= 1 THEN 'Low'
		ELSE 'No sales'
	END AS categories
FROM orders
)t
GROUP BY categories
ORDER BY total_sales DESC

-- B. Mapping Columns
/* Transform the values from one form to another 

- Task 1: Retrieve employee details with gender displayed as full text */
SELECT 
	employeeid,
	CONCAT(firstname, ' ', COALESCE(lastname, 'N/A')) AS fullname,
	CASE gender
		WHEN 'M' THEN 'Male'
		WHEN 'F' THEN 'Female'
		ELSE 'N/A'
	END AS gender_full_text
FROM employees

-- Task 2: Retrieve customer details with abbreviated country code 
SELECT 
	customerid,
	CONCAT(firstname, ' ', COALESCE(lastname, 'N/A')) AS fullname,
	country,
	CASE country
		WHEN 'USA' THEN 'US'
		WHEN 'Germany' THEN 'DE'
		ELSE 'N/A'
	END AS country_abbr
from customers


-- C. Handling NULLs
/* Replace NULLS with specific value. NULLs can lead to inaccurate results, which can lead to wrong decision-making. 
Task: Find the average scores of customers and treat NULLs as 0. And provide additional details such as customerid and lastname.  */
SELECT 
	customerid,
	lastname,
	score,
	CASE
		WHEN score IS NULL THEN 0
		ELSE score
	END AS score_clean,
	AVG(CASE
			WHEN score IS NULL THEN 0
			ELSE score
		END) OVER() avg_score_clean,
	AVG(score) OVER() AS avg_score
FROM customers

-- 4. Conditional Aggregations
/* Apply aggregate functions only on subsets of data that fulfill certain conditions. 
Task: Count how many times each customer has made an order with sales greater than 30. */
SELECT
	customerid,
	SUM(CASE 
			WHEN sales > 30 THEN 1
			ELSE 0
		END) total_orders_high_sales,
		COUNT(*) total_orders
FROM orders
GROUP BY customerid

