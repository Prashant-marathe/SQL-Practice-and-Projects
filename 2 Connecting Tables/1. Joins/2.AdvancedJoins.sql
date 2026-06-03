-- Advanced SQL joins

-- (LEFT ANTI JOIN) : Returns rows from left that do not match on the right
/* Get all the customers that have not placed any orders*/
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL

-- (RIGHT ANTI JOIN) - returns rows from right that do not match the left
/* Get all orders without matching customers*/
SELECT *
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL

-- Solve the same task using the left join
SELECT *
FROM orders AS o
LEFT JOIN customers AS c
ON o.customer_id = c.id
WHERE c.id IS NULL

-- (FULL ANTI JOIN) : Returns rows that do not have a match in both
SELECT *
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id
WHERE 
	c.id IS NULL
OR
	o.customer_id IS NULL

-- (CROSS JOIN) : combines all rows from left to all rows from right. Returns all possible combinations
SELECT *
FROM customers
CROSS JOIN orders