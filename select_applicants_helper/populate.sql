-- populate with initial data

INSERT INTO users (id, email, user_name, created_at, updated_at)
        VALUES (2, '2@qq.com', 'student_2', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (3, '3@qq.com', 'student_3', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (4, '4@qq.com', 'student_4', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (5, '5@qq.com', 'student_5', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (6, '6@qq.com', 'student_6', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (7, '7@qq.com', 'student_7', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (8, '8@qq.com', 'student_8', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO teams (id, team_name, application_status, created_at, updated_at)
        VALUES (1, 'team1', 'b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (2, 'team2', 'b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (3, 'team3', 'b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO students (id, user_id, application_status, created_at, team_id, updated_at)
     VALUES (2, 2, 'a', CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP),
      (3, 3, 'b', CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP),
      (4, 4, 'b', CURRENT_TIMESTAMP, 1, CURRENT_TIMESTAMP),
      (5, 5, 'b', CURRENT_TIMESTAMP, 2, CURRENT_TIMESTAMP),
      (6, 6, 'b', CURRENT_TIMESTAMP, 2, CURRENT_TIMESTAMP),
      (7, 7, 'b', CURRENT_TIMESTAMP, 3, CURRENT_TIMESTAMP),
      (8, 8, 'b', CURRENT_TIMESTAMP, 3, CURRENT_TIMESTAMP);