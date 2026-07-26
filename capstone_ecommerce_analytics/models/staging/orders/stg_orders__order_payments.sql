with source as (
    select * from {{ source('raw_orders', 'order_payments') }}
),

cleaned as (
    select
        payment_id,
        order_id,
        upper(payment_status) as payment_status,
        upper(payment_method) as payment_method,
        upper(payment_gateway) as payment_gateway,
        {{ round_currency('amount') }} as amount,
        paid_at,
        paid_at is not null as is_paid,
        created_at
    from source
)

select * from cleaned