-- 08_recommendations.sql
-- Quantifies recovery potential per recommendation

WITH leakage_base AS (
    SELECT
        ROUND(SUM(i.price + i.freight_value)::NUMERIC, 2) AS total_leaked
    FROM orders o
    LEFT JOIN order_items i ON o.order_id = i.order_id
    WHERE o.order_status IN ('canceled', 'unavailable')
)
SELECT
    total_leaked,
    ROUND(total_leaked * 0.03, 2) AS recovery_shipping_alerts,
    ROUND(total_leaked * 0.02, 2) AS recovery_cancellation_offers,
    ROUND(total_leaked * 0.05, 2) AS recovery_combined_estimate
FROM leakage_base;