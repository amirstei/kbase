{% macro mp_integer(   
    entity_fq,   
    header,
    debug = false
 )%}

{% set get_kwargs = kwargs %}
{%- set body -%}
    CASE
        WHEN val IS NULL THEN val
        WHEN IS_ROLE_IN_SESSION('AC_SENS_FINANCE') 
             and ARRAY_CONTAINS('finance'::variant, SPLIT(system$get_tag_on_current_column('dwh.governance.tag_sensitive'),',')) THEN val
        WHEN IS_ROLE_IN_SESSION('AC_SENS_PNL') 
             and ARRAY_CONTAINS('pnl'::variant, SPLIT(system$get_tag_on_current_column('dwh.governance.tag_sensitive'),','))     THEN val
        WHEN IS_ROLE_IN_SESSION('AC_SENS_CE_FPNA') 
             and ARRAY_CONTAINS('ce_fpna'::variant, SPLIT(system$get_tag_on_current_column('dwh.governance.tag_sensitive'),',')) THEN val
        WHEN IS_ROLE_IN_SESSION('AC_SENS_CNB')     
             and ARRAY_CONTAINS('cnb'::variant, SPLIT(system$get_tag_on_current_column('dwh.governance.tag_sensitive'),','))     THEN val
        WHEN IS_ROLE_IN_SESSION('AC_SENS_HR')      
             and ARRAY_CONTAINS('hr'::variant, SPLIT(system$get_tag_on_current_column('dwh.governance.tag_sensitive'),','))      THEN val  
        WHEN IS_ROLE_IN_SESSION('AC_SENS_GL')     
             and ARRAY_CONTAINS('gl'::variant, SPLIT(system$get_tag_on_current_column('dwh.governance.tag_sensitive'),','))      THEN val    
        ELSE -9
    END;
{% endset %}


{%- set sql %}
{{ header }} {{entity_fq}} as (val int)
returns int ->
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