DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag`
(
    `id` INT PRIMARY KEY AUTO_INCREMENT
) COMMENT 'Tags can be added dynamically and describes the problem. Tag can be \'2nd Kepler`s law\' or \'Integration by parts\'.';

DROP TABLE IF EXISTS `tag_localized_data`;
CREATE TABLE `tag_localized_data`
(
    `id`          INT PRIMARY KEY AUTO_INCREMENT,
    `tag_id`      INT        NOT NULL,

    `language`    VARCHAR(2) NOT NULL COMMENT 'ISO 639-1 language code.',

    `title`       TEXT       NOT NULL,
    `description` TEXT       NULL DEFAULT NULL,

    FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE,
    CONSTRAINT unique_language_to_tag UNIQUE (`tag_id`, `language`) COMMENT 'Each tag must have unique localization entries by language.'
);

DROP TABLE IF EXISTS `tag_structure`;
CREATE TABLE `tag_structure`
(
    `id`            INT PRIMARY KEY AUTO_INCREMENT,
    `parent_tag_id` INT NOT NULL,
    `child_tag_id`  INT NOT NULL,

    FOREIGN KEY (`parent_tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`child_tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE
) COMMENT 'Each tag can be part of other tags. Should create DAG.';

CREATE TABLE `problem_tag`
(
    `problem_id` INT,
    `tag_id`     INT,
    PRIMARY KEY (`problem_id`, `tag_id`),

    FOREIGN KEY (`problem_id`) REFERENCES `problem` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE
);
