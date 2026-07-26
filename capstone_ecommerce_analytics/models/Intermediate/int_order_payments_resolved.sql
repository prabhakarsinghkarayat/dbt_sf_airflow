with order_payments as (
    select * from {{ ref('stg_orders__order_payments') }}
),
ranked as (
    select *,
        row_number() over (
            partition by order_id 
            order by
                CASE WHEN payment_status = 'SUCCESS' then 1 else 0 end,
                created_at asc
        ) as payment_rank
    from order_payments -- Moved inside the CTE
),
resolved as (
    select 
        order_id, 
        payment_status,
        payment_method,
        payment_gateway,
        amount,
        paid_at,
        is_paid
    from ranked 
    where payment_rank = 1 -- Keep success payment per order
)
select * from resolved