USE basic_sql_questions;

/* 
To better understand CLTV customer life time value, cohort retention calculating nth - largest purchase or n-th date is very useful.
Let's implement to understand the data 
*/

-- logic
-- metric calculation for sequence or aggregation at product level purchase could be done through window functions
SELECT 
*
,DENSE_RANK() OVER (PARTITION BY user_id ORDER BY amount DESC) AS purchase_rank -- row_sequence
,SUM(amount) OVER (PARTITION BY user_id ORDER BY user_id) AS total_amount_spent
FROM purchases;
    
WITH purchase_rank AS (
# Fetch n largest purchase 
	SELECT 
		*
		,DENSE_RANK() OVER (PARTITION BY user_id ORDER BY amount DESC) AS purchase_rank -- row_sequence
		,SUM(amount) OVER (PARTITION BY user_id ORDER BY user_id) AS total_amount_spent
	FROM purchases
)
SELECT 
user_id
,SUM(amount) AS top_two_purchases
,MAX(total_amount_spent) AS total_purchase_amount
,SUM(amount) / MAX(total_amount_spent)  * 100 AS top_2_perc
FROM purchase_rank
WHERE purchase_rank IN (1,2) -- top 2 rank
GROUP BY user_id;
-- most expensive top 2 purchase amount to atleast 92% of total_spent

-- -------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------

-- Most expensive purchase item
WITH base_statistic AS
(
	SELECT 
		*
        ,DENSE_RANK() OVER (PARTITION BY user_id ORDER BY amount DESC) AS purchase_rank
        ,SUM(amount) OVER (PARTITION BY user_id ORDER BY user_id) AS total_spent
    FROM purchases
)
SELECT 
user_id
,SUM(amount) AS purchase_price
FROM base_statistic
WHERE purchase_rank = 1
GROUP BY user_id;

-- -------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------

-- First purchase date
WITH first_purchase AS
(
	SELECT 
		*
        ,MIN(purchase_date) OVER (PARTITION BY user_id ORDER BY user_id) AS first_purchase_dt

    FROM purchases
)
SELECT 
	user_id
    ,MIN(DATE(first_purchase_dt)) AS first_purchase
FROM first_purchase
GROUP BY user_id;
