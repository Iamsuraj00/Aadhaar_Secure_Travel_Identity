<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.aadhaar.model.DrivingLicense" %>
<%
    String cp      = request.getContextPath();
    String success = (String) request.getAttribute("success");
    String error   = (String) request.getAttribute("error");
    DrivingLicense license = (DrivingLicense) request.getAttribute("license");
    String prefillLic = request.getParameter("licenseNumber") != null ? request.getParameter("licenseNumber") : "";
%>
<%@ include file="/jsp/common/header.jsp" %>

<div class="page-header">
  <div>
    <h1>Record Test Result</h1>
    <div class="breadcrumb"><span>License</span> / Test Result</div>
  </div>
  <a href="<%= cp %>/license/list" class="btn btn-outline">📋 All Licences</a>
</div>

<% if (success != null) { %>
<div class="alert alert-success">✅ &nbsp;<%= success %></div>
<% } %>
<% if (error != null) { %>
<div class="alert alert-error">❌ &nbsp;<%= error %></div>
<% } %>

<% if (license != null) { %>
<div class="card">
  <div class="card-header">
    <div class="card-icon">📋</div>
    <h2>Licence Status Updated</h2>
    <%
      String st = license.getStatus().toString();
      String badgeCls = "ISSUED".equals(st) ? "badge-active" : "DENIED".equals(st) ? "badge-danger" : "badge-pending";
    %>
    <span class="badge <%= badgeCls %>" style="margin-left:auto"><%= st %></span>
  </div>
  <div class="info-grid">
    <div class="info-item"><div class="lbl">Licence Number</div><div class="val mono"><%= license.getLicenseNumber() %></div></div>
    <div class="info-item"><div class="lbl">Holder</div><div class="val"><%= license.getHolderName() %></div></div>
    <div class="info-item"><div class="lbl">Vehicle Category</div><div class="val"><%= license.getVehicleCategory() %></div></div>
    <div class="info-item"><div class="lbl">Test Result</div>
      <div class="val">
        <% if ("PASS".equals(license.getTestResult())) { %>
          <span class="badge badge-active">✅ PASS</span>
        <% } else if ("FAIL".equals(license.getTestResult())) { %>
          <span class="badge badge-danger">❌ FAIL</span>
        <% } else { %>
          <span class="badge badge-pending">Pending</span>
        <% } %>
      </div>
    </div>
    <div class="info-item"><div class="lbl">Issuing RTO</div><div class="val"><%= license.getIssuingRTO() %></div></div>
    <div class="info-item"><div class="lbl">Issue Date</div><div class="val"><%= license.getIssueDate() %></div></div>
    <div class="info-item"><div class="lbl">Expiry Date</div><div class="val"><%= license.getExpiryDate() %></div></div>
  </div>
</div>
<% } %>

<div class="card">
  <div class="card-header">
    <div class="card-icon">📝</div>
    <h2>Enter Test Result</h2>
  </div>
  <form method="post" action="<%= cp %>/license/result">
    <div class="form-grid">
      <div class="form-group">
        <label>Licence Number *</label>
        <input type="text" name="licenseNumber" placeholder="DL-XX-YYYY-NNNNNN" value="<%= prefillLic %>" required/>
      </div>
      <div class="form-group">
        <label>Test Result *</label>
        <select name="result" required>
          <option value="">Select Result</option>
          <option value="PASS">✅ PASS — Issue Licence</option>
          <option value="FAIL">❌ FAIL — Deny Licence</option>
        </select>
      </div>
    </div>
    <br/>
    <button type="submit" class="btn btn-primary">📝 &nbsp;Record Result</button>
    &nbsp;
    <button type="reset" class="btn btn-outline">↺ Reset</button>
  </form>
</div>

<%@ include file="/jsp/common/footer.jsp" %>
