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
        -- Recency: days since their most recent order, vs. the most recent date in the whole dataset
        DATEDIFF(DAY, MAX(co.order_purchase_timestamp), (SELECT MAX(order_purchase_timestamp) FROM orders)) AS recency_days,
        -- Frequency: total number of orders
        COUNT(DISTINCT co.order_id) AS frequency,
        -- Monetary: total amount spent
        SUM(ov.order_total) AS monetary
    FROM customer_orders co
    JOIN order_values ov ON co.order_id = ov.order_id
    GROUP BY co.customer_unique_id
),
rfm_scored AS (
    SELECT
        *,
        -- NTILE splits customers into 5 equal-sized buckets (5 = best)
        NTILE(5) OVER (ORDER BY recency_days ASC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency DESC) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary DESC) AS monetary_score
    FROM rfm_base
)
SELECT
    customer_unique_id,
    recency_days,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,
    (recency_score + frequency_score + monetary_score) AS rfm_total,
    CASE
        WHEN (recency_score + frequency_score + monetary_score) >= 13 THEN 'Champions'
        WHEN (recency_score + frequency_score + monetary_score) >= 10 THEN 'Loyal Customers'
        WHEN (recency_score + frequency_score + monetary_score) >= 7 THEN 'At Risk'
        ELSE 'Lost / Low Value'
    END AS customer_segment
FROM rfm_scored
ORDER BY rfm_total DESC;
