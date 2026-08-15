USE sql_tables;

/*
Prompt:
Act as a Principal Product Analytics Manager at DoorDash. 
Create a hard-difficulty product analytics technical interview exercise focused specifically on DashPass and Dasher operations.
Give me usecase, mock data, 2 questions and solution
*/

-- Business Usecase
-- Doordash premium subscription program DashPass, provides members reduced fees and expediated fulfillment SLAs.
-- During peak hours, market dynamics create fiction :
-- 1) Member expectation: DashPass carries a strict 30 minutes window for delivery
-- 2) Dasher Behavior: Dasher operates as contractor who evaluates based on payout efficiency
-- 3) Declined small tip orders create a dispatch retry cycle, delaying assignment and sla breaches

-- Solution
-- Evaluate order to dispatch retry cascade

-- Create Table 1: dashpass_orders
CREATE TABLE dashpass_orders (
    order_id INT PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    store_id VARCHAR(50) NOT NULL,
    order_timestamp TIMESTAMP NOT NULL,
    delivery_sla_mins INT NOT NULL,
    actual_delivery_mins INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL
);

-- Create Table 2: dasher_dispatches
CREATE TABLE dasher_dispatches (
    dispatch_id VARCHAR(50) PRIMARY KEY,
    order_id INT NOT NULL,
    dasher_id VARCHAR(50) NOT NULL,
    offered_timestamp TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('OFFERED', 'ACCEPTED', 'DECLINED', 'TIMEOUT')),
    estimated_payout DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES dashpass_orders(order_id)
);

-- Insert Mock Data into dashpass_orders
INSERT INTO dashpass_orders (order_id, user_id, store_id, order_timestamp, delivery_sla_mins, actual_delivery_mins, total_amount)
VALUES 
    (1001, 'u_88', 's_12', '2026-08-10 17:15:00', 30, 42, 34.50),
    (1002, 'u_91', 's_14', '2026-08-10 17:22:00', 25, 24, 18.00),
    (1003, 'u_88', 's_12', '2026-08-10 18:05:00', 30, 38, 52.00),
    (1004, 'u_74', 's_09', '2026-08-10 18:30:00', 35, 31, 22.10),
    (1005, 'u_91', 's_14', '2026-08-10 19:10:00', 25, 33, 41.00);

-- Insert Mock Data into dasher_dispatches
INSERT INTO dasher_dispatches (dispatch_id, order_id, dasher_id, offered_timestamp, status, estimated_payout)
VALUES 
    ('d_501', 1001, 'dash_01', '2026-08-10 17:15:30', 'DECLINED', 6.50),
    ('d_502', 1001, 'dash_02', '2026-08-10 17:17:00', 'ACCEPTED', 7.00),
    ('d_503', 1002, 'dash_03', '2026-08-10 17:22:15', 'ACCEPTED', 5.50),
    ('d_504', 1003, 'dash_02', '2026-08-10 18:05:15', 'DECLINED', 8.00),
    ('d_505', 1003, 'dash_04', '2026-08-10 18:07:00', 'DECLINED', 8.00),
    ('d_506', 1003, 'dash_01', '2026-08-10 18:09:30', 'ACCEPTED', 9.50),
    ('d_507', 1005, 'dash_03', '2026-08-10 19:10:30', 'DECLINED', 6.00),
    ('d_508', 1005, 'dash_04', '2026-08-10 19:12:00', 'ACCEPTED', 6.50);
    


-- Write a SQL query that analyzes the order dispatch attempt sequence. 

SELECT * FROM dasher_dispatches;
SELECT * FROM dashpass_orders;


WITH base_sequence AS
(
SELECT
      dd.order_id
     ,dd.dispatch_id
     ,dd.offered_timestamp
     ,ROW_NUMBER() OVER (PARTITION BY dd.order_id ORDER BY dd.offered_timestamp) AS dispatch_sequence
     ,FIRST_VALUE(dd.offered_timestamp) OVER (PARTITION BY dd.order_id ORDER BY dd.offered_timestamp) AS first_timestamp
     ,TIMESTAMPDIFF(SECOND, FIRST_VALUE(dd.offered_timestamp) OVER (PARTITION BY dd.order_id ORDER BY dd.offered_timestamp) , dd.offered_timestamp) AS dispatch_delay_seconds
FROM dasher_dispatches dd
)
SELECT 
    b.order_id
    ,COUNT(dispatch_sequence) AS dispatch_count
    ,SUM(dispatch_delay_seconds) AS dispatch_delay_seconds
    ,CASE WHEN do.delivery_sla_mins >= do.actual_delivery_mins THEN 0 ELSE 1 END AS is_sla_breach
FROM base_sequence b
INNER JOIN dashpass_orders do ON b.order_id = do.order_id
GROUP BY b.order_id;

-- Dispatch count, dispatch delay in seconds, was sla breached