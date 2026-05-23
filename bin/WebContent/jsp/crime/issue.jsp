<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.aadhaar.model.TravelAlert" %>
<%
    String cp      = request.getContextPath();
    String success = (String) request.getAttribute("success");
    String error   = (String) request.getAttribute("error");
    TravelAlert alert = (TravelAlert) request.getAttribute("alert");
%>
<%@ include file="/jsp/common/header.jsp" %>

<div class="page-header">
  <div>
    <h1>Issue Travel Alert</h1>
    <div class="breadcrumb"><span>Crime Dept</span> / Issue Alert</div>
  </div>
  <a href="<%= cp %>/crime/dashboard" class="btn btn-outline">← Dashboard</a>
</div>

<% if (success != null) { %>
<div class="alert alert-success">✅ &nbsp;<%= success %></div>
<% } %>
<% if (error != null) { %>
<div class="alert alert-error">❌ &nbsp;<%= error %></div>
<% } %>

<% if (alert != null) { %>
<div class="card">
  <div class="card-header">
    <div class="card-icon">🚨</div>
    <h2>Alert Issued</h2>
    <%
      String typeBadge = alert.getAlertType() == TravelAlert.AlertType.STOP_TRAVEL ? "badge-blocked" :
                         alert.getAlertType() == TravelAlert.AlertType.TRACE ? "badge-warn" : "badge-info";
    %>
    <span class="badge <%= typeBadge %>" style="margin-left:auto"><%= alert.getAlertType() %></span>
  </div>
  <div class="info-grid">
    <div class="info-item"><div class="lbl">Alert ID</div><div class="val mono"><%= alert.getAlertId() %></div></div>
    <div class="info-item"><div class="lbl">Person</div><div class="val"><%= alert.getPersonName() %></div></div>
    <div class="info-item"><div class="lbl">UID</div><div class="val mono"><%= alert.getUid() %></div></div>
    <div class="info-item"><div class="lbl">Passport</div><div class="val mono"><%= alert.getPassportNumber() %></div></div>
    <div class="info-item"><div class="lbl">Issued By</div><div class="val"><%= alert.getIssuedBy() %></div></div>
    <div class="info-item"><div class="lbl">Date</div><div class="val"><%= alert.getIssuedDate() %></div></div>
    <div class="info-item" style="grid-column:1/-1"><div class="lbl">Reason</div><div class="val"><%= alert.getReason() %></div></div>
  </div>
</div>
<% } %>

<div class="card">
  <div class="card-header">
    <div class="card-icon">⛔</div>
    <h2>New Travel Alert</h2>
  </div>
  <p style="color:var(--muted);font-size:0.9rem;margin-bottom:1.2rem">
    Issue a STOP TRAVEL, TRACE, or WATCH alert by UID or Passport Number. STOP TRAVEL immediately blocks the citizen at airport checks.
  </p>
  <form method="post" action="<%= cp %>/crime/issue">
    <div class="form-grid">
      <div class="form-group">
        <label>Aadhaar UID (or leave blank)</label>
        <input type="text" name="uid" placeholder="XXXX-XXXX-XXXX"/>
      </div>
      <div class="form-group">
        <label>Passport Number (alternative)</label>
        <input type="text" name="passport" placeholder="e.g. P1234567"/>
      </div>
      <div class="form-group">
        <label>Alert Type *</label>
        <select name="alertType" required>
          <option value="">Select Type</option>
          <option value="STOP_TRAVEL">⛔ STOP TRAVEL — Block international travel</option>
          <option value="TRACE">🔎 TRACE — Monitor travel activity</option>
          <option value="WATCH">👁️ WATCH — Add to watch list (allow travel)</option>
        </select>
      </div>
      <div class="form-group">
        <label>Issued By *</label>
        <input type="text" name="issuedBy" placeholder="e.g. CBI HQ, ED Mumbai" required/>
      </div>
      <div class="form-group full">
        <label>Reason / Justification *</label>
        <textarea name="reason" placeholder="Describe the legal basis or offence..." required></textarea>
      </div>
    </div>
    <br/>
    <button type="submit" class="btn btn-danger">⛔ &nbsp;Issue Alert</button>
    &nbsp;
    <a href="<%= cp %>/crime/dashboard" class="btn btn-outline">Cancel</a>
  </form>
</div>

<%@ include file="/jsp/common/footer.jsp" %>
