package com.juxian.bosscomments.models;

public class AccountSign extends BaseEntity {

	public static final int USER_PROFILE = 1;
	public static final int ORGANIZATION_PROFILE = 2;

	public String MobilePhone;
	public String Password;
	public String ValidationCode;
	public String RealName;
	public AdditionalAction AdditionalAction;
	public String Nickname;
	public String CurrentCompany;
	public String CurrentIndustry;
	public String CurrentJobCategory;
	public int SelectedProfileType;
	public String InviteCode;
}