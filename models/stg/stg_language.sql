{{ config(materialized='incremental') }}

SELECT
     language_id
    ,name
    ,last_update
from {{ source('dvdrental', 'language') }}
{% if is_incremental() %}
where last_update >
        ( select coalesce(max(last_update), '1900-01-01') from {{ this }} )
{% endif %}