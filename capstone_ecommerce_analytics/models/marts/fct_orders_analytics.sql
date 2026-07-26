with orders as (
    select * from {{ ref('stg_orders__orders') }}
),
customers as (
    select * from {{ ref('stg_catalog__customers') }}
),
item_aggregates as (
    Select * from {{ ref('int_order_items_aggregated') }}
),
payments as (
    select * from {{ ref('int_order_payments_resolved') }}
),
final as (
    select 
        orders.order_id,
        orders.customer_id,
        customers.first_name || customers.last_name as customer_name,
        customers.customer_segment,
        orders.delivery_city,
        orders.delivery_state,
        orders.order_status, 
        orders.order_channel,
        orders.order_placed_at,
        {{ get_week_start_date('orders.order_placed_at')}} as order_week,
        item_aggregates.item_count,
        item_aggregates.gross_item_revenue,
        {{round_currency('item_aggregates.gross_item_revenue - orders.discount_amount + orders.delivery_fee' )}} as net_revenue,
        payments.payment_status,
        payments.is_paid,
        payments.amount as payment_amount
    from orders
    left join customers on orders.customer_id = customers.customer_id
    left join item_aggregates on orders.order_id = item_aggregates.order_id
    left join payments on orders.order_id = payments.order_id
)
select * from final