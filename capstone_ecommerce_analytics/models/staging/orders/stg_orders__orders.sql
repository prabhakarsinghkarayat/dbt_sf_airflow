with source as
(select * from {{source('raw_orders','orders')}}
),
cleaned as (
    select ORDER_ID,
    customer_id,
    upper(order_status) as order_status,
    upper(order_channel) as order_channel,
    upper(PAYMENT_METHOD) as payment_method,
    initcap(delivery_city) as delivery_city,
    initcap(delivery_state) as delivery_state,
    {{ round_currency('discount_amount') }} as discount_amount,
    {{ round_currency('delivery_fee') }} as delivery_fee,
    order_placed_at,
    created_at,
    updated_at
from source
)

select * from cleaned