WITH AvgPositions AS (
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
MinPosition AS (
    SELECT MIN(avg_position) AS min_avg_position FROM AvgPositions
)
SELECT
    a.car AS car_name,
    a.class AS car_class,
    a.avg_position AS average_position,
    a.race_count,
    a.country AS car_country
FROM AvgPositions a
JOIN MinPosition m ON a.avg_position = m.min_avg_position
ORDER BY a.car
LIMIT 1;

