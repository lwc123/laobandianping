package net.juxian.appgenome.utils;

import java.lang.reflect.Type;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public final class JsonUtil {
	public static final String DateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

	public static Gson BuildGson() {
		return new GsonBuilder().setDateFormat(DateFormat).create();
	}

	public static String ToJson(Object obj) {
		Gson gson = BuildGson();
		return gson.toJson(obj);
	}

	public static <T> T ToEntity(String json, Type target) {
		Gson gson = BuildGson();
		return gson.fromJson(json, target);
	}
}
