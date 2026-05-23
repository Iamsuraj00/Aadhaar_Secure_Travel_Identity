package com.aadhaar.service;

import com.aadhaar.model.Notification;
import com.aadhaar.util.DBConnection;
import com.aadhaar.util.IdGenerator;

import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class NotificationService {

    private static final Logger LOG = Logger.getLogger(NotificationService.class.getName());
    private static final DateTimeFormatter FMT =
        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    /** Map ResultSet row → Notification */
    private Notification map(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setNotificationId(rs.getString("notification_id"));
        n.setRecipientId(rs.getString("recipient_id"));
        n.setRecipientType(rs.getString("recipient_type"));
        n.setMessage(rs.getString("message"));
        n.setTimestamp(rs.getString("timestamp"));
        n.setRead(rs.getInt("is_read") == 1);
        return n;
    }

    /** Insert a notification. */
    private void insert(String recipientId, String recipientType, String message) {
        String id  = IdGenerator.generateNotificationId();
        String ts  = LocalDateTime.now().format(FMT);
        String sql = "INSERT INTO notifications (notification_id, recipient_id, recipient_type, message, timestamp, is_read) " +
                     "VALUES (?,?,?,?,?,0)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, id);
            ps.setString(2, recipientId);
            ps.setString(3, recipientType);
            ps.setString(4, message);
            ps.setString(5, ts);
            ps.executeUpdate();
            ps.close();
        } catch (SQLException e) {
            LOG.severe("[NotificationService] insert: " + e.getMessage());
        } finally {
            DBConnection.releaseConnection(conn);
        }
    }

    /** Send a notification to an airline. */
    public void notifyAirline(String airlineId, String message) {
        insert(airlineId, "AIRLINE", message);
        LOG.info("[NotificationService] → AIRLINE [" + airlineId + "]: " + message);
    }

    /** Send a notification to the crime department. */
    public void notifyCrimeDept(String deptId, String message) {
        insert(deptId, "CRIME_DEPT", message);
        LOG.info("[NotificationService] → CRIME_DEPT [" + deptId + "]: " + message);
    }

    /** Get all notifications, most recent first. */
    public List<Notification> getAllNotifications() {
        List<Notification> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(
                "SELECT * FROM notifications ORDER BY created_at DESC");
            while (rs.next()) list.add(map(rs));
            rs.close(); st.close();
        } catch (SQLException e) {
            LOG.severe("[NotificationService] getAllNotifications: " + e.getMessage());
        } finally {
            DBConnection.releaseConnection(conn);
        }
        return list;
    }

    /** Mark all notifications for a recipient as read. */
    public void markAllRead(String recipientId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE notifications SET is_read = 1 WHERE recipient_id = ?");
            ps.setString(1, recipientId);
            ps.executeUpdate();
            ps.close();
        } catch (SQLException e) {
            LOG.severe("[NotificationService] markAllRead: " + e.getMessage());
        } finally {
            DBConnection.releaseConnection(conn);
        }
    }

    /** Count unread notifications. */
    public int countUnread() {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM notifications WHERE is_read = 0");
            int count = rs.next() ? rs.getInt(1) : 0;
            rs.close(); st.close();
            return count;
        } catch (SQLException e) {
            LOG.severe("[NotificationService] countUnread: " + e.getMessage());
            return 0;
        } finally {
            DBConnection.releaseConnection(conn);
        }
    }
}
