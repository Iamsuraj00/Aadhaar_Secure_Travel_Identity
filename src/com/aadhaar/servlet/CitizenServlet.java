package com.aadhaar.servlet;

import com.aadhaar.model.Citizen;
import com.aadhaar.service.CitizenService;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.Collection;

@WebServlet("/citizen/*")
public class CitizenServlet extends HttpServlet {
    private final CitizenService svc = new CitizenService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) path = "/";

        switch (path) {
            case "/register":
                req.getRequestDispatcher("/jsp/citizen/register.jsp").forward(req, resp);
                break;
            case "/list":
                Collection<Citizen> list = svc.getAllCitizens();
                req.setAttribute("citizens", list);
                req.getRequestDispatcher("/jsp/citizen/list.jsp").forward(req, resp);
                break;
            case "/profile":
                String uid = req.getParameter("uid");
                Citizen c = svc.getCitizenByUid(uid);
                req.setAttribute("citizen", c);
                req.getRequestDispatcher("/jsp/citizen/profile.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/citizen/list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/register".equals(path)) {
            String name  = req.getParameter("name");
            String dob   = req.getParameter("dob");
            String addr  = req.getParameter("address");
            String phone = req.getParameter("phone");
            String email = req.getParameter("email");
            String pin   = req.getParameter("pin");
            Citizen c = svc.registerCitizen(name, dob, addr, phone, email, pin);
            req.setAttribute("success", "Citizen registered! UID: " + c.getUid());
            req.setAttribute("citizen", c);
            req.getRequestDispatcher("/jsp/citizen/profile.jsp").forward(req, resp);
        } else if ("/verify".equals(path)) {
            String uid = req.getParameter("uid");
            String pin = req.getParameter("pin");
            boolean ok = svc.authenticate(uid, pin);
            req.setAttribute("authResult", ok);
            req.setAttribute("uid", uid);
            req.getRequestDispatcher("/jsp/citizen/verify.jsp").forward(req, resp);
        }
    }
}
