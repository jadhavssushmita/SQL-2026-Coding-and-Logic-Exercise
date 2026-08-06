/* User conversion mid - funnel insights */

-- Question: first ordered product by each user post aquisition

USE basic_sql_questions;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    category VARCHAR(100),
    product_name VARCHAR(255)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    product_id INT,
    order_datetime DATETIME,
    amount DECIMAL(10, 2),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_id, category, product_name) VALUES 
(1, 'Electronics', 'Laptop'),
(2, 'Electronics', 'Mouse'),
(3, 'Furniture', 'Office Chair'),
(4, 'Stationery', 'Notebook'),
(5, 'Furniture', 'Desk Lamp');

INSERT INTO orders (order_id, user_id, product_id, order_datetime, amount) VALUES 
(1001, 501, 1, '2026-04-01 10:00:00', 999.99),
(1002, 501, 2, '2026-04-02 11:30:00', 25.50),
(1003, 501, 4, '2026-04-05 09:15:00', 5.00),
(1004, 501, 2, '2026-04-07 14:00:00', 25.50),
(1005, 501, 5, '2026-04-08 16:45:00', 45.00),
(1006, 501, 4, '2026-04-10 12:00:00', 5.00),
(1007, 502, 3, '2026-04-01 12:00:00', 150.00),
(1008, 502, 5, '2026-04-03 15:20:00', 45.00),
(1009, 502, 1, '2026-04-04 10:10:00', 999.99),
(1010, 502, 4, '2026-04-06 18:30:00', 5.00),
(1011, 502, 3, '2026-04-09 11:00:00', 150.00);

SELECT * FROM products;
SELECT * FROM orders;

-- -----------------------------------------------------------------------------------------
-- --------------------------- First Ordered Product ---------------------------------------
-- -----------------------------------------------------------------------------------------

WITH base_statistic AS 
(
SELECT 
	p.product_id
    ,p.product_name
    ,p.category AS product_category
    ,o.user_id
    ,o.order_id
    ,o.order_datetime
    ,o.amount
    ,ROW_NUMBER() OVER (PARTITION BY o.user_id ORDER BY o.order_datetime) AS  purchase_sequence
FROM products p INNER JOIN orders o
ON p.product_id = o.product_id
)
, first_purchased_product AS (
SELECT 
user_id
,product_name AS first_purchased_product
FROM base_statistic
WHERE purchase_sequence = 1 
)
SELECT *
FROM first_purchased_product;


-- -----------------------------------------------------------------------------------------
-- ------ Top 3 products ordered by after their first purchase ranked by order count--------
-- -----------------------------------------------------------------------------------------

WITH base_cte AS
( 
SELECT 
  o.user_id
, p.product_id
, p.product_name
, p.category
, o.order_datetime
, ROW_NUMBER() OVER (PARTITION BY o.user_id ORDER BY o.order_datetime) AS purchase_sequence
FROM products p INNER JOIN orders o 
ON p.product_id = o.product_id
)
, purchase_sequence AS 
(
-- exclude first purchase
SELECT *
FROM base_cte
WHERE purchase_sequence != 1
)
SELECT 
product_name
,COUNT(*) AS purchase_frequency
FROM purchase_sequence
GROUP BY product_name
ORDER BY 2 DESC
LIMIT 3
;

-- List first purchase products by each user and then cross sell items

WITH base_purchase_sequence AS
(
	SELECT 
	o.user_id
	, o.order_datetime AS date_purchased
    , o.order_id
	, p.product_id
	, p.product_name
	, p.category AS product_category
	, ROW_NUMBER() OVER (PARTITION BY o.user_id ORDER BY o.order_datetime) AS purchase_sequence
	FROM products p 
	INNER JOIN orders o ON p.product_id = o.product_id
)
, first_product_purchased AS (
-- first_purchased_product
SELECT 
user_id
,product_id AS first_product_id
,date_purchased AS first_order_dt
FROM base_purchase_sequence
WHERE purchase_sequence = 1
/*
# user_id, first_product_id
'501', '1'
'502', '3'

*/
)
 , cross_sell AS (
-- FETCH EVERYTHING EXCEPT FIRST PURCHASE 
SELECT
fpp.user_id
,fpp.first_product_id
,bps.product_id AS crosssell_product_id
,bps.product_category AS crosssell_product_category
,COUNT(DISTINCT(bps.order_id)) AS orders_count
FROM base_purchase_sequence bps 
INNER JOIN first_product_purchased fpp ON bps.user_id = fpp.user_id  AND bps.date_purchased > fpp.first_order_dt
GROUP BY 1,2,3,4
)
, product_ranking AS (
-- rank products ordered by user
SELECT *
,DENSE_RANK() OVER (PARTITION BY user_id ORDER BY orders_count DESC) AS rnkk
FROM cross_sell
)
SELECT * FROM product_ranking
WHERE rnkk <= 3;


