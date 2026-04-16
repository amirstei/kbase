select coredb.SessionVarSet('{"date": "2024-07-30"}')
;
SELECT * from loandb.loans_overview_kpis_view_2 lokv 
;