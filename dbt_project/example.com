

models:
  jaffle_shop:
    staging:
      +materialized: view