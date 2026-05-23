<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.aadhaar.model.Notification, java.util.List" %>
<%
        List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
    long airlineCount   = notifications != null ? notifications.stream().filter(n -> "AIRLINE".equals(n.getRecipientType())).count() : 0;
    long crimeCount     = notifications != null ? notifications.stream().filter(n -> "CRIME_DEPT".equals(n.getRecipientType())).count() : 0;
    long unreadCount    = notifications != null ? notifications.stream().filter(n -> !n.isRead()).count() : 0;
%>
<%@ include file="/jsp/common/header.jsp" %>

<div class="page-header">
  <div>
    <h1>System Notifications</h1>
    <div class="breadcrumb"><span>System</span> / Notifications</div>
  </div>
</div>

<div class="stat-grid">
  <div class="stat-card">
    <div class="stat-value"><%= notifications != null ? notifications.size() : 0 %></div>
    <div class="stat-label">Total Notifications</div>
  </div>
  <div class="stat-card danger">
    <div class="stat-value"><%= unreadCount %></div>
    <div class="stat-label">Unread</div>
  </div>
  <div class="stat-card blue">
    <div class="stat-value"><%= airlineCount %></div>
    <div class="stat-label">Airline Alerts</div>
  </div>
  <div class="stat-card">
    <div class="stat-value"><%= crimeCount %></div>
    <div class="stat-label">Crime Dept Alerts</div>
  </div>
</div>

<div class="card">
  <div class="card-header">
    <div class="card-icon">🔔</div>
    <h2>All Notifications &nbsp;
      <span style="font-size:0.85rem;color:var(--muted);font-weight:400">
        (most recent first)
      </span>
    </h2>
  </div>
  <div class="table-wrap">
    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Recipient</th>
          <th>Type</th>
          <th>Message</th>
          <th>Timestamp</th>
          <th>Read</th>
        </tr>
      </thead>
      <tbody>
        <% if (notifications == null || notifications.isEmpty()) { %>
        <tr><td colspan="6" style="text-align:center;color:var(--muted);padding:2rem">No notifications yet.</td></tr>
        <% } else {
           for (Notification n : notifications) {
               String typeCls = "AIRLINE".equals(n.getRecipientType()) ? "badge-info" : "badge-warn";
        %>
        <tr style="<%= !n.isRead() ? "background:rgba(255,153,51,0.03);" : "" %>">
          <td class="mono" style="font-size:0.78rem"><%= n.getNotificationId() %></td>
          <td style="font-weight:600;color:var(--white)"><%= n.getRecipientId() %></td>
          <td><span class="badge <%= typeCls %>"><%= n.getRecipientType() %></span></td>
          <td style="color:<%= n.getMessage().contains("BLOCKED") ? "#ef9a9a" : "#c8d8ee" %>;max-width:320px;word-break:break-word">
            <%= n.getMessage() %>
          </td>
          <td class="mono" style="font-size:0.8rem;color:var(--muted)"><%= n.getTimestamp() %></td>
          <td>
            <% if (n.isRead()) { %>
              <span style="color:var(--muted);font-size:0.8rem">Read</span>
            <% } else { %>
              <span class="badge badge-active" style="font-size:0.65rem">New</span>
            <% } %>
          </td>
        </tr>
        <% } } %>
      </tbody>
    </table>
  </div>
</div>

<%@ include file="/jsp/common/footer.jsp" %>

