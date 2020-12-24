INSERT INTO "login" ("email", "password")
VALUES
    ('admin@fykos.cz', 'admin'),
    ('test@fykos.cz', 'test'),
    ('noob@fykos.cz', 'noob');

INSERT INTO "group" ("name")
VALUES
    ('fykos'),
    ('vyfuk');

INSERT INTO "login_group" ("login_id", "group_id")
VALUES
    (1, 1),
    (1, 2),
    (2, 1),
    (2, 2);

INSERT INTO "competition" ("label", "year", "tex_code", "type", "status", "group")
VALUES
    ('Fykos 35', 35, 'FYKOS35', 'seminar', 'not_started', 1),
    ('11. Fyziklání online', 11, 'FOL11', 'fol', 'not_started', 1),
    ('Fyziklání 2022', 14, 'FOF14', 'fof', 'not_started', 1),
    ('Výfuck 10', 10, 'vyfuck10', 'seminar', 'not_started', 2);