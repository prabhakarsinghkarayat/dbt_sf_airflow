with source as (
    select * from {{ source('raw_catalog', 'customers') }}
),

cleaned as (
    select
        customer_id,
        first_name,
        last_name,
        email,
        signup_date,
        initcap(city) as city,
        initcap(state) as state,
        upper(customer_segment) as customer_segment,
        is_active,
        created_at,
        updated_at
    from source
)

select * from cleaned