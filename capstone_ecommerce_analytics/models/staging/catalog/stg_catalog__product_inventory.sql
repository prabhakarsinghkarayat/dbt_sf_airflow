with source as (
    select * from {{ source('raw_catalog', 'product_inventory') }}
),

cleaned as (
    select
        inventory_id,
        product_id,
        warehouse_id,
        initcap(warehouse_city) as warehouse_city,
        quantity_on_hand,
        last_restocked_at,
        created_at
    from source
)

select * from cleaned