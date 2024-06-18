        
 {% macro set_tag() %}

        {% set res  = get_res_as_dict(query='select * from stg.amir_privacy.privacy_management' ) %}

        {% for i in res %}
            {{ log((i), info = true)}}
            {% set table_name=i['OBJECT_NAME'] %}
            {% set column_name=i['COLUMN_NAME'] %}           
            {% set table_db=i['DATA_BASE_NAME'] %}            
            {% set table_schema=i['SCHEMA_NAME'] %}            
            {% set tag_name=i['TAG_NAME'] %}            
            {% set tag_value=i['TAG_VALUE'] %}
        

            {% set sql %} 
            ALTER table {{table_db}}.{{table_schema}}.{{table_name}}
            MODIFY COLUMN  "{{column_name}}" set
            TAG dwh.finance.{{tag_name}} = '{{tag_value}}'
            {% endset %}  
            
            {{ log((sql), info = true)}}
            
            {% set results=run_query(sql) %}

        {% endfor %}
 {% endmacro %}       