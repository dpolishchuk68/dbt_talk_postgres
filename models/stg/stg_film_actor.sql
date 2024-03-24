{{ config(materialized='incremental') }}

SELECT
     actor_id::integer as actor_id
    ,film_id::integer as film_id
    ,last_update
FROM {{ source('dvdrental', 'film_actor') }}
{% if is_incremental() %}
where last_update >
        ( select coalesce(max(last_update), '1900-01-01') from {{ this }} )
{% endif %}