{% macro masking_policy_string(   
    entity_fq,   
    header,
    debug = false
 )%}

{# dummy variable #}
{% set get_kwargs = kwargs %}
{%- set body -%}
CASE WHEN CURRENT_ROLE() IN ('PII') THEN val
ELSE '*'
END;
{% endset %}


{%- set sql %}
{{ header }} {{entity_fq}} as (VAL VARCHAR(16777216)) 
RETURNS VARCHAR(16777216) ->
{{body}}
{% endset %}

{% set sql %}
{{- sql -}}
ALTER MASKING POLICY {{entity_fq}} SET BODY -> 
{{body}}
{% endset %}        


{{ log(fromyaml(sql), info = true) 
        if debug == 1 }}
{{return (sql)}}
{%- endmacro -%}