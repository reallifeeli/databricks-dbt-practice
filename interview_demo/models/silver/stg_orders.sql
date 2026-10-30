
{{ config(
    materialized='view',
    schema='silver'
) }}

SELECT
    CAST(order_id AS BIGINT) AS order_id,
    CAST(customer_id AS BIGINT) AS customer_id,
    CAST(amount AS DECIMAL(18,2)) AS amount,
    LOWER(TRIM(status)) AS status
FROM workspace.bronze.orders
WHERE order_id IS NOT NULL

