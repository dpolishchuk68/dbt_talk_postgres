{% macro create_index(index_name, table, columns, unique, dry_run=false) -%}
    
    {%- set ns=namespace(column_list_print="") -%}
    {%- if columns is string -%}
        {%- set column_list = [columns] -%}
    {%- else %}
        {%- set column_list = columns -%}
    {%- endif -%}

    {%- for column in column_list -%}
        {%- set ns.column_list_print = ns.column_list_print ~ column ~ (', ' if not loop.last else '') -%}
    {%- endfor -%}

    {%- set query -%}
    CREATE{%- if unique %} UNIQUE{% endif %} INDEX IF NOT EXISTS {{ index_name }} ON {{ table }} ( {{ ns.column_list_print }} );
    {%- endset -%}

    {%- do log(query, info=true) -%}
    {%- if not dry_run -%}
        {%- do run_query('BEGIN;\n'~ query ~ '\nCOMMIT;') -%}
    {%- endif -%}

{%- endmacro %}