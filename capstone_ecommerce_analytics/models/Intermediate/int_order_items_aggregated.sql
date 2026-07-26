with order_items as (
    select * from {{ ref('stg_orders__order_item') }}
),
aggregated as (
    select 
        order_id,
        count(order_item_id) as item_count,
        {{ round_currency('sum((quantity * unit_price) - item_discount)') }} as gross_item_revenue
    from order_items
    group by 1
)
select * from aggregated