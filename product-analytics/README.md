# Product Analytics: User Engagement & Revenue

**Python • Pandas • SQL • Power BI • Product Analytics**

An end-to-end portfolio project analyzing user engagement, conversion, retention, and monetization for a simulated digital product.

> **Data note:** This project uses a synthetic dataset created for portfolio/learning purposes. No real customer data is used.

## Business Problem
A digital product team wants to understand user engagement and monetization and identify opportunities to improve conversion and retention.

## Questions Answered
- How many users are active each month?
- Which acquisition channels generate the most valuable users?
- Where do users drop out of the signup-to-purchase funnel?
- Which cohorts retain best after signup?
- What are ARPU, ARPPU and conversion rate?
- Which customer segments should the product team prioritize?

## Project Structure
```text
product-analytics/
├── README.md
├── data/
│   └── generate_data.py
├── python/
│   └── product_analysis.py
├── sql/
│   └── product_analysis.sql
└── powerbi/
    └── dashboard_spec.md
```

## Workflow
**Synthetic raw data → Python/Pandas cleaning → KPI & funnel analysis → SQL business queries → Power BI dashboard**

## Key KPIs
DAU, MAU, conversion rate, retention, revenue, ARPU, ARPPU, average order value and funnel conversion.

## How to Run
```bash
pip install pandas numpy matplotlib
python data/generate_data.py
python python/product_analysis.py
```

The scripts generate the dataset locally so the project is reproducible without exposing personal or proprietary data.

## Dashboard
The Power BI specification in `powerbi/dashboard_spec.md` defines the recommended executive dashboard: KPI cards, monthly active users, revenue by channel, funnel conversion, retention by cohort and customer segment.

## Business Recommendations Framework
1. Compare channels by conversion and revenue per user, not volume alone.
2. Identify the largest funnel drop-off and prioritize experiments there.
3. Compare cohort retention before increasing acquisition spend.
4. Segment users by engagement and monetization to target high-value opportunities.

## Skills Demonstrated
Python, Pandas, NumPy, SQL, KPI design, product analytics, funnel analysis, cohort analysis, customer segmentation, data storytelling and Power BI planning.