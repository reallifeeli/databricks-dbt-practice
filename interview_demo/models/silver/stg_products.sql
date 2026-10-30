{{ config(materialized='view', schema='silver') }}

SELECT
    CAST(product_id AS BIGINT) AS product_id,
    TRIM(title) AS title,
    LOWER(TRIM(category)) AS category,
    CAST(price AS DECIMAL(18,2)) AS price,
    CAST(rating AS DOUBLE) AS rating,
    ingested_at
FROM workspace.bronze.products
WHERE product_id IS NOT NULL