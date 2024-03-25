{% macro create_index_on_satellite(table) %}
{%- if execute -%}

    {%- set table_name = table.name -%}
    {%- if not table_name.endswith('_s') -%}
        {{- exceptions.raise_compiler_error("Model '" ~ table_name ~ "' is not a satellite") -}}
    {%- endif -%}

    {%- set ns=namespace(hk_hub="", ldts="") -%}
    {%- set ldts_alias = var('datavault4dbt.ldts_alias', 'ldts') -%}

    {%- set all_columns = adapter.get_columns_in_relation(table) -%}

    {%- for column_object in all_columns -%}
        {%- set column = column_object.column -%}
        {%- if column.startswith('hk_') and column.endswith('_h') -%}
            {%- set ns.hk_hub = column -%}
        {%- elif column == ldts_alias -%}
            {%- set ns.ldts = column -%}
        {%- endif -%}
    {%- endfor -%}

    {%- do create_index(index_name=('uix_' ~ table_name), table=table, columns=[ns.hk_hub, ns.ldts], unique=true, dry_run=false) -%}

{%- endif -%}
{%- endmacro %}