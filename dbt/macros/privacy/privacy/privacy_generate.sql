{% macro privacy_generate (
        entity_config,     
        entity,
        materialized,
        materialized_db_entity,           
        privacy_db,
        privacy_schema,
        privacy_entity,
        privacy_key,
        operation_type,
        columns_privacy,
        debug = false                   
    ) %}

    {% if execute %}
        {# extract meta from database #} 
        {% set sql %}
            SHOW {{privacy_entity | upper |replace('_', ' ') }}
                IN {{privacy_db}}.{{privacy_schema}} ;        
        {% endset %}  

        {% set res_db=  get_res_as_dict(sql) %}
        
        {%if privacy_entity == 'row_access_policies'%}
            {% set rap_columns = columns_privacy |sort(attribute='privacy_value') 
                            | map(attribute='column') | list %}                      
            {%set columns_privacy = [columns_privacy[0]]%}                
            {% do columns_privacy[0].update({'column':rap_columns | join(',')}) %}  
        {%endif%}    
        


        {%for  column in columns_privacy%}       
            {% set sql = privacy_query(
                    privacy_entity = privacy_entity,  
                    materialized_db_entity = materialized_db_entity | upper,
                    operation_type = operation_type,
                    entity = entity,
                    column_name = column.column,
                    privacy_db = privacy_db,
                    privacy_schema = privacy_schema,
                    privacy_name = column.privacy_name | upper,
                    privacy_value = column.privacy_value,
                    debug = debug
            ) %} 
            {% set privacy_entity_fqn = privacy_db ~ "." ~ 
                    privacy_schema~ "." ~  column.privacy_name | upper  %}    

            {%set is_in_db = [] %}

            {%for db_entity in res_db
                if db_entity.database_name  ~ "." ~ db_entity.schema_name ~
                 "." ~  db_entity.name ==  privacy_entity_fqn                               
                %}             
                {% do is_in_db.append(db_entity) %}                                      
            {%endfor%}       

            {%if is_in_db%}
                {%if debug %}
                    {{ log (sql ,info = true) }} 
                {%else%}
                    
                    {% set re_apply = true%}
                    {%if privacy_entity == 'row_access_policies'%}
                        {% set check_if_rap_exists %} 
                        SELECT *
                        FROM TABLE(information_schema.policy_references(
                                    ref_entity_name => '{{entity}}', 
                                    ref_entity_domain => '{{materialized_db_entity}}'))
                        {% endset %}
                        {% set res = run_query(check_if_rap_exists).columns[0].values()[0]%}
                        {% set re_apply = false if res else true%}                                           
                    {%endif%}    
                 

                    {%-set log_message -%}
                    {} : {{operation_type}} {{privacy_entity}} -
                    {{privacy_entity_fqn}} for {{entity}}.{{column.column}} {{column.privacy_value}}
                        {%- endset -%}  
                    {%if re_apply%}           
                        {{ log (log_message.format('running') ,info = true) }}                                          
                        {% set res =  run_query(sql)  %} 
                        {{ log (log_message.format('finished') ,info = true) }} 
                    {%else%}
                        {{ log (log_message.format('already applied') ,info = true) }} 
                    {%endif%}
                                                
                {%endif%}            
            {%else%}

                {%-set log_message -%}
                warning : {{privacy_entity}} - {{privacy_entity_fqn}}
                was not found within the database
                {%- endset -%}         
                {{ exceptions.warn(log_message) }}  

            {%endif%}
        {%endfor%}        
    {% endif %}
{% endmacro %}  