-- Query 3: Hotels Near Restaurants
-- Purpose: Identify restaurants with the highest number of nearby hotels

-- Requirements:
-- - Use roads for restaurant features
-- - Use pois for point features
-- - Filter POIs where fclass = 'hotel'
-- - Use ST_DWithin to find hotels within 0.25 miles (402 meters) of restaurants
-- - Use a CTE to isolate hotel locations
-- - Count the number of UNIQUE hotels near each restaurant (avoid double counting)
-- - Exclude restaurants with no name (optional but recommended)
-- - Filter to include only restaurants with more than 10 nearby hotels
-- - Group by restaurant name ONLY (aggregate geometries using ST_Union)
-- - Order results by hotel count (highest first)
-- - Include geom column for spatial visualization in GeoPandas

-- Expected Output:
-- - restaurant_name
-- - nearby_hotel_count
-- - geom

WITH hotels AS (
    SELECT
        geom
    FROM
        pois
    WHERE
        fclass = 'hotel'
)

SELECT
    rds.name AS restaurant_name,
    COUNT(DISTINCT r.geom) AS nearby_hotel_count,
    ST_Union(rds.geom) AS geom
FROM
    roads AS rds
JOIN
    hotels AS r ON ST_DWithin(r.geom::geography, rds.geom::geography, 402)
WHERE
    rds.name IS NOT NULL
    AND rds.fclass = 'cycleway'
GROUP BY
    rds.name
HAVING
    COUNT(DISTINCT r.geom) > 10
ORDER BY
    nearby_hotel_count DESC;