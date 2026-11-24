-- Credit Card Transaction Analysis | PostgreSQL
-- Synthetic sample records for SQL practice; not real bank/customer data.
DROP TABLE IF EXISTS card_transactions;
CREATE TABLE card_transactions (
 txn_id INT PRIMARY KEY, card_id INT, txn_date TIMESTAMP, merchant_category VARCHAR(40),
 city VARCHAR(30), amount NUMERIC(10,2), channel VARCHAR(15), status VARCHAR(15)
);
INSERT INTO card_transactions VALUES
(1,101,'2026-01-02 10:15','Grocery','Pune',2450,'POS','Approved'),
(2,102,'2026-01-02 13:40','Travel','Mumbai',18500,'Online','Approved'),
(3,101,'2026-01-03 19:05','Fuel','Pune',3200,'POS','Approved'),
(4,103,'2026-01-04 09:20','Electronics','Nashik',42999,'Online','Declined'),
(5,104,'2026-01-05 20:30','Dining','Pune',1850,'POS','Approved'),
(6,102,'2026-01-07 11:10','Grocery','Mumbai',3890,'POS','Approved'),
(7,105,'2026-01-08 02:12','Electronics','Delhi',67500,'Online','Declined'),
(8,101,'2026-01-10 17:45','Shopping','Pune',7999,'Online','Approved'),
(9,103,'2026-01-11 14:30','Fuel','Nashik',2100,'POS','Approved'),
(10,104,'2026-01-13 22:55','Travel','Pune',12900,'Online','Approved'),
(11,105,'2026-01-15 12:05','Grocery','Delhi',1750,'POS','Approved'),
(12,102,'2026-01-17 03:10','Electronics','Mumbai',55800,'Online','Approved');
-- 1. Overall transaction KPIs
SELECT COUNT(*) AS transactions, COUNT(DISTINCT card_id) AS active_cards,
 SUM(amount) FILTER (WHERE status='Approved') AS approved_spend,
 COUNT(*) FILTER (WHERE status='Declined') AS declined_count FROM card_transactions;
-- 2. Merchant category spend
SELECT merchant_category, COUNT(*) AS txn_count, SUM(amount) AS total_amount
FROM card_transactions WHERE status='Approved' GROUP BY 1 ORDER BY total_amount DESC;
-- 3. Approval rate
SELECT channel, COUNT(*) AS attempts,
 ROUND(100.0*COUNT(*) FILTER (WHERE status='Approved')/COUNT(*),2) AS approval_rate_pct
FROM card_transactions GROUP BY channel;
-- 4. Card-level spend profile
SELECT card_id, COUNT(*) AS txn_count, SUM(amount) AS spend, AVG(amount) AS avg_ticket
FROM card_transactions WHERE status='Approved' GROUP BY card_id ORDER BY spend DESC;
-- 5. High-value transaction review queue (illustrative threshold)
SELECT * FROM card_transactions WHERE amount >= 25000 ORDER BY amount DESC;
-- 6. Hour-of-day patterns
SELECT EXTRACT(HOUR FROM txn_date) AS txn_hour, COUNT(*) AS txn_count, SUM(amount) AS amount
FROM card_transactions GROUP BY 1 ORDER BY 1;
-- 7. City and channel mix
SELECT city, channel, COUNT(*) AS txn_count, SUM(amount) AS amount
FROM card_transactions GROUP BY city,channel ORDER BY city,amount DESC;
-- 8. Daily approved spend
SELECT txn_date::date AS txn_day, SUM(amount) AS approved_spend
FROM card_transactions WHERE status='Approved' GROUP BY 1 ORDER BY 1;
