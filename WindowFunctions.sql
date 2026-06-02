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
	
	

