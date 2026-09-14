select *
from {{ ref('fct_orders') }}
where shipped_date is not null
  and shipped_date < order_date
