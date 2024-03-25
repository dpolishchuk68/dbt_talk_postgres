{% macro create_index_on_link(table) %}
{%- if execute -%}

    {%- set table_name = table.name -%}
    {%- if not table_name.endswith('_l') -%}
        {{- exceptions.raise_compiler_error("Model '" ~ table_name ~ "' is not a link") -}}
    {%- endif -%}

    {%- set ns=namespace(hk_link="", hk_hubs=[]) -%}

    {%- set all_columns = adapter.get_columns_in_relation(table) -%}

    {%- for column_object in all_columns -%}
        {%- set column = column_object.column -%}
        {%- if column.startswith('hk_') and column.endswith('_l') -%}
            {%- set ns.hk_link = column -%}
        {%- elif column.startswith('hk_') and column.endswith('_h') -%}
            {%- do ns.hk_hubs.append(column) -%}
        {%- endif -%}
    {%- endfor -%}

    {# Unique index on a link hash key #}
    {%- do create_index(index_name=('uix_' ~ table_name), table=table, columns=ns.hk_link, unique=true, dry_run=false) -%}

    {# Unique index on a hub hash keys #}
    {%- do create_index(index_name=('uix_hubs_' ~ table_name), table=table, columns=ns.hk_hubs, unique=true, dry_run=false) -%}

{%- endif -%}
{%- endmacro %}