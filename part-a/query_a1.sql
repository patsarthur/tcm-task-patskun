--До

SELECT url, COUNT(DISTINCT user_id) AS uniq_users
FROM pv
WHERE created_at >= '2025-09-15'
  AND created_at <= '2025-09-17'
  AND country = 'UA'
GROUP BY url
ORDER BY uniq_users DESC
LIMIT 5;

-- Після

USE analytics;

SELECT
    p.url,
    COUNT(DISTINCT pv.user_id) AS uniq_users
FROM page_views pv
JOIN pages p ON p.id = pv.page_id
WHERE pv.created_at BETWEEN '2025-09-15 00:00:00' AND '2025-09-17 23:59:59'
  AND pv.country = 'UA'
GROUP BY pv.page_id, p.url
ORDER BY uniq_users DESC
LIMIT 5;

