package com.aadhaar.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * ═══════════════════════════════════════════════════════
 *  DBConnection — Thread-safe JDBC Connection Pool
 *  Reads config from src/db.properties (on classpath).
 *
 *  Usage:
 *      Connection con = DBConnection.getConnection();
 *      // ... use con ...
 *      DBConnection.releaseConnection(con);
 *
 *  Always release the connection in a finally block.
 * ═══════════════════════════════════════════════════════
 */
public class DBConnection {

    private static final Logger LOG = Logger.getLogger(DBConnection.class.getName());

    // ── Config loaded from db.properties ──
    private static String DB_URL;
    private static String DB_USER;
    private static String DB_PASS;
    private static int    POOL_SIZE = 10;

    // ── Simple connection pool ──
    private static final List<Connection> pool      = new ArrayList<>();
    private static final List<Connection> usedConns = new ArrayList<>();

    private static boolean initialized = false;

    // ── Static initializer — loads config and fills pool ──
    static {
        try {
            loadProperties();
            Class.forName("com.mysql.cj.jdbc.Driver");
            fillPool();
            initialized = true;
            LOG.info("[DBConnection] Pool initialized with " + POOL_SIZE + " connections.");
        } catch (ClassNotFoundException e) {
            LOG.severe("[DBConnection] MySQL JDBC Driver not found: " + e.getMessage());
        } catch (Exception e) {
            LOG.severe("[DBConnection] Failed to initialize pool: " + e.getMessage());
        }
    }

    // ── Load db.properties from classpath ──
    private static void loadProperties() throws IOException {
        Properties props = new Properties();
        InputStream is = DBConnection.class.getClassLoader()
                                          .getResourceAsStream("db.properties");
        if (is == null) {
            throw new IOException("db.properties not found on classpath. " +
                "Place it in src/ (project source root).");
        }
        props.load(is);
        is.close();

        DB_URL   = props.getProperty("db.url",      "jdbc:mysql://localhost:3306/aadhaar_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");
        DB_USER  = props.getProperty("db.username", "root");
        DB_PASS  = props.getProperty("db.password", "suraj121");
        POOL_SIZE = Integer.parseInt(props.getProperty("db.poolSize", "10"));

        LOG.info("[DBConnection] Config loaded — URL: " + DB_URL);
    }

    // ── Pre-fill the pool ──
    private static void fillPool() throws SQLException {
        for (int i = 0; i < POOL_SIZE; i++) {
            pool.add(createNewConnection());
        }
    }

    // ── Create a single fresh connection ──
    private static Connection createNewConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    /**
     * Borrow a connection from the pool.
     * If the pool is empty, creates a new connection on demand.
     * Always call releaseConnection() when done.
     */
    public static synchronized Connection getConnection() throws SQLException {
        if (!initialized) {
            throw new SQLException("[DBConnection] Pool not initialized. Check db.properties and MySQL driver.");
        }

        // Remove any stale / closed connections and replace them
        for (int i = 0; i < pool.size(); i++) {
            Connection c = pool.get(i);
            if (c == null || c.isClosed()) {
                pool.set(i, createNewConnection());
            }
        }

        if (!pool.isEmpty()) {
            Connection conn = pool.remove(pool.size() - 1);
            usedConns.add(conn);
            return conn;
        }

        // Pool exhausted — create on demand (overflow connection)
        LOG.warning("[DBConnection] Pool exhausted. Creating overflow connection.");
        Connection conn = createNewConnection();
        usedConns.add(conn);
        return conn;
    }

    /**
     * Return a connection back to the pool.
     * Never call conn.close() directly — call this instead.
     */
    public static synchronized void releaseConnection(Connection conn) {
        if (conn == null) return;
        usedConns.remove(conn);
        try {
            if (!conn.isClosed()) {
                conn.setAutoCommit(true); // reset autocommit
                pool.add(conn);
            }
        } catch (SQLException e) {
            LOG.log(Level.WARNING, "[DBConnection] Error releasing connection", e);
        }
    }

    /** Closes all connections in pool and used list (call on app shutdown). */
    public static synchronized void shutdown() {
        closeAll(pool);
        closeAll(usedConns);
        LOG.info("[DBConnection] All connections closed.");
    }

    private static void closeAll(List<Connection> list) {
        for (Connection c : list) {
            try { if (c != null && !c.isClosed()) c.close(); }
            catch (SQLException ignored) {}
        }
        list.clear();
    }

    /** Returns current pool status string for debugging. */
    public static synchronized String getStatus() {
        return "Pool[available=" + pool.size() + ", inUse=" + usedConns.size() + "]";
    }

    // Prevent instantiation
    private DBConnection() {}
}
