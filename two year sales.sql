USE basic_sql_questions;

CREATE TABLE yearly_sales (
    year INT,
    sales INT
);

INSERT INTO yearly_sales (year, sales) VALUES 
(2023, 100),
(2024, 200),
(2025, 300),
(2026, 500);

-- Query to get the difference between the current year and 2 years prior
SELECT 
    year,
    sales,
    LAG(sales, 2) OVER (ORDER BY year) AS sales_2_years_ago,
    sales - LAG(sales, 2) OVER (ORDER BY year) AS sales_difference
FROM yearly_sales;