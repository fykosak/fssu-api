DROP TABLE IF EXISTS `work`;
CREATE TABLE `work`
(
    `id`              INT PRIMARY KEY AUTO_INCREMENT,

    `type`            ENUM (
        'PROBLEM_AUTHORSHIP', 'SOLUTION_AUTHORSHIP',                                             -- Inventing the problem; writing and computing the solution
        'ASSIGNMENT_TRANSLATION', 'SOLUTION_TRANSLATION',                                        -- Missing if *_AUTHORSHIP is in specific language
        'ASSIGNMENT_LANGUAGE_PROOFREADING', 'SOLUTION_LANGUAGE_PROOFREADING',                    -- If language is ok
        'ASSIGNMENT_TYPOGRAPHIC_PROOFREADING', 'SOLUTION_TYPOGRAPHIC_PROOFREADING',              -- If the typography is ok
        'SOLUTION_SEMANTIC_PROOFREADING_1',                                                      -- If the physics behind the task is ok
        'SOLUTION_SEMANTIC_PROOFREADING_2',
        'SOLUTION_SEMANTIC_PROOFREADING_3'
        )                                                         NOT NULL,
    `language`        VARCHAR(2)                                  NOT NULL COMMENT 'ISO 639-1 language code.',

    `state`           ENUM ('UNFINISHED', 'FINISHED', 'RETURNED') NOT NULL DEFAULT 'UNFINISHED', -- No data is equivalent to UNFINISHED

    `problem_id`      INT                                         NOT NULL,
    `current_work_id` INT                                         NOT NULL,

    FOREIGN KEY (`problem_id`) REFERENCES `problem` (`id`) ON DELETE CASCADE
) COMMENT 'Work represents what works can be done on specific problem';

DROP TABLE IF EXISTS `work_person`;
CREATE TABLE `work_person`
(
    `id`        INT PRIMARY KEY AUTO_INCREMENT,
    `work_id`   INT NOT NULL,
    `person_id` INT NOT NULL,
    `weight`    INT NOT NULL DEFAULT 10 COMMENT 'Ratio of work done on specific problem.',

    FOREIGN KEY (`work_id`) REFERENCES `work` (`id`) ON DELETE CASCADE
);
