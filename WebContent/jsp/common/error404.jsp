<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%@ include file="/jsp/common/header.jsp" %>
<div style="text-align:center;padding:4rem 2rem">
  <div style="font-family:'Rajdhani',sans-serif;font-size:6rem;font-weight:700;color:var(--saffron);line-height:1">404</div>
  <div style="font-size:1.2rem;color:var(--white);margin:1rem 0">Page Not Found</div>
  <div style="color:var(--muted);margin-bottom:2rem">The page you requested does not exist in this system.</div>
  <a href="<%= request.getContextPath() %>/" class="btn btn-primary">← Back to Dashboard</a>
</div>
<%@ include file="/jsp/common/footer.jsp" %>

