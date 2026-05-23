package com.aadhaar.util;

import java.util.concurrent.atomic.AtomicInteger;

public class IdGenerator {
    private static final AtomicInteger uidCtr   = new AtomicInteger(5000);
    private static final AtomicInteger alertCtr = new AtomicInteger(100);
    private static final AtomicInteger notifCtr = new AtomicInteger(100);

    public static String generateUID() {
        long raw = System.currentTimeMillis() % 100000000L + uidCtr.getAndIncrement();
        String d = String.format("%012d", raw);
        return d.substring(0,4)+"-"+d.substring(4,8)+"-"+d.substring(8,12);
    }
    public static String generatePassportNumber() {
        return "P" + String.format("%07d", (int)(Math.random()*9000000)+1000000);
    }
    public static String generateLicenseNumber(String state) {
        return "DL-"+state.toUpperCase()+"-"+java.time.Year.now().getValue()
               +"-"+String.format("%06d",(int)(Math.random()*900000)+100000);
    }
    public static String generateAlertId() {
        return "ALT-"+String.format("%03d", alertCtr.getAndIncrement());
    }
    public static String generateNotificationId() {
        return "NOTIF-"+String.format("%04d", notifCtr.getAndIncrement());
    }
}
