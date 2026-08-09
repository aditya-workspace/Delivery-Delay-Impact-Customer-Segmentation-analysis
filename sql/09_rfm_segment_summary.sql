USE project;
GO

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),
order_values AS (
    SELECT
        order_id,
        SUM(price + freight_value) AS order_total
    FROM order_items
    GROUP BY order_id
),
rfm_base AS (
    SELECT
        co.customer_unique_id,
        DATEDIFF(DAY, MAX(co.order_purchase_timestamp), (SELECT MAX(order_purchase_timestamp) FROM orders)) AS recency_days,
        COUNT(DISTINCT co.order_id) AS frequency,
        SUM(ov.order_total) AS monetary
    FROM customer_orders co
    JOIN order_values ov ON co.order_id = ov.order_id
    GROUP BY co.customer_unique_id
),
rfm_scored AS (
    SELECT
        *,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS monetary_score
    FROM rfm_base
),
rfm_final AS (
    SELECT
        *,
        (recency_score + frequency_score + monetary_score) AS rfm_total,
        CASE
            WHEN (recency_score + frequency_score + monetary_score) >= 13 THEN 'Champions'
            WHEN (recency_score + frequency_score + monetary_score) >= 10 THEN 'Loyal Customers'
            WHEN (recency_score + frequency_score + monetary_score) >= 7 THEN 'At Risk'
            ELSE 'Lost / Low Value'
        END AS customer_segment
    FROM rfm_scored
)
-- Summary: segment breakdown
SELECT
    customer_segment,
    COUNT(*) AS num_customers,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS pct_of_customers,
    CAST(AVG(monetary) AS DECIMAL(10,2)) AS avg_lifetime_spend,
    CAST(SUM(monetary) AS DECIMAL(12,2)) AS total_segment_revenue
FROM rfm_final
GROUP BY customer_segment
ORDER BY total_segment_revenue DESC;
