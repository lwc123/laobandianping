package com.juxian.bosscomments.utils;

import net.juxian.appgenome.utils.TextUtil;

/**
 * Created by Tam on 2016/12/12.
 */
public class MobileUtils {
    public static boolean checkPhoneNum(String phoneNumber) {
        if (!TextUtil.isNullOrEmpty(phoneNumber)) {
            return phoneNumber.matches("^1\\d{10}$");
        }
        return false;
    }
}
