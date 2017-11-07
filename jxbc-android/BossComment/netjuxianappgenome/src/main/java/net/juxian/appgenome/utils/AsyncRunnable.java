package net.juxian.appgenome.utils;

import net.juxian.appgenome.ActivityManager;
import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.widget.ActivityBase;

import android.os.Handler;
import android.os.Looper;

public class AsyncRunnable<T> {
	public static final String TAG = LogManager.Default_Tag + ":AsyncRunnable";

	private Handler handler;
	private Runnable runnable;
	private T model = null;

	protected T doInBackground(Void... params) {
		return null;
	}

	protected void onPostExecute(T model) {
		LogManager.getLogger().d("onPostExecute(%s)", model);

	}

	protected void onPostError(Exception ex) {
		LogManager.getLogger().e(ex, "[AsyncEntityTask:run] error");

		AnalyticsUtil.onError(ex);
	};

	private void postError(Exception ex) {
		try {
//			((ActivityBase)ActivityManager.getCurrent()).optionsCheckNetStatus();
			onPostError(ex);
		} catch (Exception tr) {
			LogManager.getLogger().e(ex, "[AsyncEntityTask:run] error");
			LogManager.getLogger().e(tr, "[AsyncEntityTask:onPostError]error");
		}
	}

	public AsyncRunnable() {
		this.handler = new Handler(Looper.getMainLooper());
		this.runnable = new Runnable() {
			@Override
			public void run() {
				try {
					onPostExecute(model);
				} catch (Exception ex) {
					postError(ex);
				}
			}
		};
	}

	public void execute() {
		new Thread() {
			@Override
			public void run() {
				try {
					model = doInBackground();
					handler.post(runnable);
				} catch (final Exception ex) {
					handler.post(new Runnable() {
						@Override
						public void run() {
							postError(ex);
						}
					});
				}
			}
		}.start();
	}
}