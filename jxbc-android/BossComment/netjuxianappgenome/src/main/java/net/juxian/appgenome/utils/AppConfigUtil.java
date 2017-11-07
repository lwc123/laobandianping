package net.juxian.appgenome.utils;

import java.util.UUID;

import net.juxian.appgenome.AppContextBase;
import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.models.PackageVersion;
import net.juxian.appgenome.webapi.WebApiClient;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.provider.Settings.Secure;
import android.telephony.TelephonyManager;

public class AppConfigUtil {	
	public static final int NETWORK_DISABLE = 0;
	public static final int NETWORK_WIFI = 1;
    public static final int NETWORK_MOBILE = 2;
    
    private static final String APP_DEVICEKEY = "App:Device";    
    private static final String APP_ACCESSTOKEN = "Account:AccessToken";
    
    private static Bundle AppMetaData = null;
    
	public static SharedPreferences getSharedPreferences() {
		return PreferenceManager.getDefaultSharedPreferences(AppContextBase.getCurrentBase());
	}
	
 	public static PackageVersion getCurrentVersion() {
 		Context context = AppContextBase.getCurrentBase();
		PackageVersion version = new PackageVersion();
		try {
			PackageInfo info = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
			version.VersionName = info.versionName;
			version.VersionCode = info.versionCode;
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}
		return version;
	}
	
	public static String getMetaData(String key) {		
		if(null == AppMetaData) {
			Context context = AppContextBase.getCurrentBase();
			try {    		
	    		ApplicationInfo appInfo = context.getPackageManager().getApplicationInfo(context.getPackageName(), PackageManager.GET_META_DATA);   
	    		AppMetaData = appInfo.metaData;	    		
	        } catch (Exception ex) {     
	            throw new IllegalArgumentException("Could not read the name in the manifest file.", ex);     
	        }
		}
		
		return AppMetaData.getString(key);  
	}
	
	public static String getDeviceKey() {
		String clientId = get(APP_DEVICEKEY);
		if(null == clientId)
		{
			synchronized (AppConfigUtil.class) {
				clientId = get(APP_DEVICEKEY);
				if(null == clientId) {
					Context context = AppContextBase.getCurrentBase();
					try {
						TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
						clientId = tm.getSimSerialNumber();
						if(TextUtil.isNullOrEmpty(clientId))
							clientId = tm.getDeviceId();
					} catch (Exception e){
						LogManager.getLogger("Catch").v(">>>>>>> %s", e.toString());
					}
					if(TextUtil.isNullOrEmpty(clientId)) 
						clientId = Secure.getString(context.getContentResolver(), android.provider.Settings.Secure.ANDROID_ID);	
					
					if(TextUtil.isNullOrEmpty(clientId) || clientId.length() < 6) 
						clientId = UUID.randomUUID().toString();		
					
					clientId = MD5.encode("circle-"+clientId);
					setDeviceKey(clientId);
				}
			}
		}
		return clientId;
	}
	
	public static void setDeviceKey(String deviceKey) {
		set(APP_DEVICEKEY, deviceKey);
	}
	
	public static String getAccessToken() {
		return get(APP_ACCESSTOKEN);
	}
	
	public static void setAccessToken(String accessToken) {
		set(APP_ACCESSTOKEN, accessToken);
	}	
	
	public static String get(String key) {
		SharedPreferences sharedPreferences = getSharedPreferences();
		return sharedPreferences.getString(key, null);
	}
	
	public static long getLong(String key) {
		SharedPreferences sharedPreferences = getSharedPreferences();
		return sharedPreferences.getLong(key, 0);
	}
	
	public static void set(String key, String value) {
		SharedPreferences sharedPreferences = getSharedPreferences();
		Editor editor = sharedPreferences.edit();
		editor.putString(key, value);
		editor.commit();
	}
	
	public static void set(String key, long value) {
		SharedPreferences sharedPreferences = getSharedPreferences();
		Editor editor = sharedPreferences.edit();
		editor.putLong(key, value);
		editor.commit();
	}
	
	public static int getNetworkStatus() {
        int status = NETWORK_DISABLE;
        ConnectivityManager connectivityManager = (ConnectivityManager)AppContextBase.getCurrentBase().getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = connectivityManager.getActiveNetworkInfo();
        if (networkInfo == null) {
            return status;
        }        

        switch(networkInfo.getType()) {
        	case ConnectivityManager.TYPE_WIFI:
        		status= NETWORK_WIFI;
        		break;
        	case ConnectivityManager.TYPE_MOBILE:
        		status= NETWORK_MOBILE;
        		break;
        	default:
	        	status= NETWORK_DISABLE;
	    		break;
        }        
        return status;
    }
}
