USE project;
GO

WITH monthly_revenue AS (
    SELECT
        FORMAT(o.order_purchase_timestamp, 'yyyy-MM') AS order_month,
        SUM(oi.price + oi.freight_value) AS total_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY FORMAT(o.order_purchase_timestamp, 'yyyy-MM')
)
SELECT
    order_month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY order_month) AS prev_month_revenue,
    CAST(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY order_month)) * 100.0
        / NULLIF(LAG(total_revenue) OVER (ORDER BY order_month), 0)
    AS DECIMAL(12,2)) AS pct_change_mom
FROM monthly_revenue
ORDER BY order_month;
