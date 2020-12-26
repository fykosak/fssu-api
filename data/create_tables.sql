DROP TABLE IF EXISTS "login_group";
DROP TABLE IF EXISTS "refresh_token";
DROP TABLE IF EXISTS "login";
DROP TABLE IF EXISTS "competition";
DROP TABLE IF EXISTS "group";

-- login, group & security --

CREATE TABLE "login" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "email" VARCHAR(255) NOT NULL UNIQUE,
    "password" VARCHAR(255) NOT NULL
);

CREATE TABLE "refresh_token" (
    "login_id" INT PRIMARY KEY,
    "value" VARCHAR(255) NOT NULL,
    "expires" DATETIME NOT NULL,
    FOREIGN KEY ("login_id") REFERENCES "login" ("id")
);

CREATE TABLE "group" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "name" VARCHAR(255) NOT NULL UNIQUE
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
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "text" TEXT NOT NULL,
    "action_id" INT NOT NULL,
    "parent_action_id" INT NOT NULL,
    FOREIGN KEY ("action_id") REFERENCES "action" ("id")
    FOREIGN KEY ("parent_action_id") REFERENCES "action" ("id")
);

-- competition --

CREATE TABLE "competition" (
    "id" INT PRIMARY KEY AUTO_INCREMENT,
    "label" VARCHAR(255) NOT NULL,
    "year" INT NOT NULL,
    "tex_code" VARCHAR(255) NOT NULL UNIQUE,
    "type" VARCHAR(255) NOT NULL,
    "status" VARCHAR(255) NOT NULL,
    "group_id" INT NOT NULL,
    FOREIGN KEY ("group_id") REFERENCES "group" ("id")
);


--CREATE TABLE "role"
--CREATE TABLE "draft_for_competition"
--CREATE TABLE "evaluation"