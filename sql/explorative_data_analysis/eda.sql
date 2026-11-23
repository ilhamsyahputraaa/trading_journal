-- Explorative data cleaning - 2


-- 7. Profit Efficiency (expectancy and Profit Factor)

-- a. avg profit/trade
SELECT
    ROUND(AVG(CASE
        WHEN net_profit > 0 THEN net_profit
    END), 2) AS average_win,

    ROUND(AVG(CASE
        WHEN net_profit < 0 THEN net_profit
    END), 2) AS average_loss,

    MAX(net_profit) AS largest_win,
    MIN(net_profit) AS largest_loss

FROM journal_staging2;

-- b. Profit Factor

SELECT
    ROUND(
        SUM(CASE
            WHEN net_profit > 0 THEN net_profit
            ELSE 0
        END)
        /
        NULLIF(
            SUM(CASE
                WHEN net_profit < 0 THEN ABS(net_profit)
                ELSE 0
            END), 0
        ),
    2) AS profit_factor

FROM journal_staging2;

-- c. Expectancy
SELECT
    COUNT(trade_id) AS total_trades,
    ROUND(SUM(net_profit), 2) AS total_net_profit,
    ROUND(AVG(net_profit), 2) AS expectancy_per_trade

FROM journal_staging2;

-- d. Monthly Performance Analytic
SELECT
    trade_month,
    COUNT(trade_id) AS total_trades,
    ROUND(AVG(net_profit), 2) AS expectancy,
    ROUND(SUM(net_profit), 2) AS net_profit,

    ROUND(
        SUM(CASE WHEN net_profit > 0 THEN net_profit ELSE 0 END)
        /
        NULLIF(
            SUM(CASE WHEN net_profit < 0 THEN ABS(net_profit) ELSE 0 END),
        0),
    2) AS profit_factor

FROM journal_staging2
GROUP BY trade_month
ORDER BY MIN(trade_date);

-- e. Monthly Cumulative profit
SELECT
    trade_month,
    SUM(net_profit) AS monthly_profit,

    SUM(SUM(net_profit)) OVER (
        ORDER BY MIN(trade_date)
    ) AS cumulative_profit

FROM journal_staging2
GROUP BY trade_month
ORDER BY MIN(trade_date);

-- f. Session Expectancy & Profit Factor

SELECT
    session,
    COUNT(trade_id) AS total_trades,
    ROUND(AVG(net_profit), 2) AS expectancy,
    ROUND(SUM(net_profit), 2) AS net_profit,

    ROUND(
        SUM(CASE WHEN net_profit > 0 THEN net_profit ELSE 0 END)
        /
        NULLIF(
            SUM(CASE WHEN net_profit < 0 THEN ABS(net_profit) ELSE 0 END),
        0),
    2) AS profit_factor

FROM journal_staging2
GROUP BY session
ORDER BY net_profit DESC;


-- g. Average Risk by Outcome

SELECT
    outcome,
    COUNT(trade_id) AS total_trades,
    ROUND(AVG(risk_reward), 2) AS average_risk,
    ROUND(MAX(risk_reward), 2) AS maximum_risk,
    ROUND(MIN(risk_reward), 2) AS minimum_risk,
    ROUND(AVG(net_profit), 2) AS average_result

FROM journal_staging2
GROUP BY outcome;

SELECT *
FROM journal_staging2;


