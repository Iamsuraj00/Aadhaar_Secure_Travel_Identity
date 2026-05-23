<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.aadhaar.model.Passport, java.util.Collection" %>
<%
        Collection<Passport> passports = (Collection<Passport>) request.getAttribute("passports");
%>
<%@ include file="/jsp/common/header.jsp" %>

<div class="page-header">
  <div>
    <h1>All Passports</h1>
    <div class="breadcrumb"><span>Passport</span> / List</div>
  </div>
  <a href="<%= cp %>/passport/issue" class="btn btn-primary">➕ Issue New</a>
</div>

<div class="card">
  <div class="card-header">
    <div class="card-icon">📘</div>
    <h2>Passport Registry &nbsp;<span style="font-size:0.85rem;color:var(--muted);font-weight:400">(<%= passports.size() %> records)</span></h2>
  </div>
  <div class="table-wrap">
    <table>
      <thead>
        <tr>
          <th>Passport No.</th>
          <th>Linked UID</th>
          <th>Holder Name</th>
          <th>Nationality</th>
          <th>Issue Date</th>
          <th>Expiry Date</th>
          <th>Authority</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
        <% if (passports == null || passports.isEmpty()) { %>
        <tr><td colspan="8" style="text-align:center;color:var(--muted);padding:2rem">No passports issued yet.</td></tr>
        <% } else {
           for (Passport p : passports) {
               String badgeClass = p.getStatus() == Passport.PassportStatus.ACTIVE ? "badge-active" : "badge-danger";
        %>
        <tr>
          <td class="mono"><%= p.getPassportNumber() %></td>
          <td class="mono" style="font-size:0.8rem"><%= p.getUid() %></td>
          <td style="font-weight:600;color:var(--white)"><%= p.getHolderName() %></td>
          <td><%= p.getNationality() %></td>
          <td><%= p.getIssueDate() %></td>
          <td><%= p.getExpiryDate() %></td>
          <td style="color:var(--muted);font-size:0.85rem"><%= p.getIssuingAuthority() %></td>
          <td><span class="badge <%= badgeClass %>"><%= p.getStatus() %></span></td>
        </tr>
        <% } } %>
      </tbody>
    </table>
  </div>
</div>

<%@ include file="/jsp/common/footer.jsp" %>

