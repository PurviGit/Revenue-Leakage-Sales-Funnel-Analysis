# 💰 Revenue Leakage & Sales Funnel Analysis

> Analyzed **99,441 real e-commerce orders** worth **$20.47M pipeline** using PostgreSQL and Power BI  
> to identify **$114,704 in revenue leakage** and deliver actionable business recommendations.

![Dashboard Preview](docs/screenshots/Page1_Executive_Summary)

---

## 🎯 Business Problem

**"Why are orders not converting to revenue, and where exactly is money leaking in the sales funnel?"**

This project answers that question end-to-end — from raw data ingestion and SQL analysis to an interactive executive dashboard with business recommendations.

---

## 📊 Key Results

| Metric | Value |
|--------|-------|
| Total Orders Analyzed | 99,441 |
| Total Pipeline Value | $20.47M |
| Revenue Collected | $16.11M |
| Revenue Leaked | $114,704 |
| End-to-End Conversion Rate | 97.02% |
| Highest Drop-off Stage | Approval → Shipping (1,542 orders) |
| Highest Leakage State | RO — 2.68% leakage rate |
| Top Revenue State | SP — $5.99M |
| Dataset Period | Sep 2016 – Oct 2018 |

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| PostgreSQL | Data storage, schema design |
| SQL (Advanced) | CTEs, Window Functions, Multi-table JOINs, FILTER aggregations |
| Power BI | 3-page interactive executive dashboard |
| DAX | KPI measures, conditional formatting |
| DBeaver | SQL client and CSV import |

---

## 📁 Project Structure

```
revenue-leakage-analysis/
│
├── data/
│   ├── raw/                          ← Original Kaggle CSVs
│   └── cleaned/                      ← Exported SQL result CSVs
│
├── sql/
│   ├── 01_schema.sql                 ← Table creation
│   ├── 02_data_cleaning.sql          ← NULL handling, type casting
│   ├── 03_funnel_analysis.sql        ← Stage-by-stage conversion rates
│   ├── 04_revenue_leakage.sql        ← Revenue loss quantification
│   ├── 05_regional_analysis.sql      ← State-wise performance
│   └── 06_sla_analysis.sql           ← SLA breach analysis
│   └── 07_monthly_leakage_trend.sql  ← Monthly Leakage analysis
├── powerbi/
│   └── Revenue_Leakage_Analysis.pbix ← 3-page interactive dashboard
│
├── docs/
│   └── screenshots/                  ← Dashboard screenshots
│
└── README.md
```

---

## 🔍 SQL Analysis Highlights

### Funnel Analysis (03_funnel_analysis.sql)
```sql
WITH funnel_stages AS (
    SELECT
        COUNT(*) AS total_orders,
        COUNT(*) FILTER (WHERE order_approved_at IS NOT NULL) AS stage_approved,
        COUNT(*) FILTER (WHERE order_status IN ('shipped','delivered')) AS stage_shipped,
        COUNT(*) FILTER (WHERE order_status = 'delivered') AS stage_delivered,
        COUNT(*) FILTER (WHERE order_status = 'canceled') AS stage_cancelled
    FROM orders
)
SELECT *,
    ROUND(100.0 * stage_delivered / NULLIF(total_orders, 0), 2) AS end_to_end_pct,
    ROUND(100.0 * stage_cancelled / NULLIF(total_orders, 0), 2) AS leakage_rate_pct
FROM funnel_stages;
```
**Result:** 97.02% end-to-end conversion | 1,542 orders dropped at shipping stage

---

### Revenue Leakage (04_revenue_leakage.sql)
```sql
WITH revenue_summary AS (
    SELECT o.order_status,
        COUNT(DISTINCT o.order_id) AS order_count,
        ROUND(SUM(i.price + i.freight_value)::NUMERIC, 2) AS revenue_potential
    FROM orders o
    LEFT JOIN order_items i ON o.order_id = i.order_id
    GROUP BY o.order_status
)
SELECT *,
    CASE WHEN order_status IN ('canceled','unavailable') THEN 'LEAKAGE'
         WHEN order_status = 'delivered' THEN 'COLLECTED'
         ELSE 'IN-PIPELINE' END AS category
FROM revenue_summary;
```
**Result:** $112,564 from cancelled orders + $2,140 from unavailable = **$114,704 total leakage**

---

## 📈 Dashboard Pages

### Page 1 — Executive Summary
- 5 KPI cards: Total Orders, Leakage Rate %, Dropped at Shipping, Dropped at Delivery, Conversion Rate
- Sales Funnel chart showing order journey with drop-off counts
- Revenue donut chart: Collected (97.27%) vs Leaked vs In-Pipeline

### Page 2 — Monthly Leakage Trend
- Line chart: Delivered vs Leaked orders month-over-month (2016–2018)
- Column chart: Monthly revenue leaked ($)
- KPI cards: Total Leaked Orders (1,313), Avg Leakage Rate

### Page 3 — Regional Performance
- Bar chart with conditional color: Green (low leakage) → Red (high leakage) by state
- Interactive table: All 27 states with orders, leakage, revenue, leakage rate
- Slicer for state-level drill-down
- KPI cards: 27 Total States, RO (highest leakage), SP (top revenue $6M)

---

## 💡 Business Recommendations

| Priority | Issue | Recommendation | Expected Impact |
|----------|-------|----------------|-----------------|
| HIGH | 1,542 orders drop at Approval→Shipping | Automated follow-up alerts at 24h post-approval | Recover ~3% dropped orders |
| HIGH | 625 cancelled orders ($112K leaked) | Trigger discount/offer at cancellation attempt | Recover ~2% revenue |
| MEDIUM | RO, RR, SE states have highest leakage | Regional seller review + SLA enforcement | 15% regional improvement |
| MEDIUM | Delivery drop-off 1,421 orders | Real-time delivery tracking + proactive alerts | Reduce failed deliveries |
| LOW | IN-PIPELINE orders sitting idle | SLA timer alerts for logistics team | 10% pipeline clearance |

---

## 🚀 How to Reproduce

1. **Download dataset:** [Brazilian E-Commerce (Olist) — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
2. **Set up PostgreSQL** and create database: `CREATE DATABASE revenue_leakage_db;`
3. **Run SQL files in order:** `01_schema.sql` → `02_data_cleaning.sql` → ... → `06_sla_analysis.sql`
4. **Import CSVs** using DBeaver import wizard (order: customers → sellers → orders → order_items → payments)
5. **Open Power BI:** Load exported CSVs from `data/cleaned/` → open `powerbi/Revenue_Leakage_Analysis.pbix`

---

## 📌 Dataset

**Source:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)  
**Size:** 99,441 orders | 5 linked tables | Sep 2016 – Oct 2018  
**Tables used:** olist_orders, olist_payments, olist_customers, olist_order_items, olist_sellers

---

*Built by Purvi Porwal | Data Analyst | [LinkedIn](https://linkedin.com/in/purvi-porwal-a6554a258)*
