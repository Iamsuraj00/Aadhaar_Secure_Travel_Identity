<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@ include file="/jsp/common/header.jsp" %>
<div style="text-align:center;padding:4rem 2rem">
  <div style="font-family:'Rajdhani',sans-serif;font-size:6rem;font-weight:700;color:var(--danger);line-height:1">500</div>
  <div style="font-size:1.2rem;color:var(--white);margin:1rem 0">Internal Server Error</div>
  <div style="color:var(--muted);margin-bottom:1rem">An unexpected error occurred. Check server logs for details.</div>
  <% if (exception != null) { %>
  <div style="background:rgba(229,57,53,0.08);border:1px solid rgba(229,57,53,0.3);border-radius:8px;
              padding:1rem;font-family:'JetBrains Mono',monospace;font-size:0.8rem;color:#ef9a9a;
              max-width:600px;margin:1rem auto;text-align:left;word-break:break-all">
    <%= exception.getMessage() %>
  </div>
  <% } %>
  <br/>
  <a href="<%= request.getContextPath() %>/" class="btn btn-primary">← Back to Dashboard</a>
</div>
<%@ include file="/jsp/common/footer.jsp" %>

