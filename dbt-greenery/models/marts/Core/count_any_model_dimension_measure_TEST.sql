select * from ({{count_any_model_dimension_measure('dim_users','user_state','user_orders_count')}}) t

/* select * from ({{count_any_model_dimension_measure('stg_events','event_type','event_uuid')}}) t */

