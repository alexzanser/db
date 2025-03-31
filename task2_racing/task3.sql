WITH AvgClassPositions AS (
    SELECT
        c.class,
        AVG(r.position) AS avg_position
    FROM Results r
    JOIN Cars c ON r.car = c.name
    GROUP BY c.class
),
MinClassPosition AS (
    SELECT MIN(avg_position) AS min_avg_position FROM AvgClassPositions
),
AvgPositions AS (
    SELECT
        r.car,
        c.class,
        cl.country,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS race_count
    FROM Results r
    JOIN Cars c ON r.car = c.name
    JOIN Classes cl ON c.class = cl.class
    GROUP BY r.car, c.class, cl.country
),
ClassRaceCount AS (
    SELECT
        c.class,
        COUNT(DISTINCT r.race) AS total_races
    FROM Results r
    JOIN Cars c ON r.car = c.name
    GROUP BY c.class
)
SELECT
    a.car AS car_name,
    a.class AS car_class,
    a.avg_position AS average_position,
    a.race_count,
    a.country AS car_country,
    cr.total_races
FROM AvgPositions a
JOIN MinClassPosition m ON a.avg_position = m.min_avg_position
JOIN ClassRaceCount cr ON a.class = cr.class
ORDER BY a.car;

