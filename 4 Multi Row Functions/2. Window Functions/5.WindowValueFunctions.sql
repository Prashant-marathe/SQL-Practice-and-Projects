-- WINDOW VALUE FUNCTIONS
/* Unlike aggreate functions that compute math, or ranking functions
that assign relative positions, value functions are designed to reach out and grab a specific,
raw data value from a completely different row within your partition and display it right next to the current 
row's data.*/

-- There are 4 different value functions
-- 1. LEAD(expr, [offset, [default]]) 
-- 2. LAG(expr, [offset, [default]])
-- 3. FIRST_VALUE(expr)
-- 4. LAST_VALUE(expr)

-- Syntax Rules for value functions
/* 1. ORDER BY is mendatory: You cannot look at a "previous" or "next" row unless the 
database has a perfectly locked-in sequence. Leaving out ORDER BY results in syntax error.
   2. Frame Restrictions: LEAD() and LAG() do not allow frame clause (ROWS/RANGE).They look at fixed physical offsets.
FIRST_VALUE() and LAST_VALUE() do allow frame claude where the LAST_VALUE() should always be used with frame clause to avoid a notorious logical trap.
*/

-- 	let's go over this functions and there use cases one by one
-- 	1. LEAD(expr, offset, default) - 2. LAG(expr, offset, default)
/*  expr : Expression is required and can be of any data type
	offset : optional. Number of rows forward or backward from current row. default value is 1
	default: optional. Returns default value if next/previous row is not available. default value is null */

-- Use case 1: Time Series Analysis: The process of analyzing the data to understand patterns, trends, and behaviors over time.
/* Year-over-Year (YoY): Analyze the overall growth or decline of the business's performance over time.
   Month-over-Month (MoM): Analyze short-term trends and discover patterns in seasonality. */

-- Task: Analyze the month-over-month performance by finding the percentage change in sales between the current and previous months.
SELECT
*,
current_month_sales - previous_month_sales AS MoM_change,
ROUND(
	CAST((current_month_sales - previous_month_sales) AS FLOAT) 
	/ previous_month_sales * 100, 2) AS MoM_perc
FROM (
	SELECT 
		EXTRACT(MONTH FROM orderdate) AS months,
		SUM(sales) AS current_month_sales,
		LAG(SUM(sales)) OVER(ORDER BY EXTRACT(MONTH FROM orderdate)) AS previous_month_sales
	FROM orders
	GROUP BY 
		EXTRACT(MONTH FROM orderdate)
)t

-- Use case 2: Customer retention analysis: Measure customer's behavior and loyalty to help besinesses build strong ralationships with customers.
SELECT
customerid,
AVG(days_until_next_order) AS avg_days
FROM (
SELECT 
	orderid,
	customerid,
	orderdate currentorder,
	LEAD(orderdate) OVER(PARTITION BY customerid ORDER BY orderdate) AS next_order,
	(orderdate - LEAD(orderdate) OVER(PARTITION BY customerid ORDER BY orderdate)) AS days_until_next_order
FROM orders
)
GROUP BY
	customerid

-- 1.FIRST_VALUE(): Access the value from the first row within a window
-- 2.LAST_VALUE(): Access a value from the last row within a window
-- Task: Find the lowest and highest sales for each product
SELECT
	orderid,
	productid,
	sales,
	FIRST_VALUE(sales) OVER(PARTITION BY productid ORDER BY sales ASC) lowest_sales,
	LAST_VALUE(sales) OVER(
		PARTITION BY productid 
		ORDER BY sales 
		ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
	) AS highest_value,
	FIRST_VALUE(sales) OVER(PARTITION BY productid ORDER BY sales DESC) highest_sales2,
	MIN(sales) OVER(PARTITION BY productid) lowest_sales_2,
	MAX(sales) OVER(PARTITION BY productid) highest_sales_3
FROM orders
