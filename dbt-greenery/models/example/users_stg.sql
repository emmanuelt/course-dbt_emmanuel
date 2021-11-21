{{
  config(
    materialized='table'
  )
}}

{{
  config(
    materialized='table'
  )
}}

SELECT * FROM {{ source('greenery_data_sources', 'users') }}