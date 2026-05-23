<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.aadhaar.service.*" %>
<%@ page import="com.aadhaar.model.TravelAlert" %>
<%
        CitizenService     citizenSvc = new CitizenService();
    PassportService    passportSvc = new PassportService();
    LicenseService     licenseSvc  = new LicenseService();
    CrimeDeptService   crimeSvc    = new CrimeDeptService();
    NotificationService notifSvc  = new NotificationService();

    int citizenCount  = citizenSvc.getAllCitizens().size();
    int passportCount = passportSvc.getAllPassports().size();
    int licenseCount  = licenseSvc.getAllLicenses().size();
    long alertCount   = crimeSvc.getAllAlerts().stream().filter(TravelAlert::isActive).count();
    int unreadNotifs  = notifSvc.countUnread();
%>
<%@ include file="/jsp/common/header.jsp" %>

<div class="hero">
  <div class="hero-badge">🇮🇳 &nbsp; Secure Identity Platform — MySQL Powered</div>
  <h1>Aadhaar <span>Secure</span><br/>Travel Identity</h1>
  <p>Centralized identity management for passports, driving licences, and travel security. All data persisted in MySQL.</p>
  <a href="<%= cp %>/citizen/register" class="btn btn-primary">➕ &nbsp; Register New Citizen</a>
  &nbsp;
  <a href="<%= cp %>/airport/" class="btn btn-outline">✈️ &nbsp; Airport Check</a>
</div>

<!-- Live Stats from MySQL -->
<div class="stat-grid">
  <div class="stat-card">
    <div class="stat-value"><%= citizenCount %></div>
    <div class="stat-label">Registered Citizens</div>
  </div>
  <div class="stat-card blue">
    <div class="stat-value"><%= passportCount %></div>
    <div class="stat-label">Passports Issued</div>
  </div>
  <div class="stat-card success">
    <div class="stat-value"><%= licenseCount %></div>
    <div class="stat-label">Driving Licences</div>
  </div>
  <div class="stat-card danger">
    <div class="stat-value"><%= alertCount %></div>
    <div class="stat-label">Active Travel Alerts</div>
  </div>
</div>

<% if (unreadNotifs > 0) { %>
<div class="alert alert-warn">
  🔔 &nbsp;You have <strong><%= unreadNotifs %></strong> unread notification(s).
  <a href="<%= cp %>/notifications" style="color:var(--saffron);margin-left:8px">View All →</a>
</div>
<% } %>

<!-- Modules -->
<div class="card">
  <div class="card-header">
    <div class="card-icon">🗂️</div>
    <h2>System Modules</h2>
  </div>
  <div class="module-grid">
    <a href="<%= cp %>/citizen/register" class="module-card">
      <div class="mc-icon">🪪</div>
      <div class="mc-title">Citizen Registration</div>
      <div class="mc-desc">Register citizens with unique Aadhaar UID + secure PIN stored in MySQL</div>
    </a>
    <a href="<%= cp %>/passport/issue" class="module-card">
      <div class="mc-icon">📘</div>
      <div class="mc-title">Passport Issuance</div>
      <div class="mc-desc">Link passport to UID — persisted in passports table</div>
    </a>
    <a href="<%= cp %>/airport/" class="module-card">
      <div class="mc-icon">✈️</div>
      <div class="mc-title">Airport Check</div>
      <div class="mc-desc">Real-time UID lookup against MySQL; blocks flagged travellers</div>
    </a>
    <a href="<%= cp %>/license/apply" class="module-card">
      <div class="mc-icon">🚗</div>
      <div class="mc-title">Driving Licence</div>
      <div class="mc-desc">Apply via Aadhaar; schedule test; result saved to DB</div>
    </a>
    <a href="<%= cp %>/crime/dashboard" class="module-card">
      <div class="mc-icon">🚨</div>
      <div class="mc-title">Crime Department</div>
      <div class="mc-desc">Issue STOP/TRACE/WATCH alerts — travel_blocked updated live in DB</div>
    </a>
    <a href="<%= cp %>/notifications" class="module-card">
      <div class="mc-icon">🔔</div>
      <div class="mc-title">Notifications
        <% if (unreadNotifs > 0) { %>
          <span style="background:var(--danger);color:#fff;border-radius:10px;
            font-size:0.7rem;padding:1px 7px;margin-left:6px"><%= unreadNotifs %></span>
        <% } %>
      </div>
      <div class="mc-desc">Airline + crime dept alerts stored and retrieved from MySQL</div>
    </a>
    <a href="<%= cp %>/passport/search" class="module-card">
      <div class="mc-icon">🔍</div>
      <div class="mc-title">Holder Search</div>
      <div class="mc-desc">SQL LIKE query on citizens + passports JOIN by name</div>
    </a>
    <a href="<%= cp %>/citizen/list" class="module-card">
      <div class="mc-icon">👥</div>
      <div class="mc-title">Citizen Registry</div>
      <div class="mc-desc">Full citizens table from MySQL with live status</div>
    </a>
  </div>
</div>

<!-- DB Info Card -->
<div class="card">
  <div class="card-header">
    <div class="card-icon">🗄️</div>
    <h2>Database Connection</h2>
    <span class="badge badge-active" style="margin-left:auto">MySQL Connected</span>
  </div>
  <div class="info-grid">
    <div class="info-item">
      <div class="lbl">Database</div>
      <div class="val mono">aadhaar_db</div>
    </div>
    <div class="info-item">
      <div class="lbl">Driver</div>
      <div class="val mono">com.mysql.cj.jdbc.Driver</div>
    </div>
    <div class="info-item">
      <div class="lbl">Tables</div>
      <div class="val mono">citizens · passports · driving_licenses · travel_alerts · notifications</div>
    </div>
    <div class="info-item">
      <div class="lbl">Config File</div>
      <div class="val mono">src/db.properties</div>
    </div>
  </div>
  <br/>
  <p style="font-size:0.82rem;color:var(--muted)">
    Edit <code style="background:rgba(255,255,255,0.07);padding:1px 6px;border-radius:4px">src/db.properties</code>
    to change host, port, username, or password before building.
  </p>
</div>

<%@ include file="/jsp/common/footer.jsp" %>

