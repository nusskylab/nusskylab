CREATE TABLE application_deadlines (
    id int,
    name text,
    submission_deadline timestamp
);

INSERT INTO application_deadlines
VALUES (1, 'form team deadline', CURRENT_TIMESTAMP),
(2, 'submit proposal deadline', CURRENT_TIMESTAMP),
(3, 'peer evaluation open date', CURRENT_TIMESTAMP),
(4, 'peer evaluation deadline', CURRENT_TIMESTAMP),
(5, 'result release date', CURRENT_TIMESTAMP),
(6, 'portal open date', CURRENT_TIMESTAMP);

CREATE TABLE admin_links (
    id int,
    name text,
    url text
);

INSERT INTO admin_links
VALUES (1, 'project_proposal_folder', ''),
(2, 'peer_evaluation_form', '');

ALTER TABLE students
ADD COLUMN evaluatee_ids integer[];

ALTER TABLE teams
ADD COLUMN avg_rank float;

ALTER TABLE teams
ADD COLUMN application_status text;

ALTER TABLE teams
ADD COLUMN proposal_link text;

ALTER TABLE teams
ADD COLUMN evaluator_students text[];
