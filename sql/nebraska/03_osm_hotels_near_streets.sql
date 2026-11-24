-- Query 3: Hotels Near Streets
-- Purpose: Identify streets with the highest number of nearby hotels

-- Requirements:
-- - Use roads for street features
-- - Use pois for point features
-- - Filter POIs where fclass = 'hotel'
-- - Use ST_DWithin to find hotels within 1 mile (1609 meters) of streets
-- - Use a CTE to isolate hotel locations
-- - Count the number of UNIQUE hotels near each street (avoid double counting)
-- - Exclude streets with no name (optional but recommended)
-- - Filter to include only streets with more than 10 nearby hotels
-- - Group by street name ONLY (aggregate geometries using ST_Union)
-- - Order results by hotel count (highest first)
-- - Include geom column for spatial visualization in GeoPandas

-- Expected Output:
-- - street_name
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
    rds.name AS street_name,
    COUNT(DISTINCT r.geom) AS nearby_hotel_count,
    ST_Union(rds.geom) AS geom
FROM
    roads AS rds
JOIN
    hotels AS r ON ST_DWithin(r.geom::geography, rds.geom::geography, 1609)
WHERE
    rds.name IS NOT NULL
GROUP BY
    rds.name
HAVING
    COUNT(DISTINCT r.geom) > 10
ORDER BY
    nearby_hotel_count DESC;
