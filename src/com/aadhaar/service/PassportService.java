package com.aadhaar.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import com.aadhaar.model.Citizen;
import com.aadhaar.model.Passport;
import com.aadhaar.util.DBConnection;
import com.aadhaar.util.IdGenerator;

public class PassportService {

    private static final Logger LOG = Logger.getLogger(PassportService.class.getName());
    private final CitizenService      citizenSvc = new CitizenService();
    private final NotificationService notifSvc   = new NotificationService();

    /** Map ResultSet row → Passport */
    private Passport map(ResultSet rs) throws SQLException {
        Passport p = new Passport();
        p.setPassportNumber(rs.getString("passport_number"));
        p.setUid(rs.getString("uid"));
        p.setHolderName(rs.getString("holder_name"));
        p.setNationality(rs.getString("nationality"));
        p.setIssueDate(rs.getString("issue_date"));
        p.setExpiryDate(rs.getString("expiry_date"));
        p.setIssuingAuthority(rs.getString("issuing_authority"));
        p.setStatus(Passport.PassportStatus.valueOf(rs.getString("status")));
        return p;
    }

    /** Issue a new passport linked to a citizen UID. */
    public Passport issuePassport(String uid, String nationality,
                                   String issueDate, String expiryDate, String authority) {
        Citizen citizen = citizenSvc.getCitizenByUid(uid);
        if (citizen == null) { LOG.warning("[PassportService] UID not found: " + uid); return null; }

        // Idempotent — return existing if already issued
        Passport existing = getPassportByUid(uid);
        if (existing != null) { LOG.info("[PassportService] Passport already exists for UID: " + uid); return existing; }

        String pn  = IdGenerator.generatePassportNumber();
        String sql = "INSERT INTO passports (passport_number, uid, holder_name, nationality, " +
                     "issue_date, expiry_date, issuing_authority, status) VALUES (?,?,?,?,?,?,?,?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, pn);
            ps.setString(2, uid);
            ps.setString(3, citizen.getName());
            ps.setString(4, nationality);
            ps.setDate(5, java.sql.Date.valueOf(issueDate));
            ps.setDate(6, java.sql.Date.valueOf(expiryDate));
            ps.setString(7, authority);
            ps.setString(8, "ACTIVE");
            ps.executeUpdate();
            ps.close();
            LOG.info("[PassportService] Issued passport " + pn + " for " + citizen.getName());
            return getPassportByNumber(pn);
        } catch (SQLException e) {
            LOG.severe("[PassportService] issuePassport: " + e.getMessage());
            return null;
        } finally {
            DBConnection.releaseConnection(conn);
        }
    }

    /** Airport check: retrieve passport by UID; checks travel block; notifies airline. */
    public Passport airportPassportCheck(String uid, String airlineId) {
        Citizen citizen = citizenSvc.getCitizenByUid(uid);
        if (citizen == null) return null;

        if (citizen.isTravelBlocked()) {
            notifSvc.notifyAirline(airlineId,
                "TRAVEL BLOCKED: " + citizen.getName() + " (UID: " + uid + ")");
            return null;
        }
        Passport p = getPassportByUid(uid);
        if (p != null) {
            notifSvc.notifyAirline(airlineId,
                "Passport accessed for " + citizen.getName() + " | " + p.getPassportNumber());
        }
        return p;
    }

    /** Get passport by UID. */
    public Passport getPassportByUid(String uid) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM passports WHERE uid = ? LIMIT 1");
            ps.setString(1, uid);
            ResultSet rs = ps.executeQuery();
            Passport p = rs.next() ? map(rs) : null;
            rs.close(); ps.close();
            return p;
        } catch (SQLException e) {
            LOG.severe("[PassportService] getPassportByUid: " + e.getMessage());
            return null;
        } finally {
            DBConnection.releaseConnection(conn);
        }
    }

    /** Get passport by passport number. */
    public Passport getPassportByNumber(String pn) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM passports WHERE passport_number = ?");
            ps.setString(1, pn);
            ResultSet rs = ps.executeQuery();
            Passport p = rs.next() ? map(rs) : null;
            rs.close(); ps.close();
            return p;
        } catch (SQLException e) {
            LOG.severe("[PassportService] getPassportByNumber: " + e.getMessage());
            return null;
        } finally {
            DBConnection.releaseConnection(conn);
        }
    }

    /** Get all passports. */
    public List<Passport> getAllPassports() {
        List<Passport> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(
                "SELECT * FROM passports ORDER BY holder_name");
            while (rs.next()) list.add(map(rs));
            rs.close(); st.close();
        } catch (SQLException e) {
            LOG.severe("[PassportService] getAllPassports: " + e.getMessage());
        } finally {
            DBConnection.releaseConnection(conn);
        }
        return list;
    }

    /** Search passport holders by name — returns map list with uid/name/dob/passportNumber. */
    public List<Map<String, String>> searchHoldersByName(String name) {
        List<Map<String,String>> result = new ArrayList<>();
        List<Citizen> citizens = citizenSvc.searchCitizensWithPassportByName(name);
        for (Citizen c : citizens) {
            Passport p = getPassportByUid(c.getUid());
            Map<String,String> e = new LinkedHashMap<>();
            e.put("uid",            c.getUid());
            e.put("name",           c.getName());
            e.put("dob",            c.getDateOfBirth());
            e.put("passportNumber", p != null ? p.getPassportNumber() : "N/A");
            result.add(e);
        }
        return result;
    }
}
