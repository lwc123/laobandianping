package com.juxian.bosscomments.modules;

import android.os.Build;

import com.google.gson.Gson;
import com.juxian.bosscomments.AppConfig;

public class DeviceInfo {

    public static DeviceInfo BuildDeviceInfo() {
        DeviceInfo info = new DeviceInfo();
        info.DeviceKey = AppConfig.getDeviceKey();
        info.SdkVersion = Build.VERSION.SDK_INT;
        info.Device = Build.DEVICE;
        info.Brand = Build.BRAND;
        info.Product = Build.PRODUCT;
        return info;
    }

    public String DeviceKey = null;
    public int SdkVersion = -1;
    public String Device = null;
    public String Brand = null;
    public String Product = null;

    @Override
    public String toString() {
        return new Gson().toJson(this);
    }
}
