-- Multi Table Join
/* A Multi-Table Join occurs when you need to link three or more tables together in a single SQL query

Because relational databased follow the rules of normalization -- breaking data down into small specialized tables to avoid duplication --
complex real-world questions almost always require jumping through multiple tables to get the full answer.*/

/* How a Multi Join Works
SQL executes joins sequentially, typically from left to right. When you join three tables,
the database engine first joins TABLE A and TABLE B based on their relationship, creates a temporary 
"virtual table" in memory, and then joins TABLE C to that virtual result.*/

-- Example
/* Using SalesDB, Retrive a list of all orders, along with the 
related customer, product, and employee details
For each order, display:
-- Order ID
-- Customer's name
-- Product name
-- Sales amount
-- Product price
-- Salesperson's name
*/
SELECT 
	o.orderid,
	c.firstname AS CustomerFirstname,
	c.lastname AS CustomerFirstname,
	p.product AS ProductName,
	o.sales,
	p.price,
	e.firstname AS SalesPersonFirstname,
	e.lastname AS SalesPersonLastName
FROM orders AS o
LEFT JOIN customers AS c
ON o.customerid = c.customerid
LEFT JOIN products AS p
ON o.productid = p.productid
LEFT JOIN employees AS e
ON o.salespersonid = e.employeeid
ORDER BY orderid ASC


-- select * from orders





