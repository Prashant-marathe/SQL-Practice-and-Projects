-- Use cases for Ranking Functions


-- There are many use cases for the function ROW_RANK() when compared to other integer based ranking functions

-- 1.Find the top highest sales for each product
-- This is what known as 'Top-N Analysis' where we analyse the top performers
SELECT * 
FROM (
SELECT 
	orderid,
	productid,
	sales,
	ROW_NUMBER() OVER(
		PARTITION BY productid 
		ORDER BY sales DESC
	) rank_by_product
FROM orders
)t WHERE rank_by_product = 1


-- 2. Find the lowest 2 customers based on their total sales.
SELECT * 
FROM (
SELECT 
	customerid,
	SUM(sales) total_sales,
	ROW_NUMBER() OVER(
		ORDER BY SUM(sales)
	) as customers_rank
FROM orders
GROUP BY customerid
)t WHERE customers_rank <= 2

-- 3. Generate unique id's for Orders Archive table
SELECT
	ROW_NUMBER() OVER(ORDER BY orderid, orderdate) AS unique_id,
	*
FROM ordersarchive

-- 4.Identify duplicate rows in the table 'Orders Archive' and return a clean result without any duplicates
SELECT *
FROM 
(
	SELECT 
		ROW_NUMBER() OVER(PARTITION BY orderid ORDER BY creationtime DESC) AS rn,
		*
	FROM ordersarchive
)t
WHERE rn = 1

-- Get the duplicate rows only
SELECT *
FROM 
(
	SELECT
		ROW_NUMBER() OVER(PARTITION BY orderid ORDER BY creationtime DESC) AS rn,
		*
		FROM ordersarchive
)t	WHERE rn > 1

-- Use cases for NTILE(n) function.
-- 1. Data segmentation: Divides a dataset into distinct subsets based on certain criteria.
-- segment all orders into 3 categories: high, medium, and low sales
SELECT 
*,
CASE WHEN buckets = 1 THEN 'High'
	 WHEN buckets = 2 THEN 'Medium'
	 WHEN buckets = 3 THEN 'Low'
END sales_segmentation
FROM (
SELECT
	orderid,
	sales,
	NTILE(3) OVER(ORDER BY sales DESC) AS buckets
FROM orders
)t

-- segment employees by there salary
SELECT 
*,
CASE WHEN buckets = 1 THEN 'High earners'
	 WHEN buckets = 2 THEN 'Average earners'
	 WHEN buckets = 3 THEN 'Low earners'
END AS employee_rank_by_salary
FROM (
SELECT 
	employeeid,
	salary,
	NTILE(3) OVER(ORDER BY salary DESC) AS buckets
FROM employees
)

-- 2. Equalizing (load balancing): Its the idea where if you want to export or import a large amount of data instead of doing it in one go we divide the data into multiple buckets and export the buckets one at a time
-- In order to export the data,
-- divide the orders into 2 groups
SELECT
	NTILE(2) OVER(ORDER BY orderid) buckets,
	 *
FROM orders


-- Percentage Based Ranking
-- 1. Find the products that fall within the highest 40% of the prices
SELECT 
	*,
	CONCAT(dist_rank * 100, '%') AS dist_rank_percentage
FROM (
	SELECT
		product,
		price,
		CUME_DIST() OVER(ORDER BY price DESC) AS dist_rank
	from products
)t WHERE dist_rank <= 0.4


