{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
hashkey: 'hk_actor_h'
business_keys: 
    - actor_id
source_models:
    - name: stg_dv_actor
    - name: stg_dv_film_actor
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set hashkey = metadata_dict['hashkey'] -%}
{%- set business_keys = metadata_dict['business_keys'] -%}
{%- set source_models = metadata_dict['source_models'] -%}

{{ datavault4dbt.hub(hashkey=hashkey,
                    business_keys=business_keys,
                    source_models=source_models) }}