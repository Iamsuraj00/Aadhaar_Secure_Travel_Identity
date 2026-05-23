package com.aadhaar.service;

import com.aadhaar.model.Citizen;
import com.aadhaar.model.Passport;
import com.aadhaar.model.TravelAlert;
import com.aadhaar.util.DBConnection;
import com.aadhaar.util.IdGenerator;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class CrimeDeptService {

    private static final Logger LOG = Logger.getLogger(CrimeDeptService.class.getName());
    private final CitizenService  citizenSvc  = new CitizenService();
    private final PassportService passportSvc = new PassportService();

    /** Map ResultSet row → TravelAlert */
    private TravelAlert map(ResultSet rs) throws SQLException {
        TravelAlert ta = new TravelAlert();
        ta.setAlertId(rs.getString("alert_id"));
        ta.setUid(rs.getString("uid"));
        ta.setPassportNumber(rs.getString("passport_number"));
        ta.setPersonName(rs.getString("person_name"));
        ta.setReason(rs.getString("reason"));
        ta.setAlertType(TravelAlert.AlertType.valueOf(rs.getString("alert_type")));
        ta.setIssuedBy(rs.getString("issued_by"));
        ta.setIssuedDate(rs.getString("issued_date"));
        ta.setActive(rs.getInt("active") == 1);
        return ta;
    }

    /** Issue a travel alert by UID. */
    public TravelAlert issueTravelAlertByUid(String uid, String reason,
                                              TravelAlert.AlertType type, String issuedBy) {
        Citizen citizen = citizenSvc.getCitizenByUid(uid);
        if (citizen == null) { LOG.warning("[CrimeDeptService] UID not found: " + uid); return null; }

        Passport passport = passportSvc.getPassportByUid(uid);
        String pn = passport != null ? passport.getPassportNumber() : "N/A";

        String alertId = IdGenerator.generateAlertId();
        String sql = "INSERT INTO travel_alerts (alert_id, uid, passport_number, person_name, " +
                     "reason, alert_type, issued_by, issued_date, active) VALUES (?,?,?,?,?,?,?,?,1)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, alertId);
            ps.setString(2, uid);
            ps.setString(3, pn);
            ps.setString(4, citizen.getName());
            ps.setString(5, reason);
            ps.setString(6, type.toString());
            ps.setString(7, issuedBy);
            ps.setDate  (8, Date.valueOf(LocalDate.now()));
            ps.executeUpdate();
            ps.close();

            // If STOP_TRAVEL, update citizen's travel_blocked flag in DB
            if (type == TravelAlert.AlertType.STOP_TRAVEL) {
                citizenSvc.setTravelBlocked(uid, true);
                LOG.info("[CrimeDeptService] STOP TRAVEL set for: " + citizen.getName());
            }
            LOG.info("[CrimeDeptService] Alert " + alertId + " issued for: " + citizen.getName());
            return getAlertById(alertId);
        } catch (SQLException e) {
            LOG.severe("[CrimeDeptService] issueTravelAlertByUid: " + e.getMessage());
            return null;
        } finally {
            DBConnection.releaseConnection(conn);
        }
    }

    /** Issue a travel alert by passport number. */
    public TravelAlert issueTravelAlertByPassport(String passportNumber, String reason,
                                                   TravelAlert.AlertType type, String issuedBy) {
        Passport p = passportSvc.getPassportByNumber(passportNumber);
        if (p == null) { LOG.warning("[CrimeDeptService] Passport not found: " + passportNumber); return null; }
        return issueTravelAlertByUid(p.getUid(), reason, type, issuedBy);
    }

    /** Revoke an alert by alertId; lifts travel block if STOP_TRAVEL. */
    public boolean revokeAlert(String alertId) {
        TravelAlert ta = getAlertById(alertId);
        if (ta == null) return false;

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE travel_alerts SET active = 0 WHERE alert_id = ?");
            ps.setString(1, alertId);
            ps.executeUpdate();
            ps.close();

            // Lift travel block if this was a STOP_TRAVEL alert
            if (ta.getAlertType() == TravelAlert.AlertType.STOP_TRAVEL) {
                // Only unblock if no OTHER active STOP_TRAVEL alerts remain for this UID
                List<TravelAlert> remaining = searchAlerts(ta.getUid(), "uid");
                boolean otherStopExists = remaining.stream()
                    .anyMatch(a -> a.isActive() && a.getAlertType() == TravelAlert.AlertType.STOP_TRAVEL
                                && !a.getAlertId().equals(alertId));
                if (!otherStopExists) {
                    citizenSvc.setTravelBlocked(ta.getUid(), false);
                    LOG.info("[CrimeDeptService] Travel block LIFTED for UID: " + ta.getUid());
                }
            }
            return true;
        } catch (SQLException e) {
            LOG.severe("[CrimeDeptService] revokeAlert: " + e.getMessage());
            return false;
        } finally {
            DBConnection.releaseConnection(conn);
        }
    }

    /** Fetch alert by ID. */
    public TravelAlert getAlertById(String alertId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM travel_alerts WHERE alert_id = ?");
            ps.setString(1, alertId);
            ResultSet rs = ps.executeQuery();
            TravelAlert ta = rs.next() ? map(rs) : null;
            rs.close(); ps.close();
            return ta;
        } catch (SQLException e) {
            LOG.severe("[CrimeDeptService] getAlertById: " + e.getMessage());
            return null;
        } finally {
            DBConnection.releaseConnection(conn);
        }
    }

    /**
     * Search alerts by uid / passport / name.
     * @param query  the search value
     * @param by     "uid" | "passport" | "name"
     */
    public List<TravelAlert> searchAlerts(String query, String by) {
        List<TravelAlert> list = new ArrayList<>();
        String col;
        switch (by) {
            case "uid":      col = "uid";             break;
            case "passport": col = "passport_number"; break;
            default:         col = "person_name";     break;
        }
        // Use LIKE for name searches, exact for uid/passport
        String sql = "name".equals(col)
            ? "SELECT * FROM travel_alerts WHERE person_name LIKE ? ORDER BY issued_date DESC"
            : "SELECT * FROM travel_alerts WHERE " + col + " = ? ORDER BY issued_date DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "name".equals(col) ? "%" + query + "%" : query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
            rs.close(); ps.close();
        } catch (SQLException e) {
            LOG.severe("[CrimeDeptService] searchAlerts: " + e.getMessage());
        } finally {
            DBConnection.releaseConnection(conn);
        }
        return list;
    }

    /** Get all alerts ordered by date desc. */
    public List<TravelAlert> getAllAlerts() {
        List<TravelAlert> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(
                "SELECT * FROM travel_alerts ORDER BY issued_date DESC, created_at DESC");
            while (rs.next()) list.add(map(rs));
            rs.close(); st.close();
        } catch (SQLException e) {
            LOG.severe("[CrimeDeptService] getAllAlerts: " + e.getMessage());
        } finally {
            DBConnection.releaseConnection(conn);
        }
        return list;
    }
}
