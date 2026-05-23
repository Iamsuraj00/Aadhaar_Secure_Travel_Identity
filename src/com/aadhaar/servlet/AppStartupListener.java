package com.aadhaar.servlet;

import com.aadhaar.util.DBConnection;
import com.aadhaar.util.DatabaseSeeder;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.logging.Logger;

/**
 * AppStartupListener — fires on application deploy/undeploy.
 *   • On startup : seeds the database with default data (INSERT IGNORE)
 *   • On shutdown: closes all JDBC pool connections cleanly
 */
@WebListener
public class AppStartupListener implements ServletContextListener {

    private static final Logger LOG = Logger.getLogger(AppStartupListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOG.info("[AppStartupListener] Application starting — seeding database...");
        try {
            DatabaseSeeder.seed();
            LOG.info("[AppStartupListener] Database ready. Pool: " + DBConnection.getStatus());
        } catch (Exception e) {
            LOG.severe("[AppStartupListener] Startup seed failed: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOG.info("[AppStartupListener] Application shutting down — closing DB pool...");
        DBConnection.shutdown();
    }
}
