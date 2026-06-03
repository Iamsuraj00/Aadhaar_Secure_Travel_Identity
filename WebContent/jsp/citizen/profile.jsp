<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.aadhaar.model.*" %>
<%@ page import="com.aadhaar.service.*" %>
<%
    Citizen citizen = (Citizen) request.getAttribute("citizen");
    String success  = (String)  request.getAttribute("success");

    if (citizen == null) {
        response.sendRedirect(request.getContextPath() + "/citizen/list");
        return;
    }

    PassportService passportSvc = new PassportService();
    LicenseService  licenseSvc  = new LicenseService();

    Passport       passport = passportSvc.getPassportByUid(citizen.getUid());
    DrivingLicense license  = licenseSvc.getLicenseByUid(citizen.getUid());
%>
<%@ include file="/jsp/common/header.jsp" %>

<div class="page-header">
  <div>
    <h1>Citizen Profile</h1>
    <div class="breadcrumb"><span>Citizens</span> / <%= citizen.getName() %></div>
  </div>
  <a href="<%= cp %>/citizen/list" class="btn btn-outline">← Back</a>
</div>

<% if (success != null) { %>
<div class="alert alert-success">✅ &nbsp;<%= success %></div>
<% } %>

<div class="card">
  <div class="card-header">
    <div class="card-icon">🪪</div>
    <h2>Identity Details</h2>
    <% if (citizen.isTravelBlocked()) { %>
      <span class="badge badge-blocked pulse-danger" style="margin-left:auto">⛔ Travel Blocked</span>
    <% } else { %>
      <span class="badge badge-active" style="margin-left:auto">✅ Travel Clear</span>
    <% } %>
  </div>
  <div class="profile-grid">
    <div>
      <div class="profile-avatar"><%= citizen.getName().charAt(0) %></div>
      <br/>
      <div style="text-align:center;font-size:0.72rem;color:var(--muted)">Aadhaar UID</div>
      <div class="uid-display" style="font-size:1rem;padding:6px 10px;margin-top:4px">
        <%= citizen.getUid() %>
      </div>
    </div>
    <div>
      <div class="info-grid">
        <div class="info-item">
          <div class="lbl">Full Name</div>
          <div class="val" style="font-size:1.2rem;font-family:'Rajdhani',sans-serif;font-weight:700">
            <%= citizen.getName() %>
          </div>
        </div>
        <div class="info-item">
          <div class="lbl">Date of Birth</div>
          <div class="val"><%= citizen.getDateOfBirth() %></div>
        </div>
        <div class="info-item">
          <div class="lbl">Phone</div>
          <div class="val"><%= citizen.getPhoneNumber() %></div>
        </div>
        <div class="info-item">
          <div class="lbl">Email</div>
          <div class="val"><%= citizen.getEmail() %></div>
        </div>
        <div class="info-item" style="grid-column:1/-1">
          <div class="lbl">Address</div>
          <div class="val"><%= citizen.getAddress() %></div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Linked Passport -->
<div class="card">
  <div class="card-header">
    <div class="card-icon">📘</div>
    <h2>Linked Passport</h2>
  </div>
  <% if (passport != null) { %>
  <div class="info-grid">
    <div class="info-item">
      <div class="lbl">Passport Number</div>
      <div class="val mono"><%= passport.getPassportNumber() %></div>
    </div>
    <div class="info-item">
      <div class="lbl">Nationality</div>
      <div class="val"><%= passport.getNationality() %></div>
    </div>
    <div class="info-item">
      <div class="lbl">Issue Date</div>
      <div class="val"><%= passport.getIssueDate() %></div>
    </div>
    <div class="info-item">
      <div class="lbl">Expiry Date</div>
      <div class="val"><%= passport.getExpiryDate() %></div>
    </div>
    <div class="info-item">
      <div class="lbl">Issuing Authority</div>
      <div class="val"><%= passport.getIssuingAuthority() %></div>
    </div>
    <div class="info-item">
      <div class="lbl">Status</div>
      <div class="val">
        <span class="badge <%= passport.getStatus() == Passport.PassportStatus.ACTIVE ? "badge-active" : "badge-danger" %>">
          <%= passport.getStatus() %>
        </span>
      </div>
    </div>
  </div>
  <% } else { %>
  <div style="color:var(--muted);padding:1rem 0">No passport linked.
    <a href="<%= cp %>/passport/issue?uid=<%= citizen.getUid() %>"
       class="btn btn-primary btn-sm" style="margin-left:12px">📘 Issue Passport</a>
  </div>
  <% } %>
</div>

<!-- Linked Licence -->
<div class="card">
  <div class="card-header">
    <div class="card-icon">🚗</div>
    <h2>Driving Licence</h2>
  </div>
  <% if (license != null) { %>
  <div class="info-grid">
    <div class="info-item">
      <div class="lbl">Licence Number</div>
      <div class="val mono"><%= license.getLicenseNumber() %></div>
    </div>
    <div class="info-item">
      <div class="lbl">Vehicle Category</div>
      <div class="val"><%= license.getVehicleCategory() %></div>
    </div>
    <div class="info-item">
      <div class="lbl">Issue Date</div>
      <div class="val"><%= license.getIssueDate() %></div>
    </div>
    <div class="info-item">
      <div class="lbl">Expiry Date</div>
      <div class="val"><%= license.getExpiryDate() %></div>
    </div>
    <div class="info-item">
      <div class="lbl">Issuing RTO</div>
      <div class="val"><%= license.getIssuingRTO() %></div>
    </div>
    <div class="info-item">
      <div class="lbl">Status</div>
      <div class="val">
        <%
          String ls = license.getStatus().toString();
          String lbadge = "ISSUED".equals(ls) ? "badge-active" :
                          "DENIED".equals(ls) ? "badge-danger" :
                          "PENDING".equals(ls) ? "badge-pending" : "badge-info";
        %>
        <span class="badge <%= lbadge %>"><%= ls %></span>
      </div>
    </div>
    <% if (license.getTestDate() != null) { %>
    <div class="info-item">
      <div class="lbl">Test Date</div>
      <div class="val"><%= license.getTestDate() %></div>
    </div>
    <div class="info-item">
      <div class="lbl">Test Result</div>
      <div class="val"><%= license.getTestResult() != null ? license.getTestResult() : "Pending" %></div>
    </div>
    <% } %>
  </div>
  <% } else { %>
  <div style="color:var(--muted);padding:1rem 0">No driving licence on record.
    <a href="<%= cp %>/license/apply?uid=<%= citizen.getUid() %>"
       class="btn btn-primary btn-sm" style="margin-left:12px">🚗 Apply</a>
  </div>
  <% } %>
</div>

<!-- PIN Verify -->
<div class="card">
  <div class="card-header">
    <div class="card-icon">🔐</div>
    <h2>Verify Identity PIN</h2>
  </div>
  <form method="post" action="<%= cp %>/citizen/verify"
        style="display:flex;gap:1rem;align-items:flex-end">
    <input type="hidden" name="uid" value="<%= citizen.getUid() %>"/>
    <div class="form-group" style="flex:1">
      <label>Enter PIN</label>
      <input type="password" name="pin" placeholder="4-digit PIN"
             maxlength="4" pattern="[0-9]{4}" required/>
    </div>
    <button type="submit" class="btn btn-primary">🔐 Verify</button>
  </form>
</div>

<%@ include file="/jsp/common/footer.jsp" %>