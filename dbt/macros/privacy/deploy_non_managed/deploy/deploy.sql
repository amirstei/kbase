{%- macro deploy(
                  config,
                  debug) -%}
{% if execute %}                  
  {% set get_config =  context[config| string] () %}
  {% for entity in get_config.entities %}
    {% set entity_db = entity.get('database',false)
                    or target.database %}    
    {% set entity_schema =  entity.get('schema', false)
                  or generate_schema_name () %}    
    {% set entity_fq = entity_db ~ "." ~ 
            entity_schema ~ "." ~ entity.name %}  
    {% set use_dedicated_role = 'USE ROLE ' ~ (entity.role
                or  target.role ) ~ '; '   %}
    {% set secure = 'SECURE ' if entity.secure %}                

    {% set create_or_replace = kwargs.get('create_or_replace') or false %}                  
    {%- set header = 'CREATE ' ~
                      ('OR REPLACE ' if create_or_replace) ~ 
                       secure ~
                       entity.type | upper ~
                      (' IF NOT EXISTS ' if not create_or_replace ) -%}    
                                
    {% set sql = (use_dedicated_role  if use_dedicated_role)
                ~  context[entity.macro | string]
                ( entity_fq=entity_fq,
                  header = header,
                  ref_entities = kwargs.get('ref_entities'),
                  operation_type = kwargs.get('operation_type'),
                  force = kwargs.get('force'),
                  meta = entity.meta,
                  secure = secure 
                )%}    
    {%if debug %}
        {{ log (sql ,info = true) }} 
    {%else%}
        {%-set log_message -%}
        {} : {{config}} {{entity_fq}}
        {%- endset -%}         
        {{ log (log_message.format('running') ,info = true) }}                                          
        {% set res =  run_query(sql) %} 
        {{ log (log_message.format('finished') ,info = true) }}                                     
    {%endif%}   
    {%endfor%}
{%endif%}
{%- endmacro -%}


