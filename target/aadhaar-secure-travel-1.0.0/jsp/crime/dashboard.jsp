<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.aadhaar.model.TravelAlert, java.util.Collection" %>
<%
        Collection<TravelAlert> alerts = (Collection<TravelAlert>) request.getAttribute("alerts");
    String revokeResult = (String) request.getAttribute("revokeResult");
    long activeCount = alerts != null ? alerts.stream().filter(TravelAlert::isActive).count() : 0;
    long stopCount   = alerts != null ? alerts.stream().filter(a -> a.isActive() && a.getAlertType() == TravelAlert.AlertType.STOP_TRAVEL).count() : 0;
    long traceCount  = alerts != null ? alerts.stream().filter(a -> a.isActive() && a.getAlertType() == TravelAlert.AlertType.TRACE).count() : 0;
    long watchCount  = alerts != null ? alerts.stream().filter(a -> a.isActive() && a.getAlertType() == TravelAlert.AlertType.WATCH).count() : 0;
%>
<%@ include file="/jsp/common/header.jsp" %>

<div class="page-header">
  <div>
    <h1>Crime Department Dashboard</h1>
    <div class="breadcrumb"><span>Crime Dept</span> / Travel Alerts</div>
  </div>
  <div style="display:flex;gap:0.75rem">
    <a href="<%= cp %>/crime/issue" class="btn btn-danger">⛔ Issue Alert</a>
    <a href="<%= cp %>/crime/trace" class="btn btn-outline">🔎 Trace Person</a>
  </div>
</div>

<% if (revokeResult != null) { %>
<div class="alert alert-success">✅ &nbsp;<%= revokeResult %></div>
<% } %>

<!-- Stats -->
<div class="stat-grid">
  <div class="stat-card danger">
    <div class="stat-value"><%= activeCount %></div>
    <div class="stat-label">Active Alerts</div>
  </div>
  <div class="stat-card danger">
    <div class="stat-value"><%= stopCount %></div>
    <div class="stat-label">Stop Travel</div>
  </div>
  <div class="stat-card">
    <div class="stat-value"><%= traceCount %></div>
    <div class="stat-label">Trace Active</div>
  </div>
  <div class="stat-card blue">
    <div class="stat-value"><%= watchCount %></div>
    <div class="stat-label">Watch List</div>
  </div>
</div>

<div class="card">
  <div class="card-header">
    <div class="card-icon">🚨</div>
    <h2>All Travel Alerts &nbsp;<span style="font-size:0.85rem;color:var(--muted);font-weight:400">(<%= alerts != null ? alerts.size() : 0 %> total)</span></h2>
  </div>
  <div class="table-wrap">
    <table>
      <thead>
        <tr>
          <th>Alert ID</th>
          <th>Person</th>
          <th>UID</th>
          <th>Passport No.</th>
          <th>Type</th>
          <th>Reason</th>
          <th>Issued By</th>
          <th>Date</th>
          <th>Status</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <% if (alerts == null || alerts.isEmpty()) { %>
        <tr><td colspan="10" style="text-align:center;color:var(--muted);padding:2rem">No alerts on record.</td></tr>
        <% } else {
           for (TravelAlert ta : alerts) {
               String typeBadge = "STOP_TRAVEL".equals(ta.getAlertType().toString()) ? "badge-blocked" :
                                  "TRACE".equals(ta.getAlertType().toString()) ? "badge-warn" : "badge-info";
        %>
        <tr>
          <td class="mono"><%= ta.getAlertId() %></td>
          <td style="font-weight:600;color:var(--white)"><%= ta.getPersonName() %></td>
          <td class="mono" style="font-size:0.78rem"><%= ta.getUid() %></td>
          <td class="mono" style="font-size:0.82rem"><%= ta.getPassportNumber() %></td>
          <td><span class="badge <%= typeBadge %>"><%= ta.getAlertType() %></span></td>
          <td style="color:var(--muted);font-size:0.85rem;max-width:160px;word-break:break-word"><%= ta.getReason() %></td>
          <td style="color:var(--muted);font-size:0.85rem"><%= ta.getIssuedBy() %></td>
          <td style="color:var(--muted)"><%= ta.getIssuedDate() %></td>
          <td>
            <% if (ta.isActive()) { %>
              <span class="badge badge-danger">Active</span>
            <% } else { %>
              <span class="badge" style="background:rgba(255,255,255,0.05);color:var(--muted);border:1px solid rgba(255,255,255,0.1)">Revoked</span>
            <% } %>
          </td>
          <td>
            <% if (ta.isActive()) { %>
            <a href="<%= cp %>/crime/revoke?id=<%= ta.getAlertId() %>"
               class="btn btn-outline btn-sm"
               onclick="return confirm('Revoke alert <%= ta.getAlertId() %>?')">Revoke</a>
            <% } else { %>
            <span style="color:var(--muted);font-size:0.8rem">—</span>
            <% } %>
          </td>
        </tr>
        <% } } %>
      </tbody>
    </table>
  </div>
</div>

<%@ include file="/jsp/common/footer.jsp" %>

