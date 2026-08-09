USE project;
GO

-- Step 1: figure out how many total orders each real person (customer_unique_id) placed
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        d.delivery_status
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN delivery_delay_summary d ON o.order_id = d.order_id
),
customer_purchase_counts AS (
    SELECT
        customer_unique_id,
        COUNT(DISTINCT order_id) AS total_orders,
        -- did this customer experience at least one late delivery?
        MAX(CASE WHEN delivery_status = 'Late' THEN 1 ELSE 0 END) AS had_late_delivery
    FROM customer_orders
    GROUP BY customer_unique_id
)
-- Step 2: compare repeat-purchase rate between the two groups
SELECT
    CASE WHEN had_late_delivery = 1 THEN 'Experienced Late Delivery' ELSE 'Always On Time' END AS customer_group,
    COUNT(*) AS num_customers,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    CAST(SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS repeat_purchase_rate_pct
FROM customer_purchase_counts
GROUP BY had_late_delivery;
