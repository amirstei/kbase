{% macro privacy_main (
        node_type,
        resource_type,
        privacy_entity,               
        privacy_key, 
        operation_type,   
        entity=model.name,
        only_meta_data=false,     
        debug=false
    ) %}

    {% if execute %}
        {# fetch base table meta data from graph #}
        {% set res = get_entity_meta_data(
            node_type=node_type,
            resource_type=resource_type,
            entity=entity,
            debug=debug
        ) %}      

        {# map configurations #}
        {% set materialization_map = {"table": "table", "view": "view", 
                                     "incremental": "table", 
                                     "snapshot": "table"} %}
        {% do materialization_map.update
                        ((var('custom_materializations_map', {}))) %}
        {% set materialized = res.config.materialized %}
        {% set materialized_db_entity = materialization_map.get(materialized) %}

        {% if materialized_db_entity %}
            {# set privacy vars if exist #}         
            {% set privacy_db = var(privacy_entity ~'_database', false)
                            or res.database %}    
            {% set privacy_schema = var(privacy_entity ~'_schema', false) 
                            or res.schema %}    

            {% set entity_fq = res.database ~ "." ~ 
                    res.schema ~ "." ~ res.name %}                                   
            {# extract meta from yml #}         
            {% set columns_privacy = [] %}
            {% for key,value in res.columns.items() %}
                {% set row ={} %}
                {% do row.update(
                { 'column' :key,
                'privacy_name' :value.meta.get(privacy_key).get ('name'),
                'privacy_value' :value.meta.get(privacy_key).get ('value')
                }
                ) if value.meta.get(privacy_key)%}                                               
                {% do columns_privacy.append(row) if row%}
            {%endfor%}

            {%if columns_privacy %}
                {%if not only_meta_data %}    
                    {% set res_base = privacy_generate(
                        entity_config=res,
                        entity=entity_fq,
                        materialized=materialized, 
                        materialized_db_entity=materialized_db_entity,                     
                        privacy_db=privacy_db |upper,
                        privacy_schema=privacy_schema |upper, 
                        privacy_entity=privacy_entity,
                        privacy_key=privacy_key,
                        operation_type=operation_type,                
                        columns_privacy=columns_privacy,
                        debug=debug
                    ) %}          
                {%else%}             
                    {{ return((columns_privacy)) }}
                {%endif%}   
            {%else%} 
                {%-set log_message -%}
                    No configuration for {{ privacy_entity}} named {{privacy_key}}
                    within yml file for : {{ entity_fq }}
                {%- endset -%}         
                {{ exceptions.warn(log_message) }}  
            {% endif %}
        {%else%}

            {%-set log_message -%}
               No db_entity mapping for materializion type {{materialized}}
            {%- endset -%}         
            {{ exceptions.warn(log_message) }}  
        {% endif %}    
    {% endif %}

{% endmacro %}