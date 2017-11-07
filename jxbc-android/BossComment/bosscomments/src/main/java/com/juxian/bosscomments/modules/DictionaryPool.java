package com.juxian.bosscomments.modules;


import com.juxian.bosscomments.models.BizDictEntity;
import com.juxian.bosscomments.repositories.DictionaryRepository;

import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.utils.JsonUtil;

import java.util.HashMap;
import java.util.List;

public class DictionaryPool {
	// 学历
	public static final String Code_Ccademic = "academic";
	// 城市
	public static final String Code_City = "city";
	// 行业
	public static final String Code_Industry = "industry";
	// 返聘意愿
	public static final String Code_Panicked = "panicked";
	// 薪资水平
	public static final String Code_Salary = "salary";
	// 时间段
	public static final String Code_Period = "period";
	// 离任原因
	public static final String Code_Leaving = "leaving";
	// 公司规模
	public static final String Code_CompanySize = "CompanySize";
	// 工作经验
	public static final String Code_Resume_WorkYear = "Resume_WorkYear";

	public static List<BizDictEntity> getDictionary(String code) {
		HashMap<String, List<BizDictEntity>> data = loadDictionaries();

		if (null != data && data.containsKey(code)) {
			return data.get(code);
		}
		return null;
	}

	public static HashMap<String, List<BizDictEntity>> loadDictionaries() {
		String codes = Code_Ccademic.concat(",").concat(Code_City)
				.concat(",").concat(Code_Industry).concat(",")
				.concat(Code_Panicked).concat(",")
				.concat(Code_Salary).concat(",")
				.concat(Code_Period).concat(",")
				.concat(Code_Leaving);

		HashMap<String, List<BizDictEntity>> result = DictionaryRepository
				.GetDictionaries(codes);
		LogManager.getLogger().i(JsonUtil.ToJson(result));
		return result;
	}

	public static HashMap<String, List<BizDictEntity>> loadAdvertiseDictionaries() {
		String codes = Code_Ccademic.concat(",").concat(Code_Resume_WorkYear);

		HashMap<String, List<BizDictEntity>> result = DictionaryRepository
				.GetDictionaries(codes);
		LogManager.getLogger().i(JsonUtil.ToJson(result));
		return result;
	}

	public static HashMap<String, List<BizDictEntity>> loadDepartureDictionaries() {
		String codes = Code_Panicked.concat(",").concat(Code_Leaving);

		HashMap<String, List<BizDictEntity>> result = DictionaryRepository
				.GetDictionaries(codes);
		LogManager.getLogger().i(JsonUtil.ToJson(result));
		return result;
	}

	public static HashMap<String, List<BizDictEntity>> loadCityDictionaries() {
		String codes = Code_City;

		HashMap<String, List<BizDictEntity>> result = DictionaryRepository
				.GetDictionaries(codes);
		LogManager.getLogger().i(JsonUtil.ToJson(result));
		return result;
	}

	public static HashMap<String, List<BizDictEntity>> loadScaleDictionaries() {
		String codes = Code_CompanySize;

		HashMap<String, List<BizDictEntity>> result = DictionaryRepository
				.GetDictionaries(codes);
		LogManager.getLogger().i(JsonUtil.ToJson(result));
		return result;
	}

	public static HashMap<String, List<BizDictEntity>> loadPeriodDictionaries() {
		String codes = Code_Period;

		HashMap<String, List<BizDictEntity>> result = DictionaryRepository
				.GetDictionaries(codes);
		LogManager.getLogger().i(JsonUtil.ToJson(result));
		return result;
	}

	public static HashMap<String, List<BizDictEntity>> loadIndustryDictionaries() {
		String codes = Code_Industry;

		HashMap<String, List<BizDictEntity>> result = DictionaryRepository
				.GetDictionaries(codes);
		LogManager.getLogger().i(JsonUtil.ToJson(result));
		return result;
	}

	public static HashMap<String, List<BizDictEntity>> loadAcademicDictionaries() {
		String codes = Code_Ccademic;

		HashMap<String, List<BizDictEntity>> result = DictionaryRepository
				.GetDictionaries(codes);
		LogManager.getLogger().i(JsonUtil.ToJson(result));
		return result;
	}

	public static HashMap<String, List<BizDictEntity>> loadCityIndustryDictionaries() {
		String codes = Code_City.concat(",").concat(Code_Industry);

		HashMap<String, List<BizDictEntity>> result = DictionaryRepository
				.GetDictionaries(codes);
		LogManager.getLogger().i(JsonUtil.ToJson(result));
		return result;
	}

	public static HashMap<String, List<BizDictEntity>> loadSpecificDictionary(String... code) {
		String codes = "";
		if (code.length == 1){
			codes = code[0];
		} else if (code.length > 1){
			for (int i = 0; i < code.length; i++) {
				if (i<code.length-1){
					codes = codes.concat(code[i]).concat(",");
				} else {
					codes = codes.concat(code[i]);
				}
			}
		}
		HashMap<String, List<BizDictEntity>> result = DictionaryRepository
				.GetDictionaries(codes);
		LogManager.getLogger().i(JsonUtil.ToJson(result));
		return result;
	}

//	public static LinkedHashMap<String, DictionaryEntity> loadDic() {
//		String codes = Code_IndustryCategory.concat(",")
//				.concat(",").concat(Code_Industry).concat(",")
//				.concat(Code_ServiceSequenceType);
//		LinkedHashMap<String, DictionaryEntity> result = DictionaryRepository
//				.GetDic(codes);
//		LogManager.getLogger().i(JsonUtil.ToJson(result));
//		return result;
//	}
}
