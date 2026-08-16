import numpy as np
import pandas as pd

rng = np.random.default_rng(42)
n_users = 2000
channels = ["Organic", "Paid Search", "Social", "Referral", "Email"]
channel_p = [0.34, 0.24, 0.18, 0.14, 0.10]
plans = ["Free", "Basic", "Pro"]
rows = []
start = pd.Timestamp("2025-01-01")

for i in range(1, n_users + 1):
    signup = start + pd.Timedelta(days=int(rng.integers(0, 180)))
    channel = rng.choice(channels, p=channel_p)
    plan = rng.choice(plans, p=[0.62, 0.25, 0.13])
    sessions = int(max(1, rng.poisson(9)))
    active_days = int(min(sessions, max(1, rng.poisson(5))))
    purchased = rng.random() < ({"Free": 0.11, "Basic": 0.28, "Pro": 0.46}[plan])
    orders = int(rng.integers(1, 5)) if purchased else 0
    price = {"Free": 0, "Basic": 29, "Pro": 59}[plan]
    revenue = round(orders * price * rng.uniform(0.85, 1.15), 2)
    retained_30 = int(rng.random() < (0.38 if purchased else 0.18))
    rows.append([i, signup.date(), channel, plan, sessions, active_days, orders, revenue, retained_30])

cols = ["user_id", "signup_date", "acquisition_channel", "plan", "sessions", "active_days", "orders", "revenue", "retained_30d"]
df = pd.DataFrame(rows, columns=cols)
df.to_csv("product_users.csv", index=False)
print(f"Created {len(df):,} users in product_users.csv")
print(df.head())
