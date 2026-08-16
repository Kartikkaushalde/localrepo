# Power BI Dashboard Specification

## Page 1 — Executive Overview
- KPI cards: Total Users, MAU, Purchasers, Revenue, Conversion Rate, ARPU, ARPPU, 30-Day Retention
- Line chart: Monthly users and revenue
- Bar chart: Revenue by acquisition channel
- Slicers: Month, channel, plan

## Page 2 — Funnel & Retention
- Funnel: Signup → Activated → Purchased → Retained 30D
- Cohort matrix: Signup month × 30-day retention
- Column chart: Retention by plan

## Page 3 — Customer & Channel Analysis
- Scatter: Average sessions vs revenue per user by channel
- Bar chart: Conversion rate by channel
- Table: Channel, users, conversion, revenue, revenue/user, retention
- Highlight top-performing channel and high-value segments

## Recommended DAX Measures
```DAX
Total Users = DISTINCTCOUNT(product_users[user_id])
Purchasers = CALCULATE(DISTINCTCOUNT(product_users[user_id]), product_users[orders] > 0)
Revenue = SUM(product_users[revenue])
Conversion Rate = DIVIDE([Purchasers], [Total Users])
ARPU = DIVIDE([Revenue], [Total Users])
ARPPU = DIVIDE([Revenue], [Purchasers])
Retention 30D = AVERAGE(product_users[retained_30d])
```

## Business Story
The dashboard should answer three executive questions: **Where are users coming from? Where are they dropping off? Which segments create the most value?**