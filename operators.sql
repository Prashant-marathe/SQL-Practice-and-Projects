-- Filtering Data
/* Operators in SQL : Comparison operators (=, <>, =!, >, >=, <, <=), Logical operators (AND, OR, NOT),
Range operator, Membership operators (IN, NOT IN), Search Operator (LIKE) */

-- Comparison Operators: 
-- (=) - Checks if two values are equal
SELECT * 
FROM customers
WHERE country = 'Germany'

-- (<> =!) - Checks if two values are not equal
SELECT * FROM customers 
WHERE country <> 'Germany'
-- WHERE country != 'Germany'

-- (>) - Checks if a value is greater than another value
SELECT * FROM customers
WHERE score > 500

-- (>=) - Checks if a value is greater than or equal to another value
SELECT * FROM customers
WHERE score >= 500

-- (<) - Checks if a value is less than another value
SELECT * FROM customers
WHERE score < 500

-- (<=) - Checks if a value is less than or equal to another value
SELECT * FROM customers
WHERE score <= 500



-- Logical Operators
-- (AND) - All conditions must be true
SELECT * FROM customers
WHERE country = 'USA' AND score > 500

-- (OR) - One of the both conditions must be True
SELECT * FROM customers
WHERE country = 'USA' OR score > 500

-- (NOT) - Reverse the condition. True becomes False and False becomes True. Excludes the matching row.
SELECT * FROM customers
WHERE NOT(country = 'USA' AND score > 500)
