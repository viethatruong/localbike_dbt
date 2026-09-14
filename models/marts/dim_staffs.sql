select
    s.staff_id,
    s.first_name,
    s.last_name,
    concat(s.first_name, ' ', s.last_name) as staff_name,
    s.email,
    s.phone,
    s.active,
    s.store_id,
    concat(m.first_name, ' ', m.last_name) as manager_name
from {{ ref('stg_staffs') }} s
left join {{ ref('stg_staffs') }} m
    on s.manager_id = m.staff_id
