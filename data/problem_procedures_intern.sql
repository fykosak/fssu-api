-- Problem procedures that should not be used directly as they don't guarantee the database will end in a consistent state.

DELIMITER //

DROP PROCEDURE IF EXISTS get_problem_group_id//
CREATE PROCEDURE get_problem_group_id(
    IN problem_id INT,
    OUT _group_id INT
)
BEGIN
    DECLARE _competition_id, _current_draft_id, _directory_id INT;
    
    SELECT competition_id, current_draft_id FROM problem where id = problem_id INTO _competition_id, _current_draft_id;

    IF _competition_id IS NULL THEN
        SELECT draftset_id FROM draft_history WHERE id = _current_draft_id INTO _directory_id;
    ELSE
        SELECT competition_id INTO _directory_id;
    END IF;

    SELECT group_id FROM directory WHERE id = _directory_id INTO _group_id;
END//

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
    SET @@SESSION.foreign_key_checks = 0;

    INSERT INTO "langdata" ("language_id", "problem_id", "current_langdata_id") VALUES (language_id, problem_id, 0);
    SELECT LAST_INSERT_ID() INTO langdata_id;

    INSERT INTO "action" ("problem_commit_id") VALUES (problem_commit_id);
    SELECT LAST_INSERT_ID() INTO langdata_action_id;

    INSERT INTO "langdata_history" ("id", "name", "origin", "task", "solution", "human_result", "langdata_id")
    VALUES (langdata_action_id, langdata_name, langdata_origin, langdata_task, langdata_solution, langdata_human_result, langdata_id);

    UPDATE "langdata" SET "current_langdata_id" = langdata_action_id WHERE "id" = langdata_id;

    SET @@SESSION.foreign_key_checks = 1;
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
    SET @@SESSION.foreign_key_checks = 0;

    INSERT INTO "work" ("type", "problem_id", "current_work_id") VALUES (work_type, problem_id, 0);
    SELECT LAST_INSERT_ID() INTO work_id;

    INSERT INTO "action" ("problem_commit_id") VALUES (problem_commit_id);
    SELECT LAST_INSERT_ID() INTO work_action_id;

    INSERT INTO "work_history" ("id", "status", "organizer_id", "work_id")
    VALUES (work_action_id, work_status, work_organizer_id, work_id);

    UPDATE "work" SET "current_work_id" = work_action_id WHERE "id" = work_id;

    SET @@SESSION.foreign_key_checks = 1;
END//

DELIMITER ;


-- Následující trigger funguje, ale je jen na insert ... myslím že by bylo lepší kontrolovat skupiny na začátku funkcí, co dané věci vytváří (stejně bude nutné kontrolovat,
-- zda daní organizátoři vůbec existují a tak - ačkoli to možná ne, protože v tom případě se vyhodí chyba automaticky)

-- DELIMITER //
-- 
-- DROP TRIGGER IF EXISTS work_organizer_in_group;
-- CREATE TRIGGER work_organizer_in_group BEFORE INSERT ON "work_history"
-- FOR EACH ROW
-- BEGIN
--     DECLARE _problem_id, _group_id, groups_equal INT;
--     IF NEW.organizer_id IS NOT NULL THEN
--         SELECT problem_id FROM work WHERE id = NEW.work_id INTO _problem_id;
--         CALL get_problem_group_id(_problem_id, _group_id);
-- 
--         SELECT EXISTS (SELECT * FROM organizer_group WHERE group_id = _group_id AND organizer_id = NEW.organizer_id) INTO groups_equal;
-- 
--         IF NOT groups_equal THEN
--             UPDATE "Error: groups not equal" SET x = 1;
--         END IF;
--     END IF;
-- END//
-- 
-- DELIMITER ;