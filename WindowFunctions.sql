SELECT 
	orderid,
	orderdate,
	productid,
	SUM(sales) AS total_sales 
FROM orders
GROUP BY
	orderid,
	orderdate,
	productid
	

SELECT * FROM orders