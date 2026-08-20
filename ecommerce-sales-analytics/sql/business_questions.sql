-- E-Commerce Sales & Customer Analytics

-- 1. Overall KPIs
SELECT
    SUM(sales) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity) AS units_sold,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS avg_order_value,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct
FROM ecommerce_sales;

-- 2. Revenue and profit by category
SELECT
    category,
    SUM(sales) AS revenue,
    SUM(profit) AS profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margin_pct
FROM ecommerce_sales
GROUP BY category
ORDER BY revenue DESC;

-- 3. Regional performance
SELECT
    region,
    COUNT(DISTINCT order_id) AS orders,
    SUM(sales) AS revenue,
    SUM(profit) AS profit
FROM ecommerce_sales
GROUP BY region
ORDER BY revenue DESC;

-- 4. Customer value
SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS orders,
    SUM(sales) AS revenue,
    SUM(profit) AS profit
FROM ecommerce_sales
GROUP BY customer_id
ORDER BY revenue DESC;

-- 5. Monthly sales trend
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(sales) AS revenue,
    SUM(profit) AS profit
FROM ecommerce_sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- 6. Discount vs profitability
SELECT
    discount,
    COUNT(*) AS orders,
    SUM(sales) AS revenue,
    SUM(profit) AS profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margin_pct
FROM ecommerce_sales
GROUP BY discount
ORDER BY discount;

-- 7. Top products by revenue
SELECT
    product,
    SUM(quantity) AS units_sold,
    SUM(sales) AS revenue,
    SUM(profit) AS profit
FROM ecommerce_sales
GROUP BY product
ORDER BY revenue DESC
LIMIT 10;
