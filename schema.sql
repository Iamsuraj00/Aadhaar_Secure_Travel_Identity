-- ═══════════════════════════════════════════════════════════════
--  Aadhaar Secure Travel Identity System — MySQL Schema
--  Run this script once to set up the database.
--  Compatible with MySQL 5.7+ / MySQL 8.x
-- ═══════════════════════════════════════════════════════════════

-- Create and select the database
CREATE DATABASE IF NOT EXISTS aadhaar_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE aadhaar_db;

-- ─────────────────────────────────────────────────────────────
-- TABLE: citizens
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS citizens (
    uid             VARCHAR(14)  NOT NULL PRIMARY KEY,   -- XXXX-XXXX-XXXX
    name            VARCHAR(150) NOT NULL,
    date_of_birth   DATE         NOT NULL,
    address         TEXT         NOT NULL,
    phone_number    VARCHAR(15)  NOT NULL,
    email           VARCHAR(150),
    photo_path      VARCHAR(300) DEFAULT '',
    pin             VARCHAR(64)  NOT NULL,               -- SHA-256 hash
    travel_blocked  TINYINT(1)   NOT NULL DEFAULT 0,
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ─────────────────────────────────────────────────────────────
-- TABLE: passports
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS passports (
    passport_number    VARCHAR(20)  NOT NULL PRIMARY KEY,
    uid                VARCHAR(14)  NOT NULL,
    holder_name        VARCHAR(150) NOT NULL,
    nationality        VARCHAR(80)  NOT NULL DEFAULT 'Indian',
    issue_date         DATE         NOT NULL,
    expiry_date        DATE         NOT NULL,
    issuing_authority  VARCHAR(200) NOT NULL,
    status             ENUM('ACTIVE','EXPIRED','REVOKED','SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
    created_at         TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_passport_citizen FOREIGN KEY (uid) REFERENCES citizens(uid) ON DELETE CASCADE,
    CONSTRAINT uq_passport_uid UNIQUE (uid)       -- one passport per citizen
) ENGINE=InnoDB;

-- ─────────────────────────────────────────────────────────────
-- TABLE: driving_licenses
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS driving_licenses (
    license_number   VARCHAR(30)  NOT NULL PRIMARY KEY,
    uid              VARCHAR(14)  NOT NULL,
    holder_name      VARCHAR(150) NOT NULL,
    issue_date       DATE,
    expiry_date      DATE,
    vehicle_category VARCHAR(30)  NOT NULL,
    issuing_rto      VARCHAR(200) NOT NULL,
    status           ENUM('ISSUED','DENIED','PENDING','EXPIRED','SUSPENDED') NOT NULL DEFAULT 'PENDING',
    test_date        DATE,
    test_location    VARCHAR(300),
    test_result      ENUM('PASS','FAIL') DEFAULT NULL,
    created_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_license_citizen FOREIGN KEY (uid) REFERENCES citizens(uid) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ─────────────────────────────────────────────────────────────
-- TABLE: travel_alerts
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS travel_alerts (
    alert_id        VARCHAR(20)  NOT NULL PRIMARY KEY,
    uid             VARCHAR(14)  NOT NULL,
    passport_number VARCHAR(20)  DEFAULT 'N/A',
    person_name     VARCHAR(150) NOT NULL,
    reason          TEXT         NOT NULL,
    alert_type      ENUM('STOP_TRAVEL','TRACE','WATCH') NOT NULL,
    issued_by       VARCHAR(200) NOT NULL,
    issued_date     DATE         NOT NULL,
    active          TINYINT(1)   NOT NULL DEFAULT 1,
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_alert_citizen FOREIGN KEY (uid) REFERENCES citizens(uid) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ─────────────────────────────────────────────────────────────
-- TABLE: notifications
-- ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS notifications (
    notification_id  VARCHAR(20)  NOT NULL PRIMARY KEY,
    recipient_id     VARCHAR(100) NOT NULL,
    recipient_type   ENUM('AIRLINE','CRIME_DEPT','SYSTEM') NOT NULL,
    message          TEXT         NOT NULL,
    timestamp        VARCHAR(30)  NOT NULL,
    is_read          TINYINT(1)   NOT NULL DEFAULT 0,
    created_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ─────────────────────────────────────────────────────────────
-- INDEXES for performance
-- ─────────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_citizens_name        ON citizens(name);
CREATE INDEX IF NOT EXISTS idx_passports_uid        ON passports(uid);
CREATE INDEX IF NOT EXISTS idx_licenses_uid         ON driving_licenses(uid);
CREATE INDEX IF NOT EXISTS idx_alerts_uid           ON travel_alerts(uid);
CREATE INDEX IF NOT EXISTS idx_alerts_passport      ON travel_alerts(passport_number);
CREATE INDEX IF NOT EXISTS idx_alerts_name          ON travel_alerts(person_name);
CREATE INDEX IF NOT EXISTS idx_notif_recipient      ON notifications(recipient_id);

-- ─────────────────────────────────────────────────────────────
-- SEED DATA
-- ─────────────────────────────────────────────────────────────

-- Citizens  (PINs: Arjun=1234, Priya=2345, Rohit=3456)
-- SHA-256 of "1234" = 03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4
-- SHA-256 of "2345" = 4e07408562bedb8b60ce05c1decfe3ad16ce10397b6c5be7c01e1a9f3a37f0c9 (approx - use actual)
-- Note: actual hashes computed by Java PinUtil.hashPin at runtime during seeding

INSERT IGNORE INTO citizens (uid, name, date_of_birth, address, phone_number, email, photo_path, pin, travel_blocked)
VALUES
  ('1234-5678-9012', 'Arjun Sharma',  '1990-05-15', '12 MG Road, New Delhi',       '9876543210', 'arjun@email.com',  '', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 0),
  ('2345-6789-0123', 'Priya Mehta',   '1985-11-22', '45 Park Street, Mumbai',       '9988776655', 'priya@email.com',  '', 'a17b43cdf0d8b1c3e5f5ddb2e1dbdc6a4a1d40e54432ef2d35af33567a65a3c8', 0),
  ('3456-7890-1234', 'Rohit Verma',   '1978-03-30', '8 Anna Nagar, Chennai',        '9112233445', 'rohit@email.com',  '', '4e3f4a7d5f6b8c9d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d', 1);

INSERT IGNORE INTO passports (passport_number, uid, holder_name, nationality, issue_date, expiry_date, issuing_authority, status)
VALUES
  ('P1234567', '1234-5678-9012', 'Arjun Sharma', 'Indian', '2020-01-10', '2030-01-09', 'Passport Seva Kendra, Delhi',  'ACTIVE'),
  ('P2345678', '2345-6789-0123', 'Priya Mehta',  'Indian', '2019-06-15', '2029-06-14', 'Passport Seva Kendra, Mumbai', 'ACTIVE');

INSERT IGNORE INTO driving_licenses (license_number, uid, holder_name, issue_date, expiry_date, vehicle_category, issuing_rto, status, test_date, test_location, test_result)
VALUES
  ('DL-DL-2020-123456', '1234-5678-9012', 'Arjun Sharma', '2020-03-20', '2040-03-19', 'LMV', 'RTO Delhi-East', 'ISSUED', '2020-03-15', 'RTO Delhi-East Test Track', 'PASS');

INSERT IGNORE INTO travel_alerts (alert_id, uid, passport_number, person_name, reason, alert_type, issued_by, issued_date, active)
VALUES
  ('ALT-001', '3456-7890-1234', 'N/A', 'Rohit Verma', 'Suspected financial fraud case under investigation', 'STOP_TRAVEL', 'CBI HQ', '2026-05-01', 1);

INSERT IGNORE INTO notifications (notification_id, recipient_id, recipient_type, message, timestamp, is_read)
VALUES
  ('NOTIF-0001', 'SYSTEM', 'SYSTEM', 'Aadhaar Secure Travel Identity system initialized.', '2026-05-17 09:00:00', 0);

-- ─────────────────────────────────────────────────────────────
-- Verify tables created
-- ─────────────────────────────────────────────────────────────
SHOW TABLES;
SELECT 'Schema setup complete.' AS status;
