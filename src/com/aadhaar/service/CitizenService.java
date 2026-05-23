package com.aadhaar.service;

import com.aadhaar.model.Citizen;
import com.aadhaar.util.DBConnection;
import com.aadhaar.util.IdGenerator;
import com.aadhaar.util.PinUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class CitizenService {

    private static final Logger LOG = Logger.getLogger(CitizenService.class.getName());

    /** Map a ResultSet row → Citizen */
    private Citizen map(ResultSet rs) throws SQLException {
        Citizen c = new Citizen();
        c.setUid(rs.getString("uid"));
        c.setName(rs.getString("name"));
        c.setDateOfBirth(rs.getString("date_of_birth"));
        c.setAddress(rs.getString("address"));
        c.setPhoneNumber(rs.getString("phone_number"));
        c.setEmail(rs.getString("email"));
        c.setPhotoPath(rs.getString("photo_path"));
        c.setPin(rs.getString("pin"));
        c.setTravelBlocked(rs.getInt("travel_blocked") == 1);
        return c;
    }

    /** Register a new citizen; returns the saved Citizen with generated UID. */
    public Citizen registerCitizen(String name, String dob, String address,
                                   String phone, String email, String pin) {
        String uid = IdGenerator.generateUID();
        String sql = "INSERT INTO citizens (uid, name, date_of_birth, address, phone_number, " +
                     "email, photo_path, pin, travel_blocked) VALUES (?,?,?,?,?,?,?,?,0)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, uid);
            ps.setString(2, name);
            ps.setDate  (3, Date.valueOf(dob));
            ps.setString(4, address);
            ps.setString(5, phone);
            ps.setString(6, email != null ? email : "");
            ps.setString(7, "");
            ps.setString(8, PinUtil.hashPin(pin));
            ps.executeUpdate();
            ps.close();
            LOG.info("[CitizenService] Registered: " + name + " | UID: " + uid);
            return getCitizenByUid(uid);
        } catch (SQLException e) {
            LOG.severe("[CitizenService] registerCitizen: " + e.getMessage());
            return null;
        } finally {
            DBConnection.releaseConnection(conn);
        }
    }

    /** Authenticate UID + plain PIN. */
    public boolean authenticate(String uid, String plainPin) {
        Citizen c = getCitizenByUid(uid);
        return c != null && PinUtil.verifyPin(plainPin, c.getPin());
    }

    /** Fetch citizen by UID. */
    public Citizen getCitizenByUid(String uid) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM citizens WHERE uid = ?");
            ps.setString(1, uid);
            ResultSet rs = ps.executeQuery();
            Citizen c = rs.next() ? map(rs) : null;
            rs.close(); ps.close();
            return c;
        } catch (SQLException e) {
            LOG.severe("[CitizenService] getCitizenByUid: " + e.getMessage());
            return null;
        } finally {
            DBConnection.releaseConnection(conn);
        }
    }

    /** Fetch all citizens. */
    public List<Citizen> getAllCitizens() {
        List<Citizen> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM citizens ORDER BY name");
            while (rs.next()) list.add(map(rs));
            rs.close(); st.close();
        } catch (SQLException e) {
            LOG.severe("[CitizenService] getAllCitizens: " + e.getMessage());
        } finally {
            DBConnection.releaseConnection(conn);
        }
        return list;
    }

    /** Check travel block. */
    public boolean isTravelBlocked(String uid) {
        Citizen c = getCitizenByUid(uid);
        return c != null && c.isTravelBlocked();
    }

    /** Set/unset travel block. */
    public void setTravelBlocked(String uid, boolean blocked) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE citizens SET travel_blocked = ? WHERE uid = ?");
            ps.setInt(1, blocked ? 1 : 0);
            ps.setString(2, uid);
            ps.executeUpdate();
            ps.close();
        } catch (SQLException e) {
            LOG.severe("[CitizenService] setTravelBlocked: " + e.getMessage());
        } finally {
            DBConnection.releaseConnection(conn);
        }
    }

    /** Search passport-holding citizens by partial name. */
    public List<Citizen> searchCitizensWithPassportByName(String name) {
        List<Citizen> list = new ArrayList<>();
        String sql = "SELECT c.* FROM citizens c JOIN passports p ON p.uid = c.uid " +
                     "WHERE c.name LIKE ? ORDER BY c.name";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + name + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
            rs.close(); ps.close();
        } catch (SQLException e) {
            LOG.severe("[CitizenService] searchCitizensWithPassportByName: " + e.getMessage());
        } finally {
            DBConnection.releaseConnection(conn);
        }
        return list;
    }
}
