SELECT
    c.customer_state AS state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.order_id) FILTER (
        WHERE o.order_status = 'delivered'
    ) AS delivered_orders,
    COUNT(DISTINCT o.order_id) FILTER (
        WHERE o.order_status IN ('canceled','unavailable')
    ) AS leaked_orders,
    ROUND(SUM(p.payment_value)::NUMERIC, 2) AS total_revenue,
    ROUND(100.0 * COUNT(*) FILTER (
        WHERE o.order_status IN ('canceled','unavailable')
    ) / NULLIF(COUNT(*), 0), 2) AS leakage_rate_pct,
    ROUND(AVG(p.payment_value)::NUMERIC, 2) AS avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN payments p ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY leakage_rate_pct DESC;