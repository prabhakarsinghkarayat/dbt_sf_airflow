with source as
(select * from {{source('raw_orders','order_items')}}
),
cleaned as (
    select order_item_id,
     order_id,
     product_id,
     quantity,
    {{ round_currency('unit_price') }} as unit_price,
    {{ round_currency('item_discount') }} as item_discount,
    created_at
from source
)

select * from cleaned