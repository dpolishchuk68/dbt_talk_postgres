{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_models: stg_dv_language
ref_keys: language_id
{%- endset -%}      

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ datavault4dbt.ref_hub(source_models=metadata_dict['source_models'],
                    ref_keys=metadata_dict['ref_keys']) }}