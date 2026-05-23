<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.aadhaar.model.Citizen, java.util.Collection" %>
<%
    String cp = request.getContextPath();
    Collection<Citizen> citizens = (Collection<Citizen>) request.getAttribute("citizens");
%>
<%@ include file="/jsp/common/header.jsp" %>

<div class="page-header">
  <div>
    <h1>Citizen Registry</h1>
    <div class="breadcrumb"><span>Citizens</span> / All</div>
  </div>
  <a href="<%= cp %>/citizen/register" class="btn btn-primary">➕ Register New</a>
</div>

<div class="card">
  <div class="card-header">
    <div class="card-icon">👥</div>
    <h2>Registered Citizens &nbsp;<span style="font-size:0.85rem;color:var(--muted);font-weight:400">(<%= citizens.size() %> total)</span></h2>
  </div>
  <div class="table-wrap">
    <table>
      <thead>
        <tr>
          <th>UID</th>
          <th>Name</th>
          <th>Date of Birth</th>
          <th>Phone</th>
          <th>Email</th>
          <th>Travel Status</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <% if (citizens == null || citizens.isEmpty()) { %>
        <tr><td colspan="7" style="text-align:center;color:var(--muted);padding:2rem">No citizens registered yet.</td></tr>
        <% } else {
           for (Citizen c : citizens) { %>
        <tr>
          <td class="mono"><%= c.getUid() %></td>
          <td style="font-weight:600;color:var(--white)">
            <span style="display:inline-flex;align-items:center;gap:8px">
              <span style="width:28px;height:28px;border-radius:50%;background:rgba(255,153,51,0.15);
                border:1px solid rgba(255,153,51,0.3);display:inline-flex;align-items:center;
                justify-content:center;font-family:'Rajdhani',sans-serif;font-weight:700;
                color:var(--saffron);font-size:0.8rem">
                <%= c.getName().charAt(0) %>
              </span>
              <%= c.getName() %>
            </span>
          </td>
          <td><%= c.getDateOfBirth() %></td>
          <td><%= c.getPhoneNumber() %></td>
          <td style="color:var(--muted)"><%= c.getEmail() %></td>
          <td>
            <% if (c.isTravelBlocked()) { %>
              <span class="badge badge-blocked">⛔ Blocked</span>
            <% } else { %>
              <span class="badge badge-active">✅ Clear</span>
            <% } %>
          </td>
          <td>
            <a href="<%= cp %>/citizen/profile?uid=<%= c.getUid() %>" class="btn btn-outline btn-sm">View</a>
          </td>
        </tr>
        <% } } %>
      </tbody>
    </table>
  </div>
</div>

<%@ include file="/jsp/common/footer.jsp" %>
