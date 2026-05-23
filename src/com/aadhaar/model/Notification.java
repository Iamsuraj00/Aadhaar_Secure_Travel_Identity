package com.aadhaar.model;

import java.io.Serializable;

public class Notification implements Serializable {
    private String notificationId;
    private String recipientId;
    private String recipientType;
    private String message;
    private String timestamp;
    private boolean read;

    public Notification() {}

    public Notification(String notificationId, String recipientId,
                        String recipientType, String message, String timestamp) {
        this.notificationId = notificationId; this.recipientId = recipientId;
        this.recipientType = recipientType; this.message = message;
        this.timestamp = timestamp; this.read = false;
    }

    public String getNotificationId() { return notificationId; }
    public void setNotificationId(String n) { this.notificationId = n; }
    public String getRecipientId() { return recipientId; }
    public void setRecipientId(String r) { this.recipientId = r; }
    public String getRecipientType() { return recipientType; }
    public void setRecipientType(String t) { this.recipientType = t; }
    public String getMessage() { return message; }
    public void setMessage(String m) { this.message = m; }
    public String getTimestamp() { return timestamp; }
    public void setTimestamp(String t) { this.timestamp = t; }
    public boolean isRead() { return read; }
    public void setRead(boolean r) { this.read = r; }
}
