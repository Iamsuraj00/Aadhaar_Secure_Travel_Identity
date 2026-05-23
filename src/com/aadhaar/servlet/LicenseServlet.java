package com.aadhaar.servlet;

import com.aadhaar.model.DrivingLicense;
import com.aadhaar.service.LicenseService;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/license/*")
public class LicenseServlet extends HttpServlet {
    private final LicenseService svc = new LicenseService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/apply";

        switch (path) {
            case "/apply":
                req.getRequestDispatcher("/jsp/license/apply.jsp").forward(req, resp);
                break;
            case "/list":
                req.setAttribute("licenses", svc.getAllLicenses());
                req.getRequestDispatcher("/jsp/license/list.jsp").forward(req, resp);
                break;
            case "/result":
                req.getRequestDispatcher("/jsp/license/result.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/license/apply");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();

        if ("/apply".equals(path)) {
            String uid      = req.getParameter("uid");
            String category = req.getParameter("category");
            String state    = req.getParameter("state");
            String rto      = req.getParameter("rto");
            DrivingLicense dl = svc.applyForLicense(uid, category, state, rto);
            if (dl != null) {
                req.setAttribute("license", dl);
                req.setAttribute("success", "Application submitted. License No: " + dl.getLicenseNumber());
            } else {
                req.setAttribute("error", "UID not found in Aadhaar registry.");
            }
            req.getRequestDispatcher("/jsp/license/apply.jsp").forward(req, resp);

        } else if ("/result".equals(path)) {
            String licNum = req.getParameter("licenseNumber");
            String result = req.getParameter("result");
            boolean passed = "PASS".equals(result);
            DrivingLicense dl = svc.recordTestResult(licNum, passed);
            if (dl != null) {
                req.setAttribute("license", dl);
                req.setAttribute("success", "Test result recorded: " + result);
            } else {
                req.setAttribute("error", "License not found: " + licNum);
            }
            req.getRequestDispatcher("/jsp/license/result.jsp").forward(req, resp);
        }
    }
}
