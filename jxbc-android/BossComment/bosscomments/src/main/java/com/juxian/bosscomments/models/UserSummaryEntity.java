package com.juxian.bosscomments.models;

public class UserSummaryEntity extends BaseEntity  {
    public float WalletBalance;        // 钱包余额
    public int ResumeIntegrality;    // 简历完整度
    public UserProfileEntity UserProfile = null;

    public UserProfileEntity getProfile() {
        return UserProfile;
    }

    @Override
    public String toString() {
        return "UserSummaryEntity [WalletBalance=" + WalletBalance
                + ", ResumeIntegrality=" + ResumeIntegrality + ", Profile="
                + UserProfile + "]";
    }

}
