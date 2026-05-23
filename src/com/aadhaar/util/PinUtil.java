package com.aadhaar.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PinUtil {
    public static String hashPin(String pin) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(pin.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
    public static boolean verifyPin(String plain, String stored) {
        return hashPin(plain).equals(stored);
    }
}
