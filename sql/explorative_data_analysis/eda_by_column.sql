-- Explorative data cleaning

-- 1. Overall Performance
SELECT *
FROM journal_staging2;

-- a. Total Trade
SELECT COUNT(trade_id)
FROM journal_staging2;

-- b. Total Trading days
SELECT COUNT( DISTINCT trade_date) AS total_trading_days
FROM journal_staging2;

-- c. Total Win and Lost
SELECT 
outcome, 
COUNT(trade_id) AS trades, 
SUM(net_profit) AS net_profit,
AVG(score) AS average_score,
AVG(duration_seconds) AS average_seconds,
ROUND(COUNT(trade_id) / SUM(COUNT(trade_id)) OVER () * 100, 2) AS percentage
FROM journal_staging2
GROUP BY outcome;

-- d. Winrate template
SELECT
    COUNT(trade_id) AS total_trades,
    SUM(outcome = 'PROFIT') AS total_win,
    SUM(outcome = 'LOSE') AS total_loss,
    SUM(outcome = 'BREAK EVEN') AS total_be,
    ROUND(
        SUM(outcome = 'PROFIT') /
        SUM(outcome IN ('PROFIT', 'LOSE')) * 100,
        2   ) AS win_rate,
	ROUND(
        SUM(outcome = 'PROFIT') /
        SUM(outcome IN ('PROFIT', 'LOSE')) * 100,
        2
    ) AS win_rate,

    SUM(
        CASE
            WHEN net_profit > 0 THEN net_profit
            ELSE 0
        END
    ) AS gross_profit,

    SUM(
        CASE
            WHEN net_profit < 0 THEN ABS(net_profit)
            ELSE 0
        END
    ) AS gross_loss,
    ROUND(SUM(net_profit), 2) AS net_profit
FROM journal_staging2;

-- 2. By Month
SELECT
trade_month,
    COUNT(trade_id) AS total_trades,
    SUM(outcome = 'PROFIT') AS total_win,
    SUM(outcome = 'LOSE') AS total_loss,
    SUM(outcome = 'BREAK EVEN') AS total_be,
    ROUND(
        SUM(outcome = 'PROFIT') /
        SUM(outcome IN ('PROFIT', 'LOSE')) * 100,
        2   ) AS win_rate,
	ROUND(
        SUM(outcome = 'PROFIT') /
        SUM(outcome IN ('PROFIT', 'LOSE')) * 100,
        2
    ) AS win_rate,

    SUM(
        CASE
            WHEN net_profit > 0 THEN net_profit
            ELSE 0
        END
    ) AS gross_profit,

    SUM(
        CASE
            WHEN net_profit < 0 THEN ABS(net_profit)
            ELSE 0
        END
    ) AS gross_loss,
    ROUND(SUM(net_profit), 2) AS net_profit
FROM journal_staging2
GROUP BY trade_month;

-- 3. By Day
SELECT
weekday,
    COUNT(trade_id) AS total_trades,
    SUM(outcome = 'PROFIT') AS total_win,
    SUM(outcome = 'LOSE') AS total_loss,
    SUM(outcome = 'BREAK EVEN') AS total_be,
    ROUND(
        SUM(outcome = 'PROFIT') /
        SUM(outcome IN ('PROFIT', 'LOSE')) * 100,
        2   ) AS win_rate,
	ROUND(
        SUM(outcome = 'PROFIT') /
        SUM(outcome IN ('PROFIT', 'LOSE')) * 100,
        2
    ) AS win_rate,

    SUM(
        CASE
            WHEN net_profit > 0 THEN net_profit
            ELSE 0
        END
    ) AS gross_profit,

    SUM(
        CASE
            WHEN net_profit < 0 THEN ABS(net_profit)
            ELSE 0
        END
    ) AS gross_loss,
    ROUND(SUM(net_profit), 2) AS net_profit
FROM journal_staging2
GROUP BY weekday;

-- 4. By Session
SELECT
trade_session,
    COUNT(trade_id) AS total_trades,
    SUM(outcome = 'PROFIT') AS total_win,
    SUM(outcome = 'LOSE') AS total_loss,
    SUM(outcome = 'BREAK EVEN') AS total_be,
    ROUND(
        SUM(outcome = 'PROFIT') /
        SUM(outcome IN ('PROFIT', 'LOSE')) * 100,
        2   ) AS win_rate,
	ROUND(
        SUM(outcome = 'PROFIT') /
        SUM(outcome IN ('PROFIT', 'LOSE')) * 100,
        2
    ) AS win_rate,

    SUM(
        CASE
            WHEN net_profit > 0 THEN net_profit
            ELSE 0
        END
    ) AS gross_profit,

    SUM(
        CASE
            WHEN net_profit < 0 THEN ABS(net_profit)
            ELSE 0
        END
    ) AS gross_loss,
    ROUND(SUM(net_profit), 2) AS net_profit
FROM journal_staging2
GROUP BY trade_session;

-- 5. By Symbol
SELECT
	symbol,
    COUNT(trade_id) AS total_trades,
    SUM(outcome = 'PROFIT') AS total_win,
    SUM(outcome = 'LOSE') AS total_loss,
    SUM(outcome = 'BREAK EVEN') AS total_be,
    ROUND(
        SUM(outcome = 'PROFIT') /
        SUM(outcome IN ('PROFIT', 'LOSE')) * 100,
        2   ) AS win_rate,
	ROUND(
        SUM(outcome = 'PROFIT') /
        SUM(outcome IN ('PROFIT', 'LOSE')) * 100,
        2
    ) AS win_rate,

    SUM(
        CASE
            WHEN net_profit > 0 THEN net_profit
            ELSE 0
        END
    ) AS gross_profit,

    SUM(
        CASE
            WHEN net_profit < 0 THEN ABS(net_profit)
            ELSE 0
        END
    ) AS gross_loss,
    ROUND(SUM(net_profit), 2) AS net_profit
FROM journal_staging2
GROUP BY symbol;

-- 6. By Timeframe
SELECT
timeframe,
    COUNT(trade_id) AS total_trades,
    SUM(outcome = 'PROFIT') AS total_win,
    SUM(outcome = 'LOSE') AS total_loss,
    SUM(outcome = 'BREAK EVEN') AS total_be,
    ROUND(
        SUM(outcome = 'PROFIT') /
        SUM(outcome IN ('PROFIT', 'LOSE')) * 100,
        2   ) AS win_rate,
	ROUND(
        SUM(outcome = 'PROFIT') /
        SUM(outcome IN ('PROFIT', 'LOSE')) * 100,
        2
    ) AS win_rate,

    SUM(
        CASE
            WHEN net_profit > 0 THEN net_profit
            ELSE 0
        END
    ) AS gross_profit,

    SUM(
        CASE
            WHEN net_profit < 0 THEN ABS(net_profit)
            ELSE 0
        END
    ) AS gross_loss,
    ROUND(SUM(net_profit), 2) AS net_profit
FROM journal_staging2
GROUP BY timeframe;


-- ----------------------------

-- 7. By Grade

SELECT
    setup_grade,
    COUNT(trade_id) AS total_trades,
    SUM(outcome = 'PROFIT') AS total_win,
    SUM(outcome = 'LOSE') AS total_loss,

    ROUND(
        SUM(outcome = 'PROFIT')
        /
        NULLIF(SUM(outcome IN ('PROFIT', 'LOSE')), 0)
        * 100,
    2) AS win_rate,

    ROUND(AVG(net_profit), 2) AS expectancy,
    ROUND(SUM(net_profit), 2) AS net_profit

FROM journal_staging2
GROUP BY setup_grade
ORDER BY net_profit DESC;

-- --------------------------------

-- 8. Duration to Outcome

SELECT
    outcome,
    COUNT(trade_id) AS total_trades,

    ROUND(AVG(duration_seconds), 2) AS average_seconds,
    ROUND(AVG(duration_seconds) / 60, 2) AS average_minutes,

    ROUND(MIN(duration_seconds) / 60, 2) AS shortest_minutes,
    ROUND(MAX(duration_seconds) / 60, 2) AS longest_minutes

FROM journal_staging2
GROUP BY outcome;

-- -----------------------------------------------------------------

-- 9. Duration

SELECT
    CASE
        WHEN duration_seconds < 300 THEN 'Under 5 Minutes'
        WHEN duration_seconds < 900 THEN '5-15 Minutes'
        WHEN duration_seconds < 1800 THEN '15-30 Minutes'
        WHEN duration_seconds < 3600 THEN '30-60 Minutes'
        ELSE 'Over 60 Minutes'
    END AS duration_group,

    COUNT(trade_id) AS total_trades,
    ROUND(AVG(net_profit), 2) AS expectancy,
    ROUND(SUM(net_profit), 2) AS net_profit,
    SUM(outcome = 'PROFIT') AS wins,
    SUM(outcome = 'LOSE') AS losses

FROM journal_staging2
GROUP BY duration_group
ORDER BY
    CASE duration_group
        WHEN 'Under 5 Minutes' THEN 1
        WHEN '5-15 Minutes' THEN 2
        WHEN '15-30 Minutes' THEN 3
        WHEN '30-60 Minutes' THEN 4
        ELSE 5
    END;
    
-- -----------------------------------------------------

-- 10. Confluence

SELECT
    COUNT(trade_id) AS total_trades,

    SUM(outcome = 'PROFIT') AS wins,
    SUM(outcome = 'LOSE') AS losses,

    ROUND(AVG(net_profit), 2) AS expectancy,
    ROUND(SUM(net_profit), 2) AS net_profit

FROM journal_staging2
WHERE confluence LIKE '%Fair Value Gap%';