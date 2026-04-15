-- ============================================
-- PROJECT: Revenue Leakage & Sales Funnel Analysis
-- Author: Purvi Porwal
-- Date: April 2026
-- Description: Database schema creation
-- ============================================

CREATE DATABASE revenue_leakage_db;

CREATE TABLE orders (
    order_id            VARCHAR(50) PRIMARY KEY,
    customer_id         VARCHAR(50) NOT NULL,
    order_status        VARCHAR(30) NOT NULL,
    purchase_timestamp  TIMESTAMP,
    approved_at         TIMESTAMP,
    delivered_carrier   TIMESTAMP,
    delivered_customer  TIMESTAMP,
    estimated_delivery  TIMESTAMP
);

CREATE TABLE payments (
    order_id             VARCHAR(50),
    payment_sequential   INT,
    payment_type         VARCHAR(30),
    payment_installments INT,
    payment_value        DECIMAL(10,2)
);

CREATE TABLE customers (
    customer_id        VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    zip_code           VARCHAR(10),
    city               VARCHAR(100),
    state              VARCHAR(5)
);

CREATE TABLE order_items (
    order_id            VARCHAR(50),
    order_item_id       INT,
    product_id          VARCHAR(50),
    seller_id           VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price               DECIMAL(10,2),
    freight_value       DECIMAL(10,2)
);

CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    zip_code  VARCHAR(10),
    city      VARCHAR(100),
    state     VARCHAR(5)
);

SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public';

SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM payments;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM sellers;
