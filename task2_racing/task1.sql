WITH AvgPositions AS (
    SELECT 
        r.car, 
        c.class, 
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS race_count
    FROM Results r
    JOIN Cars c ON r.car = c.name
    GROUP BY r.car, c.class
),
MinClassPositions AS (
    SELECT 
        class, 
        MIN(avg_position) AS min_avg_position
    FROM AvgPositions
    GROUP BY class
)
SELECT 
    a.car as car_name,
    a.class as car_class,
    a.avg_position as average_position,
    a.race_count
FROM AvgPositions a
JOIN MinClassPositions m ON a.class = m.class AND a.avg_position = m.min_avg_position
ORDER BY a.avg_position, a.car;
