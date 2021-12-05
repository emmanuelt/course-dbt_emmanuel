### What is our overall conversion rate?
The overall conversion rate is 36.1%.
```
select round(count(distinct case when event_type = 'checkout' then session_uuid end)::numeric
             / count(distinct session_uuid), 3) as conversion_rate
from dbt.dbt_emmanuel_t_staging.stg_events
```
For the calculation I have used the formula suggested by Sourabh on the Slack channel but I found the web events data really not self-explanatory.
Usually a checkout page is reached when products have been added to the cart and when customers are in the final step of the booking flow. And it is only once they would have finished to fill the details on the checkout page (payment details & delivery details) and after having sent the final validation ("order" click) that the visit would then be converted as an order.
So I would have expected another event after the "checkout" event and before the "package_shipped" event.
I also do not understand how some sessions can have a "delete_from_cart" event without any "add_to_cart" event, why some sessions can have a "add_to_cart" event without previous "page_view", or why "package-shipped" events are standalone events.

### What 