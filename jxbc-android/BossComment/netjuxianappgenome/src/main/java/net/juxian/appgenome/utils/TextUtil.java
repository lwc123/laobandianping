package net.juxian.appgenome.utils;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

public class TextUtil {

	public static String urlEncode(String str) {
		try {
			return URLEncoder.encode(str, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return str;
	}
	
	public static boolean isNullOrEmpty(CharSequence str) {
		return (str == null || str.length() == 0);
    }
	
	public static String join(Object[] array, String separator) {
		if(null == array) return null;
		if(0 == array.length) return "";
		
		StringBuilder builder = new StringBuilder(array.length * 16);
		for(int i=0; i<array.length-1; i++) {
			builder.append(array[i]).append(separator);
		}
		builder.append(array[array.length-1]);
		return builder.toString();
    }
}
