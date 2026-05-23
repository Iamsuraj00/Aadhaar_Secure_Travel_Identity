package com.aadhaar.servlet;

import com.aadhaar.model.TravelAlert;
import com.aadhaar.service.CrimeDeptService;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

@WebServlet("/crime/*")
public class CrimeDeptServlet extends HttpServlet {
    private final CrimeDeptService svc = new CrimeDeptService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/dashboard";

        switch (path) {
            case "/dashboard":
                req.setAttribute("alerts", svc.getAllAlerts());
                req.getRequestDispatcher("/jsp/crime/dashboard.jsp").forward(req, resp);
                break;
            case "/issue":
                req.getRequestDispatcher("/jsp/crime/issue.jsp").forward(req, resp);
                break;
            case "/trace":
                req.getRequestDispatcher("/jsp/crime/trace.jsp").forward(req, resp);
                break;
            case "/revoke":
                String alertId = req.getParameter("id");
                boolean ok = svc.revokeAlert(alertId);
                req.setAttribute("revokeResult", ok ? "Alert " + alertId + " revoked." : "Alert not found.");
                req.setAttribute("alerts", svc.getAllAlerts());
                req.getRequestDispatcher("/jsp/crime/dashboard.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/crime/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();

        if ("/issue".equals(path)) {
            String uid      = req.getParameter("uid");
            String passport = req.getParameter("passport");
            String reason   = req.getParameter("reason");
            String typeStr  = req.getParameter("alertType");
            String issuedBy = req.getParameter("issuedBy");
            TravelAlert.AlertType type = TravelAlert.AlertType.valueOf(typeStr);
            TravelAlert ta;
            if (uid != null && !uid.isEmpty()) {
                ta = svc.issueTravelAlertByUid(uid, reason, type, issuedBy);
            } else {
                ta = svc.issueTravelAlertByPassport(passport, reason, type, issuedBy);
            }
            if (ta != null) {
                req.setAttribute("alert", ta);
                req.setAttribute("success", "Alert issued: " + ta.getAlertId());
            } else {
                req.setAttribute("error", "Could not issue alert. UID/Passport not found.");
            }
            req.getRequestDispatcher("/jsp/crime/issue.jsp").forward(req, resp);

        } else if ("/trace".equals(path)) {
            String query = req.getParameter("query");
            String by    = req.getParameter("by");
            List<TravelAlert> results = svc.searchAlerts(query, by);
            req.setAttribute("results", results);
            req.setAttribute("query", query);
            req.setAttribute("by", by);
            req.getRequestDispatcher("/jsp/crime/trace.jsp").forward(req, resp);
        }
    }
}
