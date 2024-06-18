{% macro random_ip (
       entity_fq,
       header,
        debug = false
       ) %}

{# dummy variable #}
{% set get_kwargs = kwargs %}       
{% set sql %}
{{ header }} {{entity_fq }}(IPv4 boolean, IPv6 boolean)
returns string
language python
runtime_version = '3.8'
handler = 'run'
packages = ('numpy')
as
$$
import numpy
def run(IPv4=True, IPv6=True):
    ver = numpy.random.choice((['v4'] if IPv4 else []) + (['v6'] if IPv6 else []))

    if ver == 'v4':
        return '.'.join([str(numpy.random.randint(0, 255)) for _ in range(4)])
    else:
        return ':'.join([str(hex(numpy.random.randint(0, 65535))).lstrip('0x')
                         for _ in range(8)])
$$;
{% endset %}
{{ log(fromyaml(sql), info = true) if debug == 1 }}
{{ return (sql) }}
{%- endmacro -%}
