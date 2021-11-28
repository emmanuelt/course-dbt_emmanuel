/*{{
  config(
    materialized='table'
  )
}}*/

SELECT 
    product_id,
    name,
    price,
    quantity
FROM {{ source('greenery_data_sources', 'products') }}