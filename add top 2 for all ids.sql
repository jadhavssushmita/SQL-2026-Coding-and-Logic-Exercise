-- 1. Create the database (skip if you already have one active)
CREATE DATABASE store_db;
USE store_db;
-- Connect/use database (MySQL: USE store_db;)

-- 2. Create the purchase dataset table
CREATE TABLE purchase_dataset (
    id INT NOT NULL,
    transaction VARCHAR(50) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL
);

-- 3. Insert mock data with multiple transactions per ID
INSERT INTO purchase_dataset (id, transaction, amount) VALUES
(1, 'TXN_101', 150.00),
(1, 'TXN_102', 300.00),
(1, 'TXN_103',  50.00),
(1, 'TXN_104', 500.00),

(2, 'TXN_201', 120.00),
(2, 'TXN_202',  80.00),

(3, 'TXN_301', 900.00),
(3, 'TXN_302', 450.00),
(3, 'TXN_303', 150.00);

-- Retrieve dataset
SELECT * FROM purchase_dataset;

-- SQL Analytics Query
WITH RankedPurchases AS (
    SELECT 
        p.id
        ,p.transaction
        ,p.amount
        ,SUM(p.amount) OVER (PARTITION BY p.id) AS total_amount
        ,ROUND((p.amount * 100.0) / SUM(p.amount) OVER (PARTITION BY p.id), 2) AS pct_of_total
        ,ROW_NUMBER() OVER (PARTITION BY id ORDER BY amount DESC) AS rnk
    FROM 
        purchase_dataset p
)
SELECT 
    id,
    transaction,
    amount,
    total_amount,
    pct_of_total
FROM 
    RankedPurchases
WHERE 
    rnk <= 2
ORDER BY 
    id, 
    amount DESC;