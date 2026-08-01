CREATE TABLE sales_reps (
    rep_id INT PRIMARY KEY,
    rep_name VARCHAR(50),
    region VARCHAR(50)
);

CREATE TABLE merchants (
    merchant_id INT PRIMARY KEY,
    merchant_name VARCHAR(100),
    category VARCHAR(50)
);

CREATE TABLE opportunities (
    opp_id INT PRIMARY KEY,
    rep_id INT,
    merchant_id INT,
    stage VARCHAR(50),
    amount DECIMAL(10, 2),
    close_date DATE
);

CREATE TABLE monthly_revenue (
    rep_id INT,
    report_month DATE,
    revenue DECIMAL(10, 2)
);

-- Insert Sales Reps
INSERT INTO sales_reps (rep_id, rep_name, region) VALUES
(1, 'Alice Smith', 'East'),
(2, 'Bob Johnson', 'East'),
(3, 'Charlie Brown', 'West'),
(4, 'Diana Prince', 'West'),
(5, 'Evan Wright', 'East');

-- Insert Merchants
INSERT INTO merchants (merchant_id, merchant_name, category) VALUES
(101, 'Fresh Market', 'Grocery'),
(102, 'Corner Store', 'Convenience'),
(103, 'Big Box Mart', 'Retail'),
(104, 'Healthy Bites', 'Grocery'),
(105, 'Window Shoppers Inc.', 'Retail'); -- Added for the "Never Won" question

-- Insert Opportunities (Includes same-day closures, multiple deals per merchant, etc.)
INSERT INTO opportunities (opp_id, rep_id, merchant_id, stage, amount, close_date) VALUES
(1001, 1, 101, 'Closed Won', 1500.00, '2023-01-15'),
(1002, 1, 102, 'Closed Won', 2000.00, '2023-02-10'), -- Gap between deals for Alice
(1003, 2, 103, 'Closed Won', 3500.00, '2023-01-15'), -- Same day closure as Alice (opp_id 1001)
(1004, 3, 104, 'Closed Lost', 5000.00, '2023-01-20'),
(1005, 4, 104, 'Closed Won', 4000.00, '2023-03-01'),
(1006, 4, 104, 'Closed Won', 1200.00, '2023-04-05'), -- Upsell/Cross-sell for Diana
(1007, 2, 101, 'Closed Lost', 1000.00, '2023-02-01'),
(1008, 5, 105, 'Prospect', 800.00, NULL),          -- Pitching, hasn't closed
(1009, 5, 105, 'Closed Lost', 1500.00, '2023-03-15'); -- Window Shoppers Inc. never buys

-- Insert Monthly Revenue (Designed to test MoM growth, peaks, and missing revenue)
INSERT INTO monthly_revenue (rep_id, report_month, revenue) VALUES
-- Alice has 3 months of consecutive growth
(1, '2023-01-01', 1000.00),
(1, '2023-02-01', 1500.00),
(1, '2023-03-01', 2000.00),
(1, '2023-04-01', 2500.00),

-- Bob has a distinct "Peak" month in February
(2, '2023-01-01', 1000.00),
(2, '2023-02-01', 5000.00), -- Peak > Jan and Peak > Mar
(2, '2023-03-01', 2000.00),

-- Charlie has revenue drop to 0 (tests the churn/missing revenue query)
(3, '2023-01-01', 3000.00),
(3, '2023-02-01', 0.00),    

-- Diana is relatively steady
(4, '2023-01-01', 2000.00),
(4, '2023-02-01', 2200.00),
(4, '2023-03-01', 2100.00);



#########################################################################################################
SELECT *
FROM sales_reps;

SELECT *
FROM merchants;

SELECT *
FROM opportunities;

SELECT * 
FROM monthly_revenue;

#########################################################################################################






#########################################################################################################




#########################################################################################################




#########################################################################################################




#########################################################################################################