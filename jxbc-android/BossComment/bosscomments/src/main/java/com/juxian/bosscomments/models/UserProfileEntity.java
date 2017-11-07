package com.juxian.bosscomments.models;


import com.juxian.bosscomments.AppContext;

import java.util.Date;

public class UserProfileEntity extends BaseEntity {
	public static final int ProfileType_User = 1;
	public static final int ProfileType_Consultant = 2;

	public static final int AttestationStatus_None = 0;
	public static final int AttestationStatus_Submited = 1;
	public static final int AttestationStatus_Passed = 2;
	public static final int AttestationStatus_Rejected = 9;

	public long PassportId;

	public long CurrentOrganizationId;
	public int CurrentProfileType;

	public String Nickname;
	public String RealName;
	public int Gender; // 性别
	public String Avatar; // 头像
	public Date Birthday;
	public String Email;
	public String MobilePhone;
	public String Signature; // 个人签名
	public String CurrentCompany; // 当前公司
	public String CurrentJobTitle; // 当前职位
	public String CurrentIndustry; // 当前行业
	public String CurrentJobCategory; // 当前职能
	public String CurrentIndustryText; // 当前行业的文本
	public String CurrentJobCategoryText; // 当前职能的文本
	public Date LastActivityTime; // 活跃时间
	public String Brief;// 个人简介
	public String EntName;
	public String LegalRepresentative;
	public int AttestationStatus;

	//
	// public String LastSignedInTime;
	// public String CreatedTime;
	// public String ModifiedTime;
	// public longvideo Id;
	// public int PersistentState;

	public int getCurrentProfileType() {
		return ProfileType_User;
	}

	public Boolean isConsultant() {
		return false;
	}

	public String getMobilePhone() {
		return AppContext.getCurrent().getCurrentAccount().MobilePhone;
	}

	@Override
	public String toString() {
		return "UserProfileEntity [PassportId=" + PassportId + ", Nickname="
				+ Nickname + ", RealName=" + RealName + ", Gender=" + Gender
				+ ", Avatar=" + Avatar + ", Birthday=" + Birthday + ", Email="
				+ Email + ", Signature=" + Signature + ", CurrentCompany="
				+ CurrentCompany + ", CurrentJobTitle=" + CurrentJobTitle
				+ ", CurrentIndustry=" + CurrentIndustry
				+ ", CurrentJobCategory=" + CurrentJobCategory
				+ ", LastActivityTime=" + LastActivityTime + ", Brief=" + Brief
				+ "]";
	}

}
