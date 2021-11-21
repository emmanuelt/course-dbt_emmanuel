###How many users do we have?
select count(distinct user_id) as nb_of_users from users_stg;
**There are 130 users.**

###On average, how many orders do we receive per hour?
select first_order_date, last_order_date,
       extract(epoch FROM last_order_date-first_order_date)/3600 as Diff_In_Hours,
       orders / (extract(epoch FROM last_order_date-first_order_date)/3600) as Orders_per_Hour
from (select min(created_at) as first_order_date,max(created_at) as last_order_date,
             count(distinct order_id) as orders
      from orders_stg) t;
**On average 8.35 orders are received per hour.**

###On average, how long does an order take from being placed to being delivered?
select avg(Diff_In_Hours) as Avg_Delivery_Time_In_Hours
from (select created_at, delivered_at,
             extract(epoch FROM delivered_at-created_at)/3600 as Diff_In_Hours
      from orders_stg) t
where Diff_In_Hours is not null;
**On average it takes 94 hours (almost 4 days) for an order to be delivered.**

###How many users have only made one purchase? Two purchases? Three+ purchases?
select Purchases, count(distinct user_id) as Users
from
(select u.user_id, 
        case when count(distinct o.order_id)=0 then '0'
             when count(distinct o.order_id)=1 then '1'
             when count(distinct o.order_id)=2 then '2'
             when count(distinct o.order_id)>=3 then '3+'
        end as Purchases  
 from users_stg as u
 left join orders_stg as o
 on u.user_id = o.user_id
 group by u.user_id) t
group by Purchases
order by 1;
**25 users have made only 1 purchase. 22 users have made 2 purchases. 81 users have made 3 or more purchases.**

###On average, how many unique sessions do we have per hour?
select first_session_date, last_session_date, sessions,
       extract(epoch FROM last_session_date-first_session_date)/3600 as Diff_In_Hours,
       sessions / (extract(epoch FROM last_session_date-first_session_date)/3600) as Sessions_per_Hour
from (select min(created_at) as first_session_date,max(created_at) as last_session_date,
             count(distinct session_id) as sessions
      from events_stg) t;
**On average, there are 0.11 sessions per hour.**
