{% macro masking_policy_conditional (      
        entity_fq,   
        header,       
        debug = false
    ) %}

{# dummy variable #}
{% set get_kwargs = kwargs %}

{%- set body -%}
CASE WHEN CURRENT_ROLE() IN ('PII') THEN c_string
WHEN c_number = 1 THEN c_string
ELSE '*'
END
;
{% endset %}



{%- set sql %}
{{ header }} {{entity_fq}} as (C_STRING VARCHAR(16777216),
C_NUMBER NUMBER(38,0)) 
returns VARCHAR(16777216) ->
{{body}}
{% endset %}

{%- set sql -%}
{{- sql -}}
ALTER MASKING POLICY {{entity_fq}} SET BODY -> 
{{body}}
{% endset %}      

{{ log(fromyaml(sql), info = true) 
        if debug == 1 }}
{{return (sql)}}
{%- endmacro -%}


