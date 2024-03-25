{% macro get_data_vault_entity_type(table) %}

    {%- set table_name = table.name -%}
    {%- if table_name.endswith('_h') -%}
        {%- set dv_entity_type = 'hub' -%}
    {%- elif table_name.endswith('_l') -%}
        {%- set dv_entity_type = 'link' -%}
    {%- elif table_name.endswith('_s') -%}
        {%- set dv_entity_type = 'satellite' -%}
    {%- else -%}
        {%- set dv_entity_type = 'unknown' -%}
    {%- endif -%}

    {{ return (dv_entity_type) }}

{%- endmacro %}