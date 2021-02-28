-- configuration --

CREATE TABLE "language" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "name" NVARCHAR(255) NOT NULL UNIQUE
);

-- login, group & security --

CREATE TABLE "group" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "name" NVARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE "organizer" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "name" NVARCHAR(255) NOT NULL,
    "language_id" INT NOT NULL, -- default language of problems
    FOREIGN KEY ("language_id") REFERENCES "language" ("id")
);

CREATE TABLE "organizer_group" (
    "tex_alias" NVARCHAR(255),
    "organizer_id" INT,
    "group_id" INT,
    PRIMARY KEY ("tex_alias", "organizer_id", "group_id"),
    FOREIGN KEY ("organizer_id") REFERENCES "organizer" ("id"),
    FOREIGN KEY ("group_id") REFERENCES "group" ("id")
);

CREATE TABLE "login" (
    "id" INT PRIMARY KEY AUTO_INCREMENT, -- Not sure if necessary - maybe organizer_id could be used instead.
    "email" NVARCHAR(255) NOT NULL UNIQUE,
    "password_hash" NVARCHAR(255) NOT NULL,
    "organizer_id" INT NOT NULL UNIQUE, -- There is a possibility that one day, these constraints would be dropped.
    FOREIGN KEY ("organizer_id") REFERENCES "organizer" ("id")
);

CREATE TABLE "refresh_token" (
    "login_id" INT PRIMARY KEY,
    "value" NVARCHAR(255) NOT NULL,
    "expires" DATETIME NOT NULL,
    FOREIGN KEY ("login_id") REFERENCES "login" ("id")
);

CREATE TABLE "login_group" (
    "login_id" INT,
    "group_id" INT,
    PRIMARY KEY ("login_id", "group_id"),
    FOREIGN KEY ("login_id") REFERENCES "login" ("id"),
    FOREIGN KEY ("group_id") REFERENCES "group" ("id")
);

-- competition --

CREATE TABLE "directory" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "name" NVARCHAR(255) NOT NULL,
    "path" NVARCHAR(255) NOT NULL,
    "group_id" INT NOT NULL,
    FOREIGN KEY ("group_id") REFERENCES "group" ("id")
);

CREATE TABLE "draftset" (
    "id" INT PRIMARY KEY,
    FOREIGN KEY ("id") REFERENCES "directory" ("id")
);

CREATE TABLE "competition" (
    "id" INT PRIMARY KEY,
    "name" NVARCHAR(255) NOT NULL,
    "year" INT NOT NULL,
    "tex_code" NVARCHAR(255) NOT NULL UNIQUE,
    "type" NVARCHAR(255) NOT NULL,
    "status" NVARCHAR(255) NOT NULL,
    "draftset_id" INT NOT NULL UNIQUE,
    FOREIGN KEY ("id") REFERENCES "directory" ("id"),
    FOREIGN KEY ("draftset_id") REFERENCES "draftset" ("id")
);

CREATE TABLE "role" (
    "type_id" INT,
    "login_id" INT,
    "competition_id" INT,
    PRIMARY KEY ("type_id", "login_id", "competition_id"),
    FOREIGN KEY ("login_id") REFERENCES "login" ("id"),
    FOREIGN KEY ("competition_id") REFERENCES "competition" ("id")
);

-- action --

CREATE TABLE "event" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "time" DATETIME NOT NULL,
    "login_id" INT NOT NULL,
    FOREIGN KEY ("login_id") REFERENCES "login" ("id")
);

CREATE TABLE "competition_commit" (
    "id" INT PRIMARY KEY,
    "competition_id" INT NOT NULL,
    "description" NVARCHAR(255),
    FOREIGN KEY ("id") REFERENCES "event" ("id"),
    FOREIGN KEY ("competition_id") REFERENCES "competition" ("id")
);

CREATE TABLE "problem" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "solvers" INT,
    "avg" FLOAT,
    "batch" INT,
    "no" INT,
    "competition_id" INT,
    "current_data_id" INT NOT NULL,
    "current_draft_id" INT NOT NULL,
    FOREIGN KEY ("competition_id") REFERENCES "competition" ("id"),
    UNIQUE ("batch", "no", "competition_id")
);

CREATE TABLE "problem_commit" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "event_id" INT NOT NULL,
    "problem_id" INT NOT NULL,
    "description" NVARCHAR(255),
    FOREIGN KEY ("event_id") REFERENCES "event" ("id"),
    FOREIGN KEY ("problem_id") REFERENCES "problem" ("id")
);

CREATE TABLE "action" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "problem_commit_id" INT NOT NULL,
    FOREIGN KEY ("problem_commit_id") REFERENCES "problem_commit" ("id")
);

CREATE TABLE "data_history" (
    "id" INT PRIMARY KEY,
    "points" INT,
    "computer_result" TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    "additional_tex_code" TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    FOREIGN KEY ("id") REFERENCES "action" ("id")
);

ALTER TABLE "problem" ADD CONSTRAINT "current_data_id" FOREIGN KEY ("current_data_id") REFERENCES "data_history" ("id");

CREATE TABLE "draft_history" (
    "id" INT PRIMARY KEY,
    "draftset_id" INT NOT NULL,
    FOREIGN KEY ("id") REFERENCES "action" ("id"),
    FOREIGN KEY ("draftset_id") REFERENCES "draftset" ("id")
);

ALTER TABLE "problem" ADD CONSTRAINT "current_draft_id" FOREIGN KEY ("current_draft_id") REFERENCES "draft_history" ("id");

CREATE TABLE "evaluation" (
    "draft_history_id" INT PRIMARY KEY,
    "skill_difficulty" FLOAT NOT NULL,
    "work_difficulty" FLOAT NOT NULL,
    "interestingness" FLOAT NOT NULL,
    FOREIGN KEY ("draft_history_id") REFERENCES "draft_history" ("id")
);

-- work --

CREATE TABLE "work" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "type" NVARCHAR(255) NOT NULL,
    "problem_id" INT NOT NULL,
    "current_work_id" INT NOT NULL,
    FOREIGN KEY ("problem_id") REFERENCES "problem" ("id")
);

CREATE TABLE "work_history" (
    "id" INT PRIMARY KEY,
    "status" NVARCHAR(255) NOT NULL,
    "organizer_id" INT,
    "work_id" INT NOT NULL,
    FOREIGN KEY ("id") REFERENCES "action" ("id"),
    FOREIGN KEY ("organizer_id") REFERENCES "organizer" ("id"),
    FOREIGN KEY ("work_id") REFERENCES "work" ("id")
);

ALTER TABLE "work" ADD CONSTRAINT "current_work_id" FOREIGN KEY ("current_work_id") REFERENCES "work_history" ("id");

CREATE TABLE "issue" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "name" NVARCHAR(255) NOT NULL,
    "status" NVARCHAR(255) NOT NULL,
    "work_id" INT NOT NULL,
    FOREIGN KEY ("work_id") REFERENCES "work" ("id")
);

CREATE TABLE "comment" (
    "id" INT PRIMARY KEY,
    "content" TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    "issue_id" INT NOT NULL,
    FOREIGN KEY ("id") REFERENCES "event" ("id"),
    FOREIGN KEY ("issue_id") REFERENCES "issue" ("id")
);

CREATE TABLE "langdata" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "language_id" INT NOT NULL,
    "problem_id" INT NOT NULL,
    "current_langdata_id" INT NOT NULL,
    FOREIGN KEY ("problem_id") REFERENCES "problem" ("id"),
    UNIQUE ("language_id", "problem_id")
);

CREATE TABLE "langdata_history" (
    "id" INT PRIMARY KEY,
    "name" NVARCHAR(255),
    "origin" TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    "task" TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    "solution" TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    "human_result" TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    "langdata_id" INT NOT NULL,
    FOREIGN KEY ("id") REFERENCES "action" ("id"),
    FOREIGN KEY ("langdata_id") REFERENCES "langdata" ("id")
);

ALTER TABLE "langdata" ADD CONSTRAINT "current_langdata_id" FOREIGN KEY ("current_langdata_id") REFERENCES "langdata_history" ("id");

-- addfile --

CREATE TABLE "addfile" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "problem_id" INT NOT NULL,
    "refname" NVARCHAR(255) NOT NULL, -- so the file can be found and referenced from problem
    "type" NVARCHAR(255) NOT NULL, -- Filename extension (plt, mp, csv)
    "current_addfile_id" INT NOT NULL,
    FOREIGN KEY ("problem_id") REFERENCES "problem" ("id"),
    UNIQUE ("problem_id", "refname")
);

CREATE TABLE "addfile_history" (
    "id" INT PRIMARY KEY,
    "content" TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    "addfile_id" INT NOT NULL,
    FOREIGN KEY ("id") REFERENCES "action" ("id"),
    FOREIGN KEY ("addfile_id") REFERENCES "addfile" ("id")
);

ALTER TABLE "addfile" ADD CONSTRAINT "current_addfile_id" FOREIGN KEY ("current_addfile_id") REFERENCES "addfile_history" ("id");

-- flag & topic --

CREATE TABLE "flag" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "name" NVARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE "problem_flag" (
    "problem_id" INT,
    "flag_id" INT,
    PRIMARY KEY ("problem_id", "flag_id"),
    FOREIGN KEY ("problem_id") REFERENCES "problem" ("id"),
    FOREIGN KEY ("flag_id") REFERENCES "flag" ("id")
);

CREATE TABLE "topic" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "name" NVARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE "problem_topic" (
    "problem_id" INT,
    "topic_id" INT,
    PRIMARY KEY ("problem_id", "topic_id"),
    FOREIGN KEY ("problem_id") REFERENCES "problem" ("id"),
    FOREIGN KEY ("topic_id") REFERENCES "topic" ("id")
);