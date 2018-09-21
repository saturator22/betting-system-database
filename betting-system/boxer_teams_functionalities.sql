CREATE INDEX team_name ON box.boxer_teams (name);

DROP TYPE IF EXISTS team_data CASCADE;

CREATE TYPE team_data as (
team_id           int,
team_name         text,
team_description  text,
members           int,
won_battles       int,
total_battles     int,
win_percentage    int
);

CREATE OR REPLACE FUNCTION full_boxer_teams_data()
RETURNS setof team_data AS
$BODY$
  DECLARE
    r team_data%rowtype;
  BEGIN
    FOR r IN SELECT * FROM box.boxer_teams LOOP
      -- Count all members of given boxer team
      SELECT INTO r.members COUNT(*)
        FROM box.boxer_teams_boxers
        WHERE team_id = r.team_id;

      -- Count all battles won by given boxer team
      SELECT INTO r.won_battles COUNT(*)
        FROM box.event
        WHERE winner_id = r.team_id;

      -- Count total number of battles of given boxer team
      SELECT INTO r.total_battles COUNT(*)
        FROM box.rates
        WHERE competitor_1 = r.team_id OR competitor_2 = r.team_id;

      IF (r.total_battles = 0) THEN r.win_percentage = 0; -- Prevent division by 0
      ELSE r.win_percentage = r.won_battles * 100 / r.total_battles;
      END IF;
      RETURN NEXT r;

    END LOOP;
    RETURN;
  END;
$BODY$ LANGUAGE plpgsql;


DROP FUNCTION IF EXISTS create_team_as_competitor CASCADE;

CREATE FUNCTION create_team_as_competitor()
RETURNS trigger AS
$BODY$
  DECLARE
    team_id int;
  BEGIN
    SELECT INTO team_id last_value FROM box.boxer_teams_id_seq;
    INSERT INTO box.competitors VALUES (default, team_id, null);
    RETURN NEW;
  END;
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER new_team_created
  AFTER INSERT
  ON box.boxer_teams
  EXECUTE PROCEDURE create_team_as_competitor();


select *
from full_boxer_teams_data()

;