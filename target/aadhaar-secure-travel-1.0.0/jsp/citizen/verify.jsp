<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.aadhaar.model.Citizen, com.aadhaar.service.CitizenService" %>
<%
        Boolean authResult = (Boolean) request.getAttribute("authResult");
    String uid = (String) request.getAttribute("uid");
    CitizenService svc = new CitizenService();
    Citizen citizen = uid != null ? svc.getCitizenByUid(uid) : null;
%>
<%@ include file="/jsp/common/header.jsp" %>

<div class="page-header">
  <div>
    <h1>Identity Verification</h1>
    <div class="breadcrumb"><span>Citizens</span> / Verify PIN</div>
  </div>
  <a href="<%= cp %>/citizen/list" class="btn btn-outline">← Back</a>
</div>

<div class="card">
  <div class="card-header">
    <div class="card-icon">🔐</div>
    <h2>PIN Verification Result</h2>
  </div>
  <% if (authResult != null) { %>
    <% if (authResult) { %>
    <div class="alert alert-cleared">
      ✅ &nbsp;IDENTITY VERIFIED — PIN authenticated successfully for UID: <%= uid %>
    </div>
    <% if (citizen != null) { %>
    <div class="info-grid" style="margin-top:1rem">
      <div class="info-item"><div class="lbl">UID</div><div class="val mono"><%= citizen.getUid() %></div></div>
      <div class="info-item"><div class="lbl">Name</div><div class="val"><%= citizen.getName() %></div></div>
    </div>
    <% } %>
    <% } else { %>
    <div class="alert alert-blocked">❌ &nbsp;AUTHENTICATION FAILED — Incorrect PIN for UID: <%= uid %></div>
    <% } %>
  <% } %>
  <br/>
  <a href="<%= cp %>/citizen/profile?uid=<%= uid %>" class="btn btn-outline">← Back to Profile</a>
</div>

<%@ include file="/jsp/common/footer.jsp" %>

