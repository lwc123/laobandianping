package com.juxian.bosscomments.repositories;

import com.android.volley.Response;
import com.google.gson.reflect.TypeToken;
import com.juxian.bosscomments.models.BizDictEntity;

import net.juxian.appgenome.webapi.WebApiClient;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

public class DictionaryRepository {

	/**
	 * 字典
	 */
	@SuppressWarnings("unchecked")
	public static HashMap<String, List<BizDictEntity>> GetDictionaries(String codes) {
		String apiUrl = ApiEnvironment.Dictionary_Dictionaries_Endpoint
				+ "?Code=" + codes;

		Response<?> responseResult = WebApiClient.getSingleton().httpGet(
				apiUrl, new TypeToken<HashMap<String, List<BizDictEntity>>>() {
				}.getType());
		if (responseResult.isSuccess()) {
			return (HashMap<String, List<BizDictEntity>>) responseResult.result;
		} else {
			return null;
		}
	}

//	@SuppressWarnings("unchecked")
//	public static LinkedHashMap<String, List<BizDictEntity>> GetDic(String codes) {
//		String apiUrl = ApiEnvironment.Dictionary_Dictionaries_Endpoint
//				+ "?codes=" + codes;
//
//		Response<?> responseResult = WebApiClient.getSingleton().httpGet(
//				apiUrl,
//				new TypeToken<LinkedHashMap<String, List<BizDictEntity>>>() {
//				}.getType());
//		if (responseResult.isSuccess()) {
//			return (LinkedHashMap<String, List<BizDictEntity>>) responseResult.result;
//		} else {
//			return null;
//		}
//	}


}
