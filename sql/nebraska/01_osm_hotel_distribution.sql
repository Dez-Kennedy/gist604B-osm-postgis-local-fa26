-- Query 1: Hotel Locations
-- Purpose: Extract hotel locations for spatial distribution analysis

-- Requirements:
-- - Use pois for point features
-- - Filter POIs where fclass = 'hotel'
-- - Return raw point geometries
-- - (Optional) Clip to a specific region if needed

-- Expected Output:
-- - geom

SELECT
    geom
FROM
    pois
WHERE
    fclass = 'hotel';