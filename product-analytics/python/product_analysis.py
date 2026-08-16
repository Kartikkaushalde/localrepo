import pandas as pd
import matplotlib.pyplot as plt

# Run data/generate_data.py first, then place product_users.csv in this folder.
df = pd.read_csv("product_users.csv", parse_dates=["signup_date"])

# Core KPIs
users = df["user_id"].nunique()
purchasers = df.loc[df["orders"] > 0, "user_id"].nunique()
revenue = df["revenue"].sum()
orders = df["orders"].sum()
conversion = purchasers / users
arpu = revenue / users
arppu = revenue / purchasers if purchasers else 0

dprint = {
    "users": users,
    "purchasers": purchasers,
    "orders": int(orders),
    "revenue": round(revenue, 2),
    "conversion_rate": round(conversion * 100, 2),
    "ARPU": round(arpu, 2),
    "ARPPU": round(arppu, 2),
    "30_day_retention": round(df["retained_30d"].mean() * 100, 2),
}
print("CORE KPIs")
for k, v in dprint.items():
    print(f"{k}: {v}")

# Channel performance
channel = df.groupby("acquisition_channel").agg(
    users=("user_id", "nunique"),
    purchasers=("orders", lambda s: (s > 0).sum()),
    revenue=("revenue", "sum"),
    retention=("retained_30d", "mean"),
).reset_index()
channel["conversion_rate"] = channel["purchasers"] / channel["users"]
channel["revenue_per_user"] = channel["revenue"] / channel["users"]
print("\nCHANNEL PERFORMANCE")
print(channel.sort_values("revenue_per_user", ascending=False).round(3).to_string(index=False))

# Plan segmentation
plan = df.groupby("plan").agg(users=("user_id", "nunique"), revenue=("revenue", "sum"), avg_sessions=("sessions", "mean"), retention=("retained_30d", "mean")).reset_index()
print("\nPLAN SEGMENTATION")
print(plan.round(3).to_string(index=False))

# Monthly cohort overview
monthly = df.assign(month=df["signup_date"].dt.to_period("M")).groupby("month").agg(users=("user_id", "nunique"), revenue=("revenue", "sum")).reset_index()
print("\nMONTHLY OVERVIEW")
print(monthly.tail(10).round(2).to_string(index=False))

# Simple revenue chart
ax = channel.sort_values("revenue", ascending=False).plot.bar(x="acquisition_channel", y="revenue", legend=False, title="Revenue by Acquisition Channel")
ax.set_ylabel("Revenue")
plt.tight_layout()
plt.savefig("revenue_by_channel.png", dpi=160)
plt.close()
