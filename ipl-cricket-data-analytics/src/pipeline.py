from __future__ import annotations

import json
from pathlib import Path
import pandas as pd

RAW_DIR = Path("data/raw")
OUT_DIR = Path("data/processed")


def parse_match(path: Path) -> tuple[dict, list[dict]]:
    """Parse one match JSON into match metadata and delivery-level rows."""
    with path.open("r", encoding="utf-8") as f:
        doc = json.load(f)

    info = doc["info"]
    match_id = path.stem
    teams = info.get("teams", [])
    dates = info.get("dates", [])
    date = str(dates[0]) if dates else None
    venue = info.get("venue")
    season = str(info.get("season"))

    match_row = {
        "match_id": match_id,
        "season": season,
        "date": date,
        "venue": venue,
        "team_1": teams[0] if len(teams) > 0 else None,
        "team_2": teams[1] if len(teams) > 1 else None,
        "toss_winner": info.get("toss", {}).get("winner"),
        "toss_decision": info.get("toss", {}).get("decision"),
        "winner": info.get("outcome", {}).get("winner"),
    }

    deliveries = []
    for innings_no, innings in enumerate(doc.get("innings", []), start=1):
        team = innings.get("team")
        for over in innings.get("overs", []):
            over_no = over.get("over")
            for ball_no, delivery in enumerate(over.get("deliveries", []), start=1):
                batter = delivery.get("batter")
                bowler = delivery.get("bowler")
                runs = delivery.get("runs", {})
                extras = delivery.get("extras", {})
                deliveries.append({
                    "match_id": match_id,
                    "season": season,
                    "innings": innings_no,
                    "batting_team": team,
                    "over": over_no,
                    "ball": ball_no,
                    "batter": batter,
                    "bowler": bowler,
                    "batter_runs": runs.get("batter", 0),
                    "total_runs": runs.get("total", 0),
                    "extras_runs": runs.get("extras", 0),
                    "wide_runs": extras.get("wides", 0),
                    "noball_runs": extras.get("noballs", 0),
                    "byes_runs": extras.get("byes", 0),
                    "legbyes_runs": extras.get("legbyes", 0),
                    "penalty_runs": extras.get("penalty", 0),
                    "wicket": int(bool(delivery.get("wickets"))),
                })

    return match_row, deliveries


def build_dataset() -> tuple[pd.DataFrame, pd.DataFrame]:
    match_rows: list[dict] = []
    delivery_rows: list[dict] = []

    files = sorted(RAW_DIR.rglob("*.json"))
    if not files:
        raise FileNotFoundError("No JSON files found in data/raw/")

    for path in files:
        match, deliveries = parse_match(path)
        match_rows.append(match)
        delivery_rows.extend(deliveries)

    matches = pd.DataFrame(match_rows)
    deliveries = pd.DataFrame(delivery_rows)

    matches["date"] = pd.to_datetime(matches["date"], errors="coerce")
    numeric = ["innings", "over", "ball", "batter_runs", "total_runs", "extras_runs", "wide_runs", "noball_runs", "byes_runs", "legbyes_runs", "penalty_runs", "wicket"]
    deliveries[numeric] = deliveries[numeric].apply(pd.to_numeric, errors="coerce").fillna(0)

    return matches, deliveries


def validate(matches: pd.DataFrame, deliveries: pd.DataFrame) -> None:
    """Fail fast on core data-quality issues."""
    if matches["match_id"].duplicated().any():
        raise ValueError("Duplicate match_id detected")
    if deliveries[["match_id", "innings", "over", "ball"]].duplicated().any():
        raise ValueError("Duplicate delivery grain detected")
    if deliveries["match_id"].isna().any():
        raise ValueError("Missing match_id in delivery table")


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    matches, deliveries = build_dataset()
    validate(matches, deliveries)
    matches.to_csv(OUT_DIR / "dim_match.csv", index=False)
    deliveries.to_csv(OUT_DIR / "fact_delivery.csv", index=False)
    print(f"Processed {len(matches):,} matches and {len(deliveries):,} deliveries")


if __name__ == "__main__":
    main()
