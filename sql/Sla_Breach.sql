SELECT
    CASE
        WHEN order_delivered_customer_date > order_estimated_delivery_date 
            THEN 'SLA Breached'
        WHEN order_delivered_customer_date IS NULL 
            THEN 'Not Delivered'
        ELSE 
            'On Time'
    END AS sla_status,
    COUNT(*) AS order_count,
    ROUND(AVG(EXTRACT(DAY FROM 
        order_delivered_customer_date - order_estimated_delivery_date
    ))::NUMERIC, 1) AS avg_days_late,
    ROUND(100.0 * COUNT(*) / NULLIF(SUM(COUNT(*)) OVER(), 0), 2) AS percentage
FROM orders
WHERE order_status IN ('delivered', 'shipped')
GROUP BY sla_status
ORDER BY order_count DESC;

UPDATE orders SET order_approved_at = NULL 
WHERE order_approved_at = '';

UPDATE orders SET order_delivered_carrier_date = NULL 
WHERE order_delivered_carrier_date = '';

UPDATE orders SET order_delivered_customer_date = NULL 
WHERE order_delivered_customer_date = '';

UPDATE orders SET order_estimated_delivery_date = NULL 
WHERE order_estimated_delivery_date = '';

UPDATE orders SET order_purchase_timestamp = NULL 
WHERE order_purchase_timestamp = '';

-- Fix all timestamp columns to proper TIMESTAMP type
ALTER TABLE orders
    ALTER COLUMN order_purchase_timestamp 
        TYPE TIMESTAMP USING order_purchase_timestamp::TIMESTAMP,
    ALTER COLUMN order_approved_at 
        TYPE TIMESTAMP USING order_approved_at::TIMESTAMP,
    ALTER COLUMN order_delivered_carrier_date 
        TYPE TIMESTAMP USING order_delivered_carrier_date::TIMESTAMP,
    ALTER COLUMN order_delivered_customer_date 
        TYPE TIMESTAMP USING order_delivered_customer_date::TIMESTAMP,
    ALTER COLUMN order_estimated_delivery_date 
        TYPE TIMESTAMP USING order_estimated_delivery_date::TIMESTAMP;