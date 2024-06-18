{% macro config_row_access_policies(
  debug=false
  ) %}
{% set config_row_access_policies -%}

entities:
- name: RAP_STAGE5
  type : row access policy
  database: DWH
  schema:  GOVERNANCE
  role : "*SF_CDO_DEVELOPERS"
  macro : row_access_policy


{%- endset %}  
{{ log(fromyaml(config_row_access_policies)
      ,info = true)
      if debug == 1 }}
 {{ return(fromyaml(config_row_access_policies)) }}

{% endmacro %}

