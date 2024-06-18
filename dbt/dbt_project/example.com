

models:
  +transient: false                         // cancel the create or replace transient table
  +materialized: table                      // definition
  +on_schema_change: append_new_columns     // only in increment model- when column was added dbt will add the column
  # +persist_docs:                          // add the description to snowflake column
  #   relation: true
  #   columns: true  
  jaffle_shop:
    staging:
      +materialized: view