with web_events_metrics as (
    select
        --created_at::date as date_of_visit,
        count(distinct session_uuid) as web_sessions_total_if_dataset_was_good,
        count(distinct case when event_type='page_view' then session_uuid end) as web_sessions_with_page_view_if_dataset_was_good,
        count(distinct case when event_type='add_to_cart' then session_uuid end) as web_sessions_with_add_to_cart_if_dataset_was_good,
        count(distinct case when event_type='checkout' then session_uuid end) as web_sessions_with_checkout_if_dataset_was_good,
        count(distinct case when (event_type='page_view' or event_type='add_to_cart' or event_type='checkout') then session_uuid end) as web_sessions_funnel_level_1,
        count(distinct case when (event_type='add_to_cart' or event_type='checkout') then session_uuid end) as web_sessions_funnel_level_2,
        count(distinct case when event_type='checkout' then session_uuid end) as web_sessions_funnel_level_3
    from {{ ref('stg_events') }}
    --group by created_at::date
)

select 
    --date_of_visit,
    web_sessions_total_if_dataset_was_good,
    web_sessions_with_page_view_if_dataset_was_good,
    web_sessions_with_add_to_cart_if_dataset_was_good,
    web_sessions_with_checkout_if_dataset_was_good,
    web_sessions_funnel_level_1,
    web_sessions_funnel_level_2,
    web_sessions_funnel_level_3,
    round(web_sessions_funnel_level_2::numeric / nullif(web_sessions_funnel_level_1,0),4) as add_to_cart_conversion,
    round(web_sessions_funnel_level_3::numeric / nullif(web_sessions_funnel_level_2, 0),4) as checkout_conversion,
    round(web_sessions_funnel_level_3::numeric / nullif(web_sessions_funnel_level_1, 0),4) as total_conversion,
    round(1 - ((web_sessions_funnel_level_2::numeric / nullif(web_sessions_funnel_level_1, 0))),4) as add_to_cart_dropoff,
    round(1 - ((web_sessions_funnel_level_3::numeric / nullif(web_sessions_funnel_level_2, 0))),4) as checkout_dropoff,
    round(1 - ((web_sessions_funnel_level_3::numeric / nullif(web_sessions_funnel_level_1, 0))),4) as total_dropoff
from web_events_metrics
--order by 1