{% macro privacy_query(
    privacy_entity,
    materialized_db_entity,
    operation_type,
    entity,
    column_name,
    privacy_db,
    privacy_schema,
    privacy_name,
    privacy_value,
    debug=false
  ) %}
    
    {%if privacy_entity == 'tags'%}

        {%-set set_syntax = ';'-%}  
        {%if operation_type =='set'%}
            {%-set set_syntax-%}  
            = "{{privacy_value}}";
            {%-endset-%}   
        {%endif%}      

        {% set sql %} 
        ALTER {{materialized_db_entity}} {{entity}}
        MODIFY COLUMN  {{column_name}} {{operation_type | upper}} 
        TAG {{privacy_db}}.{{privacy_schema}}.{{privacy_name}} {{set_syntax}}
        {% endset %} 

    {%elif  privacy_entity == 'masking_policies'%}   

        {%-set set_syntax = ';'-%}  
        {%if operation_type =='set'%}
            {%-set set_syntax-%}  
            {{privacy_db}}.{{privacy_schema}}.{{privacy_name}};
            {%-endset-%}   
        {%endif%}      

        {% set sql %} 
        ALTER {{materialized_db_entity}} {{entity}}
        MODIFY COLUMN  {{column_name}} {{operation_type | upper}} 
        MASKING POLICY {{set_syntax}}
        {% endset %}         
        
    {%elif  privacy_entity == 'row_access_policies'%}      

        {%-set operation_type = 'ADD' 
            if  operation_type =='set' else 'DROP' -%}  
        {%-set set_syntax = ';'-%}  
        {%if operation_type =='ADD'%}
            {%-set set_syntax-%}  
        on ({{column_name}});
            {%-endset-%}   
        {%endif%}      

        {% set sql %} 
        ALTER {{materialized_db_entity}} {{entity}}
        {{operation_type}} ROW ACCESS POLICY 
        {{privacy_db}}.{{privacy_schema}}.{{privacy_name}} {{set_syntax}}
        {% endset %}        

    {%endif%}           


 {{ return(sql) }} 
 {% endmacro %}   