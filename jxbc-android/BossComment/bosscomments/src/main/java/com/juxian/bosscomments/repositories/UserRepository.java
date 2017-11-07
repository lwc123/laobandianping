package com.juxian.bosscomments.repositories;

import com.android.volley.Response;
import com.juxian.bosscomments.models.AccountEntity;
import com.juxian.bosscomments.models.AvatarEntity;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.OpenEnterpriseRequestEntity;
import com.juxian.bosscomments.models.UserProfileEntity;
import com.juxian.bosscomments.models.UserSummaryEntity;
import com.juxian.bosscomments.models.VersionEntity;

import net.juxian.appgenome.webapi.WebApiClient;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

/**
 * 用户信息api
 *
 * @author nene-zzq
 */
public class UserRepository {

    /**
     * 获取用户摘要信息，用于页面"我"
     */
    public static UserSummaryEntity GetSummary() {
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(
                ApiEnvironment.User_Summary_Endpoint, UserSummaryEntity.class);
        if (responseResult.isSuccess()) {
            return (UserSummaryEntity) responseResult.result;
        } else {
            return null;
        }
    }

    public static boolean ChangeProfile(UserProfileEntity entity) {
        Response<?> responseResult = WebApiClient.getSingleton()
                .httpPost(ApiEnvironment.User_ChangeProfile_Endpoint,entity, boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }

    /**
     * 修改用户头像
     */
    public static String ChangeAvatar(AvatarEntity entity) {
        Response<?> responseResult = WebApiClient.getSingleton()
                .httpPost(ApiEnvironment.User_ChangeAvatar_Endpoint, entity,
                        String.class);
        if (responseResult.isSuccess()) {
            return (String) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 验证身份证号是否存在
     */
    @SuppressWarnings("unchecked")
    public static boolean checkCompanyName(String CompanyName) {
        String CompanyNameEncode = CompanyName;
        try {
            CompanyNameEncode = URLEncoder.encode(CompanyName, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        String apiUrl = String.format(ApiEnvironment.User_ExistsCompany_Endpoint, CompanyNameEncode);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, Boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }

    public static AccountEntity ChangeCurrentToUserProfile() {
        Response<?> responseResult = WebApiClient.getSingleton()
                .httpPost(ApiEnvironment.User_ChangeCurrentToUserProfile_Endpoint, null,
                        AccountEntity.class);
        if (responseResult.isSuccess()) {
            return (AccountEntity) responseResult.result;
        } else {
            return null;
        }
    }

    public static AccountEntity ChangeCurrentToOrganizationProfile(UserProfileEntity profileEntity) {
        Response<?> responseResult = WebApiClient.getSingleton()
                .httpPost(ApiEnvironment.User_ChangeCurrentToOrganizationProfile_Endpoint, profileEntity,
                        AccountEntity.class);
        if (responseResult.isSuccess()) {
            return (AccountEntity) responseResult.result;
        } else {
            return null;
        }
    }

    public static CompanyEntity CreateNewCompany(OpenEnterpriseRequestEntity entity) {
        Response<?> responseResult = WebApiClient.getSingleton()
                .httpPost(ApiEnvironment.User_CreateNewCompany_Endpoint, entity,
                        CompanyEntity.class);
        if (responseResult.isSuccess()) {
            return (CompanyEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 版本更新
     *
     * @param versionCode
     * @param AppType     android或ios
     * @return
     */
    public static VersionEntity ExistsVersion(String versionCode, String AppType) {
        String apiUrl = String.format(ApiEnvironment.User_ExistsVersion_Endpoint, versionCode, AppType);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(
                apiUrl, VersionEntity.class);
        if (responseResult.isSuccess()) {
            return (VersionEntity) responseResult.result;
        } else {
            return null;
        }
    }
}
