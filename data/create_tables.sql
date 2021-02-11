DROP TABLE IF EXISTS "problem_topic";
DROP TABLE IF EXISTS "topic";
DROP TABLE IF EXISTS "problem_flag";
DROP TABLE IF EXISTS "flag";

DROP TABLE IF EXISTS "addfile_history";
DROP TABLE IF EXISTS "addfile";

DROP TABLE IF EXISTS "language_data_history";
DROP TABLE IF EXISTS "language_data";
DROP TABLE IF EXISTS "work_history";
DROP TABLE IF EXISTS "work";

DROP TABLE IF EXISTS "evaluation";
DROP TABLE IF EXISTS "draft_history";

DROP TABLE IF EXISTS "problem_history";
DROP TABLE IF EXISTS "problem";

DROP TABLE IF EXISTS "role";
DROP TABLE IF EXISTS "competition";
DROP TABLE IF EXISTS "draftset";
DROP TABLE IF EXISTS "directory";

DROP TABLE IF EXISTS "comment";
DROP TABLE IF EXISTS "action";
DROP TABLE IF EXISTS "login_group";
DROP TABLE IF EXISTS "refresh_token";
DROP TABLE IF EXISTS "login";

DROP TABLE IF EXISTS "organizer_group";
DROP TABLE IF EXISTS "organizer";
DROP TABLE IF EXISTS "group";

DROP TABLE IF EXISTS "language";

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

-- action --

CREATE TABLE "action" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "time" DATETIME NOT NULL,
    "login_id" INT NOT NULL,
    FOREIGN KEY ("login_id") REFERENCES "login" ("id")
);

CREATE TABLE "comment" (
    "id" INT PRIMARY KEY,
    "content" TEXT NOT NULL,
    "parent_action_id" INT NOT NULL,
    FOREIGN KEY ("id") REFERENCES "action" ("id"),
    FOREIGN KEY ("parent_action_id") REFERENCES "action" ("id")
);

-- competition --

CREATE TABLE "directory" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "label" NVARCHAR(255) NOT NULL,
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

-- problem --

CREATE TABLE "problem" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "solvers" INT,
    "avg" FLOAT,
    "batch" INT,
    "no" INT,
    "competition_id" INT,
    FOREIGN KEY ("competition_id") REFERENCES "competition" ("id"),
    UNIQUE ("batch", "no", "competition_id")
);

CREATE TABLE "problem_history" (
    "id" INT PRIMARY KEY,
    "points" INT,
    "computer_result" TEXT,
    "additional_text_code" TEXT,
    "problem_id" INT NOT NULL,
    FOREIGN KEY ("problem_id") REFERENCES "problem" ("id"),
    FOREIGN KEY ("id") REFERENCES "action" ("id")
);

CREATE TABLE "draft_history" (
    "id" INT PRIMARY KEY,
    "problem_id" INT NOT NULL,
    "draftset_id" INT NOT NULL,
    FOREIGN KEY ("problem_id") REFERENCES "problem" ("id"),
    FOREIGN KEY ("draftset_id") REFERENCES "draftset" ("id"),
    FOREIGN KEY ("id") REFERENCES "action" ("id")
    -- UNIQUE ("problem_id", "competition_id") -- úloha může být vícekrát přesouvána mezi stejnými draftsety
);

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
    FOREIGN KEY ("problem_id") REFERENCES "problem" ("id")
);

CREATE TABLE "work_history" (
    "id" INT PRIMARY KEY,
    "status" NVARCHAR(255) NOT NULL,
    "organizer_id" INT,
    "work_id" INT NOT NULL,
    FOREIGN KEY ("organizer_id") REFERENCES "organizer" ("id"),
    FOREIGN KEY ("work_id") REFERENCES "work" ("id"),
    FOREIGN KEY ("id") REFERENCES "action" ("id")
);

CREATE TABLE "language_data" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "language_id" INT NOT NULL,
    "problem_id" INT NOT NULL,
    FOREIGN KEY ("language_id") REFERENCES "language" ("id"),
    FOREIGN KEY ("problem_id") REFERENCES "problem" ("id"),
    UNIQUE ("language_id", "problem_id")
);

CREATE TABLE "language_data_history" (
    "id" INT PRIMARY KEY,
    "name" NVARCHAR(255),
    "origin" TEXT,
    "task" TEXT,
    "solution" TEXT,
    "human_result" TEXT,
    "language_data_id" INT NOT NULL,
    FOREIGN KEY ("language_data_id") REFERENCES "language_data" ("id"),
    FOREIGN KEY ("id") REFERENCES "action" ("id")
);

-- addfile --

CREATE TABLE "addfile" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "problem_id" INT NOT NULL,
    "refname" NVARCHAR(255) NOT NULL, -- so the file can be found and referenced from problem
    "type" NVARCHAR(255) NOT NULL, -- Filename extension (plt, mp, csv)
    FOREIGN KEY ("problem_id") REFERENCES "problem" ("id"),
    UNIQUE ("problem_id", "refname")
);

CREATE TABLE "addfile_history" (
    "id" INT PRIMARY KEY,
    "content" TEXT,
    "addfile_id" INT NOT NULL,
    FOREIGN KEY ("addfile_id") REFERENCES "addfile" ("id"),
    FOREIGN KEY ("id") REFERENCES "action" ("id")
);

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