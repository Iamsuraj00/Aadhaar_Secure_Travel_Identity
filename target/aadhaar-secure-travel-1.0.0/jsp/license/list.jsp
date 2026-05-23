<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.aadhaar.model.DrivingLicense, java.util.Collection" %>
<%
        Collection<DrivingLicense> licenses = (Collection<DrivingLicense>) request.getAttribute("licenses");
%>
<%@ include file="/jsp/common/header.jsp" %>

<div class="page-header">
  <div>
    <h1>All Driving Licences</h1>
    <div class="breadcrumb"><span>License</span> / List</div>
  </div>
  <a href="<%= cp %>/license/apply" class="btn btn-primary">➕ Apply New</a>
</div>

<div class="card">
  <div class="card-header">
    <div class="card-icon">🚗</div>
    <h2>Licence Registry &nbsp;<span style="font-size:0.85rem;color:var(--muted);font-weight:400">(<%= licenses.size() %> records)</span></h2>
  </div>
  <div class="table-wrap">
    <table>
      <thead>
        <tr>
          <th>Licence No.</th>
          <th>Linked UID</th>
          <th>Holder Name</th>
          <th>Category</th>
          <th>RTO</th>
          <th>Test Date</th>
          <th>Result</th>
          <th>Status</th>
          <th>Expiry</th>
        </tr>
      </thead>
      <tbody>
        <% if (licenses == null || licenses.isEmpty()) { %>
        <tr><td colspan="9" style="text-align:center;color:var(--muted);padding:2rem">No licences on record.</td></tr>
        <% } else {
           for (DrivingLicense dl : licenses) {
               String st = dl.getStatus().toString();
               String badgeCls = "ISSUED".equals(st) ? "badge-active" :
                                 "DENIED".equals(st) ? "badge-danger" :
                                 "PENDING".equals(st) ? "badge-pending" : "badge-warn";
        %>
        <tr>
          <td class="mono" style="font-size:0.8rem"><%= dl.getLicenseNumber() %></td>
          <td class="mono" style="font-size:0.78rem"><%= dl.getUid() %></td>
          <td style="font-weight:600;color:var(--white)"><%= dl.getHolderName() %></td>
          <td><span class="badge badge-info"><%= dl.getVehicleCategory() %></span></td>
          <td style="color:var(--muted);font-size:0.85rem"><%= dl.getIssuingRTO() %></td>
          <td style="color:var(--muted)"><%= dl.getTestDate() != null ? dl.getTestDate() : "—" %></td>
          <td>
            <% if ("PASS".equals(dl.getTestResult())) { %>
              <span class="badge badge-active">PASS</span>
            <% } else if ("FAIL".equals(dl.getTestResult())) { %>
              <span class="badge badge-danger">FAIL</span>
            <% } else { %>
              <span style="color:var(--muted)">—</span>
            <% } %>
          </td>
          <td><span class="badge <%= badgeCls %>"><%= st %></span></td>
          <td style="color:var(--muted)"><%= dl.getExpiryDate() %></td>
        </tr>
        <% } } %>
      </tbody>
    </table>
  </div>
</div>

<%@ include file="/jsp/common/footer.jsp" %>

