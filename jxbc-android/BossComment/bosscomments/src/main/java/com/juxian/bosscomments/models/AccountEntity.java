package com.juxian.bosscomments.models;

import com.google.gson.Gson;

import java.util.Date;

public class AccountEntity extends BaseEntity {
	public long AccountId = 0;
	public long PassportId = 0;
	public long DeviceId = 0;
	public String Nickname = null;
	public String MobilePhone = null;
	public String Avatar = null;
	public AccountToken Token = null;
	public UserProfileEntity UserProfile = null;
//	public ConsultantProfileEntity ConsultantProfile = null;
	public ThirdIMAccount IMAccount = null;
	public int MultipleProfiles;

	public AccountEntity() {
	}

	public boolean isAuthenticated() {
		return this.PassportId > 0;
	}
	
	public UserProfileEntity getProfile() {
//		return null == this.ConsultantProfile ? this.UserProfile : this.ConsultantProfile;
		return UserProfile;
	}

	@Override
	public String toString() {
		return new Gson().toJson(this);
	}

	public class AccountToken {
		public String AccessToken = null;
		public Date ExpiresTime = null;
	}
	public class ThirdIMAccount {
		public String PlatformAccountId = null;
		public String PlatformAccountPassword = null;
	}
	
}
