{% macro random_phone_number (
       entity_fq,
       header,
        debug = false
       ) %}

{# dummy variable #}
{% set get_kwargs = kwargs %}       
{% set sql %}
{{ header }} {{entity_fq }}(mobile boolean, landline boolean)
returns string
language python
runtime_version = '3.8'
handler = 'run'
packages = ('numpy')
as
$$
import numpy
def run(mobile=True, landline=True):
    mobile_patterns = [
        '050-ddd-dddd',
        '052-ddd-dddd',
        '053-ddd-dddd',
        '054-ddd-dddd',
        '058-ddd-dddd',
        '055-55d-dddd',
        '055-6dd-dddd',
        '050-ddddddd',
        '052-ddddddd',
        '053-ddddddd',
        '054-ddddddd'
    ]
    landline_patterns = [
        '02-ddd-dddd',
        '03-ddd-dddd',
        '04-ddd-dddd',
        '08-ddd-dddd',
        '09-ddd-dddd',
        '02-ddddddd',
        '03-ddddddd',
        '04-ddddddd',
        '08-ddddddd',
        '09-ddddddd'
    ]

    phone = numpy.random.choice((mobile_patterns if mobile else []) +
                                (landline_patterns if landline else []))
    return ''.join([str(numpy.random.randint(1, 9))
                    if item == 'd' else item for item in phone])
$$;
{% endset %}
{{ log(fromyaml(sql), info = true) if debug == 1 }}
{{ return (sql) }}
{%- endmacro -%}
