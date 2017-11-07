package com.juxian.bosscomments.repositories;

import com.android.volley.Request;
import com.android.volley.Response;
import com.google.gson.reflect.TypeToken;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.models.ResultEntity;

import net.juxian.appgenome.webapi.WebApiClient;

import java.util.List;

/**
 * Created by nene on 2016/12/8.
 * 企业成员相关API
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/8 12:59]
 * @Version: [v1.0]
 */
public class CompanyMemberRepository {

    public static ResultEntity addCompanyMember(MemberEntity entity){
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.CompanyMember_Add_Endpoint, entity,
                ResultEntity.class);
        if (responseResult.isSuccess()) {
            return (ResultEntity) responseResult.result;
        } else {
            return null;
        }
    }
    public static boolean updateCompanyMember(MemberEntity entity) {
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.CompanyMember_Update_Endpoint, entity,
                Boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }
    public static boolean deleteCompanyMember(MemberEntity entity) {
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.CompanyMember_Delete_Endpoint, entity,
                Boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }
    @SuppressWarnings("unchecked")
    public static List<MemberEntity> getMyRoles() {

        Response<?> responseResult = WebApiClient.getSingleton().httpGet(ApiEnvironment.CompanyMember_MyRoles_Endpoint,new TypeToken<List<MemberEntity>>(){}.getType());
        if (responseResult.isSuccess()) {
            return (List<MemberEntity>) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 获取授权人管理列表
     * @return
     */
    @SuppressWarnings("unchecked")
    public static List<MemberEntity> getCompanyMemberList(long CompanyId) {
        String apiUrl = String.format(ApiEnvironment.CompanyMember_CompanyMemberListByCompany_Endpoint,CompanyId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl,new TypeToken<List<MemberEntity>>(){}.getType());
        if (responseResult.isSuccess()) {
            return (List<MemberEntity>) responseResult.result;
        } else {
            return null;
        }
    }
}
