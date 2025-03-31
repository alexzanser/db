WITH ClassResults AS (
    SELECT
        c.class AS class,
        AVG(r.position) AS avg_pos,
        COUNT(DISTINCT c.name) AS car_count
    FROM Results r
    JOIN Cars c ON r.car = c.name
    GROUP BY c.class
    HAVING COUNT(DISTINCT c.name) >= 2
),

CarResults AS (
    SELECT
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count,
        cl.country AS car_country
    FROM Results r
    JOIN Cars c ON r.car = c.name
    JOIN Classes cl ON cl.class = c.class
    WHERE c.class IN (SELECT class FROM ClassResults)
    GROUP BY c.name, c.class, cl.country
)

SELECT
    cr.car_name,
    cr.car_class,
    cr.average_position,
    cr.race_count,
    cr.car_country
FROM CarResults cr
JOIN ClassResults cls ON cls.class = cr.car_class
WHERE cr.average_position < cls.avg_pos
ORDER BY cr.car_class, cr.average_position;

