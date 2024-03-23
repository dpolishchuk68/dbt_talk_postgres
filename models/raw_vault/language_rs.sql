{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_model: stg_dv_language
parent_ref_keys: language_id
src_hashdiff: hd_language_rs
src_payload:
    - name
{%- endset -%}      

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault4dbt.ref_sat_v0(source_model=metadata_dict['source_model'],
                    parent_ref_keys=metadata_dict['parent_ref_keys'],
                    src_hashdiff=metadata_dict['src_hashdiff'],
                    src_payload=metadata_dict['src_payload']) }}