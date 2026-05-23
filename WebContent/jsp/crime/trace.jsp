<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.aadhaar.model.TravelAlert, java.util.List" %>
<%
   
    String query   = (String) request.getAttribute("query");
    String by      = (String) request.getAttribute("by");
    List<TravelAlert> results = (List<TravelAlert>) request.getAttribute("results");
%>
<%@ include file="/jsp/common/header.jsp" %>

<div class="page-header">
  <div>
    <h1>Trace Person</h1>
    <div class="breadcrumb"><span>Crime Dept</span> / Trace</div>
  </div>
  <a href="<%= cp %>/crime/dashboard" class="btn btn-outline">← Dashboard</a>
</div>

<div class="card">
  <div class="card-header">
    <div class="card-icon">🔎</div>
    <h2>Search Travel Alerts</h2>
  </div>
  <p style="color:var(--muted);font-size:0.9rem;margin-bottom:1.2rem">
    Search alerts by UID, passport number, or person name. Returns all associated travel alerts.
  </p>
  <form method="post" action="<%= cp %>/crime/trace">
    <div class="form-grid triple">
      <div class="form-group">
        <label>Search By</label>
        <select name="by" required>
          <option value="name" <%= "name".equals(by) ? "selected" : "" %>>Person Name</option>
          <option value="uid"  <%= "uid".equals(by)  ? "selected" : "" %>>Aadhaar UID</option>
          <option value="passport" <%= "passport".equals(by) ? "selected" : "" %>>Passport Number</option>
        </select>
      </div>
      <div class="form-group" style="grid-column:span 2">
        <label>Search Query *</label>
        <input type="text" name="query" placeholder="Enter UID / Passport No. / Name..." value="<%= query != null ? query : "" %>" required/>
      </div>
    </div>
    <br/>
    <button type="submit" class="btn btn-primary">🔎 &nbsp;Trace</button>
  </form>
</div>

<% if (results != null) { %>
<div class="card">
  <div class="card-header">
    <div class="card-icon">📋</div>
    <h2>Results for "<%= query %>"
      <span style="font-size:0.85rem;color:var(--muted);font-weight:400">(<%= results.size() %> found)</span>
    </h2>
  </div>
  <% if (results.isEmpty()) { %>
  <div class="alert alert-warn">⚠️ &nbsp;No travel alerts found for "<%= query %>"</div>
  <% } else { %>
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
        </tr>
      </thead>
      <tbody>
        <% for (TravelAlert ta : results) {
               String typeBadge = ta.getAlertType() == TravelAlert.AlertType.STOP_TRAVEL ? "badge-blocked" :
                                  ta.getAlertType() == TravelAlert.AlertType.TRACE ? "badge-warn" : "badge-info";
        %>
        <tr>
          <td class="mono"><%= ta.getAlertId() %></td>
          <td style="font-weight:600;color:var(--white)"><%= ta.getPersonName() %></td>
          <td class="mono" style="font-size:0.78rem"><%= ta.getUid() %></td>
          <td class="mono" style="font-size:0.82rem"><%= ta.getPassportNumber() %></td>
          <td><span class="badge <%= typeBadge %>"><%= ta.getAlertType() %></span></td>
          <td style="color:var(--muted);font-size:0.85rem;max-width:180px;word-break:break-word"><%= ta.getReason() %></td>
          <td style="color:var(--muted);font-size:0.85rem"><%= ta.getIssuedBy() %></td>
          <td style="color:var(--muted)"><%= ta.getIssuedDate() %></td>
          <td>
            <% if (ta.isActive()) { %>
              <span class="badge badge-danger">Active</span>
            <% } else { %>
              <span class="badge" style="background:rgba(255,255,255,0.05);color:var(--muted);border:1px solid rgba(255,255,255,0.1)">Revoked</span>
            <% } %>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>
  <% } %>
</div>
<% } %>

<%@ include file="/jsp/common/footer.jsp" %>

