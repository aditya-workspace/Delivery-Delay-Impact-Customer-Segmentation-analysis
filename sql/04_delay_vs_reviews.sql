USE project;
GO

-- Problem: what % of orders are late, and does it hurt reviews?
SELECT
    delivery_status,
    COUNT(*) AS num_orders,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS pct_of_orders,
    AVG(CAST(review_score AS FLOAT)) AS avg_review_score
FROM delivery_delay_summary
GROUP BY delivery_status;
