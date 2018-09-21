CREATE INDEX rates_event ON box.rates (event_id);
CREATE INDEX rates_competitors ON box.rates (competitor_1, competitor_2);
CREATE INDEX rates_ratings ON box.rates (rate_1, rate_2);
