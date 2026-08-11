CREATE DATABASE sql_tables;
USE sql_tables;

CREATE TABLE program (
    program_id INT PRIMARY KEY,
    program_name VARCHAR(255) NOT NULL,
    program_category VARCHAR(100),
    program_duration_minutes DECIMAL(10, 2) NOT NULL -- Total length of the program in minutes
);

INSERT INTO program (program_id, program_name, program_category, program_duration_minutes) VALUES
(101, 'IPL Match 1: CSKs vs MI', 'Sports', 180.00), -- 3 hours = 180 minutes
(102, 'Live Concert 2026', 'Music', 60.00);           -- 1 hour = 60 minutes


CREATE TABLE session_data (
    session_id VARCHAR(100) NOT NULL,
    user_id VARCHAR(100) NOT NULL,
    program_id INT NOT NULL,
    started_at TIMESTAMP NOT NULL, -- Timestamp when user started watching
    ended_at TIMESTAMP NOT NULL,   -- Timestamp when user stopped watching
    FOREIGN KEY (program_id) REFERENCES program(program_id)
);

INSERT INTO session_data 
(session_id, user_id, program_id, started_at, ended_at) 
VALUES
-- User 1: Watched 90 minutes of IPL Match (18:00 to 19:30) -> 50%
('sess_01', 'usr_001', 101, '2026-08-10 18:00:00', '2026-08-10 19:30:00'),
('sess_02', 'usr_002', 101, '2026-08-10 18:00:00', '2026-08-10 20:42:00'),
('sess_03', 'usr_003', 102, '2026-08-10 20:00:00', '2026-08-10 20:30:00'),
('sess_04', 'usr_004', 102, '2026-08-10 20:00:00', '2026-08-10 21:00:00'),
('sess_05', 'usr_001', 101, '2026-08-10 18:00:00', '2026-08-10 19:30:00'), -- 90 mins
('sess_06', 'usr_002', 101, '2026-08-10 18:15:00', '2026-08-10 20:45:00'), -- 150 mins
('sess_07', 'usr_003', 101, '2026-08-10 18:30:00', '2026-08-10 21:00:00'), -- 150 mins
('sess_08', 'usr_004', 101, '2026-08-10 19:00:00', '2026-08-10 20:00:00'), -- 60 mins
('sess_09', 'usr_005', 101, '2026-08-10 18:00:00', '2026-08-10 21:00:00'), -- 180 mins (Full match)
('sess_10', 'usr_006', 101, '2026-08-10 19:30:00', '2026-08-10 21:00:00'), -- 90 mins
('sess_11', 'usr_007', 101, '2026-08-10 20:00:00', '2026-08-10 21:00:00'), -- 60 mins
('sess_08', 'usr_001', 102, '2026-08-10 21:30:00', '2026-08-10 22:30:00'), -- 60 mins (Full concert)
('sess_09', 'usr_002', 102, '2026-08-10 21:30:00', '2026-08-10 22:00:00'), -- 30 mins
('sess_10', 'usr_003', 102, '2026-08-10 21:45:00', '2026-08-10 22:30:00'), -- 45 mins
('sess_11', 'usr_008', 102, '2026-08-10 22:00:00', '2026-08-10 22:30:00'); -- 30 mins


SELECT * FROM program;
SELECT * FROM session_data;

/*
METRIC DEFINITION
User watch time: Number of minutes between start time and end time
total watch time per program: rollup to program grain and aggregate user watch time
Total potential viewing minutes (universe) = program length * total number of users
Average minute audience: total watch time program / program length * total number of users
Percentage of telecast watched: total watch time per program
*/

-- METRIC ANALYSIS
-- average amount of minutes each user watched each program
WITH base_cte AS 
(
    -- calculate minutes from start and end times
    SELECT
    sd.user_id
    ,p.program_name
    ,p.program_duration_minutes
    ,TIMESTAMPDIFF(MINUTE, sd.started_at, sd.ended_at) AS user_watch_time
    FROM session_data sd 
    INNER JOIN program p ON sd.program_id = p.program_id
), 
user_level_rollup AS 
(
    -- rolling up from session level to user and program level data to get aggregates calculation
    -- aggregate data of total watch time of all users
    SELECT
    user_id
    ,program_name
    ,MAX(program_duration_minutes) AS program_length
    ,SUM(user_watch_time) AS total_watch_time_per_program_per_user
    FROM 
        base_cte
    GROUP BY 1,2 
    ORDER BY 2 

)
-- just for average calculation
SELECT 
      program_name
    , COUNT(DISTINCT user_id) AS unique_users
    , MAX(program_length) as Program_length
    , SUM(total_watch_time_per_program_per_user) AS total_minutes_viewed
    , SUM(total_watch_time_per_program_per_user) / MAX(program_length) AS average_minute_audience
    , SUM(total_watch_time_per_program_per_user) / (MAX(program_length) * COUNT(DISTINCT user_id)) * 100 AS percentage_of_telecast_watched
    -- total length of program in minutes
FROM 
    user_level_rollup
GROUP BY 
    program_name ;

