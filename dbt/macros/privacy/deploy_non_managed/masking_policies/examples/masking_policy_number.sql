 {% macro masking_policy_number (      
        entity_fq,     
        header,             
        debug = false
    ) %}

{# dummy variable #}
{% set get_kwargs = kwargs %}
{%- set body -%}
CASE WHEN CURRENT_ROLE() IN ('PII') THEN val
ELSE '-9'
END;
{% endset %}


{%- set sql %}
{{ header }} {{entity_fq}}  as (VAL NUMBER(38,0)) 
returns NUMBER(38,0) ->
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


