USE ipl_analytics;

-- 1. Team batting performance by season
SELECT season, batting_team,
       SUM(total_runs) AS runs,
       COUNT(*) AS legal_and_illegal_deliveries,
       ROUND(SUM(total_runs) * 100.0 / NULLIF(COUNT(*),0), 2) AS runs_per_100_deliveries
FROM fact_delivery
GROUP BY season, batting_team
ORDER BY season, runs DESC;

-- 2. Batter leaderboard with workload and strike rate
WITH batter AS (
    SELECT batter,
           SUM(batter_runs) AS runs,
           COUNT(*) AS balls,
           SUM(CASE WHEN batter_runs = 4 THEN 1 ELSE 0 END) AS boundary_balls,
           SUM(CASE WHEN batter_runs = 6 THEN 1 ELSE 0 END) AS six_balls
    FROM fact_delivery
    GROUP BY batter
)
SELECT batter, runs, balls,
       ROUND(runs * 100.0 / NULLIF(balls,0), 2) AS strike_rate,
       boundary_balls,
       six_balls
FROM batter
WHERE balls >= 300
ORDER BY runs DESC;

-- 3. Bowler economy and wicket impact
WITH bowling AS (
    SELECT bowler,
           COUNT(*) AS deliveries,
           SUM(total_runs) - SUM(byes_runs) - SUM(legbyes_runs) AS conceded_runs,
           SUM(wicket) AS wickets
    FROM fact_delivery
    GROUP BY bowler
)
SELECT bowler, deliveries, wickets,
       ROUND(conceded_runs * 6.0 / NULLIF(deliveries,0), 2) AS economy,
       ROUND(wickets * 100.0 / NULLIF(deliveries,0), 2) AS wickets_per_100_balls
FROM bowling
WHERE deliveries >= 300
ORDER BY wickets DESC, economy ASC;

-- 4. Powerplay vs death-over scoring
SELECT batting_team,
       CASE
           WHEN over_no BETWEEN 0 AND 5 THEN 'Powerplay'
           WHEN over_no BETWEEN 6 AND 14 THEN 'Middle'
           ELSE 'Death'
       END AS phase,
       SUM(total_runs) AS runs,
       COUNT(*) AS deliveries,
       ROUND(SUM(total_runs) * 6.0 / NULLIF(COUNT(*),0), 2) AS run_rate
FROM fact_delivery
GROUP BY batting_team, phase
ORDER BY batting_team, run_rate DESC;

-- 5. Toss decision and match outcome
SELECT toss_decision,
       COUNT(*) AS matches,
       SUM(CASE WHEN winner = toss_winner THEN 1 ELSE 0 END) AS toss_winner_wins,
       ROUND(100.0 * SUM(CASE WHEN winner = toss_winner THEN 1 ELSE 0 END) / COUNT(*), 2) AS win_rate
FROM dim_match
WHERE winner IS NOT NULL
GROUP BY toss_decision;

-- 6. Venue scoring profile
SELECT venue,
       COUNT(DISTINCT match_id) AS matches,
       ROUND(SUM(total_runs) * 1.0 / COUNT(DISTINCT match_id), 2) AS average_runs_per_match
FROM fact_delivery
GROUP BY venue
HAVING COUNT(DISTINCT match_id) >= 10
ORDER BY average_runs_per_match DESC;

-- 7. Player impact score: combines volume, strike rate and boundaries
WITH stats AS (
    SELECT batter,
           SUM(batter_runs) AS runs,
           COUNT(*) AS balls,
           SUM(CASE WHEN batter_runs IN (4,6) THEN 1 ELSE 0 END) AS boundary_balls
    FROM fact_delivery
    GROUP BY batter
), scored AS (
    SELECT *,
           runs * 0.60 +
           (runs * 100.0 / NULLIF(balls,0)) * 0.25 +
           boundary_balls * 2.0 AS impact_score
    FROM stats
    WHERE balls >= 300
)
SELECT batter, runs, balls,
       ROUND(runs * 100.0 / NULLIF(balls,0),2) AS strike_rate,
       boundary_balls,
       ROUND(impact_score,2) AS impact_score,
       RANK() OVER (ORDER BY impact_score DESC) AS impact_rank
FROM scored
ORDER BY impact_rank;
