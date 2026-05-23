<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String cp = request.getContextPath();
    String uri = request.getRequestURI();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Aadhaar Secure Travel Identity</title>
  <link rel="stylesheet" href="<%= cp %>/css/style.css"/>
</head>
<body>

<!-- TOPBAR -->
<header class="topbar">
  <a href="<%= cp %>/" class="topbar-brand">
    <div class="brand-emblem"></div>
    <div class="brand-text">
      <div class="title">Aadhaar Secure Travel</div>
      <div class="subtitle">Government of India · Identity System</div>
    </div>
  </a>
  <nav class="topbar-nav">
    <a href="<%= cp %>/citizen/list" <%= uri.contains("/citizen") ? "class='active'" : "" %>>Citizens</a>
    <a href="<%= cp %>/passport/list" <%= uri.contains("/passport") ? "class='active'" : "" %>>Passport</a>
    <a href="<%= cp %>/airport/" <%= uri.contains("/airport") ? "class='active'" : "" %>>Airport</a>
    <a href="<%= cp %>/license/list" <%= uri.contains("/license") ? "class='active'" : "" %>>License</a>
    <a href="<%= cp %>/crime/dashboard" <%= uri.contains("/crime") ? "class='active'" : "" %>>Crime Dept</a>
    <a href="<%= cp %>/notifications" <%= uri.contains("/notifications") ? "class='active'" : "" %>>🔔 Alerts</a>
  </nav>
</header>

<!-- LAYOUT -->
<div class="app-layout">

<!-- SIDEBAR -->
<aside class="sidebar">
  <div class="sidebar-section">
    <div class="sidebar-label">Citizens</div>
    <a href="<%= cp %>/citizen/register" class="<%= uri.contains("register") && uri.contains("citizen") ? "active" : "" %>">
      <span class="icon">➕</span> Register
    </a>
    <a href="<%= cp %>/citizen/list" class="<%= uri.contains("list") && uri.contains("citizen") ? "active" : "" %>">
      <span class="icon">👥</span> All Citizens
    </a>
  </div>
  <div class="sidebar-section">
    <div class="sidebar-label">Passport</div>
    <a href="<%= cp %>/passport/issue" class="<%= uri.contains("issue") ? "active" : "" %>">
      <span class="icon">📘</span> Issue Passport
    </a>
    <a href="<%= cp %>/passport/list" class="<%= uri.contains("list") && uri.contains("passport") ? "active" : "" %>">
      <span class="icon">📋</span> All Passports
    </a>
    <a href="<%= cp %>/passport/search">
      <span class="icon">🔍</span> Search Holders
    </a>
  </div>
  <div class="sidebar-section">
    <div class="sidebar-label">Airport</div>
    <a href="<%= cp %>/airport/" class="<%= uri.contains("/airport") ? "active" : "" %>">
      <span class="icon">✈️</span> Travel Check
    </a>
  </div>
  <div class="sidebar-section">
    <div class="sidebar-label">Driving License</div>
    <a href="<%= cp %>/license/apply" class="<%= uri.contains("apply") ? "active" : "" %>">
      <span class="icon">🚗</span> Apply
    </a>
    <a href="<%= cp %>/license/result" class="<%= uri.contains("result") ? "active" : "" %>">
      <span class="icon">📝</span> Record Test
    </a>
    <a href="<%= cp %>/license/list" class="<%= uri.contains("list") && uri.contains("license") ? "active" : "" %>">
      <span class="icon">📋</span> All Licenses
    </a>
  </div>
  <div class="sidebar-section">
    <div class="sidebar-label">Crime Dept</div>
    <a href="<%= cp %>/crime/dashboard" class="<%= uri.contains("dashboard") ? "active" : "" %>">
      <span class="icon">🚨</span> Dashboard
    </a>
    <a href="<%= cp %>/crime/issue" class="<%= uri.contains("issue") && uri.contains("crime") ? "active" : "" %>">
      <span class="icon">⛔</span> Issue Alert
    </a>
    <a href="<%= cp %>/crime/trace" class="<%= uri.contains("trace") ? "active" : "" %>">
      <span class="icon">🔎</span> Trace Person
    </a>
  </div>
  <div class="sidebar-section">
    <div class="sidebar-label">System</div>
    <a href="<%= cp %>/notifications" class="<%= uri.contains("notifications") ? "active" : "" %>">
      <span class="icon">🔔</span> Notifications
    </a>
  </div>
</aside>

<!-- MAIN -->
<main class="main-content">
