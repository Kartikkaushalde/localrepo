-- Product Analytics SQL Analysis
-- Table: product_users

-- 1. Overall KPIs
SELECT
    COUNT(DISTINCT user_id) AS total_users,
    COUNT(DISTINCT CASE WHEN orders > 0 THEN user_id END) AS purchasers,
    SUM(orders) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN orders > 0 THEN user_id END) / COUNT(DISTINCT user_id), 2) AS conversion_rate_pct,
    ROUND(SUM(revenue) / COUNT(DISTINCT user_id), 2) AS arpu,
    ROUND(SUM(revenue) / NULLIF(COUNT(DISTINCT CASE WHEN orders > 0 THEN user_id END), 0), 2) AS arppu
FROM product_users;

-- 2. Channel performance
SELECT
    acquisition_channel,
    COUNT(DISTINCT user_id) AS users,
    COUNT(DISTINCT CASE WHEN orders > 0 THEN user_id END) AS purchasers,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN orders > 0 THEN user_id END) / COUNT(DISTINCT user_id), 2) AS conversion_rate_pct,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(SUM(revenue) / COUNT(DISTINCT user_id), 2) AS revenue_per_user
FROM product_users
GROUP BY acquisition_channel
ORDER BY revenue_per_user DESC;

-- 3. Plan-level engagement and monetization
SELECT
    plan,
    COUNT(*) AS users,
    ROUND(AVG(sessions), 2) AS avg_sessions,
    ROUND(AVG(active_days), 2) AS avg_active_days,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(100.0 * AVG(retained_30d), 2) AS retention_30d_pct
FROM product_users
GROUP BY plan
ORDER BY revenue DESC;

-- 4. Identify high-value users
SELECT
    user_id,
    acquisition_channel,
    plan,
    sessions,
    active_days,
    orders,
    revenue,
    retained_30d
FROM product_users
WHERE revenue > 100
ORDER BY revenue DESC;

-- 5. Monthly acquisition and revenue trend
SELECT
    DATE_FORMAT(signup_date, '%Y-%m') AS signup_month,
    COUNT(*) AS new_users,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(AVG(retained_30d) * 100, 2) AS retention_30d_pct
FROM product_users
GROUP BY DATE_FORMAT(signup_date, '%Y-%m')
ORDER BY signup_month;

-- 6. Funnel-style summary
SELECT
    COUNT(*) AS signed_up,
    SUM(CASE WHEN sessions > 0 THEN 1 ELSE 0 END) AS activated,
    SUM(CASE WHEN orders > 0 THEN 1 ELSE 0 END) AS purchased,
    SUM(CASE WHEN retained_30d = 1 THEN 1 ELSE 0 END) AS retained_30d
FROM product_users;
