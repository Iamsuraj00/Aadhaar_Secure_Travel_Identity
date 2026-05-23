package com.aadhaar.model;

import java.io.Serializable;

public class Citizen implements Serializable {
    private String uid;
    private String name;
    private String dateOfBirth;
    private String address;
    private String phoneNumber;
    private String email;
    private String photoPath;
    private String pin;
    private boolean travelBlocked;

    public Citizen() {}

    public Citizen(String uid, String name, String dateOfBirth, String address,
                   String phoneNumber, String email, String photoPath, String pin) {
        this.uid = uid; this.name = name; this.dateOfBirth = dateOfBirth;
        this.address = address; this.phoneNumber = phoneNumber;
        this.email = email; this.photoPath = photoPath;
        this.pin = pin; this.travelBlocked = false;
    }

    public String getUid() { return uid; }
    public void setUid(String uid) { this.uid = uid; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(String dob) { this.dateOfBirth = dob; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String p) { this.phoneNumber = p; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhotoPath() { return photoPath; }
    public void setPhotoPath(String photoPath) { this.photoPath = photoPath; }
    public String getPin() { return pin; }
    public void setPin(String pin) { this.pin = pin; }
    public boolean isTravelBlocked() { return travelBlocked; }
    public void setTravelBlocked(boolean b) { this.travelBlocked = b; }
}
