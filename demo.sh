# reset application status and proposal links
# adjust all deadlines to the future
UPDATE application_deadlines
SET submission_deadline = '2022-05-28 09:44:00';

# add 'a lonely student' (1) and failed students (6, 2 at a, b, c respectively)
# INSERT INTO teams (id, team_name, application_status, created_at, updated_at)
#         VALUES (13, 'demo1', 'b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
#         (14, 'demo2', 'b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
#         (15, 'demo3', 'b', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO users (id, email, user_name, created_at, updated_at)
        VALUES (25, '25@qq.com', 'demo_25', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (26, '26@qq.com', 'demo_26', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (27, '27@qq.com', 'demo_27', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (28, '28@qq.com', 'demo_28', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (29, '29@qq.com', 'demo_29', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (30, '30@qq.com', 'demo_30', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
        (31, '31@qq.com', 'demo_31', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

# !convert to student via the portal
# update team status
# INSERT INTO students (id, user_id, application_status, created_at, team_id, updated_at)
#         VALUES (25, 25, 'a', CURRENT_TIMESTAMP, NULL, CURRENT_TIMESTAMP),
#          (26, 26, 'b', CURRENT_TIMESTAMP, 13, CURRENT_TIMESTAMP),
#          (27, 27, 'b', CURRENT_TIMESTAMP, 13, CURRENT_TIMESTAMP),
#          (28, 28, 'b', CURRENT_TIMESTAMP, 14, CURRENT_TIMESTAMP),
#          (29, 29, 'b', CURRENT_TIMESTAMP, 14, CURRENT_TIMESTAMP),
#          (30, 30, 'b', CURRENT_TIMESTAMP, 15, CURRENT_TIMESTAMP),
#          (31, 31, 'b', CURRENT_TIMESTAMP, 15, CURRENT_TIMESTAMP);

UPDATE students
SET application_status = 'b',
    team_id = 13
    WHERE user_id = 26 or user_id = 27;

#!show update for student 26
UPDATE students
SET application_status = 'b',
    team_id = 14
    WHERE user_id = 28 or user_id = 29;

UPDATE students
SET application_status = 'b',
    team_id = 15
    WHERE user_id = 30 or user_id = 31;
# adjust the first deadline to the past (af)
UPDATE application_deadlines
SET submission_deadline = '2020-05-28 09:44:00'
WHERE name = 'form team deadline';
#! show the first student fail
# !manually submit proposal and show team mates

# adjust proposal deadline to the past (bf)
UPDATE application_deadlines
SET submission_deadline = '2020-05-28 09:44:00'
WHERE name='submit proposal deadline';
# !show fail and success

# peer evaluation open time
UPDATE application_deadlines
SET submission_deadline = '2020-05-28 09:44:00'
WHERE name='peer evaluation open date';

UPDATE application_deadlines
SET submission_deadline = '2020-05-28 09:44:00'
WHERE name='peer evaluation deadline';
# ! show change
# ! manually press peer evaluation matching generation
# ! show not changed
# select students
# adjust results announcement ddl to the past (fd)
UPDATE application_deadlines
SET submission_deadline = '2020-05-28 09:44:00'
WHERE name='result release date';

# manual delete teams

DELETE FROM students
WHERE id >= 25;

DELETE FROM users
WHERE id >= 25;
