CREATE INDEX boxer_nick ON box.boxers (nick_name);

DROP FUNCTION IF EXISTS create_boxer_as_competitor CASCADE;

CREATE FUNCTION create_boxer_as_competitor()
RETURNS trigger AS
$BODY$
  DECLARE
    boxer_id int;
  BEGIN
    SELECT INTO boxer_id last_value FROM box.boxers_id_seq;
    INSERT INTO box.competitors VALUES (default, null, boxer_id);
    RETURN NEW;
  END;
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER new_boxer_created
  AFTER INSERT
  ON box.boxers
  EXECUTE PROCEDURE create_boxer_as_competitor();
