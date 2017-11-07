package net.juxian.appgenome.utils;

import net.juxian.appgenome.LogManager;
import android.os.AsyncTask;

public class AsyncTaskWrapper<T> {

	private Exception exception = null;
	private TaskWrapper task = null;

	private final T doExecute(Void... params) {
		try {
			return this.doInBackground();
		} catch (Exception ex) {
			this.exception = ex;
			return null;
		}
	}

	private final void postExecute(T model) {

		if (null == this.exception) {
			try {
				onPostExecute(model);
			} catch (Exception ex) {
				postError(ex);
			}
		} else {
			postError(this.exception);
		}
	}

	private final void postError(Exception ex) {
		try {
			onPostError(ex);
		} catch (Exception tr) {
			LogManager.getLogger().e(ex, "[AsyncEntityTask:run] error");
			LogManager.getLogger().e(tr, "[AsyncEntityTask:onPostError]error");
		}
	}

	protected final void publishProgress(int progress) {
		if (null != this.task)
			this.task.updateProgress(progress);
	}

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

	protected void onPreExecute() {
		// empty action
	}

	protected void onProgressUpdate(int progress) {
		// empty action
	}

	protected void onCancelled() {
		// empty action
	}

	public AsyncTask<Void, Integer, T> execute() {
		this.task = new TaskWrapper(this);
		return this.task.execute();
	}

	private class TaskWrapper extends AsyncTask<Void, Integer, T> {

		private AsyncTaskWrapper<T> source;

		private TaskWrapper(AsyncTaskWrapper<T> source) {
			this.source = source;
		}

		@Override
		protected void onPreExecute() {
			source.onPreExecute();
		}

		@Override
		protected T doInBackground(Void... params) {
			return source.doExecute();
		}

		@Override
		protected void onProgressUpdate(Integer... progress) {
			source.onProgressUpdate(progress[0]);
		}

		@Override
		protected void onPostExecute(T model) {
			source.postExecute(model);
		}

		@Override
		protected void onCancelled() {
			source.onCancelled();
		}

		protected void updateProgress(Integer... progress) {
			this.publishProgress(progress);
		}
	}
}