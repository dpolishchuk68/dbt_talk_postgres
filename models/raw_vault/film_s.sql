{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
parent_hashkey: hk_film_h
src_hashdiff: hd_film_s
src_payload:
    - title
    - description
    - release_year
    - language_id
    - rental_duration
    - rental_rate
    - length
    - replacement_cost
    - rating
source_model: stg_dv_film
{%- endset -%}    

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{ datavault4dbt.sat_v0(parent_hashkey=metadata_dict['parent_hashkey'],
                        src_hashdiff=metadata_dict['src_hashdiff'],
                        source_model=metadata_dict['source_model'],
                        src_payload=metadata_dict['src_payload']) }}