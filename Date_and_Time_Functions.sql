-- DATE AND TIME FUNCTIONS SQL
/* In SQL, temporal data types are used to track when events happen -- such as transaction times, account creation dates, or scheduling deadlines. Because time can be tracked down to the nanosecond, or just as a broad calendar day, SQL divides this information into specific data types. */

--  What is Date and Time in SQL?
/*
The exact format and precision of temporal data depend on the specific data type you choose when defining a column:
- `DATE`: Stores only the calendar date.
	- Format: `YYYY-MM-DD` (e.g., `2026-05-23`).
- `TIME`: Stores only the clock time of day, without any date attached.
	- Format: `HH:MM:SS` (e.g., `14:30:15`)
- `TIMESTAMP`: Stores both the calendar date and the clock time combined into a single value.
	- Format: `YYYY-MM-DD HH:MM:SS` (e.g., `2026-05-23 14:30:15`)
*/

-- Ways to Get and Use Dates in SQL
/*
When writing queries, filtering data, or inserting new records, there are three primary ways you can provide or extract a date value.
*/

-- A. From Table Columns
/*The most common way to get a date is simply by querying a pre-existing column in your database table that has been set up with a temporal data type.
-  Example: Fetching a list of when a specific order were placed, shipped, and the account creation time. */
SELECT 
	orderid, 
	orderdate,
	shipdate, 
	creationtime
FROM orders

-- B. Using HardCoded Dates
/* Example: Filtering out any orders that came after a specific date */
SELECT 
	orderid,
	orderdate
FROM orders
WHERE orderdate >= '2025-02-01'

-- C. Using System Functions
-- NOW() : Returns current date and time according to the system in 'YYYY-MM-SS HH:MM:SS' format.
-- CURRENT_DATE : Returns current date in 'YYYY-MM-DD' format
SELECT
	orderid, 
	orderdate,
	NOW() AS moment,
	CURRENT_DATE AS todays_date
FROM orders



-- Various Date Operations
/*We can perform multiple operations on a Date and Time string. Most often we want to extract parts of an date, Instead of using `'-'` in between we want to use `'/'`, We want to perform calculations like finding difference or adding two dates, or validating whether a specific date is authentic. For all of this operations we can divide the functions to perform this operations in 4 different parts: */ 

-- A. Part Extraction
/* There are multiple functions that allow to you extract an part of a Date String */
-- 1. Extracting specific subfields using EXTRACT()
SELECT
	orderid, 
	creationtime,
	EXTRACT(YEAR FROM TIMESTAMP '2025-01-01 12:34:56') AS current_year,
	EXTRACT(MONTH FROM creationtime) AS current_month,
	EXTRACT(DAY FROM creationtime) AS current_day
FROM orders

-- 2. DATE_PART()
/* 'DATE_TIME' achieves identical results but utilizes a comma seperated syntax where the date part is passed as string literal. */
SELECT
	orderid,
	creationtime,
	DATE_PART('year', creationtime) AS current_year,
	DATE_PART('month', creationtime) AS current_month,
	DATE_PART('day', creationtime) AS current_day
FROM orders

-- 3. DATE_TRUNC() 
/* DATE_TRUNC() is one of the most powerful date functions in Postgres. Instead of extracting a numeric piece out of a date,
it rounds down a timestamp to a specific precision level 
(e.g., year, month, week, day) by resetting the remaining smaller subfields to their starting baseline values.*/
SELECT
	orderid,
	creationtime,
	DATE_TRUNC('month', creationtime) AS month_start
FROM orders
/* Counting shipped aggregated by week */
SELECT
	DATE_TRUNC('week', shipdate) AS week_starting, COUNT(*)
from orders
GROUP BY week_starting

-- 3. Alternative to EOMONTH (End of Month)
/* Postgres does not have an EOMONTH() function. To find the last day of a given month, you combine a date calculation pattern using Postgres 'INTERVAL' data type: 
steps: i. Truncate the date to the start of the current month
	  ii. Add exactly 1 month to move to the next month.
	 iii. Substract 1 day to step backword to the exact final day of the original month.

Example:   */
SELECT
	(DATE_TRUNC('month', creationtime) 
	+ INTERVAL '1 month' 
	- INTERVAL '1 day') :: date AS end_of_month
FROM orders



-- 2. Format & Casting
-- 3. Calculations
-- 4. Validation