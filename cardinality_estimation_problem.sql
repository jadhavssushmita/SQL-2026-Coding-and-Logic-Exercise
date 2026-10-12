USE basic_sql_questions;

-- Create tables
CREATE TABLE cardinality_estimation_tablea (id INT);
CREATE TABLE cardinality_estimation_tableb (id INT);

-- Insert data into Table A (8 rows)
INSERT INTO cardinality_estimation_tablea (id) VALUES 
(1), (1), (1), 
(2), (2), 
(3), 
(NULL), (NULL);

-- Insert data into Table B (7 rows)
INSERT INTO cardinality_estimation_tableb (id) VALUES 
(1), (1), 
(2), (2), (2), 
(4), 
(NULL);

SELECT * FROM cardinality_estimation_tablea;
SELECT * FROM cardinality_estimation_tableb;

SELECT * 
FROM cardinality_estimation_tablea A INNER JOIN cardinality_estimation_tableb B
ON A.id = B.id;

SELECT * 
FROM cardinality_estimation_tablea A  RIGHT JOIN cardinality_estimation_tableb B 
ON A.id = B.id;

SELECT * 
FROM cardinality_estimation_tablea A LEFT JOIN cardinality_estimation_tableb B
ON A.id = B.id;

SELECT * 
FROM cardinality_estimation_tablea A LEFT JOIN cardinality_estimation_tableb B 
ON A.id = B.id  AND B.id = 1;

SELECT * FROM cardinality_estimation_tablea A LEFT JOIN cardinality_estimation_tableb B ON A.id = B.id WHERE B.id = 1;


