-- ###Ranking Function in PostgreSQL allow you to assign a sequential number, position, or percentage tile to each  row within a sorted partition.
/* Ranking function have 2 strict syntax rules:
1. The ORDER BY clause is mandatory (you cannot rank data withour defining what comes first, second, or last).
2. The FRAME CLAUSE is not allowed (ranks are calculated across the entire partition, not a shifting sub-window).

There are 2 types of ranking :
	1. Integer based ranking: Returns an whole number (1,2,3). Has 4 core functions and the primary difference between them comes down to how they handle the ties.
*/

-- Task: Rank the products based on their sales
SELECT
	orderid,
	sales,
	RANK() OVER(ORDER BY sales) AS ranked_sales
FROM orders

	-- i. ROW_NUMBER() : Assigns a unique consecutive number to each row starting from zero. It does not care about ties and every row gets a different number
	SELECT 
		orderid,
		orderdate,
		productid,
		sales,
		ROW_NUMBER() OVER(ORDER BY sales DESC) AS ranked_rows_using_ROW_NUMBER
	FROM orders

	-- ii. RANK() : Assigns a rank based on the value. Does not care about the ties but when they are ties with the same value both the rows get the same rank. and the rank number for that value gets skipped
	SELECT
		orderid,
		orderdate,
		productid,
		sales,
		RANK() OVER(ORDER BY sales DESC) AS ranked_rows
	FROM orders

	-- iii. DENSE_RANK() : Identical rows receive the same rank just like ROWS(). But it does not skip the number. The ranking sequence remains dense 
	SELECT
		orderid,
		orderdate,
		productid,
		sales,
		DENSE_RANK() OVER(ORDER BY sales) AS ranked_rows
	FROM orders

	-- iv. NTILE(n) : Divides the rows into roughly into n equal groups (buckets) and the bucket number integer for each row
	SELECT
		orderid,
		orderdate,
		productid,
		sales,
		NTILE(5) OVER(ORDER BY sales) AS ranked_rows
	FROM orders

/* 2. Percentage Based Ranking: Percentage based ranking does not care about physical positions. Instead, it measures a row's relative standing or percentile withing the group, returning a decimal value (NUMERIC OR DOUBLE PRECISION) between 0.0 to 1.0 (which map directly to 0% and 100%).*/
	-- i. PERCENT_RANK(): 
/*	 Formula: (Rank -1) / (Total Rows -1)
	Behavior: Calculates the relative rank of a row as a percentile. The very first row in the partition will always have a PERCENT_RANK of 0.0, and the last row will always be 1.0. It tells you: "what percentage of rows have the value less than this row? "*/
	SELECT
		orderid,
		orderdate,
		productid,
		sales,
		ROUND(PERCENT_RANK() OVER(ORDER BY sales)::NUMERIC, 2) AS sales_ranked
	FROM orders

	-- ii. CUME_DIST() (cumulative Distribution)
	/* Formula: Number of rows with values <= Current value / Total Rows 
	Behavior: Calculates the cumulative distribution of a value within the set. It tells you: "What proportion of the dataset is less than or equal to the current row's value?" The result will never start at 0; it scales cleanly up to 1.0*/
	SELECT 
		orderid,
		orderdate,
		productid,
		sales,
		ROUND(CUME_DIST() OVER(ORDER BY sales)::NUMERIC, 2) AS ranked_sales
	FROM orders

-- Task: Rank the orders based on their sales from highest to lowest
SELECT
	orderid,
	ROW_NUMBER() OVER(ORDER BY sales DESC) AS row_based_ranking,
	RANK() OVER(ORDER BY sales DESC) AS value_based_ranking,
	DENSE_RANK() OVER(ORDER BY sales DESC) AS ranked_withour_gaps,
	NTILE(5) OVER(ORDER BY sales DESC) AS ranked_as_tiles,
	PERCENT_RANK() OVER(ORDER BY sales DESC) AS ranked_by_percentage,
	CUME_DIST() OVER(ORDER BY sales) AS cumulative_ranking
FROM orders

-- The ROW_NUMBER() function has more use cases as compared to the other integer-based ranking functions 
-- Task: Find the top highest sales for each product
SELECT
	orderid,
	productid,
	sales,
	ROW_NUMBER() OVER(PARTITION BY productid ORDER BY sales DESC) AS ranked_sales
FROM orders

-- Task: Assign Unique ID's to the rows of the 'Orders Archive' table
