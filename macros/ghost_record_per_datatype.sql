{%- macro postgres__ghost_record_per_datatype(column_name, datatype, ghost_record_type, col_size, alias) -%}

{%- set beginning_of_all_times = datavault4dbt.beginning_of_all_times() -%}
{%- set end_of_all_times = datavault4dbt.end_of_all_times() -%}
{%- set timestamp_format = datavault4dbt.timestamp_format() -%}
{%- set datatype = datatype | string | upper | trim -%}

{%- set unknown_value__STRING = var('datavault4dbt.unknown_value__STRING', '(unknown)') -%}
{%- set error_value__STRING = var('datavault4dbt.error_value__STRING', '(error)') -%}
{%- if ghost_record_type == 'unknown' -%}
        {# {% do log(datatype, info=true) %} #}
        {%- if datatype == 'TIMESTAMP' %} {{ datavault4dbt.string_to_timestamp( timestamp_format , beginning_of_all_times) }} as {{ alias }}
        {%- elif datatype == 'CHARACTER VARYING' %} '{{unknown_value__STRING}}' as {{ alias }}
        {%- elif datatype == 'TEXT' %} '{{unknown_value__STRING}}' as {{ alias }}
        {%- elif datatype == 'INTEGER' %} CAST('0' as INTEGER) as {{ alias }}
        {%- elif datatype == 'SMALLINT' %} CAST('0' as SMALLINT) as {{ alias }}
        {%- elif datatype == 'NUMERIC' %} CAST('0' as NUMERIC) as {{ alias }}
        {%- elif datatype == 'FLOAT64' %} CAST('0' as FLOAT64) as {{ alias }}
        {%- elif datatype == 'BOOLEAN' %} CAST('FALSE' as BOOLEAN) as {{ alias }}
        {%- else %} CAST(NULL as {{ datatype }}) as {{ alias }}
        {% endif %}
{%- elif ghost_record_type == 'error' -%}
        {%- if datatype == 'TIMESTAMP' %} {{ datavault4dbt.string_to_timestamp( timestamp_format , end_of_all_times) }} as {{ alias }}
        {%- elif datatype == 'CHARACTER VARYING' %} '{{error_value__STRING}}' as {{ alias }}
        {%- elif datatype == 'TEXT' %} '{{error_value__STRING}}' as {{ alias }}
        {%- elif datatype == 'INTEGER' %} CAST('-1' as INTEGER) as {{ alias }}
        {%- elif datatype == 'SMALLINT' %} CAST('-1' as SMALLINT) as {{ alias }}
        {%- elif datatype == 'NUMERIC' %} CAST('-1' as NUMERIC) as {{ alias }}
        {%- elif datatype == 'FLOAT64' %} CAST('-1' as FLOAT64) as {{ alias }}
        {%- elif datatype == 'BOOLEAN' %} CAST('FALSE' as BOOLEAN) as {{ alias }}
        {%- else %} CAST(NULL as {{ datatype }}) as {{ alias }}
        {% endif %}
{%- else -%}
    {%- if execute -%}
        {{ exceptions.raise_compiler_error("Invalid Ghost Record Type. Accepted are 'unknown' and 'error'.") }}
    {%- endif %}
{%- endif -%}
{%- endmacro -%}