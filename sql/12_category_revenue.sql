USE project;
GO

SELECT
    ISNULL(t.product_category_name_english, p.product_category_name) AS category,
    COUNT(DISTINCT oi.order_id) AS num_orders,
    SUM(oi.price + oi.freight_value) AS total_revenue,
    CAST(AVG(oi.price) AS DECIMAL(10,2)) AS avg_item_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_translation t ON p.product_category_name = t.product_category_name
GROUP BY ISNULL(t.product_category_name_english, p.product_category_name)
ORDER BY total_revenue DESC;
