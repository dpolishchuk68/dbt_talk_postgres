{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
parent_hashkey: hk_actor_h
src_hashdiff: hd_actor_s
src_payload:
    - first_name
    - last_name
source_model: stg_dv_actor
{%- endset -%}    

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{ datavault4dbt.sat_v0(parent_hashkey=metadata_dict['parent_hashkey'],
                        src_hashdiff=metadata_dict['src_hashdiff'],
                        source_model=metadata_dict['source_model'],
                        src_payload=metadata_dict['src_payload']) }}