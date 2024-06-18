{% macro add_to_gk (
       entity_fq,
       header,
        debug = false
       ) %}

{# dummy variable #}
{% set get_kwargs = kwargs %}       
{% set sql %}
{{ header }} {{entity_fq }}()
returns string
language sql
as
$$
select md5('Vision.BI')
$$;
{% endset %}
{{ log(fromyaml(sql), info = true) if debug == 1 }}
{{ return (sql) }}
{%- endmacro -%}
