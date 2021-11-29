### What is our user repeat rate?
**The repeat rate is 80.5%.**
```
select
(select count(user_uuid)
 from
 (select user_uuid
  from stg_orders
  group by user_uuid
  having count(distinct order_uuid)>1 
) t1 )::float
 /
 (select count(user_uuid)
  from
 (select user_uuid
  from stg_orders
  group by user_uuid
  having count(distinct order_uuid)>=1 
) t2 )::float
```

### What are good indicators of a user who will likely purchase again? 
**- Users who purchased more than once and who visited the website recently.**\
**- Users who visited the website recently and have a high conversion rate (using historical data).**\
**- Potentially users who visited the website recently and who have not purchased yet, in particular users who added items in a cart but did not went through the checkout process.**

### What about indicators of users who are likely NOT to purchase again? 
**- Users who never purchased (could have visited the website or not).**\
**- Users who purchased once and have not visited the website in the last year.**\
**- Users where the delivery date occured much later than the order date (will be unsatisfied).**

### If you had more data, what features would you want to look into to answer this question?
**It would be great to implement a post order survey to get customer satisfaction scores following an order.**\
**Ideally we should trigger the survey once the order has been delivered.**\
**We could measure metrics such as CSAT (customer satisfaction), DSAT (customer disatisfaction),and CES (customer effort score).**\
**These metrics should be good indicators to know if each user will purchase again or not.**

### Think about what exploratory analysis you would do to approach this question.
**- Scatter plots and correlation factor between number of purchases and CSAT/CES scores.**\
**- Table with share of users who purchased several times versus users who purchased only with various metrics to look at (avg CSAT, avg DSAT, avg CES, avg delivery time, share of orders in promo, avg total order).**