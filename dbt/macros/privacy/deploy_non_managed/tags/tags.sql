{% macro tags (      
	entity_fq,
	header,
	debug = false) %}

{% set namespace = namespace(alter_statement ='') %}
{% set operation_type = kwargs.get('operation_type') or 'set'%}
{% set meta = kwargs.get('meta') or {} %}
{% set ref_entities = kwargs.get('ref_entities') or false%}
{% set force = kwargs.get('force') or false%}


{%- set create_statement -%}
{{ header }} {{entity_fq}} ;
{%endset-%}


{% if 'entities' in meta.keys()
  and ref_entities %}
    {% set config =  context[meta.entities.macro| string] () %} 
    {% for entity in config.entities     
	if entity.name in meta.entities.ref_entities
    %} 
	{% set ref_entity_db = entity.get('database',false)
			or target.database %}    
	{% set ref_entity_schema =  entity.get('schema', false)
			or generate_schema_name () %}    
	{% set ref_entity_fq = ref_entity_db ~ "." ~ 
		ref_entity_schema ~ "." ~ entity.name %}  
	{% set force = 'FORCE' if force and  
		operation_type | lower == 'set' else '' %}       

	{%- set alter_statement -%}	
	ALTER  TAG {{entity_fq}} {{operation_type}} {{meta.entities.name}} {{ref_entity_fq}} {{force}};
	{%endset-%}	
  
	{%- set namespace.alter_statement %} 
	{{- namespace.alter_statement -}} 
	{{- alter_statement -}}
	{%endset-%}
    {%endfor%}d
{%endif%}

{% set sql %}
{{- create_statement -}}
{{- namespace.alter_statement  if namespace.alter_statement -}}
{%endset%}
 {{ log(fromyaml(sql), info = true) 
		if debug == 1 }}
	{{return (sql)}} 
{%- endmacro -%}


