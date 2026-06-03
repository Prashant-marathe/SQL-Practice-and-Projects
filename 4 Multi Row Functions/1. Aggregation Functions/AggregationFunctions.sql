-- Aggregate Functions 
/* Aggregate Functions in SQL are functions that performs a calculation on a set of values across 
multiple rows and return a single, summary value. 
While scalar functions (like UPPER(), ROUND(), CAST()) operate on each row individually,
aggregate functions look at an entire column of data, collapses those rows down, and output a 
singular matrix, They are the backbone of data analysis reporting, and business intelligence. 

# How Aggregate Functions Work
When you run an aggregate function, PostgreSQL scans all the rows in a designated column, skips any NULL values
(with one notable exception), applies the mathematical rule, and condenses the rows into one output. */

-- The 5 Simple (Standard) Aggregate Functions
/* Every standard relational database supports five core functions. */
	-- A.COUNT()
	SELECT 
		COUNT(sales) AS sales_count,
		COUNT(shipaddress) AS shipaddress_count
	FROM orders
	-- Task: Find the total number of customers
	SELECT
		COUNT(*) AS total_customers
	FROM customers
	-- Task: Find the total sales of all orders
	SELECT 
		COUNT(*) AS total_nr_orders,
		SUM(sales) AS total_sales
	FROM orders

	-- SUM()
	SELECT
		SUM(sales) AS total_sales,
		SUM(quantity) AS total_quantity
	FROM orders

	-- AVG()
	SELECT 
		AVG(sales) AS avg_sales
	FROM orders

	-- MAX()
	SELECT 
		MAX(sales) AS max_sales
	FROM orders

	-- MIN()
	SELECT 
		MIN(sales) AS min_sales
	FROM orders

	-- Aggregation using GROUP BY
	SELECT
		customerid,
		COUNT(*) AS total_nr_orders,
		SUM(sales) AS total_sales,
		AVG(sales) AS avg_sales,
		MAX(sales) AS highest_sales,
		MIN(sales) AS lowest_sales
	FROM orders
	GROUP BY customerid

 