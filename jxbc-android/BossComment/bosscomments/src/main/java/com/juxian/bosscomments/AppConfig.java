package com.juxian.bosscomments;

import net.juxian.appgenome.utils.AppConfigUtil;

public class AppConfig extends AppConfigUtil {
    
	private static final String ACCOUNT_CURRENT = "Account:Current";
    private static final String ACCOUNT_NICKNAME = "Account:Nickname";
    private static final String ACCOUNT_AVATAR = "Account:Avatar";
    private static final String ACCOUNT_LAST_POST_COMPANY = "LastPostCompany";
	private static final String CURRENT_PROFILE_TYPE = "CurrentProfileType";
	private static final String CURRENT_USE_COMPANY = "CurrentUseCompany";
	private static final String COMPANY_BOSS_INFORMATION = "BossInformation";
	private static final String CURRENT_USER_INFORMATION = "CurrentUserInformation";
	private static final String PERSONAL_SERVICE_CONTRACT = "PersonalServiceContract";
	private static final String COMPANY_ABBR = "CompanyAbbr";
	private static final String CONSOLE_INDEX = "ConsoleIndex";
	private static final String ACCOUNT_COMPANY = "Account:Company";
    
    private static final String BAIDU_APPKEY = "BAIDU_APPKEY";
        		
	public static String getBaiduAppKey() {
		return AppConfigUtil.getMetaData(BAIDU_APPKEY);
	}
	
	public static String getAccountData() {
		return get(ACCOUNT_CURRENT);
	}
	
	public static void setAccountData(String json) {
		set(ACCOUNT_CURRENT, json);
	}

	public static String getBossInformation() {
		return get(COMPANY_BOSS_INFORMATION);
	}

	public static void setBossInformation(String json) {
		set(COMPANY_BOSS_INFORMATION, json);
	}

	public static String getCurrentUserInformation() {
		return get(CURRENT_USER_INFORMATION);
	}

	public static void setCurrentUserInformation(String json) {
		set(CURRENT_USER_INFORMATION, json);
	}

	public static String getPersonalServiceContract() {
		return get(PERSONAL_SERVICE_CONTRACT);
	}

	public static void setPersonalServiceContract(String json) {
		set(PERSONAL_SERVICE_CONTRACT, json);
	}

	public static String getNickname() {
		return get(ACCOUNT_NICKNAME);
	}
	
	public static void setNickname(String nickname) {
		set(ACCOUNT_NICKNAME, nickname);
	}
	
	//获取头像
	public static String getAvatar() {
		return get(ACCOUNT_AVATAR);
	}
	
	public static void setAvatar(String avatar) {
		set(ACCOUNT_AVATAR, avatar);
	}	
	
	public static String getLastPostCompany() {
		return get(ACCOUNT_LAST_POST_COMPANY);
	}
	
	public static void setLastPostCompany(String avatar) {
		set(ACCOUNT_LAST_POST_COMPANY, avatar);
	}

	public static long getCurrentProfileType() {
		return getLong(CURRENT_PROFILE_TYPE);
	}

	public static void setCurrentProfileType(long type) {
		set(CURRENT_PROFILE_TYPE, type);
	}

	public static long getCurrentUseCompany() {
		return getLong(CURRENT_USE_COMPANY);
	}

	public static void setCurrentUseCompany(long companyId) {
		set(CURRENT_USE_COMPANY, companyId);
	}

	public static void setCompanyAbbr(String CompanyAbbr){
		set(COMPANY_ABBR,CompanyAbbr);
	}

	public static String getCompanyAbbr(){
		return get(COMPANY_ABBR);
	}

	public static void setConsoleIndex(String ConsoleIndex){
		set(CONSOLE_INDEX,ConsoleIndex);
	}

	public static String getConsoleIndex(){
		return get(CONSOLE_INDEX);
	}

	public static String getAccountCompany() {
		return get(ACCOUNT_COMPANY);
	}

	public static void setAccountCompany(String json) {
		set(ACCOUNT_COMPANY, json);
	}
}
