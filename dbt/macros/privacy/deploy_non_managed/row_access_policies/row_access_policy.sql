{% macro row_access_policy (      
        entity_fq, 
        header,         
        debug = false
    ) %}
{# dummy variable #}
{% set get_kwargs = kwargs %}
{%- set body -%}
exists (select 1 FROM SB.ADO.RLS_DATA_CUT  WHERE USERNAME_SF = current_user() AND DATA_SOURCE_GROUP_CODE = 4 AND DATA_CUT_CODE = 2 AND DATA_CUT_VALUE_CODE = PROFIT_CENTER_CODE)
or exists (select 1 FROM SB.ADO.RLS_DATA_CUT  WHERE USERNAME_SF = current_user() AND DATA_SOURCE_GROUP_CODE = 4 AND DATA_CUT_CODE = 5 AND DATA_CUT_VALUE_CODE = ACQUISITIONS_CODE) 
or exists (select 1 FROM SB.ADO.RLS_DATA_CUT  WHERE USERNAME_SF = current_user() AND DATA_SOURCE_GROUP_CODE = 4 AND DATA_CUT_CODE = 1 AND DATA_CUT_VALUE_CODE = ACCOUNT_CODE) 
or exists (select 1 from SB.ADO.RLS_DATA_CUT  WHERE USERNAME_SF = current_user() AND DATA_SOURCE_GROUP_CODE = 4 AND DATA_CUT_CODE = 9)
{% endset %}


{%- set sql %}
{{ header }} {{entity_fq}} as (RESOURCE_PROFIT_CENTER_CODE VARCHAR, ACQUISITIONS_CODE VARCHAR, ACCOUNT_CODE VARCHAR) returns boolean ->
{{body}}
{% endset %}

{%- set sql -%}
{{- sql -}}
ALTER ROW ACCESS POLICY {{entity_fq}} SET BODY -> 
{{body}}
{% endset %}      

{{ log(fromyaml(sql), info = true) 
        if debug == 1 }}
{{return (sql)}}
{%- endmacro -%}


