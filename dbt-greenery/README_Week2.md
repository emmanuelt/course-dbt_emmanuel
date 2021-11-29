### What is our user repeat rate?
The repeat rate is 80.5%.
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
- Users who purchased more than once and who visited the website recently.
- Users who visited the website recently and have a high conversion rate (using historical data).
- Potentially users who visited the website recently and who have not purchased yet, in particular users who added items in a cart but did not went through the checkout process.

### What about indicators of users who are likely NOT to purchase again? 
- Users who never purchased (could have visited the website or not).
- Users who purchased once and have not visited the website in the last year.
- Users where the delivery date occured much later than the order date (will be unsatisfied).

### If you had more data, what features would you want to look into to answer this question?
It would be great to implement a post order survey to get customer satisfaction scores following an order.
Ideally we should trigger the survey once the order has been delivered.
We could measure metrics such as CSAT (customer satisfaction), DSAT (customer disatisfaction),and CES (customer effort score).
These metrics should be good indicators to know if each user will purchase again or not.

### Think about what exploratory analysis you would do to approach this question.
- Scatter plots and correlation factor between number of purchases and CSAT/CES scores.
- Table with share of users who purchased several times versus users who purchased only with various metrics to look at (avg CSAT, avg DSAT, avg CES, avg delivery time, share of orders in promo, avg total order).

### Explain the marts models you added. Why did you organize the models in the way you did?
In the Core folder I created:
- **dim_users**: I added addresses data to the users data and I also calculated various metrics at user level based on website behaviors and order behaviors.
The goal was to create a big table we can rely on to get all customers dimensions but also some customer behaviors.
- **dim_product**: I simply replicated the same data than in the staging products table but keeping only the product_uuid (not keeping the integer id) and making some minor renaming to bring clarity to end users of the dimension.
- **fact_orders**: I reused a lot of fields from the orders staging table and I calculated revenue & cost metrics for the customers and for Greenery. I also added information from other tables such as the discounted value from a promotion as well as the quantity of distinct product types per order and the quantity of products per order.
The goal was to create a master table with the main data from each order. 