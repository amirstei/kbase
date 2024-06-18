-- the query will run automatically when running dbt build -s fact_stage5

with a as (
select sum(ManMonth) as col  
from {{ ref('fact_stage5') }} 
where edition='Actual'	
)
select *
from a 
where col<0