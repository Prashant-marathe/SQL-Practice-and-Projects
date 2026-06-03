-- NULL Functions in SQL
/* What is NULL? 
Null means nothing, unknown!
Null is not equal to anything!
- NULL is not zero
- NULL is not empty string
- NULL is not blank space 	*/

-- 1. Functions to check if a value is NULL
	-- IS NULL and IS NOT NULL
	/* These are the standard SQL constructs used to test for nullity.
	- IS NULL: Returns TRUE if the value is null.
	- IS NOT NULL: Returns TRUE if the value contains data. 
	
	Example: For IS NULL: */
	SELECT * FROM orders
	WHERE shipaddress IS NULL

	-- Example: For IS NOT NULL
	SELECT * FROM orders
	WHERE shipaddress IS NOT NULL

	-- IS DISTINCT FROM and IS NOT DISTINCT FROM
	/* These operators treat NULL as a known value for comparison purposes, which is incredibly helpful when comparing two columns that might both contain NULL.
	- A IS DISTINCT FROM B: Evaluates to TRUE if A and B are different, safely handling cases where one or both are NULL.
	- A IS NOT DISTINCT B: Evaluates to TRUE if A and B are equal, or if both are NULL.

	Example: for IS DISTINCT FROM */
	SELECT NULL IS DISTINCT FROM NULL -- returns false since both are same and not distinct

	-- Example: for IS NOT DISTICT FROM
	SELECT 'Apple' IS DISTINCT FROM NULL	-- returns true since 'Apple' is definitely different from NULL

-- 2. Functions to Replace NULL with a value
/* When querying data, you often want to swap out a ugly or disruptive NULL with a default placeholder value (like 0, 'N/A', or 'Unknown').*/
	-- COALESCE(val1, val2, ...., value_n)
	/* The COALESCE function evaluates the arguments in order from left to right and returns the first non-null value it encounters.*/
	SELECT 
		COALESCE(shipaddress, 'Unknown'), 
		COALESCE(billaddress, 'Unknown'),
		COALESCE(shipaddress, billaddress)
	FROM orders

	-- Use case of COALESCE is when we want to aggregate functions like sum, avg, product and we have more values than the aggregate function calculates.
	-- Example: Let's calculate the avg score 
	SELECT 
		customerid,
		score,
		AVG(score) OVER() average_score
	FROM customers
	/* The result we get from this (625.00) is wrong average since the AVG() function only calcuted the average of 4 numbers totally ignoring the 5th element
	To fix this we can use COALESCE and replace the null with 0 which will make the AVG() consider 5 numbers instead of 4*/
	SELECT
		customerid,
		score,
		AVG(COALESCE(score, 0)) OVER() average_score
	FROM customers
	/* Now we will get the average of 5 numbers as 500.00 */

	-- Another use case would be to use the COALESCE before performing mathematical operations like sum and substraction.
	-- 1 + 2 = 3 but 1 + NULL = NULL
	-- 'A' + 'B' = 'AB' but 'A' + NULL = NULL
	-- To avoid this we can convert the NULL value to something else
	/* Example: Display the full names of customers in a single field by merging their firstname and lastnames, and add 10 bonus points to each customer's score */
	SELECT
		customerid,
		score,
		firstname,
		lastname,
		CONCAT(firstname, ' ' , COALESCE(lastname, '')) as fullname,
		COALESCE(score, 0) + 10 AS increased_score
	FROM customers

-- 3. Functions to Replace a value with null
/* Sometimes you want to do the exact opposite:convert blank strings, placeholders (like -1 or '9999'), or bad data into actual database NULLs */
	-- NULLIF(val1, val2)
	/* The NULLIF function compares two arguments. If value1 is equal to value2, the function returns NULL. otherwise, it returns value1 
	This is highly effective for preventing 'division by zero' errors or cleaning up empty strings.

	-- Example 1: Prevent division by zero by turning 0 into NULL
	-- (Any number divided by NULL safely result in NULL, instead of crashing)*/
	SELECT 
		sales / NULLIF(quantity, 0)
	FROM orders

	-- Example: Convert empty strings in billaddress column to NULL
	SELECT 
		NULLIF(billaddress, '') AS billaddress_new
	FROM orders


-- There is one more thing to understand is the NULL, empty string (''), and whitespace (   ) are not equal
/* NULL: Means nothing, unknown!
Empty String ('') : String value which has zero characters.
WhiteSpace (  ): String value has one or more space characters.
Example: */
WITH ordersTemp AS (
SELECT 1 Id, 'A'::VARCHAR AS Category 
UNION ALL
SELECT 2, NULL UNION ALL
SELECT 3, '' UNION ALL
SELECT 4, ' ' 
)

SELECT *,
LENGTH(TRIM(Category)) AS nowhitespace,
LENGTH(Category) AS CategoryLen
FROM ordersTemp