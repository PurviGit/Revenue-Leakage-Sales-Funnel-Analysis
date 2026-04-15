WITH funnel_stages AS (
    SELECT
        COUNT(*) AS total_orders,
        COUNT(*) FILTER (WHERE order_approved_at IS NOT NULL) AS stage_approved,
        COUNT(*) FILTER (WHERE order_status IN ('shipped','delivered','invoiced')) AS stage_shipped,
        COUNT(*) FILTER (WHERE order_status = 'delivered') AS stage_delivered,
        COUNT(*) FILTER (WHERE order_status = 'cancelled') AS stage_cancelled,
        COUNT(*) FILTER (WHERE order_status = 'unavailable') AS stage_unavailable
    FROM orders
)
SELECT
    total_orders,
    stage_approved,
    stage_shipped,
    stage_delivered,
    stage_cancelled,
    stage_unavailable,

    ROUND(100.0 * stage_approved  / NULLIF(total_orders,   0), 2) AS approval_rate_pct,
    ROUND(100.0 * stage_delivered / NULLIF(stage_approved, 0), 2) AS delivery_rate_pct,
    ROUND(100.0 * stage_delivered / NULLIF(total_orders,   0), 2) AS end_to_end_pct,
    ROUND(100.0 * (stage_cancelled + stage_unavailable) / NULLIF(total_orders, 0), 2) AS leakage_rate_pct,

    (total_orders   - stage_approved)  AS dropped_at_approval,
    (stage_approved - stage_shipped)   AS dropped_at_shipping,
    (stage_shipped  - stage_delivered) AS dropped_at_delivery

FROM funnel_stages;