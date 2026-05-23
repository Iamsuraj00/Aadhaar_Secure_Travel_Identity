<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
   //------ String cp      = request.getContextPath();  --// IGNORE ---
    String query   = (String) request.getAttribute("query");
    List<Map<String,String>> results = (List<Map<String,String>>) request.getAttribute("results");
%>
<%@ include file="/jsp/common/header.jsp" %>

<div class="page-header">
  <div>
    <h1>Search Passport Holders</h1>
    <div class="breadcrumb"><span>Passport</span> / Search</div>
  </div>
</div>

<div class="card">
  <div class="card-header">
    <div class="card-icon">🔍</div>
    <h2>Search by Name</h2>
  </div>
  <p style="color:var(--muted);margin-bottom:1rem;font-size:0.9rem">
    Search citizens who hold a passport. Returns name, UID, passport number and photo preview path — used by Crime Department for identification.
  </p>
  <form method="post" action="<%= cp %>/passport/search" style="display:flex;gap:1rem;align-items:flex-end">
    <div class="form-group" style="flex:1">
      <label>Citizen Name</label>
      <input type="text" name="name" placeholder="Enter full or partial name..." value="<%= query != null ? query : "" %>" required/>
    </div>
    <button type="submit" class="btn btn-primary">🔍 &nbsp;Search</button>
  </form>
</div>

<% if (results != null) { %>
<div class="card">
  <div class="card-header">
    <div class="card-icon">📋</div>
    <h2>Results for "<%= query %>" &nbsp;
      <span style="font-size:0.85rem;color:var(--muted);font-weight:400">(<%= results.size() %> found)</span>
    </h2>
  </div>
  <% if (results.isEmpty()) { %>
  <div class="alert alert-warn">⚠️ &nbsp;No passport holders found matching "<%= query %>"</div>
  <% } else { %>
  <div class="table-wrap">
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>Name</th>
          <th>UID</th>
          <th>Date of Birth</th>
          <th>Passport No.</th>
          <th>Photo</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <% int i = 1; for (Map<String,String> r : results) { %>
        <tr>
          <td style="color:var(--muted)"><%= i++ %></td>
          <td style="font-weight:600;color:var(--white)">
            <span style="display:inline-flex;align-items:center;gap:8px">
              <span style="width:28px;height:28px;border-radius:50%;background:rgba(255,153,51,0.15);
                border:1px solid rgba(255,153,51,0.3);display:inline-flex;align-items:center;
                justify-content:center;font-family:'Rajdhani',sans-serif;font-weight:700;
                color:var(--saffron);font-size:0.8rem">
                <%= r.get("name").charAt(0) %>
              </span>
              <%= r.get("name") %>
            </span>
          </td>
          <td class="mono" style="font-size:0.8rem"><%= r.get("uid") %></td>
          <td><%= r.get("dob") %></td>
          <td class="mono"><%= r.get("passportNumber") %></td>
          <td>
            <span style="font-family:'JetBrains Mono',monospace;font-size:0.75rem;
              color:var(--muted);background:rgba(255,255,255,0.04);
              padding:2px 8px;border-radius:4px">
              📷 /photos/<%= r.get("name").toLowerCase().replaceAll(" ","_") %>.jpg
            </span>
          </td>
          <td>
            <a href="<%= cp %>/citizen/profile?uid=<%= r.get("uid") %>" class="btn btn-outline btn-sm">Profile</a>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>
  <% } %>
</div>
<% } %>

<%@ include file="/jsp/common/footer.jsp" %>

