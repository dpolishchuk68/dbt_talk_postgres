{{ config(
    materialized='incremental',
    indexes=[
      { 'columns': ['film_id'], 'unique': True,  'type': 'btree'},
      { 'columns': ['title'],   'unique': False, 'type': 'btree'}
    ]
)}}

select
     film_id
    ,title
    ,description
    ,release_year
    ,language_id
    ,rental_duration
    ,rental_rate
    ,length
    ,replacement_cost
    ,rating::varchar(10)
    ,last_update
from {{ source('dvdrental', 'film') }}
{% if is_incremental() %}
where last_update >
        ( select coalesce(max(last_update), '1900-01-01') from {{ this }} )
{% endif %}
{#
union all
select
     9999::integer as film_id
    ,'Chamber Italian'::varchar(255) title -- duplicate name
    ,'Test description'::text description
    ,1899::integer release_year --<=1900
    ,6::smallint as language_id -- from 1 to 6
    ,10::smallint as rental_duration
    ,9.99::numeric(4,2) rental_rate
    ,200::smallint as length
    ,99.99::numeric(5,2) as replacement_cost
    ,'TEST-18'::varchar(10) as rating
    ,current_timestamp::timestamp as last_update
#}