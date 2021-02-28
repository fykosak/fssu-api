INSERT INTO "language" ("name")
VALUES
    ('cs'),
    ('en');

INSERT INTO "group" ("name")
VALUES
    ('fykos'),
    ('vyfuk');

INSERT INTO "organizer" ("name", "language_id")
VALUES
    ('Lord Tuaki', 1),
    ('Test', 1),
    ('Random N00b', 2);

INSERT INTO "organizer_group" ("tex_alias", "organizer_id", "group_id")
VALUES
    ('bartik', 1, 1),
    ('testFykos', 2, 1),
    ('testVyfuk', 2, 2),
    ('noob', 3, 2);

INSERT INTO "login" ("email", "password_hash", "organizer_id")
VALUES
    ('admin@fykos.cz', '$2b$12$s4k0oAoUeO4YYIY04MppyOsWPPs6SA0m1lCW3Q0HjXZklmbs8SG3y', 1), -- 'admin'
    ('test@fykos.cz', '$2b$12$rH0nE6hDrRnXARlJol5fHetQr2Wr.IhkZeBhNQmfFHlc3nxxx/zti', 2), -- 'test'
    ('noob@fykos.cz', '$2b$12$N1DbNJbMtNPajDSAkXvTAeB1LBcAXdyzA4Mfjv5.cDS9bz/ZYa1e.', 3); -- 'noob'

-- INSERT INTO "refresh_token" --

INSERT INTO "login_group" ("login_id", "group_id")
VALUES
    (1, 1),
    (2, 1),
    (2, 2),
    (3, 2);

INSERT INTO "directory" ("name", "path", "group_id")
VALUES
    ('Trash', 'trash/problems', 1),
    ('Seminář 35', 'fykos35/problems', 1),
    ('Seminář 35 návrhy', 'fykos35_drafts/problems', 1),
    ('FOL 11', 'fol11/problems', 1),
    ('FOL 11 návrhy', 'fol11_drafts/problems', 1),
    ('FOF 14', 'fof14/problems', 1),
    ('FOF 14 návrhy', 'fof14_drafts/problems', 1),
    ('Trash', 'trash/problems', 2),
    ('Seminář 10', 'vyfuck10/problems', 2),
    ('Seminář 10 návrhy', 'vyfuck10_drafts/problems', 2);

INSERT INTO "draftset" ("id")
VALUES
    (1),
    (3),
    (5),
    (7),
    (8),
    (10);

INSERT INTO "competition" ("id", "name", "year", "tex_code", "type", "status", "draftset_id")
VALUES
    (2, 'Fykos 35', 35, 'FYKOS35', 'seminar', 'not_started', 3),
    (4, '11. Fyziklání online', 11, 'FOL11', 'fol', 'not_started', 5),
    (6, 'Fyziklání 2022', 14, 'FOF14', 'fof', 'not_started', 7),
    (9, 'Výfuck 10', 10, 'vyfuck10', 'seminar', 'not_started', 10);

-- TODO - kontroly na to, jestli jsou organizátoři z worku ve stejné skupině

CALL create_problem_with_langdata(1, 'Vytvoření první úlohy', 3, 1, 'těžká úloha', NULL, 'nějaké zadání', NULL, NULL, 1, 1, @problem_id, @problem_commit_id, @langdata_id);
CALL create_problem_with_langdata(1, 'Vytvoření druhé úlohy', 3, 1, 'lehká úloha', NULL, 'jiné zadání', NULL, NULL, 1, 2, @problem_id, @problem_commit_id, @langdata_id);


-- INSERT INTO "role" ("type_id", "login_id" INT, "competition_id")

-- INSERT INTO "evaluation" ("draft_history_id", "skill_difficulty", "work_difficulty", "interestingness")

-- INSERT INTO "issue" ("name", "status", "work_id")

-- INSERT INTO "comment" ("id", "content", "issue_id")

-- promyslet si, jak to mít s action_id - myslím, že by nebylo špatné mít, aby pod jením action_id mohlo být víc událostí najednou
-- rozhodně dává smysl, aby pod tím bylo jako problem_history, tak např. language_data history, pokud se týkají stejné věci
-- otázkou je, jestl mohou být dvě různé věci ze stejné třídy, které by se mohly stát v rámci stejné action
-- úprava dvou addfile? např. data + obrázek
    -- ale nevím, jestli to bude technicky možné (upravovat dva soubory najednou)
-- úprava více worků? to opět asi nepůjde
    -- ačkoli by mohlo - např. při založení úlohy rovnou přidám autora vzoráku
-- potom by bylo nejlepší dát každé _history třídě vlastní id, a zároveň jim přidat action_id, které už nebude muset být unique
    -- tím se pěkně vyřeší to, že bude možné udělat víc úprav, které spolu logicky souvisí, "najednou"

-- INSERT INTO "addfile" ("problem_id", "refname", "type")
-- INSERT INTO "addfile_history" ("id", "content", "addfile_id")

-- INSERT INTO "flag" ("name")
-- INSERT INTO "problem_flag" ("problem_id", "flag_id")

-- INSERT INTO "topic" ("name")
-- INSERT INTO "problem_topic" ("problem_id", "topic_id")