{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='product_id',
        schema='gold',
        file_format='delta'
    )
}}

SELECT
    product_id,
    title,
    category,
    price,
    rating,
    ingested_at
FROM {{ ref('stg_products') }}

{% if is_incremental() %}
WHERE ingested_at >= (
    SELECT COALESCE(
        MAX(ingested_at),
        TIMESTAMP '1900-01-01 00:00:00'
    )
    FROM {{ this }}
)
{% endif %}