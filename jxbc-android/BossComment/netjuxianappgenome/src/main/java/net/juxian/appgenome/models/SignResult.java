package net.juxian.appgenome.models;

public abstract class SignResult {
	public static final int SUCCESS = 1;
    public static final int InvalidValidationCode = 2;
	public static final int ERROR = 9;
	public static final int INVALID_EMAIL = 101;	
	public static final int INVALID_MOBILEPHONE = 102;
	public static final int INVALID_USERNAME = 103;
	public static final int INVALID_PASSWORD = 109;
	public static final int DUPLICATE_MOBILEPHONE = 202;
	public static final int DUPLICATE_ENTNAME = 204;// 重复的企业名
	public static final int USER_REJECTED = 999;
	
	public int SignStatus;	
	public String ErrorMessage;
}
