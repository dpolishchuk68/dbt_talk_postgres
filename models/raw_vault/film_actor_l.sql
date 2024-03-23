{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
link_hashkey: hk_film_actor_l
foreign_hashkeys: 
    - hk_film_h
    - hk_actor_h
source_models: stg_dv_film_actor
{%- endset -%}    

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{%- set link_hashkey = metadata_dict['link_hashkey'] -%}
{%- set foreign_hashkeys = metadata_dict['foreign_hashkeys'] -%}
{%- set source_models = metadata_dict['source_models'] -%}


{{ datavault4dbt.link(link_hashkey=link_hashkey,
        foreign_hashkeys=foreign_hashkeys,
        source_models=source_models) }}