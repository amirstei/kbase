{% macro config_functions(
  debug=false
  ) %}
{% set config_functions -%}

entities:    
{# - name: add_to_gk
  type : function
  database: DATALAKE_RAW
  schema: utils
  role : SYSADMIN
  macro : add_to_gk 
  secure: true    
   #}

{%- endset %}  
{{ log(fromyaml(config_functions)
      ,info = true)
      if debug == 1 }}
 {{ return(fromyaml(config_functions)) }}

{% endmacro %}

