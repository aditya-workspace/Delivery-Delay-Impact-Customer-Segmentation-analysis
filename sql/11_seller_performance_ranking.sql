USE project;
GO

WITH seller_orders AS (
    SELECT
        oi.seller_id,
        o.order_id,
        DATEDIFF(DAY, o.order_purchase_timestamp, o.order_delivered_customer_date) AS delivery_days,
        r.review_score
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    LEFT JOIN order_reviews r ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
        AND o.order_delivered_customer_date IS NOT NULL
),
seller_stats AS (
    SELECT
        seller_id,
        COUNT(DISTINCT order_id) AS total_orders,
        AVG(CAST(delivery_days AS FLOAT)) AS avg_delivery_days,
        AVG(CAST(review_score AS FLOAT)) AS avg_review_score
    FROM seller_orders
    GROUP BY seller_id
    HAVING COUNT(DISTINCT order_id) >= 10  -- only sellers with meaningful order volume
)
SELECT
    seller_id,
    total_orders,
    CAST(avg_delivery_days AS DECIMAL(6,1)) AS avg_delivery_days,
    CAST(avg_review_score AS DECIMAL(3,2)) AS avg_review_score,
    RANK() OVER (ORDER BY avg_review_score DESC, avg_delivery_days ASC) AS seller_rank
FROM seller_stats
ORDER BY seller_rank;
