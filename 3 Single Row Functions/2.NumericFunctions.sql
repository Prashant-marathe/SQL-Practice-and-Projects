-- SQL NUMERIC FUNCTIONS
/* SQL Numeric Functions are single-row (scalar) mathematical functions built into the 
database engine. They allow you to perform calculations, adjust decimal placement, and manipulate numeric columns row-by-row.*/


-- 1.ROUND(number, decimal_places)
/* Definition: Rounds a numeric value to a specified number of decimal places based on standard mathematical rounding rules 
(5 or above rounds up, below 5 rounds down). */
SELECT 
3.516,
ROUND(3.516, 2),
ROUND(3.516, 1),
ROUND(3.516, 0)

-- 2. TRUNC()
/* Unlike ROUND, this function completely cuts off (chops) a number to a specified decimal position without performing any mathematical rounding, regardless of what trailing digits are */
SELECT 
3.516,
TRUNC(3.516, 2),  -- OUTPUT: Keeps the 2 digits after the decimal
TRUNC(3.516, 1),  -- OUTPUT: Keeps only 1 digit after the decimal
TRUNC(3.516, 0)   -- OUTPUT: No digits after the decimal

-- 3. CEIL()
/* Returns the smallest integer value that is greater than or equal to the given number.
In simple terms, it always rounds a decimal up to the next whole number. */
SELECT 
3.516,
CEIL(3.516)		-- OUTPUT: 4

-- 4. FLOOR()
/* Returns the largest integer value that is less than or equal to the given number. It always rounds a decimal down to the next whole number. */
SELECT 
3.516,
FLOOR(3.516)	-- OUTPUT: 3

-- 5.ABS()
/* Returns the absolute (positive) value of a number. If a number is negetive, it converts it to positive; if it is already positive, it leaves it unchanged. */


-- 6. MOD()
/* Performs a division operation between two numbers but returns only the remainder of that division */
SELECT
MOD(5,5)

-- 7. POWER() & SQRT()
/* POWER() raises a number to the exponent of another number.
SQRT() calculates the mathematical square root of a positive number. */
SELECT
144,
POWER(144,2),
SQRT(144)







