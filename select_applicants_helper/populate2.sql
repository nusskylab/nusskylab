-- INSERT INTO users (id, email, user_name, created_at, updated_at)
--         VALUES (9, '9@qq.com', 'student_9', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
--         (10, '10@qq.com', 'student_10', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
--         (11, '11@qq.com', 'student_11', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
--         (12, '12@qq.com', 'student_12', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
--         (13, '13@qq.com', 'student_13', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
--         (14, '14@qq.com', 'student_14', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
--         (15, '15@qq.com', 'student_15', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
--         (16, '16@qq.com', 'student_16', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- INSERT INTO teams (id, team_name, application_status, created_at, updated_at)
--         VALUES (4, 'team4', 'b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
--         (5, 'team5', 'b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
--         (6, 'team6', 'b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
--         (7, 'team7', 'b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- INSERT INTO students (id, user_id, application_status, created_at, team_id, updated_at)
--      VALUES (9, 9, 'b', CURRENT_TIMESTAMP, 4, CURRENT_TIMESTAMP),
--       (10, 10, 'b', CURRENT_TIMESTAMP, 4, CURRENT_TIMESTAMP),
--       (11, 11, 'b', CURRENT_TIMESTAMP, 5, CURRENT_TIMESTAMP),
--       (12, 12, 'b', CURRENT_TIMESTAMP, 5, CURRENT_TIMESTAMP),
--       (13, 13, 'b', CURRENT_TIMESTAMP, 6, CURRENT_TIMESTAMP),
--       (14, 14, 'b', CURRENT_TIMESTAMP, 6, CURRENT_TIMESTAMP),
--       (15, 15, 'b', CURRENT_TIMESTAMP, 7, CURRENT_TIMESTAMP),
--       (16, 16, 'b', CURRENT_TIMESTAMP, 7, CURRENT_TIMESTAMP);

-- UPDATE teams
-- SET proposal_link = 'link'
-- WHERE id > 1;