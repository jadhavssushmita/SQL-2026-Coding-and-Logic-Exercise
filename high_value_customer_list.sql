/*

Generate a report listing each high-value customer
defined as any customer whose cumulative spending across all completed transactions exceeds $1,000
along with their total spend. 
	> SUM(amount) > 1000
Ensure that customers who registered in the last 30 days are excluded from the output 
	> registration_date < CURRENT_DATE - INTERVAL '30 DAYS'
    
and display only those who have placed a minimum of 3 distinct orders.
	> HAVING COUNT(DISTINCT order_id) <= 3
*/

/*
USE basic_sql_questions;
-- Create the customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    registration_date DATE NOT NULL
);

-- Create the orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Insert sample customers
INSERT INTO customers (customer_id, name, registration_date) VALUES
(1, 'Alice Smith',   '2025-01-15'), -- Eligible (registered > 30 days ago)
(2, 'Bob Jones',     '2025-03-01'), -- Eligible (registered > 30 days ago)
(3, 'Charlie Brown', '2026-08-25'), -- Excluded: Registered recently (within 30 days)
(4, 'Diana Prince',  '2024-11-10'); -- Eligible (registered > 30 days ago)

-- Insert sample orders
INSERT INTO orders (order_id, customer_id, amount, status, order_date) VALUES
-- Alice: 3 completed orders, total spend = $1,200 (Meets all criteria -> Included)
(101, 1, 400.00, 'completed', '2026-02-10'),
(102, 1, 500.00, 'completed', '2026-04-15'),
(103, 1, 300.00, 'completed', '2026-06-20'),

-- Bob: 4 orders, but total completed spend = $800 (Fails total spend > $1000 threshold -> Excluded)
(104, 2, 200.00, 'completed', '2026-03-10'),
(105, 2, 300.00, 'completed', '2026-05-12'),
(106, 2, 300.00, 'completed', '2026-07-01'),
(107, 2, 150.00, 'cancelled', '2026-07-15'),

-- Charlie: High spend & 3 orders, but registered recently (Fails registration date filter -> Excluded)
(108, 3, 600.00, 'completed', '2026-08-26'),
(109, 3, 500.00, 'completed', '2026-08-28'),
(110, 3, 400.00, 'completed', '2026-09-01'),

-- Diana: Total spend = $1,500, but only 2 orders (Fails distinct orders >= 3 requirement -> Excluded)
(111, 4, 800.00, 'completed', '2026-01-20'),
(112, 4, 700.00, 'completed', '2026-03-05');


SELECT * FROM customers;
SELECT * FROM orders;
*/
SELECT 
    customer_id,
    SUM(amount) AS total_spend
FROM orders
JOIN customers USING (customer_id)
WHERE status = 'completed'
  AND registration_date < CURRENT_DATE - INTERVAL 30 DAY
GROUP BY customer_id
HAVING COUNT(DISTINCT order_id) >= 3
   AND SUM(amount) > 1000;




