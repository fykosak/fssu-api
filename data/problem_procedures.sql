DELIMITER //

DROP PROCEDURE IF EXISTS create_problem//
CREATE PROCEDURE create_problem(
    IN login_id INT,
    IN commit_description NVARCHAR(255),
    IN draftset_id INT,
    OUT problem_id INT,
    OUT problem_commit_id INT
)
BEGIN
DECLARE event_id, data_action_id, draft_action_id INT;

START TRANSACTION;
    SET @@SESSION.foreign_key_checks = 0;

    INSERT INTO "event" ("time", "login_id") VALUES (NOW(), login_id);
    SELECT LAST_INSERT_ID() INTO event_id;

    INSERT INTO "problem" ("solvers", "avg", "batch", "no", "competition_id", "current_data_id", "current_draft_id") VALUES (NULL, NULL, NULL, NULL, NULL, 0, 0);
    SELECT LAST_INSERT_ID() INTO problem_id;

    INSERT INTO "problem_commit" ("event_id", "problem_id", "description") VALUES (event_id, problem_id, commit_description);
    SELECT LAST_INSERT_ID() INTO problem_commit_id;

    INSERT INTO "action" ("problem_commit_id") VALUES (problem_commit_id);
    SELECT LAST_INSERT_ID() INTO data_action_id;

    INSERT INTO "data_history" ("id", "points", "computer_result", "additional_tex_code") VALUES (data_action_id, NULL, NULL, NULL);

    INSERT INTO "action" ("problem_commit_id") VALUES (problem_commit_id);
    SELECT LAST_INSERT_ID() INTO draft_action_id;

    INSERT INTO "draft_history" ("id", "draftset_id") VALUES (draft_action_id, draftset_id);

    UPDATE "problem" SET "current_data_id" = data_action_id, "current_draft_id" = draft_action_id WHERE "id" = problem_id;

    SET @@SESSION.foreign_key_checks = 1;
COMMIT;
SET @@SESSION.foreign_key_checks = 1;
-- SELECT problem_id, problem_commit_id;
END//

DROP PROCEDURE IF EXISTS create_langdata//
CREATE PROCEDURE create_langdata(
    IN problem_commit_id INT,
    IN problem_id INT,
    IN language_id INT,
    IN langdata_name NVARCHAR(255),
    IN langdata_origin TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    IN langdata_task TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    IN langdata_solution TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    IN langdata_human_result TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    OUT langdata_id INT
)
BEGIN
DECLARE langdata_action_id INT;

START TRANSACTION;
    SET @@SESSION.foreign_key_checks = 0;

    INSERT INTO "langdata" ("language_id", "problem_id", "current_langdata_id") VALUES (language_id, problem_id, 0);
    SELECT LAST_INSERT_ID() INTO langdata_id;

    INSERT INTO "action" ("problem_commit_id") VALUES (problem_commit_id);
    SELECT LAST_INSERT_ID() INTO langdata_action_id;

    INSERT INTO "langdata_history" ("id", "name", "origin", "task", "solution", "human_result", "langdata_id")
    VALUES (langdata_action_id, langdata_name, langdata_origin, langdata_task, langdata_solution, langdata_human_result, langdata_id);

    UPDATE "langdata" SET "current_langdata_id" = langdata_action_id WHERE "id" = langdata_id;

    SET @@SESSION.foreign_key_checks = 1;
COMMIT;
SET @@SESSION.foreign_key_checks = 1;
-- SELECT langdata_id;
END//

DROP PROCEDURE IF EXISTS create_work//
CREATE PROCEDURE create_work(
    IN problem_commit_id INT,
    IN problem_id INT,
    IN work_type NVARCHAR(255),
    IN work_status NVARCHAR(255),
    IN work_organizer_id INT,
    OUT work_id INT
)
BEGIN
DECLARE work_action_id INT;

START TRANSACTION;
    SET @@SESSION.foreign_key_checks = 0;

    INSERT INTO "work" ("type", "problem_id", "current_work_id") VALUES (work_type, problem_id, 0);
    SELECT LAST_INSERT_ID() INTO work_id;

    INSERT INTO "action" ("problem_commit_id") VALUES (problem_commit_id);
    SELECT LAST_INSERT_ID() INTO work_action_id;

    INSERT INTO "work_history" ("id", "status", "organizer_id", "work_id")
    VALUES (work_action_id, work_status, work_organizer_id, work_id);

    UPDATE "work" SET "current_work_id" = work_action_id WHERE "id" = work_id;

    SET @@SESSION.foreign_key_checks = 1;
COMMIT;
SET @@SESSION.foreign_key_checks = 1;
-- SELECT work_id;
END//

DROP PROCEDURE IF EXISTS create_problem_with_langdata//
CREATE PROCEDURE create_problem_with_langdata(
    IN login_id INT,
    IN commit_description NVARCHAR(255),
    IN draftset_id INT,
    IN language_id INT,
    IN langdata_name NVARCHAR(255),
    IN langdata_origin TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    IN langdata_task TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    IN langdata_solution TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    IN langdata_human_result TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    IN task_author_id INT,
    IN solution_author_id INT,
    OUT problem_id INT,
    OUT problem_commit_id INT,
    OUT langdata_id INT
)
BEGIN
DECLARE task_work_id, solution_work_id INT;

START TRANSACTION;
    CALL create_problem(login_id, commit_description, draftset_id, problem_id, problem_commit_id);
    CALL create_langdata(problem_commit_id, problem_id, language_id, langdata_name, langdata_origin, langdata_task, langdata_solution, langdata_human_result, langdata_id);
    CALL create_work(problem_commit_id, problem_id, 'task_author', 'created', task_author_id, task_work_id);
    CALL create_work(problem_commit_id, problem_id, 'solution_author', 'created', solution_author_id, solution_work_id);
COMMIT;
END//

DELIMITER ;