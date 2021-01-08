INSERT INTO "login" ("email", "password_hash")
VALUES
    ('admin@fykos.cz', '$2b$12$s4k0oAoUeO4YYIY04MppyOsWPPs6SA0m1lCW3Q0HjXZklmbs8SG3y'), -- 'admin'
    ('test@fykos.cz', '$2b$12$rH0nE6hDrRnXARlJol5fHetQr2Wr.IhkZeBhNQmfFHlc3nxxx/zti'), -- 'test'
    ('noob@fykos.cz', '$2b$12$N1DbNJbMtNPajDSAkXvTAeB1LBcAXdyzA4Mfjv5.cDS9bz/ZYa1e.'); -- 'noob'

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

INSERT INTO "competition" ("label", "year", "tex_code", "type", "status", "group_id")
VALUES
    ('Fykos 35', 35, 'FYKOS35', 'seminar', 'not_started', 1),
    ('11. Fyziklání online', 11, 'FOL11', 'fol', 'not_started', 1),
    ('Fyziklání 2022', 14, 'FOF14', 'fof', 'not_started', 1),
    ('Výfuck 10', 10, 'vyfuck10', 'seminar', 'not_started', 2);