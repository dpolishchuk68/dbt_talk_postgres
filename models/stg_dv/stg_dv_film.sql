{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model: stg_film
ldts: last_update
rsrc: '!dvdrental/film'
hashed_columns: 
    hk_film_h:
        - film_id
    hd_film_s:
        is_hashdiff: true
        columns:
            - title
            - description
            - release_year
            - rental_duration
            - rental_rate
            - length
            - replacement_cost
            - rating
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set source_model = metadata_dict['source_model'] -%}
{%- set ldts = metadata_dict['ldts'] -%}
{%- set rsrc = metadata_dict['rsrc'] -%}
{%- set hashed_columns = metadata_dict['hashed_columns'] -%}
{%- set derived_columns = metadata_dict['derived_columns'] -%}
{%- set prejoined_columns = metadata_dict['prejoined_columns'] -%}
{%- set missing_columns = metadata_dict['missing_columns'] -%}

{{ datavault4dbt.stage(source_model=source_model,
                    ldts=ldts,
                    rsrc=rsrc,
                    hashed_columns=hashed_columns,
                    derived_columns=derived_columns,
                    prejoined_columns=prejoined_columns,
                    missing_columns=missing_columns) }}