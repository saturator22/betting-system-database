CREATE INDEX users_login ON box.users(login);
CREATE INDEX bet_userId ON box.bets(user_id);
CREATE INDEX bet_eventId ON box.bets(event_id);
CREATE INDEX bet_date ON box.bets(date);
CREATE INDEX transaction_userId ON box.transactions(user_id);
CREATE INDEX event_date ON box.event(event_date);
CREATE INDEX event_location ON box.event(location_id);
CREATE INDEX event_winnerId ON box.event(winner_id);