select
    cast(store_id as int64) as store_id,
    cast(product_id as int64) as product_id,
    cast(quantity as int64) as quantity,
    concat(cast(store_id as string), '-', cast(product_id as string)) as stock_key
from {{ source('local_bike', 'stocks') }}
