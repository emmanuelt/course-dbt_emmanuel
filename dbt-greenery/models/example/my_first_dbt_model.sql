with users_test as (
    select * from {{ source('greenery_data_sources','users') }}
),

final as (select * from users_test)

select * from final limit 10