{% macro create_index_on_data_vault_entity(table) %}
{%- if execute -%}

{%- set dv_entity_type = get_data_vault_entity_type(table) -%}

    {%- if dv_entity_type == 'hub' -%}
        {%- do create_index_on_hub(table) -%}
    {%- elif dv_entity_type == 'link' -%}
        {%- do create_index_on_link(table) -%}
    {%- elif dv_entity_type == 'satellite' -%}
        {%- do create_index_on_satellite(table) -%}
    {%- else -%}
        {%- do log('Unknown data vault entity type', info=true) -%}
    {%- endif -%}

{%- endif -%}
{%- endmacro %}