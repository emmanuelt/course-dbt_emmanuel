### (1) How users move through the product funnel? Which steps in the funnel have largest dropoff points?

I have created the model "fact_product_funnel" in my Product mart.\
The model is calculating funnel metrics at date level.\
I have calculated the conversion rates and dropoff rates at date level in my model, but  below I have calculated the metrics without aggregating per date to get the overall customer behaviours (on the whole period).\
The metrics have been calculating based on the week 4 instructions, but it is not necessarily the way I would calcualte them usually (if the dataset was cleaner / more logical).
<br />
The **total conversion rate** from level 1 to level 3 (Sessions with any event of type page_view / add_to_cart / checkout --> Sessions with any event of type checkout) is **57.5%**.\
The **add_to_cart conversion rate** from level 1 to level 2 (Sessions with any event of type page_view / add_to_cart / checkout --> Sessions with any event of type add_to_cart / checkout) is **87.5%**.\
The **checkout rate** from level 2 to level 3 (Sessions with any event of type add_to_cart / checkout --> Sessions with any event of type checkout) is **65.7%**.\
<br />
Therefore the **biggest dropoff point is between level 2 and level 3** (Sessions with any event of type add_to_cart / checkout --> Sessions with any event of type checkout).
The dropoff rate between these 2 stages is equal to **34.3%**.\

```sql
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
```
