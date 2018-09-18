-- DROP DATABASE betting_system;
-- CREATE DATABASE betting_system;

DROP SCHEMA box CASCADE;
CREATE SCHEMA box;

CREATE TABLE box.users (
  id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  login TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  balance INT DEFAULT 0
);

CREATE TABLE box.transactions (
  user_id INT REFERENCES box.users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  date DATE DEFAULT now(),
  value INT NOT NULL,
  is_Bet BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE box.locations (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  address TEXT
);

CREATE TABLE box.boxer_teams (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT NOT NULL
);

CREATE TABLE box.boxers (
  id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  nick_name TEXT
);

CREATE TABLE box.boxer_teams_boxers (
  team_id INT REFERENCES box.boxer_teams(id) ON DELETE CASCADE ON UPDATE CASCADE,
  boxer_id INT REFERENCES box.boxers(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE box.competitors (
  id SERIAL PRIMARY KEY,
  team_id INT REFERENCES box.boxer_teams(id) ON DELETE CASCADE ON UPDATE CASCADE,
  boxer_id INT REFERENCES box.boxers(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE box.event (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  event_date DATE,
  location_id INT REFERENCES box.locations(id) ON DELETE CASCADE ON UPDATE CASCADE,
  winner_id INT REFERENCES box.competitors(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE box.bets (
  user_id INT REFERENCES box.users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  event_id INT REFERENCES box.event(id) ON DELETE CASCADE ON UPDATE CASCADE,
  competitor_id INT REFERENCES box.competitors(id) ON DELETE CASCADE ON UPDATE CASCADE,
  bet INT NOT NULL,
  date DATE
);

CREATE TABLE box.rates (
  event_id INT REFERENCES box.event(id),
  competitor_1 INT REFERENCES box.competitors(id) ON DELETE CASCADE ON UPDATE CASCADE,
  competitor_2 INT REFERENCES box.competitors(id) ON DELETE CASCADE ON UPDATE CASCADE,
  rate_1 REAL NOT NULL,
  rate_2 REAL NOT NULL
);

COPY box.users(first_name, last_name, login, password, balance)  FROM '/home/filip/Java_adv/TW_2/betting-system-database/betting-system/Sample_Data/CSV/users.csv'
DELIMITER ',';
COPY box.transcations FROM '/home/filip/Java_adv/TW_2/betting-system-database/betting-system/Sample_Data/CSV/transactions.csv'
DELIMITER ',';
INSERT INTO box.users (first_name, last_name, login, password)
VALUES ('Wojtekgdasd', 'Makiela3dasd', 'Wasdasojtek123', 'Makiela1asd23');