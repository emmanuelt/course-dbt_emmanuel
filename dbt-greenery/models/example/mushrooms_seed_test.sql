-- This refers to the table created from course-dbt_emmanuel/mushrooms.csv
select * from {{ ref('mushrooms') }}