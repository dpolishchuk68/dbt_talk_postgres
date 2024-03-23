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

/*
union all

select
     9999 as film_id
    ,'Test film' title
    ,'Test description' description
    ,'1900' release_year
    ,1 as language_id -- from 1 to 6
    ,10 as rental_duration
    ,9.99 rental_rate
    ,200 as length
    ,99.99 as replacement_cost
    ,'TEST-18' as rating
    ,current_timestamp::timestamp as last_update
*/