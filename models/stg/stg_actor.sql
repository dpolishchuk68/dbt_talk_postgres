{{ config(
    materialized='incremental',
    indexes=[
      { 'columns': ['actor_id'], 'unique': True, 'type': 'btree'}
    ]
)}}

select
     actor_id
    ,first_name
    ,last_name
    ,last_update
from {{ source('dvdrental', 'actor') }}
{% if is_incremental() %}
where last_update >
        ( select coalesce(max(last_update), '1900-01-01') from {{ this }} )
{% endif %}