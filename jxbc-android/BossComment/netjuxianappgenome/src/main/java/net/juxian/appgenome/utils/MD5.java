package net.juxian.appgenome.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import net.juxian.appgenome.LogManager;

public final class MD5 {
    private final static char[] hexDigits = { '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f' };

    public static String encode(String original) {
        String result = null;
        try {
        	byte[] inputStream = original.getBytes();
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(inputStream);
            byte[] outputStream = md.digest();
            int j = outputStream.length;
            char output[] = new char[j * 2];
            int k = 0;
            for (int i = 0; i < j; i++) {
                byte byte0 = outputStream[i];
                output[k++] = hexDigits[byte0 >>> 4 & 0xf];
                output[k++] = hexDigits[byte0 & 0xf];
            }
            result = new String(output);
        } catch (NoSuchAlgorithmException ex) {
            LogManager.getLogger().e(ex, "MD5 failed.");
        	ex.printStackTrace();
        }
        return result;
    }
}