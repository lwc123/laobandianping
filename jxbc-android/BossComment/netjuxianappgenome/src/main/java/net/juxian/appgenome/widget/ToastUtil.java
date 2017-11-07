package net.juxian.appgenome.widget;

import java.util.Locale;

import net.juxian.appgenome.AppContextBase;
import android.view.Gravity;
import android.widget.Toast;

public class ToastUtil {
	public final static void showInfo(String text, Object... args) {
		if (args != null) {
			text = String.format(Locale.US, text, args);
		}
		Toast toast = Toast.makeText(AppContextBase.getCurrentBase(), text,
				Toast.LENGTH_SHORT);
		toast.setGravity(Gravity.CENTER, 0, 0);
		toast.show();
		// Toast.makeText(AppContextBase.getCurrentBase(), text,
		// Toast.LENGTH_SHORT).show();
	}

	public final static void showError(String text, Object... args) {
		if (args != null) {
			text = String.format(Locale.US, text, args);
		}
		Toast toast = Toast.makeText(AppContextBase.getCurrentBase(), text,
				Toast.LENGTH_SHORT);
		toast.setGravity(Gravity.CENTER, 0, 0);
		toast.show();
		// Toast.makeText(AppContextBase.getCurrentBase(), text,
		// Toast.LENGTH_LONG)
		// .show();
	}
}
