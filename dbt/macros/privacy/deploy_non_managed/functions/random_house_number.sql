{% macro random_house_number (
       entity_fq,
       header,
        debug = false
       ) %}

{# dummy variable #}
{% set get_kwargs = kwargs %}       
{% set sql %}
{{ header }} {{entity_fq }}()
returns string
language python
runtime_version = '3.8'
handler = 'run'
packages = ('numpy')
as
$$
import numpy
def run():
    patterns = [
        'd',
        'd/א',
        'dd',
        'dd כניסה א',
        'dd כניסה ב',
        'dd/א',
        'dd/ב'
    ]

    pattern = numpy.random.choice(patterns)
    return ''.join([item.replace('d', str(numpy.random.randint(1, 9)))
                    for item in pattern])
$$;
{% endset %}
{{ log(fromyaml(sql), info = true) if debug == 1 }}
{{ return (sql) }}
{%- endmacro -%}
