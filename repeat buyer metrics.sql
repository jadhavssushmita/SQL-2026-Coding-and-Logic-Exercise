-- repeat buyer metrics
/*
-- purchase sequence logic 
-- difference in number of days
*/

-- Q1] What are total number of repeat buyers?
WITH base_statistic AS (
	SELECT 
	p.user_id
	,purchase_date
	, ROW_NUMBER() OVER (PARTITION BY p.user_id ORDER BY p.purchase_date) AS purchase_sequence
	FROM purchases p
)
SELECT COUNT(DISTINCT user_id) AS total_repeat_buyers
FROM base_statistic
WHERE purchase_sequence > 1;

-- Q2] What is the total percentage of repeat buyers?
WITH base_statistic AS (
SELECT 
p.user_id
,COUNT(user_id) AS purchase_sequence
FROM purchases p
GROUP BY p.user_id
)
SELECT 
COUNT(CASE WHEN purchase_sequence > 1 THEN 1 END) / COUNT(DISTINCT user_id) * 100 AS pct_repeat_buyers
FROM base_statistic;

-- Q2] Days between purchases

SELECT 
p.user_id
,p.purchase_date
,LAG(p.purchase_date) OVER (PARTITION BY p.user_id ORDER BY p.user_id) AS previous_purchase_date
,datediff(p.purchase_date , LAG(p.purchase_date) OVER (PARTITION BY p.user_id ORDER BY p.user_id) ) AS days
FROM purchases p;


-- Q3] Fetch users who re purchase within a week
WITH base AS (
SELECT 
	p.user_id
	,p.purchase_date
	,LAG(p.purchase_date) OVER (PARTITION BY p.user_id ORDER BY p.user_id) AS previous_purchase_date
	,datediff(p.purchase_date , LAG(p.purchase_date) OVER (PARTITION BY p.user_id ORDER BY p.user_id) ) AS days
	,date_add(p.purchase_date , INTERVAL 7 DAY) AS week_later
	FROM purchases p
)
SELECT COUNT(DISTINCT user_id) AS total_users
FROM base
WHERE days <= 7;




