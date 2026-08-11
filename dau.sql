-- DAU / MAU
-- 1. Create Table
CREATE TABLE user_activity_log (
    log_id INT PRIMARY KEY,
    event_date DATE NOT NULL,
    user_id VARCHAR(20) NOT NULL,
    platform VARCHAR(20) NOT NULL,
    event_name VARCHAR(50) NOT NULL
);

-- 2. Insert Granular Activity Data
INSERT INTO user_activity_log (log_id, event_date, user_id, platform, event_name) VALUES
(1001, '2026-01-01', 'USR_001', 'iOS', 'app_open'),
(1002, '2026-01-01', 'USR_001', 'iOS', 'view_item'),
(1003, '2026-01-01', 'USR_002', 'Android', 'app_open'),
(1004, '2026-01-02', 'USR_001', 'iOS', 'checkout'),
(1005, '2026-01-02', 'USR_003', 'Web', 'app_open'),
(1006, '2026-01-15', 'USR_002', 'Android', 'app_open'),
(1007, '2026-01-15', 'USR_004', 'iOS', 'app_open'),
(1008, '2026-01-31', 'USR_001', 'iOS', 'app_open'),
(1009, '2026-01-31', 'USR_003', 'Web', 'view_item'),
(1010, '2026-01-31', 'USR_005', 'Android', 'app_open'),
(1011, '2026-02-01', 'USR_001', 'iOS', 'app_open'),
(1012, '2026-02-01', 'USR_002', 'Android', 'app_open'),
(1013, '2026-02-01', 'USR_006', 'Web', 'app_open'),
(1014, '2026-02-14', 'USR_003', 'Web', 'app_open'),
(1015, '2026-02-14', 'USR_006', 'Web', 'view_item'),
(1016, '2026-02-28', 'USR_001', 'iOS', 'checkout'),
(1017, '2026-02-28', 'USR_007', 'Android', 'app_open');

SELECT * FROM user_activity_log;

-- Daily active users
WITH base AS 
(
	SELECT 
	event_date
	,COUNT(DISTINCT user_id) AS unique_user_per_day
	FROM user_activity_log
	GROUP BY event_date
)
SELECT 
	event_date
    ,unique_user_per_day AS current_user_count
    ,LAG(unique_user_per_day) OVER (ORDER BY event_date) AS previous_day
    -- round( ( current - previous ) / previous * 100  ,2 )
       , ROUND((unique_user_per_day - LAG(unique_user_per_day) OVER (ORDER BY event_date) ) / LAG(unique_user_per_day) OVER (ORDER BY event_date) * 100, 2) AS DAU

FROM base ;

/*
DAU metric : How many users were active on 31 January 2026?
A 50% increase is seen on 31 January 2026 compared to previous day
*/


-- Average DAU
WITH base AS 
(
	SELECT 
	event_date
	,COUNT(DISTINCT user_id) AS unique_user_per_day
	FROM user_activity_log
	GROUP BY event_date
)
, dau AS
(
	SELECT 
		event_date
		,unique_user_per_day AS current_user_count
		,LAG(unique_user_per_day) OVER (ORDER BY event_date) AS previous_day
		-- round( ( current - previous ) / previous * 100  ,2 )
		, ROUND((unique_user_per_day - LAG(unique_user_per_day) OVER (ORDER BY event_date) ) / LAG(unique_user_per_day) OVER (ORDER BY event_date) * 100, 0) AS DAU

	FROM base 
)
SELECT 
ROUND(AVG(DAU),0) AS average_dau
FROM dau;

-- The average daily users is 3 users per day