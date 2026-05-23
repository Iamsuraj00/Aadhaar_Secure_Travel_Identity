package com.aadhaar.model;

import java.io.Serializable;

public class DrivingLicense implements Serializable {
    public enum LicenseStatus { ISSUED, DENIED, PENDING, EXPIRED, SUSPENDED }

    private String licenseNumber;
    private String uid;
    private String holderName;
    private String issueDate;
    private String expiryDate;
    private String vehicleCategory;
    private String issuingRTO;
    private LicenseStatus status;
    private String testDate;
    private String testLocation;
    private String testResult;

    public DrivingLicense() {}

    public DrivingLicense(String licenseNumber, String uid, String holderName,
                          String issueDate, String expiryDate,
                          String vehicleCategory, String issuingRTO) {
        this.licenseNumber = licenseNumber; this.uid = uid;
        this.holderName = holderName; this.issueDate = issueDate;
        this.expiryDate = expiryDate; this.vehicleCategory = vehicleCategory;
        this.issuingRTO = issuingRTO; this.status = LicenseStatus.ISSUED;
    }

    public String getLicenseNumber() { return licenseNumber; }
    public void setLicenseNumber(String n) { this.licenseNumber = n; }
    public String getUid() { return uid; }
    public void setUid(String uid) { this.uid = uid; }
    public String getHolderName() { return holderName; }
    public void setHolderName(String n) { this.holderName = n; }
    public String getIssueDate() { return issueDate; }
    public void setIssueDate(String d) { this.issueDate = d; }
    public String getExpiryDate() { return expiryDate; }
    public void setExpiryDate(String d) { this.expiryDate = d; }
    public String getVehicleCategory() { return vehicleCategory; }
    public void setVehicleCategory(String c) { this.vehicleCategory = c; }
    public String getIssuingRTO() { return issuingRTO; }
    public void setIssuingRTO(String r) { this.issuingRTO = r; }
    public LicenseStatus getStatus() { return status; }
    public void setStatus(LicenseStatus s) { this.status = s; }
    public String getTestDate() { return testDate; }
    public void setTestDate(String d) { this.testDate = d; }
    public String getTestLocation() { return testLocation; }
    public void setTestLocation(String l) { this.testLocation = l; }
    public String getTestResult() { return testResult; }
    public void setTestResult(String r) { this.testResult = r; }
}
