DROP VIEW user_bets_view;

CREATE OR REPLACE TEMP VIEW user_bets_view AS
SELECT b.user_id, b.event_id, b.competitor_id, b.bet, b.date
  FROM box.bets b;

DROP FUNCTION getBets(id INT);
CREATE OR REPLACE FUNCTION getBets(id INT)
  RETURNS table(event_id INT, competitor_id INT, bet INT, date DATE) AS $$

  BEGIN
    RETURN QUERY EXECUTE 'SELECT event_id, competitor_id, bet, date ' ||
                         'FROM user_bets_view' ||
                         'WHERE ' || id || ' = user_id';
  end;$$
  LANGUAGE PLPGSQL;

SELECT getBets();

