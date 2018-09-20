DROP MATERIALIZED VIEW user_bets_view;

CREATE MATERIALIZED VIEW user_bets_view AS
SELECT u.login, b.user_id, b.event_id, b.competitor_id, b.bet, b.date
  FROM box.bets b
JOIN box.users u
ON u.id = b.user_id
WITH NO DATA;

DROP FUNCTION getBets(id INT);
CREATE OR REPLACE FUNCTION getBets(id INT)
  RETURNS table(login TEXT, event_id INT, competitor_id INT, bet INT, date DATE) AS $$

  BEGIN
    EXECUTE 'REFRESH MATERIALIZED VIEW user_bets_view';
    RETURN QUERY EXECUTE 'SELECT ubv.login, ubv.event_id, ubv.competitor_id, ubv.bet, ubv.date ' ||
                         'FROM user_bets_view as ubv ' ||
                         'WHERE ' || id || '= ubv.user_id';
  end;$$
  LANGUAGE PLPGSQL;

REFRESH MATERIALIZED VIEW user_bets_view;
SELECT * FROM user_bets_view;
SELECT * FROM getBets(2);

