import pandas as pd
import matplotlib.pyplot as plt

# Load data
df = pd.read_csv('../data/ecommerce_sales.csv', parse_dates=['order_date'])

# Basic validation
print('Rows:', len(df))
print('Missing values:\n', df.isna().sum())

# KPI summary
kpis = {
    'Revenue': df['sales'].sum(),
    'Orders': df['order_id'].nunique(),
    'Units Sold': df['quantity'].sum(),
    'Average Order Value': df['sales'].sum() / df['order_id'].nunique(),
    'Profit': df['profit'].sum(),
    'Profit Margin %': df['profit'].sum() / df['sales'].sum() * 100,
}
print('\nKPI Summary')
for name, value in kpis.items():
    print(f'{name}: {value:,.2f}')

# Category analysis
category = (df.groupby('category', as_index=False)
              .agg(revenue=('sales', 'sum'), profit=('profit', 'sum'))
              .sort_values('revenue', ascending=False))
print('\nCategory performance:\n', category)

# Regional analysis
region = (df.groupby('region', as_index=False)
            .agg(revenue=('sales', 'sum'), profit=('profit', 'sum'), orders=('order_id', 'nunique'))
            .sort_values('revenue', ascending=False))
print('\nRegional performance:\n', region)

# Monthly trend
monthly = (df.assign(month=df['order_date'].dt.to_period('M').astype(str))
             .groupby('month', as_index=False)
             .agg(revenue=('sales', 'sum'), profit=('profit', 'sum')))
print('\nMonthly trend:\n', monthly)

# Top customers
top_customers = (df.groupby('customer_id', as_index=False)
                   .agg(revenue=('sales', 'sum'), profit=('profit', 'sum'))
                   .sort_values('revenue', ascending=False)
                   .head(10))
print('\nTop customers:\n', top_customers)

# Visualization
monthly.plot(x='month', y='revenue', kind='line', marker='o', title='Monthly Revenue Trend')
plt.ylabel('Revenue')
plt.xlabel('Month')
plt.tight_layout()
plt.savefig('monthly_revenue.png', dpi=150)
plt.show()
