
{{ config(materialized='view') }}

SELECT
    symbol,
    trading_date,
    daily_close,
    daily_volume,

    ROUND(
        100 * (
            daily_close /
            LAG(daily_close) OVER (
                PARTITION BY symbol
                ORDER BY trading_date
            ) - 1
        ), 2
    ) AS daily_return_pct

FROM {{ ref('daily_candles') }}
