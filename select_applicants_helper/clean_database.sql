DROP TABLE application_deadlines;
DROP TABLE admin_links;

ALTER TABLE students
DROP COLUMN evaluatee_ids;

ALTER TABLE teams
DROP COLUMN avg_rank;

ALTER TABLE teams
DROP COLUMN application_status;

ALTER TABLE teams
DROP COLUMN proposal_link;

ALTER TABLE teams
DROP COLUMN evaluator_students;