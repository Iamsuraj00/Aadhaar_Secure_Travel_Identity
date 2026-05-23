package com.aadhaar.servlet;

import com.aadhaar.service.NotificationService;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {
    private final NotificationService svc = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("notifications", svc.getAllNotifications());
        req.getRequestDispatcher("/jsp/common/notifications.jsp").forward(req, resp);
    }
}
