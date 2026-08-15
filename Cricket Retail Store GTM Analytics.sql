/*

DROP TABLE IF EXISTS sales_orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS teams;

-- 1. Cricket Teams (IPL & International)
CREATE TABLE teams (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(50) NOT NULL,
    league VARCHAR(15) CHECK (league IN ('IPL', 'International')),
    region VARCHAR(20) CHECK (region IN ('India', 'Global'))
);

-- 2. Products
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    team_id INT REFERENCES teams(team_id),
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    stock_quantity INT DEFAULT 0
);

-- 3. Customers (With First-Touch GTM Attribution)
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    favorite_team_id INT REFERENCES teams(team_id),
    joined_date DATE NOT NULL,
    signup_utm_source VARCHAR(50),
    signup_utm_medium VARCHAR(50),
    signup_utm_campaign VARCHAR(50)
);

-- 4. Sales Orders (With Last-Touch GTM Attribution)
CREATE TABLE sales_orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    order_date DATE NOT NULL,
    quantity INT CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL,
    channel VARCHAR(20) CHECK (channel IN ('In-Store', 'Online', 'App')),
    utm_source VARCHAR(50),
    utm_medium VARCHAR(50),
    utm_campaign VARCHAR(50),
    landing_page VARCHAR(100)
);


INSERT INTO teams (team_id, team_name, league, region) VALUES
(101, 'Chennai Super Kings', 'IPL', 'India'),
(102, 'Mumbai Indians', 'IPL', 'India'),
(103, 'Royal Challengers Bengaluru', 'IPL', 'India'),
(104, 'Kolkata Knight Riders', 'IPL', 'India'),
(105, 'Gujarat Titans', 'IPL', 'India'),
(106, 'India National Team', 'International', 'Global'),
(107, 'Australia National Team', 'International', 'Global'),
(108, 'England National Team', 'International', 'Global'),
(109, 'Pakistan National Team', 'International', 'Global'),
(110, 'South Africa National Team', 'International', 'Global');

INSERT INTO products (product_id, product_name, category, team_id, price, stock_quantity) VALUES
(1, 'CSK Whistle Podu Official Match Jersey', 'Apparel', 101, 195.00, 50),
(2, 'MI Blue Gold Fan Cap', 'Headwear', 102, 42.00, 120),
(3, 'RCB Signed Replica Bat - Virat Kohli Edition', 'Memorabilia', 103, 85.00, 30),
(4, 'KKR Purple Gold Hooded Sweatshirt', 'Apparel', 104, 75.00, 60),
(5, 'GT Championship Autographed Leather Ball', 'Memorabilia', 105, 120.00, 15),
(6, 'India T20 World Cup Champion Jersey', 'Apparel', 106, 175.00, 40),
(7, 'Aussie Baggy Green Style Cap', 'Headwear', 107, 35.00, 80),
(8, 'England Test Cricket Classic Polo', 'Apparel', 108, 65.00, 45),
(9, 'Phillies Mascot Plush / Pakistan Green Bobblehead', 'Collectibles', 109, 30.00, 100),
(10, 'Proteas Gold & Green Sun Cap', 'Headwear', 110, 38.00, 90),
(11, 'CSK Yellow Bucket Hat', 'Headwear', 101, 32.00, 70),
(12, 'RCB Custom Player Name Jersey', 'Apparel', 103, 210.00, 25),
(13, 'MI Wankhede Stadium Framed Turf Relic', 'Memorabilia', 102, 50.00, 20),
(14, 'KKR Knight Mascot Plush Toy', 'Collectibles', 104, 25.00, 150),
(15, 'GT Victory Commemorative Pennant Flag', 'Collectibles', 105, 18.00, 200);

INSERT INTO customers (customer_id, first_name, last_name, email, favorite_team_id, joined_date, signup_utm_source, signup_utm_medium, signup_utm_campaign) VALUES
(501, 'MS', 'Dhoni', 'msd7@example.com', 101, '2024-01-15', 'google', 'cpc', 'opening_day_2024'),
(502, 'Rohit', 'Sharma', 'hitman@example.com', 102, '2024-02-10', 'facebook', 'paid_social', 'spring_training_sale'),
(503, 'Virat', 'Kohli', 'king@example.com', 103, '2024-03-01', 'instagram', 'paid_social', 'rcb_retargeting'),
(504, 'Gautam', 'Gambhir', 'gg23@example.com', 104, '2024-03-12', 'google', 'organic', 'seo_brand'),
(505, 'Hardik', 'Pandya', 'hp33@example.com', 105, '2024-04-05', 'newsletter', 'email', 'monthly_digest_apr'),
(506, 'Jasprit', 'Bumrah', 'boom@example.com', 106, '2024-05-18', 'twitter', 'paid_social', 'playoff_push'),
(507, 'Pat', 'Cummins', 'patty@example.com', 107, '2024-06-02', 'google', 'cpc', 'father_day_2024'),
(508, 'Ben', 'Stokes', 'stokesy@example.com', 108, '2024-06-20', 'direct', 'none', 'none'),
(509, 'Babar', 'Azam', 'babar56@example.com', 109, '2024-07-01', 'youtube', 'influencer', 'harper_unboxing'),
(510, 'AB', 'de Villiers', 'abd17@example.com', 110, '2024-07-15', 'google', 'cpc', 'all_star_game');

INSERT INTO sales_orders (order_id, customer_id, product_id, order_date, quantity, unit_price, channel, utm_source, utm_medium, utm_campaign, landing_page) VALUES
(1001, 501, 1, '2026-06-01', 1, 195.00, 'Online', 'google', 'cpc', 'summer_apparel_2026', '/products/csk-match-jersey'),
(1002, 501, 11, '2026-06-01', 2, 32.00, 'Online', 'google', 'cpc', 'summer_apparel_2026', '/products/csk-bucket-hat'),
(1003, 502, 2, '2026-06-02', 1, 42.00, 'In-Store', 'direct', 'none', 'store_kiosk', '/pos'),
(1004, 502, 13, '2026-06-03', 1, 50.00, 'In-Store', 'direct', 'none', 'store_kiosk', '/pos'),
(1005, 503, 3, '2026-06-05', 1, 85.00, 'App', 'klaviyo', 'email', 'flash_sale_june', '/app/replica-bat'),
(1006, 503, 12, '2026-06-05', 1, 210.00, 'App', 'klaviyo', 'email', 'flash_sale_june', '/app/custom-jersey'),
(1007, 504, 4, '2026-06-07', 2, 75.00, 'Online', 'google', 'organic', 'seo_hoodies', '/category/kkr-apparel'),
(1008, 505, 5, '2026-06-10', 1, 120.00, 'In-Store', 'direct', 'none', 'store_kiosk', '/pos'),
(1009, 505, 15, '2026-06-10', 3, 18.00, 'In-Store', 'direct', 'none', 'store_kiosk', '/pos'),
(1010, 506, 6, '2026-06-12', 1, 175.00, 'Online', 'facebook', 'paid_social', 'city_connect_promo', '/products/india-wc-jersey'),
(1011, 507, 7, '2026-06-14', 2, 35.00, 'App', 'push_notification', 'app_push', 'fathers_day_deals', '/app/snapback'),
(1012, 508, 8, '2026-06-15', 1, 65.00, 'Online', 'google', 'cpc', 'father_day_2026', '/products/england-polo'),
(1013, 509, 9, '2026-06-18', 4, 30.00, 'In-Store', 'direct', 'none', 'store_kiosk', '/pos'),
(1014, 510, 10, '2026-06-20', 1, 38.00, 'Online', 'instagram', 'paid_social', 'proteas_green_cap', '/products/proteas-cap'),
(1015, 501, 1, '2026-06-22', 1, 195.00, 'App', 'push_notification', 'app_push', 'csk_win_streak', '/app/csk-match-jersey'),
(1016, 503, 3, '2026-06-25', 2, 85.00, 'In-Store', 'direct', 'none', 'store_kiosk', '/pos'),
(1017, 504, 14, '2026-06-28', 1, 25.00, 'Online', 'klaviyo', 'email', 'weekly_newsletter', '/products/kkr-plush'),
(1018, 502, 2, '2026-07-01', 3, 42.00, 'Online', 'facebook', 'paid_social', 'summer_apparel_2026', '/products/mi-cap'),
(1019, 506, 6, '2026-07-03', 1, 175.00, 'App', 'push_notification', 'app_push', 'india_promo', '/app/wc-jersey'),
(1020, 507, 7, '2026-07-05', 1, 35.00, 'In-Store', 'direct', 'none', 'store_kiosk', '/pos'),
(1021, 508, 8, '2026-07-08', 2, 65.00, 'Online', 'google', 'organic', 'seo_polo', '/products/england-polo'),
(1022, 509, 9, '2026-07-10', 1, 30.00, 'App', 'tiktok', 'influencer', 'bobblehead_trend', '/app/pakistan-bobblehead'),
(1023, 510, 10, '2026-07-12', 2, 38.00, 'In-Store', 'direct', 'none', 'store_kiosk', '/pos'),
(1024, 501, 11, '2026-07-15', 1, 32.00, 'Online', 'google', 'cpc', 'mid_season_sale', '/products/csk-bucket-hat'),
(1025, 505, 5, '2026-07-18', 1, 120.00, 'App', 'klaviyo', 'email', 'vip_collectibles', '/app/gt-autographed-ball'),
(1026, 504, 4, '2026-07-20', 1, 75.00, 'In-Store', 'direct', 'none', 'store_kiosk', '/pos'),
(1027, 503, 12, '2026-07-22', 1, 210.00, 'Online', 'google', 'cpc', 'mid_season_sale', '/products/rcb-custom-jersey'),
(1028, 502, 13, '2026-07-25', 2, 50.00, 'App', 'push_notification', 'app_push', 'mi_wankhede_promo', '/app/mi-framed-turf'),
(1029, 507, 7, '2026-07-28', 1, 35.00, 'Online', 'google', 'organic', 'seo_hats', '/products/aussie-cap'),
(1030, 510, 10, '2026-08-01', 3, 38.00, 'In-Store', 'direct', 'none', 'store_kiosk', '/pos');


*/

SELECT * FROM  sales_orders;
SELECT * FROM  products;
SELECT * FROM  customers;
SELECT * FROM  teams;

-- What is the total revenue and average order value (AOV) generated by each marketing channel (utm_source / utm_medium)?

SELECT
  utm_source AS source
, utm_campaign AS medium
,SUM(unit_price * quantity) AS total_revenue
,ROUND(AVG(unit_price * quantity) ,2) AS avg_order_value
FROM sales_orders
GROUP BY 1,2 
ORDER BY 3 DESC;

-- Which specific team generates the highest revenue across all merchandise sales?

-- Logic
-- Fetch the order with highest sale
-- map product to find team but joining to sales order, products and teams table

WITH base AS
(
    SELECT
          order_id
        , product_id
        , SUM(quantity * unit_price) AS total_revenue
        , DENSE_RANK() OVER (ORDER BY SUM(quantity * unit_price) DESC) AS rnk
    FROM sales_orders so
    GROUP BY order_id, product_id
 )
SELECT DISTINCT 
   b.product_id 
 , b.total_revenue
  , t.team_name
FROM base b
INNER JOIN products p ON b.product_id = p.product_id AND b.rnk = 1
INNER JOIN teams t ON p.team_id = t.team_id;

-- Compare sales distribution across channel
SELECT
channel
,COUNT(order_id) AS total_orders
,COUNT(DISTINCT customer_id) AS total_customers
,SUM(quantity) AS total_items_sold
,SUM(quantity * unit_price) AS total_revenue
,ROUND(SUM(quantity * unit_price) * 100 / SUM(SUM(quantity * unit_price)) OVER (), 2 ) AS revenue_share_pct
FROM sales_orders
GROUP BY channel;

-- Analyze First-Touch Campaign (signup_utm_campaign) vs. Last-Touch Order Campaign (utm_campaign) mismatch for customers.
SELECT
 CONCAT(c.first_name, " ",c.last_name) AS customer_name
, so.order_id
, c.signup_utm_campaign AS first_touch_point
, so.utm_campaign AS last_touchpoint
, CASE 
    WHEN c.signup_utm_campaign = so.utm_campaign THEN 'Same Campaign'
    WHEN c.signup_utm_campaign != so.utm_campaign THEN 'Campaign Mismatch (Multi Touch)'
    END AS touchpoint_status
    
FROM customers c 
-- one customer can have multiple orders
INNER JOIN sales_orders so ON c.customer_id = so.customer_id ;

-- Which campaign generated highest revenue for online and app orders?
SELECT 
 so.utm_campaign
, SUM(so.quantity * so.unit_price) AS total_revenue
FROM sales_orders so
WHERE channel IN ('Online', 'App')
GROUP BY so.utm_campaign
ORDER BY 2
LIMIT 1;
