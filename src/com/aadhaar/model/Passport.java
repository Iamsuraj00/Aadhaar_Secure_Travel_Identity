package com.aadhaar.model;

import java.io.Serializable;

public class Passport implements Serializable {
    public enum PassportStatus { ACTIVE, EXPIRED, REVOKED, SUSPENDED }

    private String passportNumber;
    private String uid;
    private String holderName;
    private String nationality;
    private String issueDate;
    private String expiryDate;
    private String issuingAuthority;
    private PassportStatus status;

    public Passport() {}

    public Passport(String passportNumber, String uid, String holderName,
                    String nationality, String issueDate, String expiryDate,
                    String issuingAuthority) {
        this.passportNumber = passportNumber; this.uid = uid;
        this.holderName = holderName; this.nationality = nationality;
        this.issueDate = issueDate; this.expiryDate = expiryDate;
        this.issuingAuthority = issuingAuthority;
        this.status = PassportStatus.ACTIVE;
    }

    public String getPassportNumber() { return passportNumber; }
    public void setPassportNumber(String n) { this.passportNumber = n; }
    public String getUid() { return uid; }
    public void setUid(String uid) { this.uid = uid; }
    public String getHolderName() { return holderName; }
    public void setHolderName(String n) { this.holderName = n; }
    public String getNationality() { return nationality; }
    public void setNationality(String n) { this.nationality = n; }
    public String getIssueDate() { return issueDate; }
    public void setIssueDate(String d) { this.issueDate = d; }
    public String getExpiryDate() { return expiryDate; }
    public void setExpiryDate(String d) { this.expiryDate = d; }
    public String getIssuingAuthority() { return issuingAuthority; }
    public void setIssuingAuthority(String a) { this.issuingAuthority = a; }
    public PassportStatus getStatus() { return status; }
    public void setStatus(PassportStatus s) { this.status = s; }
}
