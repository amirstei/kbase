{% macro seven_to_eight (
       entity_fq,
       header,
        debug = false
       ) %}

{# dummy variable #}
{% set get_kwargs = kwargs %}       
{% set sql %}
{{ header }} {{entity_fq }}(val string)
returns string
language python
runtime_version = '3.8'
handler = 'seven_to_eight'
as
$$
def get_bidi_vector(sentence):
    """note: sentence is a list of words.
    this function returns a vector of 1s or 0s,
    indicating if each word is hebrew or not
    (hebrew characters count vs other characters)"""
    bidi_vector = [
        sum([1 if 1488 <= ord(letter) <= 1514 else -1 for letter in word])
        for word in sentence
    ]

    return [1 if 0 <= val else -1 for val in bidi_vector]


def right_to_left(sentence, bidi_vector):
    """note: sentence is a list of words.
    """

    res = [word[::-1] if 0 < is_rtl else word
           for is_rtl, word in zip(bidi_vector, sentence)]

    # when most of the words are in Hebrew, reverse words order
    # (i.e. reverse the order of words in sentence)
    if 0 <= sum(bidi_vector):
        return res[::-1]
    else:
        return res


def seven_to_eight(val):
    special_chars = {'(': ')', ')': '('}

    try:
        # ignore whitespace
        if not val.strip():
            return val
        else:
            # to hebrew characters
            res = [chr(ord(item) + 1_392)
                   if 96 <= ord(item) <= 122 else item for item in val]
            # handle brackets
            res = [special_chars.get(item, item) for item in res]

            # join characters, and re-split to words
            res = ''.join(res).split(' ')
            bidi_vector = get_bidi_vector(res)
            res = right_to_left(res, bidi_vector)

            return ' '.join(res)
    except:
        return 'ERROR'
$$;
{% endset %}
{{ log(fromyaml(sql), info = true) if debug == 1 }}
{{ return (sql) }}
{%- endmacro -%}
