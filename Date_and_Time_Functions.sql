-- ^ DATE AND TIME FUNCTIONS SQL
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

SELECT 
	orderid,
	creationtime,
	EXTRACT(YEAR FROM creationtime) AS year_col
FROM orders

-- 2. DATE_PART()
/* 'DATE_PART' achieves identical results but utilizes a comma seperated syntax where the date part is passed as string literal. */
SELECT
	orderid,
	creationtime,
	DATE_PART('year', creationtime) AS current_year,
	DATE_PART('month', creationtime) AS current_month,
	DATE_PART('day', creationtime) AS current_day,
	DATE_PART('week', creationtime) AS week_dp,
	DATE_PART('quarter', creationtime) AS quarter_dp,
	DATE_PART('hour', creationtime) AS hour_dp,
	DATE_PART('minute', creationtime) AS minute_dp,
	DATE_PART('second', creationtime) AS second_dp
FROM orders

-- 3. DATE_TRUNC() 
/* DATE_TRUNC() is one of the most powerful date functions in Postgres. Instead of extracting a numeric piece out of a date,
it rounds down a timestamp to a specific precision level 
(e.g., year, month, week, day) by resetting the remaining smaller subfields to their starting baseline values.*/
SELECT
	orderid,
	creationtime,
	DATE_TRUNC('month', creationtime) AS month_start,
	DATE_TRUNC('hour', creationtime) AS start_hour,
	DATE_TRUNC('minute', creationtime) AS start_minute,
	DATE_TRUNC('second', creationtime) AS start_second
FROM orders
/* Counting shipped aggregated by week */
SELECT
	DATE_TRUNC('week', shipdate) AS week_starting, COUNT(*)
from orders
GROUP BY week_starting
/* Another example for showing why DATE_TRUNC(part, date) is amazing */
SELECT 
	DATE_TRUNC('month', creationtime) AS creation,
	-- creationtime,		-- In this case the level of detail makes it harder to group creationtime. So, we can use DATE_TRUNC() and round the time to hour or even day, month, or year to group creationtime
	COUNT(*)
FROM orders
GROUP BY DATE_TRUNC('month', creationtime)

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

-- 4. PostgreSQL does not have a built-in DATENAME function; the primary alternative is the TO_CHAR() function, which formats date or timestamp values into strings using specific format templates. 
/* TO_CHAR(CURRENT_TIMESTAMP, part): To replicate common DATENAME behaviors, use the following format specifiers:

Full Day Name: Use 'Day' for capitalized (e.g., "Saturday"), 'DAY' for uppercase ("SATURDAY"), or 'day' for lowercase ("saturday"). 
Abbreviated Day Name: Use 'DY' for uppercase ("SAT"), 'Dy' for capitalized ("Sat"), or 'dy' for lowercase ("sat"). 
Full Month Name: Use 'Month' for capitalized ("January"), 'MONTH' for uppercase ("JANUARY"), or 'month' for lowercase ("january"). 
Abbreviated Month Name: Use 'Mon' for capitalized ("Jan"). */
-- Example
SELECT 
	orderdate,
	TO_CHAR(orderdate, 'Month') AS full_month_name_Cap,
	TO_CHAR(orderdate, 'MONTH') AS full_month_name_upper,
	TO_CHAR(orderdate, 'month') AS full_month_name_lower,
	TO_CHAR(orderdate, 'Mon') AS abbr_month_name_Cap,
	TO_CHAR(orderdate, 'Day') AS full_day_name_Cap
FROM orders


-- Use case for Date and Time Extraction
-- 1. Data Aggregation : How many orders were placed each month?
SELECT 
	DATE_TRUNC('month', orderdate),
	COUNT(*) AS nr_of_orders
FROM orders
GROUP BY DATE_TRUNC('month', orderdate)
ORDER BY DATE_TRUNC('month', orderdate) ASC

SELECT 
	-- EXTRACT(MONTH FROM orderdate) AS orders_month,
	TO_CHAR(orderdate, 'Month') AS orders_month,
	COUNT(*) AS nr_of_orders
FROM orders
GROUP BY TO_CHAR(orderdate, 'Month')
ORDER BY TO_CHAR(orderdate, 'Month') ASC

-- How many orders were placed each year?
SELECT 
	EXTRACT(YEAR FROM orderdate) AS orders_year,
	COUNT(*) AS nr_of_orders
FROM orders
GROUP BY EXTRACT(YEAR FROM orderdate)

-- 2. Data Filtering : Show all orders that were placed during the month of February
SELECT 
	TO_CHAR(orderdate, 'Mon') AS orders_month,
	orderid,
	orderdate,
	shipdate,
	shipaddress,
	quantity,
	creationtime,
	sales
FROM orders
WHERE TO_CHAR(orderdate, 'Mon') = 'Feb'



-- 2. Format & Casting

-- Formatting Functions in PostgreSQL: PostgreSQL uses specialized template patterns (like 'YYYY' for a 4-digit year, 'MM' for a month, and 'DD' for a day) to handle formatting.
-- A. TO_CHAR()
/* -- Definition: Converts a timestamp, date, or numeric value to a 
formatted text string based on a specified layout mask.
-- Syntax: 'TO_CHAR(value, 'format_pattern')' */

-- Example (Formatting a Date):
SELECT 
	TO_CHAR(orderdate, 'Day, DD Month YYYY') AS readable_date
FROM orders

-- Example (Formatting Currency/Numbers)
SELECT TO_CHAR(12500.00, '99,999.99') AS formatted_currency

-- Working with various formats
SELECT 
	orderdate,
	creationtime,
	TO_CHAR(creationtime, 'mm-dd-yyyy') usa_format,
	TO_CHAR(creationtime, 'dd-mm-yyyy') europian_format,
	TO_CHAR(creationtime, 'd') d,
	TO_CHAR(creationtime, 'dd') dd,
	TO_CHAR(creationtime, 'ddd') ddd,
	TO_CHAR(creationtime, 'Mon') Mon,
	TO_CHAR(creationtime, 'Month') Month_cap,
	TO_CHAR(creationtime, 'MONTH') month_full,
	TO_CHAR(creationtime, 'month') month_full_lower
FROM orders

-- Task: Show creationtime using the following format "Day, Wed Jan Q1 2025 12:34:56 PM"
SELECT
	creationtime,
	format('Day, %s', TO_CHAR(creationtime, 'Dy Mon Q1 YYYY HH:MM:SS PM'))
FROM orders

-- Task: How many orders were placed in each month? (Use date formatting)
SELECT
	TO_CHAR(orderdate, 'Mon YY') orderdate,
	COUNT(*)
FROM orders
GROUP BY TO_CHAR(orderdate, 'Mon YY')




-- Casting Functions In PostgreSQL
/* Definition: To convert data types explicitly, PostgreSQL provides two 
distinct syntax pathways:the standard ANSI(CAST()) function and the 
Postgres-native shorthand '::' operator.*/

-- A. The standard CAST() Function
/* Definition: Conforms to universal SQL standards to convert an expression to a target data type.
Syntax: CAST(expression AS target_data_type)
Example: Conveting a text string extracted from an API into an actual calculator-ready integer.*/
SELECT CAST('42' AS INTEGER) AS total_count

-- Example: String to Int convert
SELECT CAST('123' AS INTEGER) AS "String to Int Convert"

-- B. The PostgreSQL Shortcut Operator (::)
/* Definition: A proprietary, highly popular Postgres-native shorthand operator that performs identical type conversions with cleaner, more concise syntax.
Syntax: `expression::target_data_type`
Example 1 (Text to Date):	*/
SELECT '2026-05-24'::DATE AS registeration_date

-- Example 2 (Timestamp to Time): Slicing off the calendar date to isolate just the clock time.
SELECT NOW()::TIME AS current_clock_time

-- 3. Calculations
/* Postgres allows you to perform addition, substraction, multiplication, and division on temporal data using 
(+, -, *, /) operators alongside the INTERVAL data type.*/

-- * INTERVAL: The Core Secret
/* To perform math or dates, you must understand the INTERVAL data type. An interval represents a span of time (e.g., '3 days', '2 months', '5 hours'). You use to tell postgres exactly how much time to add or substract.*/
-- Common formats:
	-- INTERVAL '1 day'
	-- INTERVAL '4 weeks'
	-- INTERVAL '2 months 15 days'
	-- INTERVAL '1 year 3 months'

-- Basic Date Arithmetic Operations

-- A. Adding Time to a Date / Timestamp (Date + INTERVAL)
/* Syntax: base_date + INTERVAL 'quantity unit' 
Example: Add 2 years in the order_date */
SELECT 
	orderdate,
	orderdate + INTERVAL '2 years' as future
FROM orders

SELECT 
	orderdate,
	creationtime + INTERVAL '2 months' as future
FROM orders

-- B. Substracting Time from Date/Timestamp (Date-Interval)
/* Example:  */
SELECT 
	orderdate,
	creationtime,
	orderdate - INTERVAL '2 years' two_years_in_past,
	creationtime - INTERVAL '2 months' two_months_in_past
FROM orders

-- Substracting a Date from another Date (Date - Date)
/* Syntax: future_date - past_date 
Example: Substract orderdate from creationtime */
SELECT 
	orderdate,
	shipdate,
	shipdate - orderdate as days
FROM orders

-- Example: Calculate the age of employees
SELECT 
	NOW() - birthdate AS empAGE
FROM employees
 
-- Find the average shipping duration in days for each month
SELECT 
	EXTRACT(MONTH FROM shipdate),
	AVG(EXTRACT(MONTH FROM shipdate))
FROM orders
GROUP BY EXTRACT(MONTH FROM shipdate)

/* We can also substract an timestamp from another timestamp. We only have one timestamp column so that gives me an excuse to not write an example...*/

-- C. Advanced multiplication and division with intervals
/* We cannot multiply two dates together (as that makes no physical sense), but you can multiply or divide an INTERVAL by a regular number. */

	-- i. INTERVAL multiplication
	/* Example: if a billing cycle repeats every 3 months, calculate how far out an account will renew after 4 consecutivev billing cycles */
	SELECT 
		NOW() + (INTERVAL '3 months' * 4) AS final_renewal_date 
	/* so it basically multiplied 3 with 4 making the 3 months 12 months */

	-- ii. INTERVAL Division
	/* Example: Split a standard 30-day project phase into three equal milestones to find out how many days each milestone gets. */
	SELECT INTERVAL '30 days' / 3 AS milestone_duration

-- D. Built-In Mathematical Functions for Dates
/* Aside from standard math symbols, Postgres provides unique build-in functions to handle age calculations*/
	-- i. AGE() function:
	/* Definition: Calculates the precise difference between two timestamps and returns the 
	output as a highly detailed, readable interval showing years, months, and days. If you only
	pass in one date, it automatically substracts that date from the current system time (NOW()) 
	Syntax: AGE(future_date, past_date) or AGE(past_date)
	Example: Finding my exact age */
	SELECT 
		AGE('2025-05-27', '2004-01-01') AS myAge,
		AGE('2004-01-01') AS myAge2
		
	SELECT 
		AGE('2004-01-01'::TIMESTAMP) AS myAge


