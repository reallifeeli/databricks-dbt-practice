
{{ config(materialized='view') }}

SELECT
    symbol,
    DATE(open_time) AS trading_date,
    MAX_BY(close, open_time) AS daily_close,
    SUM(volume) AS daily_volume,
    COUNT(*) AS hourly_candles
FROM workspace.crypto_silver.market_candles
GROUP BY symbol, DATE(open_time)
HAVING COUNT(*) = 24
