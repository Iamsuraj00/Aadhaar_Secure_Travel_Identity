package com.aadhaar.servlet;

import com.aadhaar.model.Passport;
import com.aadhaar.service.PassportService;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.*;

@WebServlet("/passport/*")
public class PassportServlet extends HttpServlet {
    private final PassportService svc = new PassportService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/list";

        switch (path) {
            case "/issue":
                req.getRequestDispatcher("/jsp/passport/issue.jsp").forward(req, resp);
                break;
            case "/list":
                req.setAttribute("passports", svc.getAllPassports());
                req.getRequestDispatcher("/jsp/passport/list.jsp").forward(req, resp);
                break;
            case "/search":
                req.getRequestDispatcher("/jsp/passport/search.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/passport/list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();

        if ("/issue".equals(path)) {
            String uid    = req.getParameter("uid");
            String nat    = req.getParameter("nationality");
            String issued = req.getParameter("issueDate");
            String expiry = req.getParameter("expiryDate");
            String auth   = req.getParameter("authority");
            Passport p = svc.issuePassport(uid, nat, issued, expiry, auth);
            if (p != null) {
                req.setAttribute("passport", p);
                req.setAttribute("success", "Passport issued: " + p.getPassportNumber());
            } else {
                req.setAttribute("error", "Could not issue passport. UID not found or already exists.");
            }
            req.getRequestDispatcher("/jsp/passport/issue.jsp").forward(req, resp);

        } else if ("/search".equals(path)) {
            String name = req.getParameter("name");
            List<Map<String,String>> results = svc.searchHoldersByName(name);
            req.setAttribute("results", results);
            req.setAttribute("query", name);
            req.getRequestDispatcher("/jsp/passport/search.jsp").forward(req, resp);
        }
    }
}
