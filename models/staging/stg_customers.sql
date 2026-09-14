select
    safe_cast(customer_id as int64) as customer_id,
    trim(first_name) as first_name,
    trim(last_name) as last_name,
    nullif(trim(phone), '') as phone,
    lower(trim(email)) as email,
    trim(street) as street,
    trim(city) as city,
    trim(state) as state,
    safe_cast(zip_code as int64) as zip_code
from {{ source('local_bike', 'customers') }}

