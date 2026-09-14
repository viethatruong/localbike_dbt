select
    customer_id,
    first_name,
    last_name,
    concat(first_name, ' ', last_name) as customer_name,
    phone,
    email,
    street,
    city,
    state,
    zip_code
from {{ ref('stg_customers') }}
