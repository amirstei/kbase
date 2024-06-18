{%- macro function_second() -%}
{% set frustrating_jinja_feature = varargs %}
{% set frustrating_jinja_feature = kwargs %}
{% for intf in varargs -%}
{# {{print (intf)}} #}
{%endfor%}
{%  for intf, vid in kwargs.items() -%}
{{print (intf)}}
{%set kldfkd =intf %}
{%endfor%} 
{{print (kldfkd)}}
  {% do print(kwargs.resource_type) %}
{%- endmacro -%}


