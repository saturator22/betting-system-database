CREATE DATABASE betting_system;

CREATE SCHEMA box;

CREATE TABLE box.users (
  id INT PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  login TEXT UNIQUE NOT NULL,
  password TEXT UNIQUE NOT NULL,
  balance INT DEFAULT 0
);

CREATE TABLE box.locations (
  id INT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  address TEXT
);

CREATE TABLE box.event (
  id INT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  event_date DATE,
  location_id INT REFERENCES box.locations(id)
);

CREATE TABLE box.bets (
  id INT PRIMARY KEY,
  user_id INT REFERENCES box.users(id),
  event_id INT REFERENCES box.event(id),
  bet INT NOT NULL
);

CREATE TABLE box.betting_history (
  user_id INT REFERENCES box.users(id),
  bet_id INT REFERENCES box.bets(id),
  won BOOLEAN NOT NULL
);
--TODO winner id references to ?
CREATE TABLE box.event_history (
  event_id INT REFERENCES box.event(id),
  winner_id INT REFERENCES box.competitors(id),
  won_competitor_1 BOOLEAN
);

CREATE TABLE box.rates (
  event_id INT REFERENCES box.event(id),
  is_group_fight BOOLEAN,
  competitor_1 INT REFERENCES box.competitors(id),
  competitor_2 INT REFERENCES box.competitors(id),

)
