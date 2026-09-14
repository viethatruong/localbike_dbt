select
    p.product_id,
    p.product_name,
    p.brand_id,
    b.brand_name,
    p.category_id,
    c.category_name,
    p.model_year,
    p.list_price
from {{ ref('stg_products') }} p
left join {{ ref('stg_brands') }} b
    on p.brand_id = b.brand_id
left join {{ ref('stg_categories') }} c
    on p.category_id = c.category_id
