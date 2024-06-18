{% macro config_tags(
  debug=false
  ) %}
{% set config_tags -%}

entities:
- name: TAG_SENSITIVE
  type : tag
  macro: tags
  database: DWH
  schema:  GOVERNANCE
  role : "*SF_CDO_DEVELOPERS"
  meta:  
    entities:
      name : masking policy
      macro : config_masking_policies
      ref_entities:
        - 'mp_string'
        - 'mp_integer'
        - 'mp_date'
        - 'mp_float'                
{%- endset %}  
{{ log(fromyaml(config_tags)
      ,info = true)
      if debug == 1 }}
 {{ return(fromyaml(config_tags)) }}

{% endmacro %}

