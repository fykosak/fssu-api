-- Safe problem procedures.

DELIMITER //

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
    OUT problem_id INT
)
BEGIN
    DECLARE task_work_id, solution_work_id, problem_commit_id, langdata_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
        END;
    START TRANSACTION;

        -- TODO:
            -- zkontrolovat, jestli jsou organizátoři task_author_id a solution_author_id ve stejné skupině jako draftset_id
            -- solution_author_i může být null, potom nevytvoříme příslušný work

        CALL create_problem(login_id, commit_description, draftset_id, problem_id, problem_commit_id);
        CALL create_langdata(problem_commit_id, problem_id, language_id, langdata_name, langdata_origin, langdata_task, langdata_solution, langdata_human_result, langdata_id);
        CALL create_work(problem_commit_id, problem_id, 'task_author', 'created', task_author_id, task_work_id);
        CALL create_work(problem_commit_id, problem_id, 'solution_author', 'created', solution_author_id, solution_work_id);
    COMMIT;
END//

-- TODO - přidat následující procedury ... měly by v argumentu brát commit, aby je bylo možné řetězit
-- samotné řetězení už bude na klientské aplikaci - ta si vytvoří commit a pak si do něj bude jen sázet jednotlivé změny pomocí následujících procedur
-- ty by na sobě neměly záviset, aby se daly libovolně kombinovat aby chyba jedné nevedla k chybám ostatních
DROP PROCEDURE IF EXISTS update_problem//
DROP PROCEDURE IF EXISTS add_langdata//
DROP PROCEDURE IF EXISTS update_langdata//
DROP PROCEDURE IF EXISTS add_work//
DROP PROCEDURE IF EXISTS update_work//

DELIMITER ;