select
    safe_cast(staff_id as int64) as staff_id,
    trim(first_name) as first_name,
    trim(last_name) as last_name,
    lower(trim(email)) as email,
    nullif(trim(phone), '') as phone,
    safe_cast(active as int64) as active,
    safe_cast(store_id as int64) as store_id,
    safe_cast(manager_id as int64) as manager_id
from {{ source('local_bike', 'staffs') }}