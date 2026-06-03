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

-- Range Operator 
-- (BETWEEN) - Checks if values are between an certain range. Marks Lower Boundary and Upper Boundary and anything inside this boundaries is true, anything outside is false. This boundaries are inclusive
SELECT * 
FROM customers 
WHERE score BETWEEN 100 AND 500

SELECT * 
FROM customers
WHERE (score >= 100 and score <= 500)


-- Membership Operator
-- (IN) : Check if a value exists in a list
SELECT * 
FROM customers
WHERE country IN ('Germany', 'USA')

-- (NOT IN): Opposite of IN. Check if the value does not exist in the list and returns that value
SELECT * 
FROM customers
WHERE country NOT IN ('Germany', 'USA')


-- Search Operator
-- (LIKE) : Search for a pattern in a text
-- % - Means anything, (_) - Exactly one value
-- M% : Must start with M and anything after that
-- %in : Must end with in and anything after that
-- %r% : Must have an 'r' somewhere in the text
-- __b% : We need an char at first and second position and then third character is b and anything after that is not we care about. eg. Albert, Rob, Abel


-- Find all customers whose first starts with an capital 'M'

SELECT * FROM customers
WHERE first_name LIKE 'M%'

-- Find all customers whose first name ends with 'n'
SELECT * 
FROM customers
WHERE first_name LIKE '%n'


-- Find customers whose first name contains an 'r'
SELECT * FROM customers
WHERE first_name LIKE '%r%'


-- find customers whose first_name has an 'r' in the third position
SELECT * FROM customers
WHERE first_name LIKE '__r%'


-- Handling Missing Data (`IS NULL`)
/* An important topic to add to your filtering toolkit is handling **missing or unentered data**. As we saw briefly in the DML section, `NULL` cannot be evaluated with standard comparison operators like `= NULL` or `!= NULL`. Instead, SQL provides specific operators for this: */


-- Find customers who don't have a score registered yet
SELECT * FROM customers 
WHERE score IS NULL;

-- Find customers who have any score registered
SELECT * FROM customers 
WHERE score IS NOT NULL;
