-- NULL check across all key columns
SELECT 
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS null_status,
    SUM(CASE WHEN purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS null_purchase,
    SUM(CASE WHEN approved_at IS NULL THEN 1 ELSE 0 END) AS null_approval,
    SUM(CASE WHEN delivered_customer IS NULL THEN 1 ELSE 0 END) AS null_delivery
FROM orders;

-- Check all order status values that exist
SELECT order_status, COUNT(*) as count
FROM orders
GROUP BY order_status
ORDER BY count DESC;

-- Payment value sanity check
SELECT 
    MIN(payment_value), MAX(payment_value),
    AVG(payment_value),
    COUNT(*) FILTER (WHERE payment_value <= 0) AS bad_values
FROM payments;