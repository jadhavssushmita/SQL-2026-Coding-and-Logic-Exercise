/*
Act as a Principal Product Analytics Manager at Staples. 
Create a hard-difficulty product analytics technical interview exercise focused specifically on sku bid data.
Give me usecase, mock data, questions and solution

*/

USE basic_sql_questions;

-- Use Case: Dynamic SKU-Level Bid Optimization Engine Evaluation
/*
Business Context:On the Staples Media Network (SMN), vendors and internal category managers bid on sponsored search keywords 
(e.g., "heavy-duty paper shredder", "ergonomic office chair") to drive on-site conversion.  
The AdTech Data Science team developed a new automated bidding engine (Algo_v2) to replace the rule-based legacy engine (Algo_v1). 
Algo_v2 dynamically adjusts target cost-per-click (CPC) bids based on real-time inventory levels, predicted conversion 
rate , and target Return on Ad Spend (ROAS).To evaluate Algo_v2, 
product analytics ran a 30-day A/B test across 5 high-volume Staples SKUs. 
The primary goal is to maximize Net Margin Dollars after Ad Spend, while preventing out-of-stock (OOS) conditions that 
cannibalize organic search rankings and destroy overall operational profitability.
*/

-- Stakeholder : VP of Product and Head of Retail Media Network

-- uncomment from here to build the table and populate rows for this question
/*
-- Drop table if exists to allow clean execution
DROP TABLE IF EXISTS sku_bid_performance;

-- Create the table schema for SKU Bid Performance tracking
CREATE TABLE sku_bid_performance (
    sku_id        VARCHAR(20)    NOT NULL,
    category      VARCHAR(50)    NOT NULL,
    algo_variant  VARCHAR(20)    NOT NULL,
    unit_price    NUMERIC(10, 2) NOT NULL,
    unit_cogs     NUMERIC(10, 2) NOT NULL,
    ad_clicks     INT            NOT NULL CHECK (ad_clicks >= 0),
    ad_spend      NUMERIC(10, 2) NOT NULL CHECK (ad_spend >= 0),
    ad_orders     INT            NOT NULL CHECK (ad_orders >= 0),
    ad_units_sold INT            NOT NULL CHECK (ad_units_sold >= 0),
    stockout_days INT            NOT NULL CHECK (stockout_days >= 0 AND stockout_days <= 30),
    
    PRIMARY KEY (sku_id, algo_variant)
);

-- Insert 30-day A/B test data for evaluation
INSERT INTO sku_bid_performance (
    sku_id, category, algo_variant, unit_price, unit_cogs, 
    ad_clicks, ad_spend, ad_orders, ad_units_sold, stockout_days
) VALUES
('SKU-101', 'Shredders',    'Control_v1', 120.00, 70.00, 2000, 1600.00, 100, 100, 0),
('SKU-101', 'Shredders',    'Test_v2',    120.00, 70.00, 3750, 3375.00, 150, 150, 4),
('SKU-102', 'Paper (Bulk)', 'Control_v1',  45.00, 30.00, 5000, 2500.00, 500, 750, 0),
('SKU-102', 'Paper (Bulk)', 'Test_v2',     45.00, 30.00, 7200, 4320.00, 576, 864, 8),
('SKU-103', 'Tech Acc.',    'Control_v1',  60.00, 25.00, 3200, 1920.00, 224, 224, 0),
('SKU-103', 'Tech Acc.',    'Test_v2',     60.00, 25.00, 4750, 2375.00, 380, 380, 1);


*/
-- Write a SQL query to calculate eCPC, conversion rate, gross ad revenue, net margin dollars after ad spend and COGS, and ROAS per SKU and algorithm variant.

SELECT  * FROM sku_bid_performance;

SELECT 
    sku_id,
    algo_variant,
    ROUND(ad_spend / NULLIF(ad_clicks, 0), 2) AS ecpc,
    ROUND(ad_orders  / NULLIF(ad_clicks, 0), 4) AS CVR,
    (ad_units_sold * unit_price) AS gross_ad_revenue,
    ((ad_units_sold * (unit_price - unit_cogs)) - ad_spend) AS net_margin_dollars,
    ROUND((ad_units_sold * unit_price) / NULLIF(ad_spend, 0), 2) AS ad_roas
FROM sku_bid_performance;
