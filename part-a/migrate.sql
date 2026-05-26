USE analytics;

INSERT IGNORE INTO pages (url)
SELECT DISTINCT url FROM analytics_legacy.pv;

INSERT INTO page_views (user_id, page_id, country, device, created_at, duration_ms)
SELECT
    pv.user_id,
    p.id,
    pv.country,
    pv.device,
    STR_TO_DATE(pv.created_at, '%Y-%m-%d %H:%i:%s'),
    pv.duration_ms
FROM analytics_legacy.pv pv
JOIN pages p ON p.url = pv.url
WHERE pv.user_id IS NOT NULL;