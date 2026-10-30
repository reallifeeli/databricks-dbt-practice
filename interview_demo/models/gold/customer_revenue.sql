
{{ config(
    materialized='table',
    schema='gold'
) }}

SELECT
    customer_id,
    COUNT(order_id) AS total_orders,
    SUM(amount) AS total_revenue
FROM {{ ref('stg_orders') }}
WHERE status = 'completed'
GROUP BY customer_id

