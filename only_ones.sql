/*
Join row count multiplication questions (Only ones)
*/

USE basic_sql_questions;

-- ------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------

-- Drop existing tables
DROP TABLE IF EXISTS TableA;
DROP TABLE IF EXISTS TableB;

-- Create TableA and TableB
CREATE TABLE TableA (id INT);
CREATE TABLE TableB (id INT);

-- Populate TableA (5 ones)
INSERT INTO TableA (id) VALUES (1), (1), (1), (1), (1);

-- Populate TableB (3 ones)
INSERT INTO TableB (id) VALUES (1), (1), (1);

SELECT * FROM TableA a INNER JOIN TableB b ON a.id = b.id; 
-- 15 rows 
-- Every 1 in Table A matches every 1 in Table B 

SELECT * FROM TableA a LEFT JOIN TableB b ON a.id = b.id; 
-- 15 rows
-- Every row in table A has atleast one match in table begin alter

SELECT * FROM TableA a RIGHT JOIN TableB b ON a.id = b.id; 
-- 15 rows
-- Every row in table b found match in table a 

SELECT TableA.id AS A_id, TableB.id AS B_id
FROM TableA 
LEFT JOIN TableB ON TableA.id = TableB.id AND 1 = 0;

SELECT * FROM TableA a CROSS JOIN TableB b ON a.id = b.id; 
-- No unmatched rows
-- rows in a x rows in b

-- How many rows are returned when checking for rows in TableA that have no match in TableB?
SELECT * FROM TableA a LEFT JOIN TableB b ON a.id = b.id
WHERE b.id IS NULL; 

SELECT TableA.id AS A_id, TableB.id AS B_id
FROM TableA 
LEFT JOIN TableB ON TableA.id = TableB.id AND 1 = 0;


SELECT TableA.id AS A_id, TableB.id AS B_id
FROM TableA 
LEFT JOIN TableB ON TableA.id = TableB.id
WHERE TableB.id = 2;
