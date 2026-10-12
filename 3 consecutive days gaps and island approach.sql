-- gaps-and-islands approach

USE basic_sql_questions;

CREATE TABLE user_logins (
    qn INT, -- optional sequence/id if needed, or we can use userid and login_date directly
    userid VARCHAR(50),
    login_date DATE
);

INSERT INTO user_logins (userid, login_date) VALUES 
('a', NULL),
('a', '2025-01-02'),
('a', '2025-01-04'),
('b', '2025-01-01'),
('b', '2025-01-02'),
('b', '2025-01-03');

SELECT * FROM user_logins;

-- fetch users who logged in 3 consecutive days


WITH distinct_logins AS (
    SELECT DISTINCT userid, login_date
    FROM user_logins
    WHERE login_date IS NOT NULL
)
 ,login_order AS (
    SELECT 
        userid,
        login_date,
        ROW_NUMBER() OVER (PARTITION BY userid ORDER BY login_date) AS rn
    FROM distinct_logins
)
  ,island_groups AS (
    SELECT 
		userid
        ,login_date
        , rn
       , DATE_ADD(login_date, INTERVAL -rn DAY) AS streak_group
    FROM login_order
)
SELECT  userid
FROM island_groups
GROUP BY userid, streak_group
HAVING COUNT(streak_group) = 3 ;