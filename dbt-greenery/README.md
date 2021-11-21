### How many users do we have?
**There are 130 users.**__
select count(distinct user_id) as nb_of_users from users_stg;__

### On average, how many orders do we receive per hour?
**On average 8.35 orders are received per hour.**__
select first_order_date, last_order_date,__
       extract(epoch from last_order_date-first_order_date)/3600 as Diff_In_Hours,__
       orders / (extract(epoch from last_order_date-first_order_date)/3600) as Orders_per_Hour__
from (select min(created_at) as first_order_date,max(created_at) as last_order_date,__
             count(distinct order_id) as orders__
      from orders_stg) t;

### On average, how long does an order take from being placed to being delivered?
**On average it takes 94 hours (almost 4 days) for an order to be delivered.**__
select avg(Diff_In_Hours) as Avg_Delivery_Time_In_Hours__
from (select created_at, delivered_at,__
             extract(epoch FROM delivered_at-created_at)/3600 as Diff_In_Hours__
      from orders_stg) t__
where Diff_In_Hours is not null;

### How many users have only made one purchase? Two purchases? Three+ purchases?
**25 users have made only 1 purchase. 22 users have made 2 purchases. 81 users have made 3 or more purchases.**__
select Purchases, count(distinct user_id) as Users__
from__
(select u.user_id, __
        case when count(distinct o.order_id)=0 then '0'__
             when count(distinct o.order_id)=1 then '1'__
             when count(distinct o.order_id)=2 then '2'__
             when count(distinct o.order_id)>=3 then '3+'__
        end as Purchases__
 from users_stg as u__
 left join orders_stg as o__
 on u.user_id = o.user_id__
 group by u.user_id) t__
group by Purchases__
order by 1;

### On average, how many unique sessions do we have per hour?
**On average, there are 0.11 sessions per hour.**__
select first_session_date, last_session_date, sessions,__
       extract(epoch from last_session_date-first_session_date)/3600 as Diff_In_Hours,__
       sessions / (extract(epoch from last_session_date-first_session_date)/3600) as Sessions_per_Hour__
from (select min(created_at) as first_session_date,max(created_at) as last_session_date,__
             count(distinct session_id) as sessions__
      from events_stg) t;
