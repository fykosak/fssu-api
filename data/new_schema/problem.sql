SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `directory`;
CREATE TABLE `directory`
(
    `id`   INT PRIMARY KEY AUTO_INCREMENT,
    `name` NVARCHAR(255) NULL COMMENT 'Human name of the directory. Only for organisers.',
    `code` VARCHAR(255)  NOT NULL COMMENT 'String identifier of the directory'
) COMMENT 'Represents competition as a directory in a large directory structure.';

DROP TABLE IF EXISTS `directory_structure`;
CREATE TABLE `directory_structure`
(
    `id`                  INT PRIMARY KEY AUTO_INCREMENT,
    `parent_directory_id` INT NOT NULL,
    `child_directory_id`  INT NOT NULL,

    FOREIGN KEY (`parent_directory_id`) REFERENCES `directory` (`id`),
    FOREIGN KEY (`child_directory_id`) REFERENCES `directory` (`id`)
);

DROP TABLE IF EXISTS `problem`;
CREATE TABLE `problem`
(
    `id`           INT PRIMARY KEY AUTO_INCREMENT,

    `solvers`      INT         NULL DEFAULT NULL COMMENT 'Number of competitors who submitted the problem. (series specific)', -- series specific
    `avg`          FLOAT       NULL DEFAULT NULL COMMENT 'Average point score in the competition. (competition type specific)',

    `directory_id` INT         NOT NULL,
    `label`        VARCHAR(16) NULL DEFAULT NULL COMMENT 'Problem order or in-group identifier. (competition type specific)',  -- order in the directory

    `points`       INT         NULL DEFAULT NULL COMMENT 'How many points for correct solution. (competition type specific)',

    FOREIGN KEY (`directory_id`) REFERENCES `directory` (`id`),
    CONSTRAINT unique_label_in_directory UNIQUE (`directory_id`, `label`) COMMENT 'Each problem in the directory must have unique label if set.'
);

DROP TABLE IF EXISTS `problem_localized_data`;
CREATE TABLE `problem_localized_data`
(
    `id`           INT PRIMARY KEY AUTO_INCREMENT,
    `problem_id`   INT           NOT NULL,
    `language`     VARCHAR(2)    NOT NULL COMMENT 'ISO 639-1 language code.',

    `title`        NVARCHAR(255) NULL DEFAULT NULL COMMENT 'Name of the problem.',
    `origin`       TEXT          NULL DEFAULT NULL COMMENT 'Public text describing the invention of the task.',
    `task`         TEXT          NULL DEFAULT NULL COMMENT 'Problem statement.',
    `solution`     TEXT          NULL DEFAULT NULL COMMENT 'Problem solution',

    `human_result` TEXT          NULL DEFAULT NULL COMMENT 'Human problem result. (FOF specific)',

    FOREIGN KEY (`problem_id`) REFERENCES `problem` (`id`),
    CONSTRAINT unique_language_to_problem UNIQUE (`problem_id`, `language`) COMMENT 'Each problem must have unique localization entries by language.'
) COMMENT 'All the data associated with the problem and depends on the language.';

SET FOREIGN_KEY_CHECKS=1;
