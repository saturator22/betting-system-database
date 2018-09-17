-- DROP DATABASE betting_system;
CREATE DATABASE betting_system;

DROP SCHEMA box CASCADE;
CREATE SCHEMA box;

CREATE TABLE box.users (
  id INT PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  login TEXT UNIQUE NOT NULL,
  password TEXT UNIQUE NOT NULL,
  balance INT DEFAULT 0
);

CREATE TABLE box.transcations (
  user_id INT REFERENCES box.users(id),
  date DATE DEFAULT now(),
  value INT NOT NULL
);

CREATE TABLE box.locations (
  id INT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  address TEXT
);

CREATE TABLE box.boxer_teams (
  id INT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT NOT NULL
);

CREATE TABLE box.boxers (
  id INT PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  nick_name TEXT
);

CREATE TABLE box.boxer_teams_boxers (
  team_id INT REFERENCES box.boxer_teams(id),
  boxer_id INT REFERENCES box.boxers(id)
);

CREATE TABLE box.competitors (
  id INT PRIMARY KEY,
  team_id INT REFERENCES box.boxer_teams(id),
  boxer_id INT REFERENCES box.boxers(id)
);

CREATE TABLE box.event (
  id INT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  event_date DATE,
  location_id INT REFERENCES box.locations(id),
  winner_id INT REFERENCES box.competitors(id)
);

CREATE TABLE box.bets (
  id INT PRIMARY KEY,
  date DATE,
  user_id INT REFERENCES box.users(id),
  event_id INT REFERENCES box.event(id),
  bet INT NOT NULL
);

CREATE TABLE box.rates (
  event_id INT REFERENCES box.event(id),
  is_group_fight BOOLEAN,
  competitor_1 INT REFERENCES box.competitors(id),
  competitor_2 INT REFERENCES box.competitors(id),
  rate_1 REAL NOT NULL,
  rate_2 REAL NOT NULL
);
