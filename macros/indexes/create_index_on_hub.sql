{% macro create_index_on_hub(table) %}
{%- if execute -%}

    {%- set table_name = table.name -%}
    {%- if not table_name.endswith('_h') -%}
        {{- exceptions.raise_compiler_error("Model '" ~ table_name ~ "' is not a hub") -}}
    {%- endif -%}

    {%- set ns=namespace(hk_hub="", bus_keys=[]) -%}
    {%- set ldts_alias = var('datavault4dbt.ldts_alias', 'ldts') -%}
    {%- set rsrc_alias = var('datavault4dbt.ldts_alias', 'rsrc') -%}

    {%- set all_columns = adapter.get_columns_in_relation(table) -%}

    {%- for column_object in all_columns -%}
        {%- set column = column_object.column -%}
        {%- if column.startswith('hk_') and column.endswith('_h') -%}
            {%- set ns.hk_hub = column -%}
        {%- elif not (column.startswith('hk_') or column.endswith('_h') or column in [ldts_alias, rsrc_alias]) -%}
            {%- do ns.bus_keys.append(column) -%}
        {%- endif -%}
    {%- endfor -%}

    {# Unique index on a hub hash key #}
    {%- do create_index(index_name=('uix_' ~ table_name), table=table, columns=ns.hk_hub, unique=true, dry_run=false) -%}

    {# Unique index on business keys #}
    {%- do create_index(index_name=('uix_bus_keys_' ~ table_name), table=table, columns=ns.bus_keys, unique=true, dry_run=false) -%}

{%- endif -%}
{%- endmacro %}