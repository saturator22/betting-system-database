--GET TRANSACTIONS FOR USER

DROP FUNCTION IF EXISTS getTransactions(id INT);

CREATE OR REPLACE FUNCTION getTransactions(id INT)
  RETURNS table(d DATE, v INT, b BOOLEAN) AS $$
  BEGIN
    EXECUTE 'CREATE OR REPLACE TEMP VIEW user_transactions_view AS
            SELECT t.date, t.value, t.is_bet FROM box.transactions t
            WHERE ' || id || '= t.user_id';
    RETURN QUERY EXECUTE 'SELECT * FROM user_transactions_view';

END;$$
  LANGUAGE PLPGSQL;

SELECT * FROM getTransactions(29430);

--GET BETS FOR USER
DROP FUNCTION getBets(id INT);

CREATE OR REPLACE FUNCTION getBets(id INT)
  RETURNS table(login TEXT, event_id INT, competitor_id INT, bet INT, date DATE) AS $$

  BEGIN
    EXECUTE 'REFRESH MATERIALIZED VIEW user_bets_view';
    RETURN QUERY EXECUTE 'SELECT login, event_id, competitor_id, bet, date ' ||
                         'FROM user_bets_view ' ||
                         'WHERE ' || id || ' = user_id';
  end;$$
  LANGUAGE PLPGSQL;

SELECT * FROM getBets(2);

--VALIDATE TRANSACTIONS
DROP FUNCTION IF EXISTS isTransactionValid(id INT, betValue INT);

CREATE OR REPLACE FUNCTION isTransactionValid(id INT, betValue INT)
  RETURNS BOOLEAN AS $$
  DECLARE
    balance INT;
  BEGIN
    SELECT INTO balance u.balance
    FROM box.users as u
    WHERE u.id = $1;

    RETURN betValue < balance;
  END;$$
  LANGUAGE PLPGSQL;


--MAKE TRANSACTION
CREATE OR REPLACE FUNCTION makeTransaction(id INT, transactionAmount INT, is_Bet BOOLEAN)
  RETURNS VOID AS $$
  BEGIN
    INSERT INTO box.transactions VALUES ($1, now(), $2, $3);
  end;$$
  LANGUAGE PLPGSQL;

--UPDATE BALANCE
CREATE OR REPLACE FUNCTION updateBalance(id INT, amount INT)
  RETURNS VOID AS $$
  DECLARE
    balanceBeforeUpdate INT;
  BEGIN
    SELECT INTO balanceBeforeUpdate u.balance FROM box.users as u
    WHERE u.id = $1;

    UPDATE box.users SET balance = balanceBeforeUpdate + amount
    WHERE users.id = $1;
  end;$$
  LANGUAGE PLPGSQL;

SELECT updateBalance(2, 2000);
SELECT * FROM box.users WHERE users.id = 2;
SELECT isTransactionValid(2, 300);

--WITHDRAW

CREATE OR REPLACE FUNCTION withdrawMoney(id INT, amount INT)
  RETURNS VOID AS $$

  BEGIN
    IF (SELECT isTransactionValid($1, $2)) THEN PERFORM updateBalance($1, (-1 * $2));
    end if;
  end;$$
  LANGUAGE PLPGSQL;

SELECT withdrawMoney(2, 300);


--TRIGGER FUNCTION
-- DROP FUNCTION placeBet();

CREATE OR REPLACE FUNCTION placeBet()
  RETURNS trigger AS $$
  BEGIN
    IF (SELECT isTransactionValid(new.user_id, new.bet)) THEN
      PERFORM makeTransaction(new.user_id, new.bet, true);
      PERFORM updateBalance(new.user_id, (-1 * new.bet));
    ELSE RAISE EXCEPTION 'Transaction can not be executed for value %',new.bet;
    end if;
    RETURN new;
  end;$$
  LANGUAGE PLPGSQL;


--TRIGGER
CREATE TRIGGER placing_bet BEFORE INSERT
  ON box.bets
  FOR EACH ROW
  EXECUTE PROCEDURE placeBet();

-- DROP TRIGGER placing_bet ON box.bets;

--TEST
-- INSERT INTO box.bets VALUES (2, 2, 2, 300, now());
--
-- SELECT * FROM box.users
-- WHERE users.id = 2;
--
-- SELECT * FROM box.bets;
-- SELECT * FROM box.transactions
--     WHERE user_id = 2;
--
-- DELETE FROM box.bets;