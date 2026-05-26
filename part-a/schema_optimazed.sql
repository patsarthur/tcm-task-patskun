CREATE DATABASE IF NOT EXISTS analytics;
USE analytics;

CREATE TABLE pages (
    id   SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    url  VARCHAR(512)      NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_url (url)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE page_views (
    id          INT UNSIGNED      NOT NULL AUTO_INCREMENT,
    user_id     INT UNSIGNED      NOT NULL,
    page_id     SMALLINT UNSIGNED NOT NULL,
    country     CHAR(2)           NOT NULL,
    device      ENUM('desktop','mobile','tablet') NOT NULL,
    created_at  DATETIME          NOT NULL,
    duration_ms MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,

    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_date_country_page on page_views(created_at, country, page_id);

CREATE INDEX idx_user ON page_views(user_id);

ALTER TABLE page_views ADD CONSTRAINT fk_page FOREIGN KEY (page_id) REFERENCES pages(id) ON DELETE RESTRICT ON UPDATE RESTRICT;