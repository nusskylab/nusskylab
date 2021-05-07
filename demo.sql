# reset application status and proposal links
# UPDATE teams
SET application_status = 'a',
    evaluator_students = NULL,
    proposal_link = NULL,
    avg_rank = 1;
# # UPDATE students
# SET application_status = 'a'
#     evaluatee_ids = NULL;
# # # adjust all deadlines to the future
# UPDATE application_deadlines
# SET submission_deadline = '2021-05-28 09:44:00';
# # add "a lonely student" (1) and failed students (6, 2 at a, b, c respectively)
# for i in {25..32} do
#     #todo: convert int to str, adjust team id
#     #create teams
#     if [$i > 25]
#         INSERT INTO teams (id, team_name, application_status, created_at)
#             VALUES ($i//2, 'team' + $i, 'a' + $i, CURRENT_TIMESTAMP);
#         INSERT INTO users (id, email, user_name, created_at)
#             VALUES ($i, $i + '@qq.com', 'student' + $i, CURRENT_TIMESTAMP);
#         INSERT INTO students (id, user_id, application_status, created_at, team_id)
#             VALUES ($i, $i + '@qq.com', 'a', CURRENT_TIMESTAMP, $i//2);
#     else
#         INSERT INTO users (id, email, user_name, created_at)
#             VALUES ($i, $i + '@qq.com', 'student' + $i, CURRENT_TIMESTAMP);
#         INSERT INTO students (id, user_id, application_status, created_at)
#             VALUES ($i, $i + '@qq.com', 'a', CURRENT_TIMESTAMP);
#     fi
# done
# # adjust the first deadline to the past (fc)
# UPDATE application_deadlines
# SET submission_deadline = '2020-05-28 09:44:00'
# WHERE name = form_team_deadline;
# # first added team doesn't submit proposals while other do
# for i in {26..32} do
#     #todo: convert int to str
#     #submit project proposals
#     if [$i > 27]
#         UPDATE teams
#         SET application_status = 'b',
#             proposal_link = 'a proposal link'
#         WHERE team_id = $i//2;
#     fi
# done
# # adjust proposal deadline to the past (fc)
# UPDATE application_deadlines
# SET submission_deadline = '2020-05-28 09:44:00'
# WHERE name="submit_proposal_deadline";
# # manually press peer evaluation matching generation
# # adjust peer evaluation ddl to the past (fc)
# UPDATE application_deadlines
# SET submission_deadline = '2020-05-28 09:44:00'
# WHERE name="peer_evaluation_deadline";
# # select students
# # adjust results announcement ddl to the past (fc)
# UPDATE application_deadlines
# SET submission_deadline = '2020-05-28 09:44:00'
# WHERE name="result_release_date";
