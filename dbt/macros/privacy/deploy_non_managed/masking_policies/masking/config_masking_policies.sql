{% macro config_masking_policies(
  debug=false
  ) %}
{% set config_masking_policies -%}

entities:
- name: mp_date
  type : masking policy
  database: DWH
  schema:  GOVERNANCE
  role : "*SF_CDO_DEVELOPERS"
  macro : mp_date
- name: mp_string
  type : masking policy
  database: DWH
  schema:  GOVERNANCE
  role : "*SF_CDO_DEVELOPERS"
  macro : mp_string
- name: mp_float
  type : masking policy
  database: DWH
  schema:  GOVERNANCE
  role : "*SF_CDO_DEVELOPERS"
  macro : mp_float
- name: mp_integer
  type : masking policy
  database: DWH
  schema:  GOVERNANCE
  role : "*SF_CDO_DEVELOPERS"
  macro : mp_integer

{%- endset %}  
{{ log(fromyaml(config_masking_policies)
      ,info = true)
      if debug == 1 }}
 {{ return(fromyaml(config_masking_policies)) }}

{% endmacro %}

