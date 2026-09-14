with order_totals as (
    select
        order_id,
        sum(net_amount) as order_total,
        sum(quantity) as total_items,
        count(*) as line_count
    from {{ ref('int_order_items_calculated') }}
    group by order_id
)

select
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_status_name,
    o.order_date,
    o.required_date,
    o.shipped_date,
    o.store_id,
    o.staff_id,
    coalesce(ot.order_total, 0) as order_total,
    coalesce(ot.total_items, 0) as total_items,
    coalesce(ot.line_count, 0) as line_count
from {{ ref('stg_orders') }} o
left join order_totals ot
    on o.order_id = ot.order_id
