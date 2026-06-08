-- Use cases for Ranking Functions

-- 1.Identify duplicate rows in the table 'Orders Archive' and return a clean result without any duplicates
SELECT *
FROM 
(
	SELECT 
		ROW_NUMBER() OVER(PARTITION BY orderid ORDER BY creationtime DESC) AS rn,
		*
	FROM ordersarchive
)t
WHERE rn = 1

-- Get the duplicate rows only
SELECT *
FROM 
(
	SELECT
		ROW_NUMBER() OVER(PARTITION BY orderid ORDER BY creationtime DESC) AS rn,
		*
		FROM ordersarchive
)t	WHERE rn > 1

