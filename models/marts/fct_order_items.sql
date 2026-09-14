select
    order_item_id,
    order_id,
    product_id,
    product_name,
    quantity,
    list_price,
    discount,
    gross_amount,
    discount_amount,
    net_amount
from {{ ref('int_order_items_calculated') }}
