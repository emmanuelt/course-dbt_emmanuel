### What is our user repeat rate?
**The repeat rate is 80.5%.**
```
select
(select count(user_id)
 from
 (select user_id
  from stg_orders
  group by user_id
  having count(distinct order_id)>1 
) t1 )::float
 /
 (select count(user_id)
  from
 (select user_id
  from stg_orders
  group by user_id
  having count(distinct order_id)>=1 
) t2 )::float
```