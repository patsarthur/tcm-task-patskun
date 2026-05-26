-- Для великих батчів (10 000+ рядків) можна тимчасово вимкнути перевірки:
-- SET foreign_key_checks = 0;
-- SET unique_checks = 0;

-- СПОСІБ 1: Один INSERT з багатьма рядками
-- У 50x швидше ніж 1000 окремих INSERT
-- ─────────────────────────────────────────
 
START TRANSACTION;
 
INSERT INTO page_views (user_id, page_id, country, device, created_at, duration_ms)
VALUES
    (122, 1, 'FR', 'desktop', '2025-10-09 17:41:14', 1715),
    (188, 1, 'FR', 'mobile', '2025-10-11 03:06:06', 1992),
    (134, 3, 'DE', 'desktop', '2025-09-30 08:43:24', 1134),
    (95, 3, 'FR', 'mobile', '2025-09-19 00:31:38', 589),
    (147, 3, 'GB', 'desktop', '2025-10-06 07:49:34', 704),
    (187, 3, 'GB', 'desktop', '2025-10-13 09:07:27', 570),
    (66, 3, 'FR', 'tablet', '2025-10-09 10:39:44', 1189),
    (174, 2, 'UA', 'desktop', '2025-09-17 16:45:16', 1862),
    (20, 2, 'PL', 'desktop', '2025-10-06 06:38:43', 1258),
    (179, 3, 'UA', 'desktop', '2025-09-20 19:43:51', 726);
    --Наступні 490 рядків

-- Другий батч (наступні 500 рядків)
INSERT INTO page_views (user_id, page_id, country, device, created_at, duration_ms)
VALUES
    (192, 2, 'GB', 'mobile', '2025-09-27 16:55:51', 701),
    (177, 1, 'GB', 'mobile', '2025-09-23 23:53:55', 156),
    (97, 1, 'PL', 'mobile', '2025-10-09 19:02:26', 999),
    (46, 2, 'FR', 'tablet', '2025-10-03 19:44:21', 591),
    (139, 3, 'GB', 'tablet', '2025-09-24 02:38:50', 1342),
    (121, 1, 'DE', 'desktop', '2025-09-19 22:21:36', 1647),
    (28, 1, 'DE', 'mobile', '2025-09-16 04:18:12', 368),
    (62, 2, 'UA', 'mobile', '2025-09-24 09:37:49', 133),
    (36, 3, 'UA', 'desktop', '2025-10-13 05:45:11', 512),
    (110, 2, 'DE', 'mobile', '2025-09-26 12:22:06', 933),
    (31, 2, 'DE', 'desktop', '2025-09-27 11:58:30', 991);
    --Наступні 490 рядків
    
COMMIT;
-- SET foreign_key_checks = 1;
-- SET unique_checks = 1;

-- СПОСІБ 2: LOAD DATA INFILE (з CSV файлу)
-- Найшвидший варіант для мільйонів рядків

LOAD DATA INFILE 'D:/OSPanel/userdata/temp/upload/page_views.csv'
INTO TABLE page_views
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(user_id, page_id, country, device, created_at, duration_ms);