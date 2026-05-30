-- ============================================================
-- PROJECT   : Indian Railway Operations Analysis
-- AUTHOR    : Your Name | Final Year | Aspiring Data Analyst
-- TOOL      : Microsoft SQL Server
-- DATASET   : rail_data.csv (1000 records, 19 columns)
-- PURPOSE   : Analyze delay patterns, passenger trends and
--             zone performance across Indian Railways
-- ============================================================


-- ============================================================
-- SECTION A : BASIC ANALYSIS (Q1 - Q5)
-- Concepts  : SELECT, WHERE, GROUP BY, ORDER BY, TOP, UNION ALL
-- ============================================================


-- Q1. How many trains were severely delayed in Monsoon season?
-- Business Purpose: Measure monsoon impact on operations
-- ------------------------------------------------------------
SELECT COUNT(train_name) AS severely_delayed
FROM rail_data
WHERE season = 'Monsoon'
AND delay_mins > 120;


-- Q2. Which zone has the highest number of journeys recorded?
-- Business Purpose: Identify busiest railway zone
-- ------------------------------------------------------------
SELECT TOP 1
    zone,
    COUNT(zone) AS total_journeys
FROM rail_data
GROUP BY zone
ORDER BY COUNT(zone) DESC;


-- Q3. Average delay in minutes for each train type. Highest first.
-- Business Purpose: Compare performance across train categories
-- ------------------------------------------------------------
SELECT
    train_type,
    AVG(delay_mins) AS avg_delay
FROM rail_data
GROUP BY train_type
ORDER BY AVG(delay_mins) DESC;


-- Q4. Total passengers travelled in each zone. Highest first.
-- Business Purpose: Understand passenger load per zone
-- ------------------------------------------------------------
SELECT
    zone,
    SUM(passengers_count) AS total_passengers
FROM rail_data
GROUP BY zone
ORDER BY SUM(passengers_count) DESC;


-- Q5. Longest and shortest route — train name, distance, zone.
-- Business Purpose: Understand route coverage extremes
-- ------------------------------------------------------------
SELECT * FROM (
    SELECT TOP 1
        train_name, distance_km, zone,
        'Longest Route' AS route_type
    FROM rail_data
    ORDER BY distance_km DESC
) AS t1
UNION ALL
SELECT * FROM (
    SELECT TOP 1
        train_name, distance_km, zone,
        'Shortest Route' AS route_type
    FROM rail_data
    ORDER BY distance_km ASC
) AS t2;


-- ============================================================
-- SECTION B : INTERMEDIATE ANALYSIS (Q6 - Q13)
-- Concepts  : HAVING, Subquery, RANK, DENSE_RANK, CASE WHEN
-- ============================================================


-- Q6. Zones where average delay exceeds overall average delay.
-- Business Purpose: Flag underperforming zones
-- ------------------------------------------------------------
SELECT
    zone,
    AVG(delay_mins) AS avg_delay
FROM rail_data
GROUP BY zone
HAVING AVG(delay_mins) > (SELECT AVG(delay_mins) FROM rail_data);


-- Q7. Most common delay reason for each season.
-- Business Purpose: Identify seasonal delay causes
-- ------------------------------------------------------------
SELECT season, delay_reason, total_occurrences
FROM (
    SELECT
        season,
        delay_reason,
        COUNT(delay_reason) AS total_occurrences,
        RANK() OVER (PARTITION BY season ORDER BY COUNT(delay_reason) DESC) AS rnk
    FROM rail_data
    GROUP BY season, delay_reason
) AS t
WHERE rnk = 1;


-- Q8. Total journeys and average delay for each year. Highest delay first.
-- Business Purpose: Track year-on-year performance trend
-- ------------------------------------------------------------
SELECT
    year,
    COUNT(journey_id)  AS total_journeys,
    AVG(delay_mins)    AS avg_delay
FROM rail_data
GROUP BY year
ORDER BY AVG(delay_mins) DESC;


-- Q9. Top 3 trains with highest passenger count in each zone.
-- Business Purpose: Identify high demand trains per zone
-- ------------------------------------------------------------
SELECT zone, train_name, passengers_count, zone_rank
FROM (
    SELECT
        zone,
        train_name,
        passengers_count,
        DENSE_RANK() OVER (PARTITION BY zone ORDER BY passengers_count DESC) AS zone_rank
    FROM rail_data
) AS t
WHERE zone_rank <= 3;


-- Q10. Zone with highest severe delays in each year.
-- Business Purpose: Monitor which zones need urgent attention yearly
-- ------------------------------------------------------------
WITH severe_counts AS (
    SELECT
        year,
        zone,
        COUNT(*) AS severe_delay_count
    FROM rail_data
    WHERE delay_category = 'Severe Delay'
    GROUP BY year, zone
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY year ORDER BY severe_delay_count DESC) AS rnk
    FROM severe_counts
)
SELECT year, zone, severe_delay_count
FROM ranked
WHERE rnk = 1
ORDER BY year;


-- Q11. Trains with more than 20 journeys AND average delay above 60 mins.
-- Business Purpose: Find consistently poor performing trains
-- ------------------------------------------------------------
SELECT
    train_name,
    COUNT(*)         AS total_journeys,
    AVG(delay_mins)  AS avg_delay
FROM rail_data
GROUP BY train_name
HAVING COUNT(*) > 20
AND AVG(delay_mins) > 60;


-- Q12. Most delayed route — source, destination, avg delay, total journeys.
-- Business Purpose: Find worst performing route for intervention
-- ------------------------------------------------------------
SELECT TOP 1
    source_station,
    destination_station,
    AVG(delay_mins)  AS avg_delay,
    COUNT(*)         AS total_journeys
FROM rail_data
GROUP BY source_station, destination_station
ORDER BY AVG(delay_mins) DESC;


-- Q13. Percentage of on-time vs delayed trains for each train type.
-- Business Purpose: Calculate punctuality KPI by train category
-- ------------------------------------------------------------
SELECT
    train_type,
    ROUND(100.0 * SUM(CASE WHEN delay_mins = 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS on_time_pct,
    ROUND(100.0 * SUM(CASE WHEN delay_mins > 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS delayed_pct
FROM rail_data
GROUP BY train_type;


-- ============================================================
-- SECTION C : ADVANCED ANALYSIS (Q14 - Q20)
-- Concepts  : Window Functions, CTE, LAG, RANK, DENSE_RANK
-- ============================================================


-- Q14. Rank all zones by punctuality — best zone gets rank 1.
-- Business Purpose: Zone performance leaderboard
-- ------------------------------------------------------------
SELECT
    zone,
    AVG(delay_mins)                              AS avg_delay,
    RANK() OVER (ORDER BY AVG(delay_mins))       AS punctuality_rank
FROM rail_data
GROUP BY zone;


-- Q15. Trains delayed more than their own zone average.
-- Business Purpose: Identify outlier trains within each zone
-- ------------------------------------------------------------
WITH zone_avg AS (
    SELECT
        zone,
        AVG(delay_mins) AS zone_avg_delay
    FROM rail_data
    GROUP BY zone
)
SELECT
    r.train_name,
    r.zone,
    AVG(r.delay_mins)    AS train_avg_delay,
    z.zone_avg_delay
FROM rail_data AS r
JOIN zone_avg AS z ON r.zone = z.zone
GROUP BY r.train_name, r.zone, z.zone_avg_delay
HAVING AVG(r.delay_mins) > z.zone_avg_delay
ORDER BY r.zone, train_avg_delay DESC;


-- Q16. Top 3 most delayed trains per zone using DENSE_RANK.
-- Business Purpose: Zone-wise worst performer list
-- ------------------------------------------------------------
WITH train_zone_delay AS (
    SELECT
        zone,
        train_name,
        AVG(delay_mins) AS avg_delay,
        DENSE_RANK() OVER (PARTITION BY zone ORDER BY AVG(delay_mins) DESC) AS zone_rank
    FROM rail_data
    GROUP BY zone, train_name
)
SELECT zone, train_name, avg_delay, zone_rank
FROM train_zone_delay
WHERE zone_rank <= 3
ORDER BY zone, zone_rank;


-- Q17. Worst performing zone each season using CTE.
-- Business Purpose: Seasonal zone performance tracking
-- ------------------------------------------------------------
WITH seasonal_performance AS (
    SELECT
        season,
        zone,
        AVG(delay_mins) AS avg_delay
    FROM rail_data
    GROUP BY season, zone
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY season ORDER BY avg_delay DESC) AS rnk
    FROM seasonal_performance
)
SELECT season, zone, avg_delay
FROM ranked
WHERE rnk = 1
ORDER BY avg_delay DESC;


-- Q18. Month-wise delay trend with comparison to previous month using LAG.
-- Business Purpose: Track delay improvement or deterioration monthly
-- ------------------------------------------------------------
WITH monthly_avg AS (
    SELECT
        month,
        AVG(delay_mins) AS avg_delay
    FROM rail_data
    GROUP BY month
)
SELECT
    month,
    avg_delay,
    LAG(avg_delay) OVER (ORDER BY avg_delay DESC)                         AS prev_month_delay,
    ROUND(avg_delay - LAG(avg_delay) OVER (ORDER BY avg_delay DESC), 2)  AS delay_change
FROM monthly_avg
ORDER BY avg_delay DESC;


-- Q19. Does longer distance mean more delay? Distance category analysis.
-- Business Purpose: Understand distance impact on punctuality
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN distance_km < 200                THEN 'Short  (< 200 km)'
        WHEN distance_km BETWEEN 200 AND 500  THEN 'Medium (200-500 km)'
        ELSE                                       'Long   (> 500 km)'
    END                     AS distance_category,
    COUNT(*)                AS total_trains,
    AVG(delay_mins)         AS avg_delay
FROM rail_data
GROUP BY
    CASE
        WHEN distance_km < 200                THEN 'Short  (< 200 km)'
        WHEN distance_km BETWEEN 200 AND 500  THEN 'Medium (200-500 km)'
        ELSE                                       'Long   (> 500 km)'
    END
ORDER BY avg_delay DESC;


-- Q20. Zone Scorecard — all KPIs in one query.
-- Business Purpose: Executive summary dashboard for all zones
-- ------------------------------------------------------------
WITH zone_kpis AS (
    SELECT
        zone,
        COUNT(*)                          AS total_journeys,
        AVG(delay_mins)                   AS avg_delay,
        MAX(delay_mins)                   AS max_delay,
        MIN(delay_mins)                   AS min_delay,
        SUM(passengers_count)             AS total_passengers,
        ROUND(100.0 * SUM(CASE WHEN delay_mins = 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS on_time_pct
    FROM rail_data
    GROUP BY zone
)
SELECT *,
    RANK() OVER (ORDER BY avg_delay) AS punctuality_rank
FROM zone_kpis
ORDER BY punctuality_rank;

-- ============================================================
-- END OF ANALYSIS
-- Key Findings:
-- 1. Monsoon season has highest severe delays
-- 2. Northern zone has worst punctuality
-- 3. Long distance trains delay more
-- 4. Mail trains have lowest on-time percentage
-- ============================================================
