<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.aadhaar.model.Citizen" %>
<%
    String cp = request.getContextPath();
    String success = (String) request.getAttribute("success");
    String error   = (String) request.getAttribute("error");
    Citizen citizen = (Citizen) request.getAttribute("citizen");
%>
<%@ include file="/jsp/common/header.jsp" %>

<div class="page-header">
  <div>
    <h1>Register Citizen</h1>
    <div class="breadcrumb"><span>Citizens</span> / Register</div>
  </div>
  <a href="<%= cp %>/citizen/list" class="btn btn-outline">← All Citizens</a>
</div>

<% if (success != null) { %>
<div class="alert alert-success">✅ &nbsp;<%= success %></div>
<% } %>
<% if (error != null) { %>
<div class="alert alert-error">❌ &nbsp;<%= error %></div>
<% } %>

<% if (citizen != null) { %>
<!-- Show profile after registration -->
<div class="card">
  <div class="card-header">
    <div class="card-icon">🪪</div>
    <h2>Citizen Registered Successfully</h2>
  </div>
  <div class="profile-grid">
    <div>
      <div class="profile-avatar"><%= citizen.getName().charAt(0) %></div>
    </div>
    <div>
      <div class="uid-display"><%= citizen.getUid() %></div>
      <br/>
      <div class="info-grid">
        <div class="info-item"><div class="lbl">Full Name</div><div class="val"><%= citizen.getName() %></div></div>
        <div class="info-item"><div class="lbl">Date of Birth</div><div class="val"><%= citizen.getDateOfBirth() %></div></div>
        <div class="info-item"><div class="lbl">Phone</div><div class="val"><%= citizen.getPhoneNumber() %></div></div>
        <div class="info-item"><div class="lbl">Email</div><div class="val"><%= citizen.getEmail() %></div></div>
        <div class="info-item" style="grid-column:1/-1"><div class="lbl">Address</div><div class="val"><%= citizen.getAddress() %></div></div>
      </div>
      <br/>
      <a href="<%= cp %>/passport/issue?uid=<%= citizen.getUid() %>" class="btn btn-primary">📘 Issue Passport</a>
      &nbsp;
      <a href="<%= cp %>/license/apply?uid=<%= citizen.getUid() %>" class="btn btn-outline">🚗 Apply for Licence</a>
    </div>
  </div>
</div>
<% } %>

<div class="card">
  <div class="card-header">
    <div class="card-icon">➕</div>
    <h2>New Citizen Registration</h2>
  </div>
  <form method="post" action="<%= cp %>/citizen/register">
    <div class="form-grid">
      <div class="form-group full">
        <label>Full Name *</label>
        <input type="text" name="name" placeholder="e.g. Rahul Kumar Singh" required/>
      </div>
      <div class="form-group">
        <label>Date of Birth *</label>
        <input type="date" name="dob" required/>
      </div>
      <div class="form-group">
        <label>Phone Number *</label>
        <input type="tel" name="phone" placeholder="10-digit mobile number" maxlength="10" required/>
      </div>
      <div class="form-group">
        <label>Email Address</label>
        <input type="email" name="email" placeholder="citizen@example.com"/>
      </div>
      <div class="form-group">
        <label>4-Digit PIN *</label>
        <input type="password" name="pin" placeholder="••••" maxlength="4" pattern="[0-9]{4}" required/>
      </div>
      <div class="form-group full">
        <label>Residential Address *</label>
        <textarea name="address" placeholder="House No, Street, City, State, PIN Code" required></textarea>
      </div>
    </div>
    <br/>
    <button type="submit" class="btn btn-primary">🪪 &nbsp; Register Citizen</button>
    &nbsp;
    <button type="reset" class="btn btn-outline">↺ Reset</button>
  </form>
</div>

<%@ include file="/jsp/common/footer.jsp" %>
