package com.aadhaar.util;

import java.sql.*;
import java.util.logging.Logger;

/**
 * DatabaseSeeder — inserts default seed data on first startup.
 * Called by AppStartupListener. Safe to call multiple times (uses INSERT IGNORE).
 */
public class DatabaseSeeder {

    private static final Logger LOG = Logger.getLogger(DatabaseSeeder.class.getName());

    public static void seed() {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            seedCitizens(conn);
            seedPassports(conn);
            seedLicenses(conn);
            seedAlerts(conn);
            seedNotifications(conn);
            LOG.info("[DatabaseSeeder] Seed complete.");
        } catch (SQLException e) {
            LOG.severe("[DatabaseSeeder] Seed failed: " + e.getMessage());
        } finally {
            DBConnection.releaseConnection(conn);
        }
    }

    private static void seedCitizens(Connection conn) throws SQLException {
        // PINs: Arjun=1234, Priya=2345, Rohit=3456  (SHA-256 hashed)
        String sql = "INSERT IGNORE INTO citizens " +
                     "(uid, name, date_of_birth, address, phone_number, email, photo_path, pin, travel_blocked) " +
                     "VALUES (?,?,?,?,?,?,?,?,?)";
        PreparedStatement ps = conn.prepareStatement(sql);

        Object[][] rows = {
            {"1234-5678-9012","Arjun Sharma","1990-05-15","12 MG Road, New Delhi",   "9876543210","arjun@email.com", "", PinUtil.hashPin("1234"), 0},
            {"2345-6789-0123","Priya Mehta", "1985-11-22","45 Park Street, Mumbai",  "9988776655","priya@email.com", "", PinUtil.hashPin("2345"), 0},
            {"3456-7890-1234","Rohit Verma", "1978-03-30","8 Anna Nagar, Chennai",   "9112233445","rohit@email.com", "", PinUtil.hashPin("3456"), 1},
        };

        for (Object[] r : rows) {
            ps.setString(1, (String)  r[0]);
            ps.setString(2, (String)  r[1]);
            ps.setDate  (3, Date.valueOf((String) r[2]));
            ps.setString(4, (String)  r[3]);
            ps.setString(5, (String)  r[4]);
            ps.setString(6, (String)  r[5]);
            ps.setString(7, (String)  r[6]);
            ps.setString(8, (String)  r[7]);
            ps.setInt   (9, (Integer) r[8]);
            ps.addBatch();
        }
        ps.executeBatch();
        ps.close();
        LOG.info("[DatabaseSeeder] Citizens seeded.");
    }

    private static void seedPassports(Connection conn) throws SQLException {
        String sql = "INSERT IGNORE INTO passports " +
                     "(passport_number, uid, holder_name, nationality, issue_date, expiry_date, issuing_authority, status) " +
                     "VALUES (?,?,?,?,?,?,?,?)";
        PreparedStatement ps = conn.prepareStatement(sql);

        Object[][] rows = {
            {"P1234567","1234-5678-9012","Arjun Sharma","Indian","2020-01-10","2030-01-09","Passport Seva Kendra, Delhi","ACTIVE"},
            {"P2345678","2345-6789-0123","Priya Mehta", "Indian","2019-06-15","2029-06-14","Passport Seva Kendra, Mumbai","ACTIVE"},
        };

        for (Object[] r : rows) {
            for (int i = 0; i < 7; i++) ps.setString(i+1, (String) r[i]);
            ps.setString(8, (String) r[7]);
            ps.addBatch();
        }
        ps.executeBatch();
        ps.close();
        LOG.info("[DatabaseSeeder] Passports seeded.");
    }

    private static void seedLicenses(Connection conn) throws SQLException {
        String sql = "INSERT IGNORE INTO driving_licenses " +
                     "(license_number, uid, holder_name, issue_date, expiry_date, vehicle_category, issuing_rto, status, test_date, test_location, test_result) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?,?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1,  "DL-DL-2020-123456");
        ps.setString(2,  "1234-5678-9012");
        ps.setString(3,  "Arjun Sharma");
        ps.setDate  (4,  Date.valueOf("2020-03-20"));
        ps.setDate  (5,  Date.valueOf("2040-03-19"));
        ps.setString(6,  "LMV");
        ps.setString(7,  "RTO Delhi-East");
        ps.setString(8,  "ISSUED");
        ps.setDate  (9,  Date.valueOf("2020-03-15"));
        ps.setString(10, "RTO Delhi-East Test Track");
        ps.setString(11, "PASS");
        ps.executeUpdate();
        ps.close();
        LOG.info("[DatabaseSeeder] Licenses seeded.");
    }

    private static void seedAlerts(Connection conn) throws SQLException {
        String sql = "INSERT IGNORE INTO travel_alerts " +
                     "(alert_id, uid, passport_number, person_name, reason, alert_type, issued_by, issued_date, active) " +
                     "VALUES (?,?,?,?,?,?,?,?,?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, "ALT-001");
        ps.setString(2, "3456-7890-1234");
        ps.setString(3, "N/A");
        ps.setString(4, "Rohit Verma");
        ps.setString(5, "Suspected financial fraud case under investigation");
        ps.setString(6, "STOP_TRAVEL");
        ps.setString(7, "CBI HQ");
        ps.setDate  (8, Date.valueOf("2026-05-01"));
        ps.setInt   (9, 1);
        ps.executeUpdate();
        ps.close();
        LOG.info("[DatabaseSeeder] Travel alerts seeded.");
    }

    private static void seedNotifications(Connection conn) throws SQLException {
        String sql = "INSERT IGNORE INTO notifications " +
                     "(notification_id, recipient_id, recipient_type, message, timestamp, is_read) " +
                     "VALUES (?,?,?,?,?,?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, "NOTIF-0001");
        ps.setString(2, "SYSTEM");
        ps.setString(3, "SYSTEM");
        ps.setString(4, "Aadhaar Secure Travel Identity system initialized with MySQL database.");
        ps.setString(5, "2026-05-17 09:00:00");
        ps.setInt   (6, 0);
        ps.executeUpdate();
        ps.close();
        LOG.info("[DatabaseSeeder] Notifications seeded.");
    }
}
