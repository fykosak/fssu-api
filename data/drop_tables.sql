DROP TABLE IF EXISTS "problem_topic";
DROP TABLE IF EXISTS "topic";
DROP TABLE IF EXISTS "problem_flag";
DROP TABLE IF EXISTS "flag";

ALTER TABLE "addfile" DROP FOREIGN KEY "current_addfile_id";
DROP TABLE IF EXISTS "addfile_history";
DROP TABLE IF EXISTS "addfile";

ALTER TABLE "langdata" DROP FOREIGN KEY "current_langdata_id";
DROP TABLE IF EXISTS "langdata_history";
DROP TABLE IF EXISTS "langdata";

DROP TABLE IF EXISTS "comment";
DROP TABLE IF EXISTS "issue";

ALTER TABLE "work" DROP FOREIGN KEY "current_work_id";
DROP TABLE IF EXISTS "work_history";
DROP TABLE IF EXISTS "work";

DROP TABLE IF EXISTS "evaluation";
ALTER TABLE "problem" DROP FOREIGN KEY "current_draft_id";
DROP TABLE IF EXISTS "draft_history";

ALTER TABLE "problem" DROP FOREIGN KEY "current_data_id";
DROP TABLE IF EXISTS "data_history";
DROP TABLE IF EXISTS "action";

DROP TABLE IF EXISTS "problem_commit";
DROP TABLE IF EXISTS "problem";
DROP TABLE IF EXISTS "competition_commit";
DROP TABLE IF EXISTS "event";

DROP TABLE IF EXISTS "role";
DROP TABLE IF EXISTS "competition";
DROP TABLE IF EXISTS "draftset";
DROP TABLE IF EXISTS "directory";

DROP TABLE IF EXISTS "login_group";
DROP TABLE IF EXISTS "refresh_token";
DROP TABLE IF EXISTS "login";

DROP TABLE IF EXISTS "organizer_group";
DROP TABLE IF EXISTS "organizer";
DROP TABLE IF EXISTS "group";

DROP TABLE IF EXISTS "language";