with source as (
    select * from {{ source('raw_catalog', 'products') }}
),

cleaned as (
    select
        product_id,
        product_name,
        upper(category) as category,
        upper(sub_category) as sub_category,
        initcap(brand) as brand,
        {{ round_currency('unit_price') }} as unit_price,
        is_active,
        created_at,
        updated_at
    from source
)

select * from cleaned