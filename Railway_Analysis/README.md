# Indian Railway Operations Analysis

## Overview
Indian Railways is one of the largest railway networks in the world,
carrying millions of passengers daily. Delays affect passenger experience
and operational efficiency. This project analyzes 1000+ journey records
to uncover delay patterns across zones, seasons and train types.

---

## Business Problem
Which zones, seasons and routes have the worst delay patterns —
and what can Railway operations do to improve punctuality?

---

## Dataset
| Detail | Info |
|--------|------|
| Records | 1000 journeys |
| Columns | 19 |
| Period | 2022 – 2024 |
| Source | Synthetic dataset based on real Indian railway patterns |

**Key columns:**
- `zone` — Railway zone (Northern, Southern, Eastern, etc.)
- `delay_mins` — Delay in minutes
- `delay_category` — On Time / Minor / Major / Severe Delay
- `delay_reason` — Fog, Signal failure, Landslide, etc.
- `season` — Monsoon / Summer / Winter
- `passengers_count` — Number of passengers per journey
- `train_type` — Superfast / Express / Mail

---

## Tools Used
| Tool | Purpose |
|------|---------|
| Microsoft SQL Server | Data extraction and analysis |
| Power BI Desktop | Dashboard and visualization |

---

## Project Structure
```
RAIL/
├── rail_data.csv               ← Dataset (1000 records, 19 columns)
├── railway_analysis.sql        ← 20 SQL queries (Basic to Advanced)
├── rail_dashboard.pbix         ← Power BI dashboard
└── README.md                   ← Project documentation
```

---

## SQL Analysis — 20 Business Questions

### Section A — Basic (Q1 to Q5)
| # | Question |
|---|----------|
| Q1 | How many trains were severely delayed in Monsoon? |
| Q2 | Which zone has highest number of journeys? |
| Q3 | Average delay by train type |
| Q4 | Total passengers per zone |
| Q5 | Longest and shortest routes |

### Section B — Intermediate (Q6 to Q13)
| # | Question |
|---|----------|
| Q6 | Zones above overall average delay |
| Q7 | Most common delay reason per season |
| Q8 | Year-wise journey and delay trends |
| Q9 | Top 3 trains by passengers per zone |
| Q10 | Zone with most severe delays per year |
| Q11 | Trains with high journeys and high delays |
| Q12 | Most delayed route |
| Q13 | On-time vs delayed % by train type |

### Section C — Advanced (Q14 to Q20)
| # | Question |
|---|----------|
| Q14 | Zone punctuality ranking |
| Q15 | Trains delayed more than zone average |
| Q16 | Top 3 delayed trains per zone |
| Q17 | Worst zone per season |
| Q18 | Month-wise delay trend using LAG |
| Q19 | Distance vs delay analysis |
| Q20 | Complete zone scorecard — all KPIs |

---

## SQL Concepts Used
- SELECT, WHERE, GROUP BY, ORDER BY, TOP
- HAVING with subqueries
- CASE WHEN
- UNION ALL
- Window Functions — RANK, DENSE_RANK, LAG
- Common Table Expressions (CTE)
- JOIN

---

## Power BI Dashboard
**KPI Cards:**
- 710K Total Passengers
- 54.05 Average Delay (mins)
- 1K Total Journeys

**Charts:**
- Zone-wise Delay Analysis (Bar Chart)
- Delay by Season (Column Chart)
- Monthly Delay Trend (Line Chart)
- Delay Category Breakdown (Pie Chart)
- Train Type Analysis (Donut Chart)
- Interactive Season Slicer

---

## Key Findings
1. **Northern zone** has the worst punctuality across all seasons
2. **Monsoon** causes 3x more delays compared to Winter
3. **Long distance routes** (500km+) show significantly higher delays
4. **Mail trains** have the highest average delay among all train types
5. **Signal failure and fog** are the most common delay reasons
6. **35% of trains** experience major or severe delays (60+ minutes)

---

## Business Recommendations
1. Increase buffer time in monsoon scheduling (June to September)
2. Prioritize infrastructure upgrades in Northern zone
3. Convert Mail trains to Express for better punctuality
4. Implement real-time delay monitoring for long distance routes
5. Deploy fog detection systems at Northern zone stations

---

## Resume Line
*"Analyzed 1000+ Indian railway journeys using SQL Server and Power BI
to identify delay patterns across 7 zones — built interactive dashboard
showing zone-wise punctuality, seasonal trends and delay KPIs"*

---
## Dashboard Preview

![Overview](Screenshots/over%20view.png)

![Chart 1](Screenshots/chat%201.png)

![Chart 2](Screenshots/chart%202.png)

---

## Author
BHARATHI R | Final Year (AI & DS) Student | Aspiring Data Analyst
Skills: SQL Server · Power BI · Data Analysis
