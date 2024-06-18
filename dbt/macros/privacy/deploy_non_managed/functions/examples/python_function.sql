{% macro python_function (
       entity_fq,
       header,
        debug = false
       ) %}

{# dummy variable #}
{% set get_kwargs = kwargs %}       
{% set sql %}
{{ header }} {{entity_fq }}(i int)
returns int
language python
runtime_version = '3.8'
handler = 'addone_py'
as
$$
def addone_py(i):
  return i+1
$$;
{% endset %}
{{ log(fromyaml(sql), info = true) if debug == 1 }}
{{ return (sql) }}
{%- endmacro -%}
