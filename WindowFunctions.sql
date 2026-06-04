-- WINDOW FUNCTIONS IN SQL
/* Window functions are one of the most powerful features in SQL, transforming how we analyze data. To
truly understand them, we must first look at how they differ from standard aggregation.

## 1. The Core Difference: Window Functions vs. Aggregate Functions

The fundamental difference between an aggregate function and a window function comes down to one thing: **whether the rows are collapsed.**

### Aggregate Functions (Collapses Rows)

An aggregate function takes a multi-row collection of data and condenses it into a **single summary row**. When you use standard aggregation, you lose the individual identity of the original rows.

* *Example:* If you calculate the average exam score of a department, you get one number (e.g., `78`). You can no longer see *which* individual candidate scored what.

### Window Functions (Preserves Rows)

A window function performs a calculation across a set of table rows that are somehow related to the current row, but it **retains the identity of every single individual row**.

* *Example:* You can display a candidate's individual score, their name, and the average score of their department right next to it on the exact same row.

*/

-- Let's understand why we need window functions even though we have aggregate functions.
	-- Task 1: Find the total sales across all orders
	SELECT 
		SUM(sales)
	FROM orders

	-- Task 2: Find the total sales for each product
	SELECT 
		productid,
		SUM(sales)
	FROM orders
	GROUP BY productid 

	-- Task 3: Find the total sales for each product
	-- Additionally provide details such as orderid, order data
	SELECT 
		orderid,
		orderdate,
		productid,
		SUM(sales)
	FROM orders
	GROUP BY productid, orderid, orderdate
/* From above three tasks we can clearly understand the drawback of using aggregation since it limits the level of details we can get 
If we try to get additional information like orderid, orderdate, and productid we need to add them inside GROUP BY
The more columns we add the less details we get since orderid has 10 unique rows and the group by will shows all those rows. At that point 
we will not get the first part (total sales for each product) of the task.*/

	-- To solve this issue we have window functions
	-- Task 1: Find the total sales across all orders
	SELECT 
		SUM(sales) OVER()
	FROM orders

	-- Task 2: Find the total sales for each product
	SELECT 
		productid,
		SUM(sales) OVER(PARTITION BY productid) AS total_sales_by_product
	FROM orders

	-- Task 3: Find the total sales for each product
	-- Additionally provide details such as orderid, orderdate
	SELECT
		orderid,
		orderdate,
		productid,
		SUM(sales) OVER(PARTITION BY productid) AS total_sales_by_product
	FROM orders

-- WINDOW function Syntax
/* The general syntax of a window function in PostgreSQL follows a specific, structured pattern. Every window function requires the "OVER" clause, which signals to the database engine that it should treat the function as window operation rather than a standard aggregate. 
syntax: 
SELECT
	column name, window function() OVER(
		[PARTITION BY pertition_column]
		[ORDER BY sort_column]
		[ROWS|RANGE frame_specification]
	) AS alias name; 
*/

-- Let's look at how we can use each part of the syntax one by one
	-- Task: Find the total sales across all orders
	-- Additionally provide details such as orderid, orderdate
	
-- Empty OVER()
	SELECT 
		orderid,
		orderdate,
		SUM(sales) OVER() AS total_sales
	FROM orders

	-- Task: Find the total sales for each product, additionally provide details such order id & order date
--First part of the window function inside over (Partition clause). using PARTITION with OVER()
	SELECT
		orderid,
		orderdate,
		productid,
		SUM(sales) OVER(PARTITION BY productid) AS total_sales_by_product
	FROM orders

	-- Task: Find the total sales across all orders. Find the total sales for each product. Additionally provide details such as orderid, orderdate
	-- Using multiple aggregations with windows
	SELECT
		orderid,
		orderdate,
		productid,
		sales,
		SUM(sales) OVER() total_sales,
		SUM(sales) OVER(PARTITION BY productid) total_sales_by_product
	FROM orders

	-- Task: Find the total sales for each combination of product and order status
	-- using multiple columns in PARTITION BY
	SELECT
		orderid,
		orderdate,
		productid,
		orderstatus,
		sales,
		SUM(sales) OVER() total_sales,
		SUM(sales) OVER(PARTITION BY productid) total_sales_by_product,
		SUM(sales) OVER(PARTITION BY productid, orderstatus) AS total_sales_by_product_and_orderstatus
	FROM orders

	-- Task: Rank each order based on their sales from highest to lowest, additionally provide details such as orderid and orderdate
--Second part of the window function inside over (order clase). Using ORDER BY with PARTITION BY inside over
	SELECT 
		orderid,
		orderdate,
		sales,
		RANK() OVER(ORDER BY sales DESC) AS rank_sales
	FROM orders



-- Third part of the window function inside over(frame clause).
	-- get the nth row after the current row
	SELECT 
		EXTRACT(MONTH FROM orderdate) AS order_month,
		sales,
		SUM(sales) OVER(ORDER BY EXTRACT(MONTH FROM orderdate)
		ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING)
	FROM orders

	-- The last possible row within a window
	SELECT
		EXTRACT(MONTH FROM orderdate) AS order_month,
		sales,
		SUM(sales) OVER(ORDER BY EXTRACT(MONTH FROM orderdate)
		ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
	FROM orders

	-- The nth row before the current row
	SELECT
		EXTRACT(MONTH FROM orderdate) AS order_month,
		sales,
		SUM(sales) OVER(ORDER BY EXTRACT(MONTH FROM orderdate)
		ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)
	FROM orders

	-- The first possible row within the window
	SELECT 
		EXTRACT(MONTH FROM orderdate) AS order_month,
		sales,
		SUM(sales) OVER(ORDER BY EXTRACT(MONTH FROM orderdate)
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
	FROM orders

	-- 1 preceding and 1 following 
	SELECT
		EXTRACT(MONTH FROM orderdate) AS order_month,
		sales,
		SUM(sales) OVER(ORDER BY EXTRACT(MONTH FROM orderdate)
		ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
	FROM orders

	-- Get everything
	SELECT
		EXTRACT(MONTH FROM orderdate) AS order_month,
		sales,
		SUM(sales) OVER(ORDER BY EXTRACT(MONTH FROM orderdate)
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
	FROM orders

	-- With partition
	SELECT
		orderid,
		orderdate,
		orderstatus,
		sales,
		EXTRACT(MONTH FROM orderdate) AS order_month,
		SUM(sales) OVER(
			PARTITION BY orderstatus 
			ORDER BY EXTRACT(MONTH FROM orderdate)
			ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
		) AS total_sales
	FROM orders

	-- If we don't define an frame and use order by we will still get an framed response. There is a default frame in SQL even if we don't define one ourselves.
	SELECT
		orderstatus,
		sales,
		SUM(sales) OVER(
			PARTITION BY orderstatus 
			ORDER BY orderdate
		) AS total_sales
	FROM orders
	-- With ORDER BY it's ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	-- Withour ORDER BY it's ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

-- Rules for using the Window functions
/* 1. Window functions can be used ONLY in SELECT and ORDER BY clauses
   2. Nesting window functions is not allowed
   3. SQL executes window functions only after the WHERE clause
Example for 3rd rule:
Task: Find the total sales for each order status, only for two products 101 and 102
*/
SELECT
	productid,
	orderstatus,
	sales,
	SUM(sales) OVER(PARTITION BY orderstatus) AS total_sales
FROM orders
WHERE productid BETWEEN 101 AND 102
-- 4. Window function can be used together with GROUP BY in the same query, ONLY if the same columns are used.
-- Example for 4th rule:
-- Task: Rank customers based on their total sales
SELECT 
	customerid,
	SUM(sales) AS total_sales,
	RANK() OVER(ORDER BY SUM(sales) DESC) customer_ranking
FROM orders
GROUP BY customerid