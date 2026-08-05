USE basic_sql_questions;

-- 1. Create the base table
CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    purchase_date TIMESTAMP NOT NULL,
    amount DECIMAL(10, 2) NOT NULL
);

-- 2. Insert sample data to demonstrate all target metrics
INSERT INTO purchases (purchase_id, user_id, product_name, purchase_date, amount) VALUES
-- User 101: Multiple purchases across months, short-gap repeat
(1, 101, 'Laptop',     '2026-01-05 10:00:00', 1200.00),
(2, 101, 'Mouse',      '2026-01-06 14:00:00',   25.00),  -- 1 day gap (Repeat <= 2 days & <= 7 days)
(3, 101, 'Monitor',    '2026-02-10 09:00:00',  300.00),  -- Purchase > 30 days later
(4, 101, 'Keyboard',   '2026-02-15 11:00:00',   75.00),

-- User 102: Repeat buyer with a 5-day gap
(5, 102, 'Phone',      '2026-01-10 12:00:00',  800.00),
(6, 102, 'Case',       '2026-01-15 16:00:00',   30.00),  -- 5 day gap (Repeat <= 7 days)
(7, 102, 'Laptop',     '2026-03-01 10:00:00', 1200.00),

-- User 103: One-time buyer
(8, 103, 'Headphones', '2026-02-01 08:00:00',  150.00),

-- User 104: First-time buyer in March
(9, 104, 'Phone',      '2026-03-05 11:00:00',  800.00);

-- ----------------------------------------------------------------------------------------------------------
-- Analytics SQL Metrics Calculation 
-- ----------------------------------------------------------------------------------------------------------

-- FIRST TIME BUYER TREND PER MONTH
WITH base_cte AS (
	SELECT 
		*
		,MIN(purchase_date) OVER (PARTITION BY user_id) AS first_purchase -- first purchase date per user
		,ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY purchase_date ASC) AS user_purchase_sequence -- purchase sequence per user
		,LAG(purchase_date) OVER (PARTITION BY user_id ORDER BY purchase_date ASC) AS prev_purchase_date -- previous purchase date per user
		,SUM(amount) OVER (PARTITION BY user_id) AS total_user_spent
	FROM purchases

)
-- first time buyer trend per month
SELECT
	YEAR(purchase_date) AS yy
	,MONTH(purchase_date) AS purchase_month
	,COUNT(DISTINCT user_id) AS user_count
FROM base_cte
WHERE user_purchase_sequence = 1
GROUP BY 1,2;

-- SECOND MOST SOLD PRODUCT
WITH base_cte AS (
	SELECT 
		*
		,MIN(purchase_date) OVER (PARTITION BY user_id) AS first_purchase -- first purchase date per user
		,ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY purchase_date ASC) AS user_purchase_sequence -- purchase sequence per user
		,LAG(purchase_date) OVER (PARTITION BY user_id ORDER BY purchase_date ASC) AS prev_purchase_date -- previous purchase date per user
		,SUM(amount) OVER (PARTITION BY user_id) AS total_user_spent
        ,COUNT(*) OVER (PARTITION BY product_name) AS total_units_sold
        ,amount * (COUNT(*) OVER (PARTITION BY product_name) ) AS total_item_cost
	FROM purchases

)
-- product sales metric
-- , product_ranking AS (
SELECT
	*
    
    ,DENSE_RANK() OVER (ORDER BY total_item_cost DESC) AS product_rankk
FROM base_cte






