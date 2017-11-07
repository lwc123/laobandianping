package net.juxian.appgenome.widget;

import net.juxian.appgenome.AppContextBase;
import net.juxian.appgenome.R;
import android.app.Activity;
import android.os.Handler;
import android.os.Looper;
import android.widget.Toast;

public class DoubleClickExitHandler {
	private static final int CONFIRM_TIMEOUT = 2000;

	private final Activity activity;

	private boolean isOnKeyBacking;
	private Handler handler;
	private Toast backToast;

	public DoubleClickExitHandler(Activity container) {
		this.activity = container;
		handler = new Handler(Looper.getMainLooper());
	}

	public void process() {
		if (isOnKeyBacking) {
			handler.removeCallbacks(onBackTimeRunnable);
			if (backToast != null) {
				backToast.cancel();
			}
			AppContextBase.getCurrentBase().exit();
		} else {
			isOnKeyBacking = true;
			if (backToast == null) {
				backToast = Toast.makeText(activity, R.string.app_exit_confirm,
						CONFIRM_TIMEOUT);
			}
			backToast.show();
			handler.postDelayed(onBackTimeRunnable, CONFIRM_TIMEOUT);
		}
	}

	private Runnable onBackTimeRunnable = new Runnable() {
		@Override
		public void run() {
			isOnKeyBacking = false;
			if (backToast != null) {
				backToast.cancel();
			}
		}
	};
}
