package net.juxian.appgenome.utils;

import android.content.Context;
import net.juxian.appgenome.ActivityManager;
import net.juxian.appgenome.AppContextBase;
import net.juxian.appgenome.AppEnvironment;
import net.juxian.appgenome.BuildConfig;
import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.widget.ToastUtil;

import com.umeng.analytics.MobclickAgent;

public class AnalyticsUtil {
	public static final String EVENT_ACCOUNT_NEW = "account_new";
	public static final String EVENT_ACCOUNT_SIGNIN = "account_signin";
	public static final String EVENT_ACCOUNT_SIGNOUT = "account_signout";
	
	public static void initialize() {	
		if (BuildConfig.DEBUG) {
			LogManager.getLogger().d("[AnalyticsUtil] initialize.");
//			return;
		}
		
		MobclickAgent.openActivityDurationTrack(false);
		if(false == AppEnvironment.isPublicMode()) {			
			MobclickAgent.setDebugMode(true);
		}
	}

	public static void onPageStart(Context context, String pageName) {
		if (BuildConfig.DEBUG) {
			LogManager.getLogger().d("[page] %s start.", pageName);	
			return;
		}
		
		MobclickAgent.onPageStart(pageName);
		MobclickAgent.onResume(context);
	}

	public static void onPageEnd(Context context, String pageName) {	
		if (BuildConfig.DEBUG) {
			LogManager.getLogger().d("[page] %s end.", pageName);	
			return;
		}
		
		MobclickAgent.onPause(context);
		MobclickAgent.onPageEnd(pageName);
	}

	public static void onEvent(String key, String source) {
		if (BuildConfig.DEBUG) {
			LogManager.getLogger().d("[event] event:%s, source:%s", key, source);	
			return;
		}
		
		if (null == source)
			MobclickAgent.onEvent(AppContextBase.getCurrentBase(), key);
		else
			MobclickAgent.onEvent(AppContextBase.getCurrentBase(), key, source);
	}

	public static void onError(Exception ex) {
		if (BuildConfig.DEBUG) {
			LogManager.getLogger().e(ex, "An error occurred on an asynchronous thread");
			return;
		}
		
		Context context = ActivityManager.getCurrent();
		if (null == context)
			context = AppContextBase.getCurrentBase();
		
		MobclickAgent.reportError(context, ex);
	}
}
