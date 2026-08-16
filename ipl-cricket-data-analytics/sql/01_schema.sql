CREATE DATABASE IF NOT EXISTS ipl_analytics;
USE ipl_analytics;

DROP TABLE IF EXISTS fact_delivery;
DROP TABLE IF EXISTS dim_match;

CREATE TABLE dim_match (
    match_id VARCHAR(100) PRIMARY KEY,
    season VARCHAR(20),
    match_date DATE,
    venue VARCHAR(255),
    team_1 VARCHAR(100),
    team_2 VARCHAR(100),
    toss_winner VARCHAR(100),
    toss_decision VARCHAR(30),
    winner VARCHAR(100)
);

CREATE TABLE fact_delivery (
    match_id VARCHAR(100) NOT NULL,
    season VARCHAR(20),
    innings INT NOT NULL,
    batting_team VARCHAR(100),
    over_no INT,
    ball_no INT,
    batter VARCHAR(150),
    bowler VARCHAR(150),
    batter_runs INT,
    total_runs INT,
    extras_runs INT,
    wide_runs INT,
    noball_runs INT,
    byes_runs INT,
    legbyes_runs INT,
    penalty_runs INT,
    wicket TINYINT,
    PRIMARY KEY (match_id, innings, over_no, ball_no),
    FOREIGN KEY (match_id) REFERENCES dim_match(match_id)
);
