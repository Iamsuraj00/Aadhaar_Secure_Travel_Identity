<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.aadhaar.model.*" %>
<%
   //------ String cp      = request.getContextPath();  --// IGNORE ---
    String error   = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
    Boolean blocked = (Boolean) request.getAttribute("blocked");
    Boolean cleared = (Boolean) request.getAttribute("cleared");
    Citizen citizen = (Citizen) request.getAttribute("citizen");
    Passport passport = (Passport) request.getAttribute("passport");
%>
<%@ include file="/jsp/common/header.jsp" %>

<div class="page-header">
  <div>
    <h1>Airport Travel Check</h1>
    <div class="breadcrumb"><span>Airport</span> / Passport Verification</div>
  </div>
</div>

<% if (Boolean.TRUE.equals(blocked)) { %>
<div class="alert alert-blocked pulse-danger">
  ⛔ &nbsp;TRAVEL BLOCKED — <%= message %>
</div>
<% if (citizen != null) { %>
<div class="card">
  <div class="card-header">
    <div class="card-icon" style="background:rgba(229,57,53,0.15);border-color:rgba(229,57,53,0.3)">🚨</div>
    <h2 style="color:#ef9a9a">Flagged Citizen Details</h2>
  </div>
  <div class="profile-grid">
    <div>
      <div class="profile-avatar" style="border-color:var(--danger);color:#ef9a9a"><%= citizen.getName().charAt(0) %></div>
    </div>
    <div class="info-grid">
      <div class="info-item"><div class="lbl">UID</div><div class="val mono"><%= citizen.getUid() %></div></div>
      <div class="info-item"><div class="lbl">Name</div><div class="val"><%= citizen.getName() %></div></div>
      <div class="info-item"><div class="lbl">Phone</div><div class="val"><%= citizen.getPhoneNumber() %></div></div>
      <div class="info-item"><div class="lbl">Travel Status</div><div class="val"><span class="badge badge-blocked">⛔ Blocked</span></div></div>
    </div>
  </div>
  <br/>
  <a href="<%= cp %>/crime/dashboard" class="btn btn-danger">🚨 View Crime Dept Alerts</a>
</div>
<% } %>
<% } else if (Boolean.TRUE.equals(cleared) && passport != null) { %>
<div class="alert alert-cleared">✅ &nbsp;TRAVEL CLEARED — Passport verified. Citizen may proceed.</div>
<div class="card">
  <div class="card-header">
    <div class="card-icon">✅</div>
    <h2>Passport Details Retrieved</h2>
    <span class="badge badge-active" style="margin-left:auto">CLEARED FOR TRAVEL</span>
  </div>
  <div class="profile-grid">
    <% if (citizen != null) { %>
    <div>
      <div class="profile-avatar"><%= citizen.getName().charAt(0) %></div>
    </div>
    <div>
    <% } else { %><div style="grid-column:1/-1"><% } %>
      <div class="uid-display"><%= passport.getPassportNumber() %></div>
      <br/>
      <div class="info-grid">
        <div class="info-item"><div class="lbl">Holder Name</div><div class="val" style="font-family:'Rajdhani',sans-serif;font-size:1.2rem;font-weight:700"><%= passport.getHolderName() %></div></div>
        <div class="info-item"><div class="lbl">Linked UID</div><div class="val mono"><%= passport.getUid() %></div></div>
        <div class="info-item"><div class="lbl">Nationality</div><div class="val"><%= passport.getNationality() %></div></div>
        <div class="info-item"><div class="lbl">Status</div><div class="val"><span class="badge badge-active"><%= passport.getStatus() %></span></div></div>
        <div class="info-item"><div class="lbl">Issue Date</div><div class="val"><%= passport.getIssueDate() %></div></div>
        <div class="info-item"><div class="lbl">Expiry Date</div><div class="val"><%= passport.getExpiryDate() %></div></div>
        <div class="info-item" style="grid-column:1/-1"><div class="lbl">Issuing Authority</div><div class="val"><%= passport.getIssuingAuthority() %></div></div>
      </div>
    </div>
  </div>
</div>
<% } %>

<% if (error != null) { %>
<div class="alert alert-error">❌ &nbsp;<%= error %></div>
<% } %>

<div class="card">
  <div class="card-header">
    <div class="card-icon">✈️</div>
    <h2>UID-Based Passport Check</h2>
  </div>
  <p style="color:var(--muted);font-size:0.9rem;margin-bottom:1.2rem">
    Airport staff enter the citizen's Aadhaar UID to retrieve passport details from the centralized server.
    System automatically checks for travel blocks. Airline is notified of every access.
  </p>
  <form method="post" action="<%= cp %>/airport/">
    <div class="form-grid">
      <div class="form-group">
        <label>Aadhaar UID *</label>
        <input type="text" name="uid" placeholder="XXXX-XXXX-XXXX" required/>
      </div>
      <div class="form-group">
        <label>Airline / Terminal ID *</label>
        <input type="text" name="airlineId" placeholder="e.g. AIR_INDIA_DEL_T3" required/>
      </div>
    </div>
    <br/>
    <button type="submit" class="btn btn-primary">✈️ &nbsp;Verify Travel Clearance</button>
  </form>
</div>

<!-- Quick test UIDs -->
<div class="card">
  <div class="card-header">
    <div class="card-icon">💡</div>
    <h2>Quick Test UIDs</h2>
  </div>
  <div style="display:flex;flex-wrap:wrap;gap:0.75rem">
    <div style="background:rgba(46,125,50,0.08);border:1px solid rgba(46,125,50,0.3);border-radius:6px;padding:10px 16px">
      <div style="font-family:'Rajdhani',sans-serif;font-size:0.72rem;letter-spacing:0.08em;color:#69f0ae;margin-bottom:2px">✅ CLEAR — ARJUN SHARMA</div>
      <div class="mono">1234-5678-9012</div>
    </div>
    <div style="background:rgba(46,125,50,0.08);border:1px solid rgba(46,125,50,0.3);border-radius:6px;padding:10px 16px">
      <div style="font-family:'Rajdhani',sans-serif;font-size:0.72rem;letter-spacing:0.08em;color:#69f0ae;margin-bottom:2px">✅ CLEAR — PRIYA MEHTA</div>
      <div class="mono">2345-6789-0123</div>
    </div>
    <div style="background:rgba(229,57,53,0.08);border:1px solid rgba(229,57,53,0.3);border-radius:6px;padding:10px 16px">
      <div style="font-family:'Rajdhani',sans-serif;font-size:0.72rem;letter-spacing:0.08em;color:#ef9a9a;margin-bottom:2px">⛔ BLOCKED — ROHIT VERMA</div>
      <div class="mono">3456-7890-1234</div>
    </div>
  </div>
</div>

<%@ include file="/jsp/common/footer.jsp" %>

