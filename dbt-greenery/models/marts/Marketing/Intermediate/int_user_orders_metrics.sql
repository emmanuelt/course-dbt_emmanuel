select 
  u.user_uuid,
  min(e.created_at) as user_first_web_activity_date,
  max(e.created_at) as user_last_web_activity_date,
  extract(day from now()-max(e.created_at)) as user_days_since_last_web_activity,
  count(distinct e.session_uuid) as user_web_sessions_count,
  count(distinct case when e.event_type = 'page_view' then e.session_uuid else null end) as user_web_sessions_with_page_viewed,
  count(distinct case when e.event_type = 'add_to_cart' then e.session_uuid else null end) as user_web_sessions_with_product_added_to_cart,
  count(distinct case when e.event_type = 'checkout' then e.session_uuid else null end) as user_web_sessions_with_checkout,
  min(o.created_at) as user_first_order_date,
  max(o.created_at) as user_last_order_date,
  extract(day from now()-max(o.created_at)) as user_days_since_last_order,
  count(distinct o.order_uuid) as user_orders_count,
  oi.order_product_types,
  oi.order_quantity_of_products     
from {{ ref('stg_users') }} u
left join {{ ref('stg_events') }} e
on u.user_uuid=e.user_uuid
left join {{ ref('stg_orders') }} o
on u.user_uuid=o.user_uuid
left join {{ ref('int_order_items_metrics') }} oi
on o.order_uuid=oi.order_uuid
group by u.user_uuid,
          oi.order_product_types,
          oi.order_quantity_of_products