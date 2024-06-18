{% macro random_israeli_id (
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
    id = numpy.random.randint(1_000_000, 99_999_999)
    if id < 10_000_000:
        id = '0' + str(id)
    else:
        id = str(id)

    # calculate check digit
    weights = [1, 2, 1, 2, 1, 2, 1, 2]
    check_digit = [int(num) * weight for num, weight in zip(id, weights)]
    weights_sum = sum([sum(int(digit) for digit in str(item))
                       for item in check_digit])
    check_digit = str(10 - (weights_sum % 10))[-1]
    return id + check_digit
$$;
{% endset %}
{{ log(fromyaml(sql), info = true) if debug == 1 }}
{{ return (sql) }}
{%- endmacro -%}
