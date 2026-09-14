select
    cast(order_id as int64) as order_id,
    cast(customer_id as int64) as customer_id,
    cast(order_status as int64) as order_status,
    case cast(order_status as int64)
        when 1 then 'Pending'
        when 2 then 'Processing'
        when 3 then 'Rejected'
        when 4 then 'Completed'
        else 'Unknown'
    end as order_status_name,
    cast(order_date as date) as order_date,
    cast(required_date as date) as required_date,
    cast(shipped_date as date) as shipped_date,
    cast(store_id as int64) as store_id,
    cast(staff_id as int64) as staff_id
from {{ source('local_bike', 'orders') }}
