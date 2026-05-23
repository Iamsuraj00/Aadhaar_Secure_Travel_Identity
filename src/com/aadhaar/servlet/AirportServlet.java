package com.aadhaar.servlet;

import com.aadhaar.model.*;
import com.aadhaar.service.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/airport/*")
public class AirportServlet extends HttpServlet {
    private final PassportService  passportSvc  = new PassportService();
    private final CitizenService   citizenSvc   = new CitizenService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/airport/check.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String uid       = req.getParameter("uid");
        String airlineId = req.getParameter("airlineId");

        Citizen citizen  = citizenSvc.getCitizenByUid(uid);
        if (citizen == null) {
            req.setAttribute("error", "No citizen found for UID: " + uid);
            req.getRequestDispatcher("/jsp/airport/check.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("citizen", citizen);

        if (citizen.isTravelBlocked()) {
            req.setAttribute("blocked", true);
            req.setAttribute("message", "⛔ TRAVEL BLOCKED — " + citizen.getName() +
                " is flagged by the Crime Department.");
        } else {
            Passport p = passportSvc.airportPassportCheck(uid, airlineId);
            if (p != null) {
                req.setAttribute("passport", p);
                req.setAttribute("cleared", true);
            } else {
                req.setAttribute("error", "No passport linked to this UID.");
            }
        }
        req.getRequestDispatcher("/jsp/airport/check.jsp").forward(req, resp);
    }
}
