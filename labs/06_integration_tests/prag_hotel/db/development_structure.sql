CREATE TABLE "reservations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "check_in" date, "check_out" date, "name" varchar(255), "rate" integer, "number_of_rooms" integer, "room_type_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "room_types" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "rack_rate" decimal, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('2');