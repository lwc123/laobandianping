package com.juxian.bosscomments.repositories;

import com.android.volley.Request;
import com.android.volley.Response;
import com.juxian.bosscomments.models.CompanyAuditEntity;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.InvitedRegisterEntity;

import net.juxian.appgenome.webapi.WebApiClient;

/**
 * Created by nene on 2016/12/2.
 * 企业相关API
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/2 17:55]
 * @Version: [v1.0]
 */
public class CompanyRepository {

    public static CompanyEntity getSummary(long CompanyId){
        String apiUrl = String.format(ApiEnvironment.Company_Summary_Endpoint, CompanyId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl,CompanyEntity.class);
        if (responseResult.isSuccess()) {
            return (CompanyEntity) responseResult.result;
        } else {
            return null;
        }
    }

    public static CompanyEntity getMine(long CompanyId){
        String apiUrl = String.format(ApiEnvironment.Company_Mine_Endpoint, CompanyId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl,CompanyEntity.class);
        if (responseResult.isSuccess()) {
            return (CompanyEntity) responseResult.result;
        } else {
            return null;
        }
    }

    public static boolean updateCompanyInfo(CompanyEntity entity) {
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.Company_Update_Endpoint, entity,
                Boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }

    public static CompanyAuditEntity getRejectCompanyInfo(long CompanyId){
        String apiUrl = String.format(ApiEnvironment.Company_MyAuditInfo_Endpoint, CompanyId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl,CompanyAuditEntity.class);
        if (responseResult.isSuccess()) {
            return (CompanyAuditEntity) responseResult.result;
        } else {
            return null;
        }
    }

    public static InvitedRegisterEntity getInviteRegister(long CompanyId){
        String apiUrl = String.format(ApiEnvironment.Company_InviteRegister_Endpoint, CompanyId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl,InvitedRegisterEntity.class);
        if (responseResult.isSuccess()) {
            return (InvitedRegisterEntity) responseResult.result;
        } else {
            return null;
        }
    }
}
