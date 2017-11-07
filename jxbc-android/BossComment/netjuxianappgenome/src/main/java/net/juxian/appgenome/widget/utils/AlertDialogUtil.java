package net.juxian.appgenome.widget.utils;

import java.lang.reflect.Field;

import android.app.AlertDialog;

public class AlertDialogUtil {
	public static void disableDismiss(AlertDialog dialog) {
		modifyEnableStatus(dialog, false);
	}
	
	public static void dismiss(AlertDialog dialog) {
		modifyEnableStatus(dialog, true);
		dialog.dismiss();
	}
	
	private static void modifyEnableStatus(AlertDialog dialog, boolean enable) {
		Field field = null;
		try {
			field = dialog.getClass().getSuperclass().getDeclaredField( "mShowing" );
			field.setAccessible(true);
			field.set(dialog, enable);
		} catch (Exception e) {
		}
	}
}
