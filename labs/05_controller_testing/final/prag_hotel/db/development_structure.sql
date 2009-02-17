CREATE TABLE reservations ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "check_in" date DEFAULT NULL, "check_out" date DEFAULT NULL, "name" varchar(255) DEFAULT NULL, "rate" integer DEFAULT NULL, "number_of_rooms" integer DEFAULT NULL, "room_type_id" integer DEFAULT NULL, "created_at" datetime DEFAULT NULL, "updated_at" datetime DEFAULT NULL);
CREATE TABLE room_types ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255) DEFAULT NULL, "rack_rate" decimal DEFAULT NULL, "created_at" datetime DEFAULT NULL, "updated_at" datetime DEFAULT NULL);
CREATE TABLE schema_info (version integer);
INSERT INTO schema_info (version) VALUES (2)