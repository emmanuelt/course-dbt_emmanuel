-- Function to aggregate event types per any web measure
{% macro count_event_types_per_any_event_measure(event_measure) %}

    select event_type,
           count(distinct {{event_measure}}) as {{event_measure}}_quantity
    from {{ ref('stg_events') }}
    group by event_type

{% endmacro %}