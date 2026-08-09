USE project;
GO

SELECT
    AVG(order_total) AS avg_order_value
FROM (
    SELECT order_id, SUM(price + freight_value) AS order_total
    FROM order_items
    GROUP BY order_id
) t;
