# Aadhaar Secure Travel Identity — JSP + Servlet + MySQL

A full-stack Java EE web application using **JSP** (views), **Servlets** (controllers),
and **MySQL** (persistent database via raw JDBC with a connection pool).

---

## Prerequisites

| Requirement        | Version     |
|--------------------|-------------|
| Java JDK           | 11 or later |
| Apache Tomcat      | 9.x         |
| MySQL Server       | 5.7 or 8.x  |
| Maven (optional)   | 3.6+        |

---

## Step 1 — Set Up the MySQL Database

Open MySQL Workbench or the `mysql` CLI and run the schema file:

```sql
mysql -u root -p < schema.sql
```

This will:
- Create database `aadhaar_db`
- Create all 5 tables (`citizens`, `passports`, `driving_licenses`, `travel_alerts`, `notifications`)
- Create indexes
- Insert seed data (3 citizens, 2 passports, 1 licence, 1 travel alert)

---

## Step 2 — Configure the Database Connection

Edit **`src/db.properties`** to match your MySQL setup:

```properties
db.url      = jdbc:mysql://localhost:3306/aadhaar_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
db.username = root
db.password = yourpassword
db.driver   = com.mysql.cj.jdbc.Driver
db.poolSize = 10
```

> This file must be on the Java classpath (i.e. inside `src/`). Maven copies it to `WEB-INF/classes/` automatically.

---

## Step 3 — Build & Run

### Option A — Maven + Embedded Tomcat (Easiest)

```bash
mvn tomcat7:run
# Open: http://localhost:8080/aadhaar
```

### Option B — Build WAR + Deploy to Tomcat

```bash
mvn clean package
# WAR created at: target/aadhaar-secure-travel-1.0.0.war
# Copy to: $TOMCAT_HOME/webapps/aadhaar.war
# Start Tomcat, open: http://localhost:8080/aadhaar
```

### Option C — Eclipse (No Maven)

1. **File → New → Dynamic Web Project** — name: `AadhaarWeb`
2. Set **Java Source** folder to `src/`
3. Set **Web Content** folder to `WebContent/`
4. **Right-click project → Properties → Java Build Path → Add External JARs:**
   - `mysql-connector-java-8.0.33.jar` ← [download from MySQL site](https://dev.mysql.com/downloads/connector/j/)
   - `jstl-1.2.jar`
5. Add **Apache Tomcat 9** runtime to the project
6. **Run on Server → Tomcat v9.0**

---

## Database Architecture

```
aadhaar_db
├── citizens           ← uid (PK), name, dob, address, phone, email, pin (SHA-256), travel_blocked
├── passports          ← passport_number (PK), uid (FK → citizens), holder_name, dates, status
├── driving_licenses   ← license_number (PK), uid (FK), category, rto, status, test_date, result
├── travel_alerts      ← alert_id (PK), uid (FK), type (STOP/TRACE/WATCH), reason, active flag
└── notifications      ← notification_id (PK), recipient_id, type (AIRLINE/CRIME_DEPT), message
```

---

## How the JDBC Layer Works

```
Servlet (HTTP)
    │
    ▼
Service Layer (CitizenService, PassportService, etc.)
    │   Uses PreparedStatement for all queries — SQL injection safe
    ▼
DBConnection.java (Connection Pool)
    │   Reads db.properties from classpath
    │   Maintains a pool of 10 live JDBC connections
    │   Thread-safe: getConnection() / releaseConnection() are synchronized
    ▼
MySQL Server (aadhaar_db)
```

**Always use `DBConnection.releaseConnection(conn)` in a `finally` block** — never call `conn.close()` directly, or the connection is lost from the pool.

---

## Pre-loaded Seed Data

| Name         | UID              | PIN  | Passport  | Travel Status |
|--------------|------------------|------|-----------|---------------|
| Arjun Sharma | 1234-5678-9012   | 1234 | P1234567  | ✅ Clear       |
| Priya Mehta  | 2345-6789-0123   | 2345 | P2345678  | ✅ Clear       |
| Rohit Verma  | 3456-7890-1234   | 3456 | —         | ⛔ Blocked     |

---

## URL Reference

| URL                  | Action                                      |
|----------------------|---------------------------------------------|
| `/`                  | Home dashboard (live MySQL stats)           |
| `/citizen/register`  | Register citizen → INSERT into citizens     |
| `/citizen/list`      | SELECT * FROM citizens                      |
| `/citizen/profile`   | SELECT citizen + passport + licence by UID  |
| `/passport/issue`    | INSERT into passports                       |
| `/passport/list`     | SELECT * FROM passports                     |
| `/passport/search`   | SELECT with JOIN + LIKE on name             |
| `/airport/`          | SELECT passport by UID + travel_blocked check |
| `/license/apply`     | INSERT into driving_licenses (PENDING)      |
| `/license/result`    | UPDATE status + test_result                 |
| `/license/list`      | SELECT * FROM driving_licenses              |
| `/crime/dashboard`   | SELECT * FROM travel_alerts                 |
| `/crime/issue`       | INSERT travel_alert + UPDATE travel_blocked |
| `/crime/trace`       | SELECT alerts WHERE uid/passport/name LIKE  |
| `/crime/revoke`      | UPDATE active=0 + UPDATE travel_blocked=0   |
| `/notifications`     | SELECT * FROM notifications ORDER BY date   |

---

## Project File Structure

```
AadhaarWeb/
├── schema.sql                         ← Run this first in MySQL
├── pom.xml                            ← Maven build (includes mysql-connector-java 8.0.33)
├── src/
│   ├── db.properties                  ← ⚙️  Edit with your DB credentials
│   └── com/aadhaar/
│       ├── model/          (5 POJOs)
│       ├── service/        (5 JDBC-backed services)
│       ├── util/
│       │   ├── DBConnection.java      ← Connection pool (10 connections)
│       │   ├── DatabaseSeeder.java    ← Seeds default rows on startup
│       │   ├── PinUtil.java           ← SHA-256 PIN hashing
│       │   └── IdGenerator.java
│       └── servlet/
│           ├── AppStartupListener.java ← @WebListener: seeds DB, shuts pool
│           ├── CitizenServlet.java
│           ├── PassportServlet.java
│           ├── AirportServlet.java
│           ├── LicenseServlet.java
│           ├── CrimeDeptServlet.java
│           ├── NotificationServlet.java
│           └── EncodingFilter.java
└── WebContent/
    ├── index.jsp                      ← Live stats from MySQL
    ├── css/style.css
    ├── js/app.js
    ├── WEB-INF/web.xml
    └── jsp/  (16 JSP pages across 6 modules)
```

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `Communications link failure` | MySQL not running or wrong port in db.properties |
| `Access denied for user` | Wrong username/password in db.properties |
| `Table doesn't exist` | Run `schema.sql` in MySQL first |
| `ClassNotFoundException: com.mysql.cj.jdbc.Driver` | mysql-connector-java JAR missing from classpath |
| `db.properties not found` | Ensure it's in `src/` (not WebContent) |
| Data missing after restart | Normal — seed data uses INSERT IGNORE, persistent data survives restarts |
