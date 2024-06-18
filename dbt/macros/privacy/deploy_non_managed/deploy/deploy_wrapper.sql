
{%- macro deploy_wrapper(
                  operation_type = 'set',
                  create_or_replace = 0,
                  ref_entities = 1,
                  force = 1,
                  debug= 0
                  ) -%}
{% if execute %}


    {# initiliaze env  #}
        {% set res = deploy(
            config = 'config_tags',
            operation_type = operation_type,
            create_or_replace =  0,
            ref_entities =  0 ,
            force =  0 ,
            debug = debug
            ) 
        %}    

    {%set config_entities = (kwargs.get('config') or 
                   'config_masking_policies,config_tags,config_row_access_policies'
                              
                    ).split (',')
                    %}
    {% for config in config_entities %}              
        {% set res = deploy(
            config = config,
            operation_type = operation_type,
            create_or_replace =  create_or_replace,
            ref_entities =  ref_entities ,
            force =  force ,
            debug = debug
            ) 
        %}    
    {%endfor%}    
{%endif%}
{%- endmacro -%}
