select
    safe_cast(store_id as int64) as store_id,
    safe_cast(product_id as int64) as product_id,
    safe_cast(quantity as int64) as quantity,
    concat(safe_cast(store_id as string), '-', safe_cast(product_id as string)) as stock_key
from {{ source('local_bike', 'stocks') }}
