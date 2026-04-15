SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp::TIMESTAMP) AS month,
    COUNT(*) FILTER (
        WHERE o.order_status IN ('canceled','unavailable')
    ) AS leaked_orders,
    COUNT(*) FILTER (
        WHERE o.order_status = 'delivered'
    ) AS successful_orders,
    ROUND(
        SUM(p.payment_value) FILTER (
            WHERE o.order_status IN ('canceled','unavailable')
        )::NUMERIC, 2
    ) AS monthly_revenue_leaked,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE o.order_status IN ('canceled','unavailable')
        ) / NULLIF(COUNT(*), 0), 2
    ) AS monthly_leakage_rate_pct
FROM orders o
LEFT JOIN payments p ON o.order_id = p.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp::TIMESTAMP)
ORDER BY month;

