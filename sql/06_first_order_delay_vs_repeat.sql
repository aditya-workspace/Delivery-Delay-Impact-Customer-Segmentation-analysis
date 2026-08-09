USE project;
GO

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,
        d.delivery_status,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS order_sequence
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN delivery_delay_summary d ON o.order_id = d.order_id
),
first_orders AS (
    SELECT customer_unique_id, delivery_status AS first_order_status
    FROM customer_orders
    WHERE order_sequence = 1
),
total_orders_per_customer AS (
    SELECT customer_unique_id, COUNT(*) AS total_orders
    FROM customer_orders
    GROUP BY customer_unique_id
)
SELECT
    f.first_order_status,
    COUNT(*) AS num_customers,
    SUM(CASE WHEN t.total_orders > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    CAST(SUM(CASE WHEN t.total_orders > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS repeat_purchase_rate_pct
FROM first_orders f
JOIN total_orders_per_customer t ON f.customer_unique_id = t.customer_unique_id
GROUP BY f.first_order_status;
