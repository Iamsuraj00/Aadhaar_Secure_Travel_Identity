<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.aadhaar.model.DrivingLicense" %>
<%
   //------ String cp      = request.getContextPath();  --// IGNORE ---

    String success = (String) request.getAttribute("success");
    String error   = (String) request.getAttribute("error");
    DrivingLicense license = (DrivingLicense) request.getAttribute("license");
    String prefillUid = request.getParameter("uid") != null ? request.getParameter("uid") : "";
%>
<%@ include file="/jsp/common/header.jsp" %>

<div class="page-header">
  <div>
    <h1>Apply for Driving Licence</h1>
    <div class="breadcrumb"><span>License</span> / Apply</div>
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
    <h2>Application Submitted</h2>
    <span class="badge badge-pending" style="margin-left:auto"><%= license.getStatus() %></span>
  </div>
  <div class="info-grid">
    <div class="info-item"><div class="lbl">Licence Number</div><div class="val mono" style="font-size:1.1rem"><%= license.getLicenseNumber() %></div></div>
    <div class="info-item"><div class="lbl">Applicant</div><div class="val"><%= license.getHolderName() %></div></div>
    <div class="info-item"><div class="lbl">Vehicle Category</div><div class="val"><%= license.getVehicleCategory() %></div></div>
    <div class="info-item"><div class="lbl">Issuing RTO</div><div class="val"><%= license.getIssuingRTO() %></div></div>
  </div>
  <hr class="divider"/>
  <div style="background:rgba(255,152,0,0.07);border:1px solid rgba(255,152,0,0.25);border-radius:8px;padding:1.2rem">
    <div style="font-family:'Rajdhani',sans-serif;font-weight:700;color:var(--saffron);font-size:1rem;margin-bottom:0.5rem">📅 TEST SCHEDULE</div>
    <div class="info-grid">
      <div class="info-item"><div class="lbl">Test Date</div><div class="val"><%= license.getTestDate() %></div></div>
      <div class="info-item"><div class="lbl">Test Location</div><div class="val"><%= license.getTestLocation() %></div></div>
    </div>
  </div>
  <br/>
  <a href="<%= cp %>/license/result?licenseNumber=<%= license.getLicenseNumber() %>" class="btn btn-primary">📝 Record Test Result</a>
</div>
<% } %>

<div class="card">
  <div class="card-header">
    <div class="card-icon">🚗</div>
    <h2>New Licence Application via Aadhaar</h2>
  </div>
  <p style="color:var(--muted);font-size:0.9rem;margin-bottom:1.2rem">
    Citizen details are auto-fetched from the Aadhaar registration database using the UID. No manual entry required.
  </p>
  <form method="post" action="<%= cp %>/license/apply">
    <div class="form-grid">
      <div class="form-group full">
        <label>Aadhaar UID *</label>
        <input type="text" name="uid" placeholder="XXXX-XXXX-XXXX" value="<%= prefillUid %>" required/>
      </div>
      <div class="form-group">
        <label>Vehicle Category *</label>
        <select name="category" required>
          <option value="">Select Category</option>
          <option value="LMV">LMV — Light Motor Vehicle</option>
          <option value="HMV">HMV — Heavy Motor Vehicle</option>
          <option value="Motorcycle">Motorcycle (≤ 50cc)</option>
          <option value="Motorcycle>50cc">Motorcycle (> 50cc)</option>
          <option value="MCWG">MCWG — Motor Cycle With Gear</option>
          <option value="Transport">Transport Vehicle</option>
        </select>
      </div>
      <div class="form-group">
        <label>State Code *</label>
        <select name="state" required>
          <option value="">Select State</option>
          <option value="DL">DL — Delhi</option>
          <option value="MH">MH — Maharashtra</option>
          <option value="KA">KA — Karnataka</option>
          <option value="TN">TN — Tamil Nadu</option>
          <option value="UP">UP — Uttar Pradesh</option>
          <option value="GJ">GJ — Gujarat</option>
          <option value="RJ">RJ — Rajasthan</option>
          <option value="WB">WB — West Bengal</option>
          <option value="HP">HP — Himachal Pradesh</option>
          <option value="PB">PB — Punjab</option>
        </select>
      </div>
      <div class="form-group full">
        <label>RTO Office *</label>
        <input type="text" name="rto" placeholder="e.g. RTO Delhi-East" required/>
      </div>
    </div>
    <br/>
    <button type="submit" class="btn btn-primary">🚗 &nbsp;Submit Application</button>
    &nbsp;
    <button type="reset" class="btn btn-outline">↺ Reset</button>
  </form>
</div>

<%@ include file="/jsp/common/footer.jsp" %>

