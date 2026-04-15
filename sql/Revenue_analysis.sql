WITH revenue_summary AS (
    SELECT
        o.order_status,
        COUNT(DISTINCT o.order_id) AS order_count,
        ROUND(SUM(p.payment_value)::NUMERIC, 2) AS revenue_collected,
        ROUND(SUM(i.price + i.freight_value)::NUMERIC, 2) AS revenue_potential
    FROM orders o
    LEFT JOIN payments p ON o.order_id = p.order_id
    LEFT JOIN order_items i ON o.order_id = i.order_id
    GROUP BY o.order_status
),
totals AS (
    SELECT SUM(revenue_potential) AS grand_total FROM revenue_summary
)
SELECT
    rs.order_status,
    rs.order_count,
    rs.revenue_potential,
    rs.revenue_collected,
    CASE 
        WHEN rs.order_status IN ('canceled','unavailable') 
        THEN ROUND(rs.revenue_potential::NUMERIC, 2)
        ELSE 0 
    END AS revenue_leaked,
    ROUND(100.0 * rs.revenue_potential / NULLIF(t.grand_total, 0), 2) AS pct_of_pipeline,
    CASE 
        WHEN rs.order_status IN ('canceled','unavailable') THEN 'LEAKAGE'
        WHEN rs.order_status = 'delivered'                THEN 'COLLECTED'
        ELSE                                                   'IN-PIPELINE'
    END AS category
FROM revenue_summary rs, totals t
ORDER BY rs.revenue_potential DESC;