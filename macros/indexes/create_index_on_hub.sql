{% macro create_index_on_hub(table) %}
{%- if execute -%}

    {%- set table_name = table.name -%}
    {%- if not table_name.endswith('_h') -%}
        {{- exceptions.raise_compiler_error("Model '" ~ table_name ~ "' is not a hub") -}}
    {%- endif -%}

    {%- set ns=namespace(hk_column_l="") -%}

    {%- set all_columns = adapter.get_columns_in_relation(table) -%}

    {%- for column_object in all_columns -%}
        {%- set column = column_object.column -%}
        {%- if column.startswith('hk_') and column.endswith('_h') -%}
            {%- set ns.hk_column = column -%}
        {%- endif -%}
    {%- endfor -%}

    {%- do create_index(index_name=('uix_' ~ table_name), table=table, columns=ns.hk_column, unique=true, dry_run=false) -%}

{%- endif -%}
{%- endmacro %}