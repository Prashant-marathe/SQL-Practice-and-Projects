-- Joins in SQL (Horizontal Combination)
/* Joins require a common column (usually a Primary Key in one table)
 and a foreign key in other to link records. */
-- There are multiple times that differ based on Use case

-- Basic Joins in SQL
-- 1. NO JOIN: Returns data from both tables seperately without combining them
/* Retrive all data from customers and orders in 2 different result */
SELECT * FROM customers;
SELECT * FROM orders;

-- 2. INNER JOIN: Returns only matching rows from both tables
/* Get all customers along with their orders, but only for customers who have placed an order*/
SELECT 
	-- id, first_name, order_id, sales
	
	-- customers.id, customers.first_name, orders.order_id, orders.sales

	c.id,
	c.first_name,
	o.order_id, 
	o.sales
FROM customers AS c
INNER JOIN orders AS o
-- ON customers.id = orders.customer_id
ON c.id = o.customer_id
-- ON id = customer_id

-- LEFT JOIN: Get all the rows from the left and Only the matching from the right
/* Get all customers along with their orders, including those withour orders */
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id

-- RIGHT JOIN: Get all the rows from the right and only the matching rows from the left
/* Get all customers along with their orders, including orders without matching customers */
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id

/* Get all customers along with their orders,
including orders without matching customers (Using LEFT JOIN) */
SELECT 
	c.id, 
	c.first_name,
	o.order_id,
	o.sales
FROM orders AS o
LEFT JOIN customers AS c
ON o.customer_id = c.id

-- FULL JOIN / OUTER JOIN: Returns everything from both tables
/* Get all customers and all orders, even if there's no match.*/
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id