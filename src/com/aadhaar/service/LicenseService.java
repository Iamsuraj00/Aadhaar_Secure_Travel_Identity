package com.aadhaar.service;

import com.aadhaar.model.Citizen;
import com.aadhaar.model.DrivingLicense;
import com.aadhaar.util.DBConnection;
import com.aadhaar.util.IdGenerator;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class LicenseService {

    private static final Logger LOG = Logger.getLogger(LicenseService.class.getName());
    private final CitizenService citizenSvc = new CitizenService();

    /** Map ResultSet row → DrivingLicense */
    private DrivingLicense map(ResultSet rs) throws SQLException {
        DrivingLicense dl = new DrivingLicense();
        dl.setLicenseNumber(rs.getString("license_number"));
        dl.setUid(rs.getString("uid"));
        dl.setHolderName(rs.getString("holder_name"));
        dl.setIssueDate(rs.getString("issue_date"));
        dl.setExpiryDate(rs.getString("expiry_date"));
        dl.setVehicleCategory(rs.getString("vehicle_category"));
        dl.setIssuingRTO(rs.getString("issuing_rto"));
        dl.setStatus(DrivingLicense.LicenseStatus.valueOf(rs.getString("status")));
        dl.setTestDate(rs.getString("test_date"));
        dl.setTestLocation(rs.getString("test_location"));
        dl.setTestResult(rs.getString("test_result"));
        return dl;
    }

    /** Apply for a licence using the UID; auto-fetches citizen name from Aadhaar DB. */
    public DrivingLicense applyForLicense(String uid, String category,
                                           String stateCode, String rto) {
        Citizen citizen = citizenSvc.getCitizenByUid(uid);
        if (citizen == null) { LOG.warning("[LicenseService] UID not found: " + uid); return null; }

        // If already issued, return existing
        DrivingLicense ex = getLicenseByUid(uid);
        if (ex != null && ex.getStatus() == DrivingLicense.LicenseStatus.ISSUED) {
            LOG.info("[LicenseService] Active licence already exists for UID: " + uid);
            return ex;
        }

        String licNum   = IdGenerator.generateLicenseNumber(stateCode);
        String today    = LocalDate.now().toString();
        String expiry   = LocalDate.now().plusYears(20).toString();
        String testDate = LocalDate.now().plusDays(7).toString();
        String testLoc  = rto + " Test Track";

        String sql = "INSERT INTO driving_licenses (license_number, uid, holder_name, issue_date, " +
                     "expiry_date, vehicle_category, issuing_rto, status, test_date, test_location) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, licNum);
            ps.setString(2, uid);
            ps.setString(3, citizen.getName());
            ps.setDate  (4, Date.valueOf(today));
            ps.setDate  (5, Date.valueOf(expiry));
            ps.setString(6, category);
            ps.setString(7, rto);
            ps.setString(8, "PENDING");
            ps.setDate  (9, Date.valueOf(testDate));
            ps.setString(10, testLoc);
            ps.executeUpdate();
            ps.close();
            LOG.info("[LicenseService] Application created: " + licNum + " for " + citizen.getName());
            return getLicenseByNumber(licNum);
        } catch (SQLException e) {
            LOG.severe("[LicenseService] applyForLicense: " + e.getMessage());
            return null;
        } finally {
            DBConnection.releaseConnection(conn);
        }
    }

    /** Record the test result and update status to ISSUED or DENIED. */
    public DrivingLicense recordTestResult(String licNum, boolean passed) {
        String status = passed ? "ISSUED" : "DENIED";
        String result = passed ? "PASS"   : "FAIL";
        String sql = "UPDATE driving_licenses SET status = ?, test_result = ? WHERE license_number = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, result);
            ps.setString(3, licNum);
            int rows = ps.executeUpdate();
            ps.close();
            if (rows == 0) { LOG.warning("[LicenseService] Licence not found: " + licNum); return null; }
            return getLicenseByNumber(licNum);
        } catch (SQLException e) {
            LOG.severe("[LicenseService] recordTestResult: " + e.getMessage());
            return null;
        } finally {
            DBConnection.releaseConnection(conn);
        }
    }

    /** Get licence by licence number. */
    public DrivingLicense getLicenseByNumber(String licNum) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM driving_licenses WHERE license_number = ?");
            ps.setString(1, licNum);
            ResultSet rs = ps.executeQuery();
            DrivingLicense dl = rs.next() ? map(rs) : null;
            rs.close(); ps.close();
            return dl;
        } catch (SQLException e) {
            LOG.severe("[LicenseService] getLicenseByNumber: " + e.getMessage());
            return null;
        } finally {
            DBConnection.releaseConnection(conn);
        }
    }

    /** Get most recent licence for a UID. */
    public DrivingLicense getLicenseByUid(String uid) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM driving_licenses WHERE uid = ? ORDER BY created_at DESC LIMIT 1");
            ps.setString(1, uid);
            ResultSet rs = ps.executeQuery();
            DrivingLicense dl = rs.next() ? map(rs) : null;
            rs.close(); ps.close();
            return dl;
        } catch (SQLException e) {
            LOG.severe("[LicenseService] getLicenseByUid: " + e.getMessage());
            return null;
        } finally {
            DBConnection.releaseConnection(conn);
        }
    }

    /** Get all licences. */
    public List<DrivingLicense> getAllLicenses() {
        List<DrivingLicense> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(
                "SELECT * FROM driving_licenses ORDER BY holder_name");
            while (rs.next()) list.add(map(rs));
            rs.close(); st.close();
        } catch (SQLException e) {
            LOG.severe("[LicenseService] getAllLicenses: " + e.getMessage());
        } finally {
            DBConnection.releaseConnection(conn);
        }
        return list;
    }
}
