# IPL Cricket Data Analytics — End-to-End Analytics Engineering Project

**Python • Pandas • SQL • JSON • Data Modeling • Analytics Engineering**

An advanced end-to-end IPL analytics project built around ball-by-ball JSON data. The project converts nested match JSON into an analytics-ready relational model and answers business-style questions about team performance, player value, batting, bowling, phases, venues, toss decisions and match outcomes.

> **Data note:** The repository contains code and SQL, not the original IPL JSON files. Add the source JSON files locally under `data/raw/` before running the pipeline.

## Project Objective

Build a reproducible analytics pipeline:

`Raw Cricsheet-style JSON → Python ETL → Validation → Relational Tables → SQL Analytics → KPI Dataset`

The project is designed to demonstrate more than basic Pandas analysis: **data engineering, dimensional modeling, SQL analytics and business interpretation**.

## Dataset Scale

The source dataset used during development contained approximately **1,243 matches and 295,000+ deliveries** across multiple IPL seasons.

## Key Business Questions

### Team Analytics
- Which teams have the strongest win percentage by season?
- How does toss decision relate to match outcome?
- Which teams perform best while chasing versus setting a target?
- Which venues produce the highest average first-innings scores?

### Batting Analytics
- Who are the most valuable run scorers after controlling for strike rate and workload?
- Which batters dominate the powerplay, middle overs and death overs?
- Which players convert starts into high-impact innings?
- Which teams have the strongest batting depth?

### Bowling Analytics
- Which bowlers combine economy, wicket-taking and workload?
- Who performs best in the powerplay and death overs?
- Which bowlers have the strongest dot-ball percentage?
- Which bowling units defend targets most effectively?

### Match & Strategy Analytics
- Does winning the toss provide a meaningful advantage?
- How does chasing performance vary by venue and season?
- What is the relationship between powerplay score, death-over scoring and match outcome?
- Which venues and conditions favour batting-first or chasing teams?

## Repository Structure

```text
ipl-cricket-data-analytics/
├── README.md
├── requirements.txt
├── data/
│   ├── raw/              # Source JSON files (not committed)
│   └── processed/        # Generated CSVs (not committed)
├── sql/
│   ├── 01_schema.sql     # Relational/star-style schema
│   ├── 02_views.sql      # Reusable analytical views
│   └── 03_analysis.sql   # Advanced business questions
├── src/
│   ├── __init__.py
│   ├── config.py
│   ├── extract.py
│   ├── transform.py
│   ├── validate.py
│   └── pipeline.py
└── reports/
    └── KPI_DEFINITIONS.md
```

## Data Model

The pipeline creates a practical analytics model with:

- `dim_match`
- `dim_player`
- `dim_team`
- `dim_venue`
- `fact_delivery`
- `fact_batting`
- `fact_bowling`
- `fact_team_match`

This separates descriptive entities from high-volume event data and makes downstream SQL analysis easier.

## Advanced Analytics Included

- Window functions for player/team rankings
- CTE-based analytical pipelines
- Conditional aggregation
- Rolling/season comparisons
- Powerplay/middle/death phase analysis
- Strike rate and economy calculations
- Dot-ball percentage
- Boundary percentage
- Chase versus defend performance
- Toss decision analysis
- Venue-level scoring patterns
- Player workload normalization
- Composite player impact scoring

## Run the Project

```bash
pip install -r requirements.txt
python -m src.pipeline
```

Then load the generated CSV files into MySQL and execute:

```text
sql/01_schema.sql
sql/02_views.sql
sql/03_analysis.sql
```

## Important Data Engineering Decisions

1. Keep raw JSON immutable.
2. Normalize nested innings/over/delivery structures before analysis.
3. Preserve match, innings and delivery identifiers for traceability.
4. Separate player/team/venue dimensions from delivery facts.
5. Validate row counts, missing identifiers, innings totals and duplicate deliveries before loading SQL.
6. Keep calculated KPIs reproducible in SQL rather than hard-coding results.

## Portfolio Skills Demonstrated

**Python:** JSON parsing, Pandas transformations, reusable ETL functions, validation

**SQL:** joins, CTEs, conditional aggregation, window functions, analytical views

**Data Modeling:** fact/dimension design, grain definition, keys and analytical tables

**Analytics:** KPI design, performance benchmarking, segmentation and business recommendations

## Limitations

This project focuses on structured match and delivery data. It does not claim player salary, injury, pitch-tracking or proprietary performance data that is absent from the source dataset.
