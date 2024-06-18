 {% macro sql_function (      
       entity_fq,
        header,  
        debug = false
    ) %}

 {# dummy variable #}
{% set get_kwargs = kwargs %}
 {% set sql %}
  {{ header }} {{entity_fq}} (radius float)
  returns float
  as
  $$
    pi() * radius * radius
  $$
  ;
 {%endset%}
 {{ log(fromyaml(sql), info = true) 
        if debug == 1 }}
 {{return (sql)}}
{%- endmacro -%}