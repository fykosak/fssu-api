DROP TABLE IF EXISTS `topic`;
CREATE TABLE `topic`
(
    `id`   INT PRIMARY KEY AUTO_INCREMENT,
    `code` VARCHAR(255) NOT NULL COMMENT 'Topic string identifier'
);

DROP TABLE IF EXISTS `topic_localized_data`;
CREATE TABLE `topic_localized_data`
(
    `id`          INT PRIMARY KEY AUTO_INCREMENT,
    `topic_id`    INT        NOT NULL,

    `language`    VARCHAR(2) NOT NULL COMMENT 'ISO 639-1 language code.',

    `title`       TEXT       NOT NULL,
    `description` TEXT       NULL DEFAULT NULL,

    FOREIGN KEY (`topic_id`) REFERENCES `topic` (`id`) ON DELETE CASCADE,
    CONSTRAINT unique_language_to_topic UNIQUE (`topic_id`, `language`) COMMENT 'Each topic must have unique localization entries by language.'
);

CREATE TABLE `problem_topic`
(
    `problem_id` INT,
    `topic_id`   INT,
    PRIMARY KEY (`problem_id`, `topic_id`),

    FOREIGN KEY (`problem_id`) REFERENCES `problem` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`topic_id`) REFERENCES `topic` (`id`) ON DELETE CASCADE
);
