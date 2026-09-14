select
    order_id,
    customer_id,
    store_id,
    staff_id,
    order_status,
    order_status_name,
    order_date,
    required_date,
    shipped_date,
    order_total,
    total_items,
    line_count,
    date_diff(shipped_date, order_date, day) as shipping_days,
    date_diff(required_date, order_date, day) as promised_days
from {{ ref('int_orders_enriched') }}
