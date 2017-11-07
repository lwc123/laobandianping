package net.juxian.appgenome;

import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

import android.app.Activity;
import android.app.ActivityManager.RunningTaskInfo;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

public class ActivityManager {
	private static Stack<Activity> ActivityStack;
	private static Class<?> HomeClazz;
	private static Activity currentActivity;

	public static boolean isRunningForeground() {
		AppContextBase context = AppContextBase.getCurrentBase();
		String packageName = context.getPackageName();
		String topActivityName = getTopActivityName();
		if (packageName != null && topActivityName != null
				&& topActivityName.startsWith(packageName)) {
			return true;
		} else {
			return false;
		}
	}

	public static String getTopActivityName() {
		AppContextBase context = AppContextBase.getCurrentBase();
		String topActivityName = null;
		android.app.ActivityManager activityManager = (android.app.ActivityManager) (context
				.getSystemService(android.content.Context.ACTIVITY_SERVICE));
		List<RunningTaskInfo> runningTaskInfos = activityManager
				.getRunningTasks(1);
		if (runningTaskInfos != null) {
			ComponentName component = runningTaskInfos.get(0).topActivity;
			topActivityName = component.getClassName();
		}
		return topActivityName;
	}

	public static void add(Activity activity) {
		if (null == ActivityStack) {
			ActivityStack = new Stack<Activity>();
		}
		ActivityStack.add(activity);
		setCurrent(activity);
	}

	public static int size() {
		return ActivityStack.size();
	}

	public static void registerHomeActivity(Class<?> clazz) {
		HomeClazz = clazz;
	}

	public static void goHome(Boolean finishSelf) {
		if (null == HomeClazz) {
			throw new RuntimeException("HomeClazz is null");
		}
		Activity current = getCurrent();
		goHome(current, finishSelf);
	}

	public static void goHome(Context context, Boolean finishSelf) {
		LogManager.getLogger().d("%s => goHome(%s)",
				context.getClass().getName(), finishSelf);
		Intent intent = new Intent(context, HomeClazz);
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK
				| Intent.FLAG_ACTIVITY_CLEAR_TOP);
		context.startActivity(intent);
		if (finishSelf && Activity.class.isInstance(context))
			((Activity) context).finish();
	}

	public static Activity getCurrent() {
		if (null != ActivityStack && ActivityStack.size() > 0 && null == currentActivity)
			currentActivity = ActivityStack.lastElement();
		return currentActivity;
	}

	public static void setCurrent(Activity activity){
		currentActivity = activity;
	}

	public static void startForResult(Class<?> clazz, int requestCode,
			Bundle bundle) {
		Activity activity = getCurrent();
		Intent intent = new Intent();
		intent.setClass(activity, clazz);
		if (null != bundle)
			intent.putExtras(bundle);

		activity.startActivityForResult(intent, requestCode);
	}

	public static void finishCurrent() {
		Activity activity = ActivityStack.lastElement();
		finish(activity);
	}

	public static void finish(Activity activity) {
		if (null == activity)
			return;

		ActivityStack.remove(activity);
		if (false == activity.isFinishing()) {
			activity.finish();
		}
		activity = null;
	}

	public static void finishActivities(Class<?> clazz) {
		List<Activity> targetActivities = new ArrayList<Activity>();

		for (Activity activity : ActivityStack) {
			if (activity.getClass().equals(clazz)) {
				targetActivities.add(activity);
			}
		}

		for (Activity activity : targetActivities) {
			finish(activity);
		}
	}

	public static void finishAll() {
		int count = ActivityStack.size();
		for (int i = 0, size = count; i < size; i++) {
			Activity activity = ActivityStack.get(i);
			if (null != activity) {
				activity.finish();
			}
		}
		ActivityStack.clear();
	}
}