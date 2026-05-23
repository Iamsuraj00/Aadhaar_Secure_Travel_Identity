<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.aadhaar.model.Passport" %>
<%
    String cp      = request.getContextPath();
    String success = (String) request.getAttribute("success");
    String error   = (String) request.getAttribute("error");
    Passport passport = (Passport) request.getAttribute("passport");
    String prefillUid = request.getParameter("uid") != null ? request.getParameter("uid") : "";
%>
<%@ include file="/jsp/common/header.jsp" %>

<div class="page-header">
  <div>
    <h1>Issue Passport</h1>
    <div class="breadcrumb"><span>Passport</span> / Issue</div>
  </div>
  <a href="<%= cp %>/passport/list" class="btn btn-outline">📋 All Passports</a>
</div>

<% if (success != null) { %>
<div class="alert alert-success">✅ &nbsp;<%= success %></div>
<% } %>
<% if (error != null) { %>
<div class="alert alert-error">❌ &nbsp;<%= error %></div>
<% } %>

<% if (passport != null) { %>
<div class="card">
  <div class="card-header">
    <div class="card-icon">📘</div>
    <h2>Passport Issued</h2>
    <span class="badge badge-active" style="margin-left:auto"><%= passport.getStatus() %></span>
  </div>
  <div class="info-grid">
    <div class="info-item"><div class="lbl">Passport Number</div><div class="val mono" style="font-size:1.3rem"><%= passport.getPassportNumber() %></div></div>
    <div class="info-item"><div class="lbl">Linked UID</div><div class="val mono"><%= passport.getUid() %></div></div>
    <div class="info-item"><div class="lbl">Holder Name</div><div class="val"><%= passport.getHolderName() %></div></div>
    <div class="info-item"><div class="lbl">Nationality</div><div class="val"><%= passport.getNationality() %></div></div>
    <div class="info-item"><div class="lbl">Issue Date</div><div class="val"><%= passport.getIssueDate() %></div></div>
    <div class="info-item"><div class="lbl">Expiry Date</div><div class="val"><%= passport.getExpiryDate() %></div></div>
    <div class="info-item" style="grid-column:1/-1"><div class="lbl">Issuing Authority</div><div class="val"><%= passport.getIssuingAuthority() %></div></div>
  </div>
</div>
<% } %>

<div class="card">
  <div class="card-header">
    <div class="card-icon">➕</div>
    <h2>Link Passport to Aadhaar UID</h2>
  </div>
  <form method="post" action="<%= cp %>/passport/issue">
    <div class="form-grid">
      <div class="form-group full">
        <label>Aadhaar UID *</label>
        <input type="text" name="uid" placeholder="XXXX-XXXX-XXXX" value="<%= prefillUid %>" required/>
      </div>
      <div class="form-group">
        <label>Nationality *</label>
        <select name="nationality" required>
          <option value="Indian" selected>Indian</option>
          <option value="NRI">NRI</option>
          <option value="PIO">PIO</option>
        </select>
      </div>
      <div class="form-group">
        <label>Issuing Authority *</label>
        <input type="text" name="authority" placeholder="e.g. PSK New Delhi" required/>
      </div>
      <div class="form-group">
        <label>Issue Date *</label>
        <input type="date" name="issueDate" required/>
      </div>
      <div class="form-group">
        <label>Expiry Date *</label>
        <input type="date" name="expiryDate" required/>
      </div>
    </div>
    <br/>
    <button type="submit" class="btn btn-primary">📘 Issue Passport</button>
    &nbsp;
    <button type="reset" class="btn btn-outline">↺ Reset</button>
  </form>
</div>

<%@ include file="/jsp/common/footer.jsp" %>
