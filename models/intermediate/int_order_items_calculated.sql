select
    oi.order_item_id,
    oi.order_id,
    oi.item_id,
    oi.product_id,
    p.product_name,
    oi.quantity,
    oi.list_price,
    oi.discount,
    round(oi.quantity * oi.list_price, 2) as gross_amount,
    round(oi.quantity * oi.list_price * oi.discount, 2) as discount_amount,
    round(oi.quantity * oi.list_price * (1 - oi.discount), 2) as net_amount
from {{ ref('stg_order_items') }} oi
left join {{ ref('stg_products') }} p
    on oi.product_id = p.product_id
