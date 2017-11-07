package com.juxian.bosscomments.utils;

import android.util.Log;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class TimeUtil {

	/**
	 * 解析时间 时间格式是 本天： HH时mm分 本年非本天：MM月dd日HH时 非本年： yyyy年MM月dd日
	 * 
	 * @param timeStr
	 * @return
	 */
	public static String parserTime(String timeStr) {
		long time = Long.parseLong(timeStr);
		Calendar parseCalendar = Calendar.getInstance();
		parseCalendar.setTimeInMillis(time);
		Calendar curCalendar = Calendar.getInstance();
		String format;
		if (parseCalendar.get(Calendar.YEAR) < curCalendar.get(Calendar.YEAR)) {
			format = "yy/MM/dd HH:mm";
		} else if (parseCalendar.get(Calendar.DAY_OF_YEAR) < curCalendar
				.get(Calendar.DAY_OF_YEAR)) {
			format = "MM/dd HH:mm";
		} else {
			format = "HH:mm";
		}
		DateFormat dateFormat = new SimpleDateFormat(format);
		return dateFormat.format(parseCalendar.getTime());
	}

	/**
	 * 解析时间 时间格式是 本天： HH时mm分 本年非本天且非昨天：MM月dd日  非本年： yyyy年MM月dd日   本年且是昨天：昨天
	 * 
	 * @param timeStr
	 * @return
	 */
	public static String parserTimeRule(String timeStr) {
		long time = Long.parseLong(timeStr);
		Calendar parseCalendar = Calendar.getInstance();
		parseCalendar.setTimeInMillis(time);
		Calendar curCalendar = Calendar.getInstance();
		String format;
		if (parseCalendar.get(Calendar.YEAR) < curCalendar.get(Calendar.YEAR)) {
			format = "yyyy年MM月dd日";
		} else if (parseCalendar.get(Calendar.DAY_OF_YEAR) < curCalendar
				.get(Calendar.DAY_OF_YEAR)&&(curCalendar.get(Calendar.DAY_OF_YEAR) - parseCalendar.get(Calendar.DAY_OF_YEAR))>1) {
			format = "MM月dd日";
		} else if (parseCalendar.get(Calendar.DAY_OF_YEAR) < curCalendar
				.get(Calendar.DAY_OF_YEAR)&&(curCalendar.get(Calendar.DAY_OF_YEAR) - parseCalendar.get(Calendar.DAY_OF_YEAR)) == 1) {
			format = "HH:mm";
			DateFormat dateFormat = new SimpleDateFormat(format);
			return "昨天 "+dateFormat.format(parseCalendar.getTime());
		} else {
			format = "HH:mm";
		}
		DateFormat dateFormat = new SimpleDateFormat(format);
		return dateFormat.format(parseCalendar.getTime());
	}

	/**
	 * 解析时间 时间格式是 本天： HH时mm分 本年非本天：MM月dd日HH时 非本年： yyyy年MM月dd日
	 *
	 * @param timeStr
	 * @return
	 */
	public static String parserTime3(String timeStr) {
		long time = Long.parseLong(timeStr);
		Calendar parseCalendar = Calendar.getInstance();
		parseCalendar.setTimeInMillis(time);
		Calendar curCalendar = Calendar.getInstance();
		String format;
		if (parseCalendar.get(Calendar.YEAR) < curCalendar.get(Calendar.YEAR)) {
			format = "yyyy年MM月dd日 HH:mm";
		} else if (parseCalendar.get(Calendar.DAY_OF_YEAR) < curCalendar
				.get(Calendar.DAY_OF_YEAR)) {
			format = "MM月dd日 HH:mm";
		} else {
			format = "HH:mm";
		}
		DateFormat dateFormat = new SimpleDateFormat(format);
		return dateFormat.format(parseCalendar.getTime());
	}

	/**
	 * 解析时间 yyyy年MM月dd日 HH时mm分
	 *
	 * @param timeStr
	 * @return
	 */
	public static String parserTime4(String timeStr) {
		long time = Long.parseLong(timeStr);
		Calendar parseCalendar = Calendar.getInstance();
		parseCalendar.setTimeInMillis(time);
		Calendar curCalendar = Calendar.getInstance();
		String format;
//		if (parseCalendar.get(Calendar.YEAR) < curCalendar.get(Calendar.YEAR)) {
//			format = "yyyy年MM月dd日 HH:mm";
//		} else if (parseCalendar.get(Calendar.DAY_OF_YEAR) < curCalendar
//				.get(Calendar.DAY_OF_YEAR)) {
//			format = "MM月dd日 HH:mm";
//		} else {
//			format = "HH:mm";
//		}
		format = "yyyy-MM-dd HH:mm";
		DateFormat dateFormat = new SimpleDateFormat(format);
		return dateFormat.format(parseCalendar.getTime());
	}

	public static String parserTime2(String timeStr) {
		long time = Long.parseLong(timeStr);
		// 本日内容显示“**时**分”；本年非本日内容显示“**月**日**时**分”；非本年内容显示“**年**月**日”
		Calendar parseCalendar = Calendar.getInstance();
		parseCalendar.setTimeInMillis(time);
		Calendar curCalendar = Calendar.getInstance();
		String format = "yyyy-MM-dd";
		if (parseCalendar.get(Calendar.YEAR) == curCalendar.get(Calendar.YEAR)) {
			if (parseCalendar.get(Calendar.DAY_OF_YEAR) == curCalendar
					.get(Calendar.DAY_OF_YEAR)) {
				format = "HH:mm";
			} else {
				format = "yyyy-MM-dd";
			}
		} else if (parseCalendar.get(Calendar.DAY_OF_YEAR) != curCalendar
				.get(Calendar.DAY_OF_YEAR)) {
			format = "yyyy-MM-dd";
		}
		DateFormat dateFormat = new SimpleDateFormat(format);
		return dateFormat.format(parseCalendar.getTime());
	}

	public static String parserTimeType1(String timeStr) {
		long time = Long.parseLong(timeStr.trim());
		Calendar parseCalendar = Calendar.getInstance();
		parseCalendar.setTimeInMillis(time);
		// Calendar curCalendar = Calendar.getInstance();
		String format;
		format = "MM-dd HH:mm";
		DateFormat dateFormat = new SimpleDateFormat(format);
		return dateFormat.format(parseCalendar.getTime());
	}

	/**
	 * 解析时间 时间格式是 本天： HH时mm分 本年非本天：MM月dd日HH时 非本年： yyyy年MM月dd日
	 * 
	 * @param timeStr
	 * @return
	 */
	public static String parserTimeType(String timeStr) {
		long time = Long.parseLong(timeStr.trim());
		Calendar parseCalendar = Calendar.getInstance();
		parseCalendar.setTimeInMillis(time);
		Calendar curCalendar = Calendar.getInstance();
		String format;
		int iFlag = 0;
		if (parseCalendar.get(Calendar.YEAR) < curCalendar.get(Calendar.YEAR)) {
			format = "yy-MM-dd HH:mm";
		} else if (parseCalendar.get(Calendar.DAY_OF_YEAR) < curCalendar
				.get(Calendar.DAY_OF_YEAR)) {
			format = "MM-dd HH:mm";
		} else {
			iFlag = -1;
			format = "HH:mm";
		}
		DateFormat dateFormat = new SimpleDateFormat(format);
		String strParserTime = dateFormat.format(parseCalendar.getTime());
		if (iFlag == -1) {
			strParserTime = "今天 " + strParserTime;
		}
		return strParserTime;
	}

	/**
	 * 解析时间 时间格式是 本天： HH时mm分 本年非本天：MM月dd日HH时 非本年： yyyy年MM月dd日
	 * 
	 * @param timeStr
	 * @return
	 */
	public static String parserTimeType2(String timeStr) {
		long time = Long.parseLong(timeStr.trim());
		Calendar parseCalendar = Calendar.getInstance();
		parseCalendar.setTimeInMillis(time);
		Calendar curCalendar = Calendar.getInstance();
		String format;
		int iFlag = 0;
		if (parseCalendar.get(Calendar.YEAR) < curCalendar.get(Calendar.YEAR)) {
			format = "yy/MM/dd HH:mm";
		} else if (parseCalendar.get(Calendar.DAY_OF_YEAR) < curCalendar
				.get(Calendar.DAY_OF_YEAR)) {
			format = "MM/dd HH:mm";
		} else {
			iFlag = -1;
			format = "HH:mm";
		}
		DateFormat dateFormat = new SimpleDateFormat(format);
		String strParserTime = dateFormat.format(parseCalendar.getTime());
		if (iFlag == -1) {
			strParserTime = "今天 " + strParserTime;
		}
		return strParserTime;
	}

	/**
	 * 获取时间是当年度第几天
	 * 
	 * @param datedate
	 * @return
	 */
	public static int getDaysInYear(Date date) {
		String daysStr = String.format("%tj", date);
		try {
			return Integer.parseInt(daysStr);
		} catch (Exception e) {
			return -1;
		}
	}

	public static String parserTime(long time) {
		Calendar parseCalendar = Calendar.getInstance();
		parseCalendar.setTimeInMillis(time);
		Calendar curCalendar = Calendar.getInstance();
		// Log4Tsingda.e("TabView", "======parserTime===time======" + time);
		// Log4Tsingda.e("TabView", "======parserTime===curCalendar======" +
		// curCalendar.getTimeInMillis());
		String format = "yyyy-MM-dd HH:mm:ss";
		// String format;
		// if (parseCalendar.get(Calendar.YEAR) <
		// curCalendar.get(Calendar.YEAR)) {
		// // format = "yy/MM/dd HH:mm";
		// format = "yy年MM月dd日";
		// } else if (parseCalendar.get(Calendar.DAY_OF_YEAR) < curCalendar
		// .get(Calendar.DAY_OF_YEAR)) {
		// // format = "MM/dd HH:mm";
		// format = "MM月dd日";
		// } else {
		// longvideo sub = curCalendar.getTimeInMillis() - time;
		// if (sub < 1000 * 60) {
		// return "刚刚";
		// } else if (sub < 1000 * 60 * 60) {
		// return "" + sub / (1000 * 60) + "分钟前";
		// } else if (sub < 1000 * 60 * 60 * 24) {
		// return "" + sub / (1000 * 60 * 60) + "小时前";
		// }
		// format = "HH:mm";
		// }

		DateFormat dateFormat = new SimpleDateFormat(format, Locale.CHINA);
		return dateFormat.format(parseCalendar.getTime());
	}

	public static String getStrTime(Date cc_time) {
		String re_StrTime = null;
		SimpleDateFormat sdf = new SimpleDateFormat("MM月dd日  HH:mm");
		String time = sdf.format(cc_time);
		return time;
	}

	public static String getDate() {
		SimpleDateFormat formatter = new SimpleDateFormat(
				"yyyy年MM月dd日 HH:mm:ss ");
		Date curDate = new Date(System.currentTimeMillis());
		String str = formatter.format(curDate);
		return str;
	}

	public static Date getStartTime(String time) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String realTime = time + "-8 15:30:22";
		Log.i("JuXian", "编码时间" + realTime);
		Date date = null;
		try {
			date = sdf.parse(realTime);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return date;
	}

	/**
	 * 获取两个日期之间的间隔天数
	 * @return
	 */
	public static int getGapCount(Date startDate, Date endDate) {
		Calendar fromCalendar = Calendar.getInstance();
		fromCalendar.setTime(startDate);
		fromCalendar.set(Calendar.HOUR_OF_DAY, 0);
		fromCalendar.set(Calendar.MINUTE, 0);
		fromCalendar.set(Calendar.SECOND, 0);
		fromCalendar.set(Calendar.MILLISECOND, 0);

		Calendar toCalendar = Calendar.getInstance();
		toCalendar.setTime(endDate);
		toCalendar.set(Calendar.HOUR_OF_DAY, 0);
		toCalendar.set(Calendar.MINUTE, 0);
		toCalendar.set(Calendar.SECOND, 0);
		toCalendar.set(Calendar.MILLISECOND, 0);

		return (int) ((toCalendar.getTime().getTime() - fromCalendar.getTime().getTime()) / (1000 * 60 * 60 * 24));
	}

	/**
	 * 获取两个日期之间的间隔小时数
	 * @return
	 */
	public static int getHourDifferenceValue(Date startDate, Date endDate) {
		Calendar fromCalendar = Calendar.getInstance();
		fromCalendar.setTime(startDate);
		fromCalendar.set(Calendar.HOUR_OF_DAY, 0);
		fromCalendar.set(Calendar.MINUTE, 0);
		fromCalendar.set(Calendar.SECOND, 0);
		fromCalendar.set(Calendar.MILLISECOND, 0);

		Calendar toCalendar = Calendar.getInstance();
		toCalendar.setTime(endDate);
		toCalendar.set(Calendar.HOUR_OF_DAY, 0);
		toCalendar.set(Calendar.MINUTE, 0);
		toCalendar.set(Calendar.SECOND, 0);
		toCalendar.set(Calendar.MILLISECOND, 0);

		return (int) ((toCalendar.getTime().getTime() - fromCalendar.getTime().getTime()) / (1000 * 60 * 60));
	}
}
