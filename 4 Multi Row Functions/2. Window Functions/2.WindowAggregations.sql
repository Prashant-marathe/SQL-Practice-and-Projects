-- #### WINDOW AGGREGATION FUNCTIONS
/* An aggregate function takes a multi-row collection of data and condenses it into a **single summary row**. When you use standard aggregation, you lose the individual identity of the original rows but with windows you retain all the rows along with the aggregation value.

##### There are 5 Aggregation Function in Total:
1. **COUNT():** Counts the number of rows in an particular column or 
	the whole table regardless of whether the row is null or not. */
	-- Task: Find the total number of orders for each product (COUNT(*)- counts the rows with NULL values as well)
	SELECT 
		product,
		COUNT(*) OVER(PARTITION BY product) orders_per_product
	FROM products
	-- Task: Find the total sales for each products (COUNT(column) - Counts only the non-NULL columns and ignores the NULLs)
	SELECT
		orderid,
		productid,
		COUNT(sales) OVER(PARTITION BY productid) AS total_sales_by_product
	FROM orders
	-- COUNT() out of all other aggregate functions has a special case which allows it to count values of any data type may that be a number or string
	-- Task: Count the total products for customers
	SELECT 
		product,
		category,
		COUNT(product) OVER(PARTITION BY category) AS product_count_per_category
	FROM products
	-- Task: Find the total number of orders for each customer. Additionally provide details such as orderid, orderdate
	SELECT 
		orderid,
		orderdate,
		customerid,
		COUNT(*) OVER(PARTITION BY customerid) AS total_orders
	FROM orders
	-- Find the total number of customers and total score Additionally provide all details
	SELECT * ,
		COUNT(*) OVER() AS total_customers,
		COUNT(score) OVER() AS total_sales
	FROM customers

-- SUM(): Returns the sum of all values within the window
	-- Task: Find the total sales across all orders and the total sales for each product. Additionally provide details such as order ID and order date
	SELECT 
		orderid,
		orderdate,
		productid,
		sales,
		SUM(sales) OVER() AS total_sales,
		SUM(sales) OVER(PARTITION BY productid) AS total_sales_by_product
	FROM orders
	-- Find the percentge contribution of each products sales to the totaL sales
	SELECT 
		sales,
		SUM(sales) OVER() total_sales,
		ROUND((sales::FLOAT / SUM(sales) OVER() * 100)::NUMERIC, 2) AS percentage_sales
	FROM orders

-- AVG(): Returns the average of values between each window
	-- Find the average sales for each product. NULL sales means zero
	SELECT 
		sales,
		productid,
		ROUND(AVG(sales) OVER(PARTITION BY productid), 2) AS average_sales
	FROM orders
	-- Find the average scores of customers. Additionally provide details such as customerid and lastname
	SELECT
 		customerid,
		lastname,
		score,
		ROUND(AVG(COALESCE(score, 0)) OVER(), 2) AS avg_score
	FROM customers
	-- Find all orders where sales are higher than the average sales across all orders
	SELECT *
	FROM (
	SELECT 
		orderid,
		productid,
		sales,
		ROUND(AVG(COALESCE(sales, 0)) OVER(), 2) AS average_sales
	FROM orders
	)t
	WHERE sales > average_sales

-- MIN(): Returns the lowest value in the window
-- MAX(): Returns the highest value in the window
	-- Task: Find the lowest and highest sales for each product
	SELECT
		orderid,
		orderdate,
		productid,
		sales,
		-- In business we understand nulls as zeros
		MAX(COALESCE(sales, 0)) OVER(PARTITION BY productid) AS max_sales,
		MIN(COALESCE(sales, 0)) OVER(PARTITION BY productid) AS min_sales
	FROM orders
	-- Task: Find the highest and lowest sales across all orders 
	-- and the highest and lowest sales for each product
	-- Additionally, provide details such as orderid and orderdate
	SELECT
		orderid,
		orderdate,
		sales,
		productid,
		MAX(COALESCE(sales, 0)) OVER() AS max_sales,
		MIN(COALESCE(sales, 0)) OVER() AS max_sales,
		MAX(COALESCE(sales, 0)) OVER(PARTITION BY productid) AS max_sales_by_product,
		MIN(COALESCE(sales, 0)) OVER(PARTITION BY productid) AS min_sales
	FROM orders
	-- Task: Show the employees who have the highest salaries
	SELECT
	* 
	FROM (
		SELECT 
		*,
		MAX(COALESCE(salary, 0)) OVER() highest_salary
		FROM employees
	)t 	
		WHERE salary = highest_salary
	-- Task: Compare to extremese
	-- Find the deviation of each sales from the minimum and maximum sales amounts
	SELECT
		orderid,
		orderdate,
		productid,
		sales,
		MAX(sales) OVER() highest_sales,
		MIN(sales) OVER() lowest_sales,
		sales - MIN(sales) OVER() deviation_from_min,
		-- ABS(sales - MAX(sales) OVER()) deviation_over_max
		MAX(sales) OVER() - sales deviation_from_max
	FROM orders

-- Use cases for aggregate functions
-- 1. RUNNING AND ROLLING TOTAL
/* Tracking: Tracking current sales with target sales
Trend analysis: Providing insights into historical patterns 
They aggregate sequence of members, and the aggregation is updated each time a new member is added. */
 
-- RUNNING TOTAL: Aggregate all values from the beginning up to the current point withour dropping off older data
-- ROLLING TOTAL: Aggregate all values within a fixed time window (e.g. 30 days)

-- 2. MOVING AVERAGE	

