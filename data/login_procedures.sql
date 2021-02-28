DELIMITER //

DROP PROCEDURE IF EXISTS set_refresh_token//
CREATE PROCEDURE set_refresh_token(
    IN input_login_id INT,
    IN input_value VARCHAR(255),
    IN input_expires DATETIME
)
BEGIN
START TRANSACTION;
    SELECT EXISTS (SELECT * FROM "refresh_token" WHERE "login_id" = input_login_id) INTO @already_exists;

    IF @already_exists THEN
        UPDATE "refresh_token" SET "value" = input_value, "expires" = input_expires WHERE "login_id" = input_login_id;
    ELSE
        INSERT INTO "refresh_token" ("login_id", "value", "expires") VALUES (input_login_id, input_value, input_expires);
    END IF;
COMMIT;
SELECT input_login_id AS login_id;
END//

DROP PROCEDURE IF EXISTS reset_refresh_token//
CREATE PROCEDURE reset_refresh_token(
    IN old_value VARCHAR(255),
    IN new_value VARCHAR(255),
    IN input_expires DATETIME
)
procedureLabel:BEGIN
START TRANSACTION;
    SELECT MIN(login_id) FROM "refresh_token" WHERE "value" = old_value INTO @login_id;

    IF @login_id IS NULL THEN
        SELECT 'Token does not exist.' AS error;
        LEAVE procedureLabel;
    END IF;

    SELECT "expires" >= NOW() FROM "refresh_token" WHERE "login_id" = @login_id INTO @still_valid;

    IF !@still_valid THEN
        SELECT 'Token is not valid.' AS error;
        LEAVE procedureLabel;
    END IF;

    UPDATE "refresh_token" SET "value" = new_value, "expires" = input_expires WHERE "login_id" = @login_id;
COMMIT;
SELECT @login_id AS login_id;
END//

DELIMITER ;