package com.aadhaar.model;

import java.io.Serializable;

public class TravelAlert implements Serializable {
    public enum AlertType { STOP_TRAVEL, TRACE, WATCH }

    private String alertId;
    private String uid;
    private String passportNumber;
    private String personName;
    private String reason;
    private AlertType alertType;
    private String issuedBy;
    private String issuedDate;
    private boolean active;

    public TravelAlert() {}

    public TravelAlert(String alertId, String uid, String passportNumber,
                       String personName, String reason, AlertType alertType,
                       String issuedBy, String issuedDate) {
        this.alertId = alertId; this.uid = uid;
        this.passportNumber = passportNumber; this.personName = personName;
        this.reason = reason; this.alertType = alertType;
        this.issuedBy = issuedBy; this.issuedDate = issuedDate;
        this.active = true;
    }

    public String getAlertId() { return alertId; }
    public void setAlertId(String a) { this.alertId = a; }
    public String getUid() { return uid; }
    public void setUid(String uid) { this.uid = uid; }
    public String getPassportNumber() { return passportNumber; }
    public void setPassportNumber(String p) { this.passportNumber = p; }
    public String getPersonName() { return personName; }
    public void setPersonName(String n) { this.personName = n; }
    public String getReason() { return reason; }
    public void setReason(String r) { this.reason = r; }
    public AlertType getAlertType() { return alertType; }
    public void setAlertType(AlertType t) { this.alertType = t; }
    public String getIssuedBy() { return issuedBy; }
    public void setIssuedBy(String i) { this.issuedBy = i; }
    public String getIssuedDate() { return issuedDate; }
    public void setIssuedDate(String d) { this.issuedDate = d; }
    public boolean isActive() { return active; }
    public void setActive(boolean a) { this.active = a; }
}
