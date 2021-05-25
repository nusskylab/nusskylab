-- populate with initial data

INSERT INTO users (id, email, user_name, created_at, updated_at)
        VALUES (17, '17@qq.com', 'student_17', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (18, '18@qq.com', 'student_18', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (19, '19@qq.com', 'student_19', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (20, '20@qq.com', 'student_20', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO teams (id, team_name, application_status, created_at, updated_at)
        VALUES (8, 'team8', 'b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (9, 'team9', 'b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO students (id, user_id, application_status, created_at, team_id, updated_at)
     VALUES (17, 17, 'b', CURRENT_TIMESTAMP, 8, CURRENT_TIMESTAMP),
      (18, 18, 'b', CURRENT_TIMESTAMP, 8, CURRENT_TIMESTAMP),
      (19, 19, 'b', CURRENT_TIMESTAMP, 9, CURRENT_TIMESTAMP),
      (20, 20, 'b', CURRENT_TIMESTAMP, 9, CURRENT_TIMESTAMP);