package net.juxian.appgenome;

import java.util.HashMap;
import java.util.Locale;

import android.util.Log;

public class LogManager {
	public static final String Default_Tag = "JuXian";

	private static Logger Logger;
	private static HashMap<String, Logger> LoggerMap = null;

	public static Logger getLogger() {
		return getLogger(null);
	}

	public static Logger getLogger(String tag) {
		if (true) {
			return getDebugLogger(tag);
		} else if (Logger == null) {
			Logger = new Logger();
		}
		return Logger;
	}

	private static Logger getDebugLogger(String tag) {
		if (null == tag)
			tag = Default_Tag;

		Logger logger;
		if (null == LoggerMap) {
			synchronized (LogManager.class) {
				if (null == LoggerMap)
					LoggerMap = new HashMap<String, Logger>();
			}
		}

		if (LoggerMap.containsKey(tag))
			logger = LoggerMap.get(tag);
		else {
			logger = new DebugLogger(tag);
			LoggerMap.put(tag, logger);
		}
		return logger;
	}

	public static class Logger {

		private Logger() {
		}

		public void v(String format, Object... args) {
		}

		public void d(String format, Object... args) {
		}

		public void i(String format, Object... args) {
		}

		public void w(String format, Object... args) {
		}

		public void w(Throwable tr, String format, Object... args) {
		}

		public void e(String format, Object... args) {
		}

		public void e(Throwable tr, String format, Object... args) {
		}

		public void wtf(String format, Object... args) {
		}

		public void wtf(Throwable tr, String format, Object... args) {
		}
	}

	private static class DebugLogger extends Logger {
		private String tag;

		private DebugLogger(String tag) {

			if (null != this.tag && tag == this.tag)
				return;
			this.tag = null == tag ? LogManager.Default_Tag : tag;
		}

		@Override
		public void v(String format, Object... args) {
			Log.v(tag, buildSimpleMessage(format, args));
		}

		@Override
		public void d(String format, Object... args) {
			Log.d(tag, buildSimpleMessage(format, args));
		}

		@Override
		public void i(String format, Object... args) {
			Log.i(tag, buildSimpleMessage(format, args));
		}

		@Override
		public void w(String format, Object... args) {
			Log.w(tag, buildMessage(format, args));
		}

		@Override
		public void w(Throwable tr, String format, Object... args) {
			Log.w(tag, buildMessage(format, args), tr);
		}

		@Override
		public void e(String format, Object... args) {
			Log.e(tag, buildMessage(format, args));
		}

		@Override
		public void e(Throwable tr, String format, Object... args) {
			Log.e(tag, buildMessage(format, args), tr);
		}

		@Override
		public void wtf(String format, Object... args) {
			Log.wtf(tag, buildMessage(format, args));
		}

		@Override
		public void wtf(Throwable tr, String format, Object... args) {
			Log.wtf(tag, buildMessage(format, args), tr);
		}

		private String buildSimpleMessage(String format, Object... args) {
			return (args == null) ? format : String.format(Locale.US, format,
					args);
		}

		private String buildMessage(String format, Object... args) {
			String msg = buildSimpleMessage(format, args);
			StackTraceElement[] trace = new Throwable().fillInStackTrace()
					.getStackTrace();

			String caller = "<unknown>";
			// Walk up the stack looking for the first caller outside of
			// VolleyLog.
			// It will be at least two frames up, so start there.
			for (int i = 2; i < trace.length; i++) {
				Class<?> clazz = trace[i].getClass();
				if (!clazz.equals(DebugLogger.class)) {
					String callingClass = trace[i].getClassName();
					callingClass = callingClass.substring(callingClass
							.lastIndexOf('.') + 1);
					callingClass = callingClass.substring(callingClass
							.lastIndexOf('$') + 1);

					caller = callingClass + "." + trace[i].getMethodName();
					break;
				}
			}
			return String.format(Locale.US, "[%d] %s: %s", Thread
					.currentThread().getId(), caller, msg);
		}
	}
}
