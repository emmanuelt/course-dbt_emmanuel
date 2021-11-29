select
  product_id
  , product_guid
  , product_name
  , product_price
  , product_stock_quantity
from
  {{ ref('stg_products') }}