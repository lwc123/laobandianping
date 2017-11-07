package com.juxian.bosscomments.repositories;

import com.android.volley.Request;
import com.android.volley.Response;
import com.google.gson.reflect.TypeToken;
import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.models.CompanyAuditEntity;
import com.juxian.bosscomments.models.EmployeArchiveEntity;
import com.juxian.bosscomments.models.EmployeArchiveListEntity;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.models.ResultEntity;

import net.juxian.appgenome.webapi.WebApiClient;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

/**
 * Created by nene on 2016/12/8.
 * 企业员工档案API
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/8 12:59]
 * @Version: [v1.0]
 */
public class EmployeArchiveRepository {
    /**
     * 添加员工档案
     * @param entity
     * @return
     */
    public static ResultEntity addEmployeArchive(EmployeArchiveEntity entity){
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.EmployeArchive_Add_Endpoint, entity,
                ResultEntity.class);
        if (responseResult.isSuccess()) {
            return (ResultEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 获取档案列表
     */
    @SuppressWarnings("unchecked")
    public static EmployeArchiveListEntity getEmployeeList(long CompanyId) {
        String apiUrl = String.format(ApiEnvironment.EmployeArchive_EmployeList_Endpoint, CompanyId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl,EmployeArchiveListEntity.class);
        if (responseResult.isSuccess()) {
            return (EmployeArchiveListEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 验证身份证号是否存在
     */
    @SuppressWarnings("unchecked")
    public static ResultEntity checkIDCard(long CompanyId, String IDCard) {
        String apiUrl = String.format(ApiEnvironment.EmployeArchive_ExistsIDCard_Endpoint, CompanyId,IDCard);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl,ResultEntity.class);
        if (responseResult.isSuccess()) {
            return (ResultEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 获取档案详情
     */
    @SuppressWarnings("unchecked")
    public static EmployeArchiveEntity getArchiveDetail(long CompanyId,long ArchiveId) {
        String apiUrl = String.format(ApiEnvironment.EmployeArchive_ArchiveDetail_Endpoint, CompanyId,ArchiveId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl,EmployeArchiveEntity.class);
        if (responseResult.isSuccess()) {
            return (EmployeArchiveEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 修改员工档案
     * @param entity
     * @return
     */
    public static ResultEntity updateEmployeeArchive(EmployeArchiveEntity entity){
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.EmployeArchive_Update_Endpoint, entity,
                ResultEntity.class);
        if (responseResult.isSuccess()) {
            return (ResultEntity) responseResult.result;
        } else {
            return null;
        }
    }

    public static List<EmployeArchiveEntity> getSearchResult(long CompanyId, String RealName, int page) {
        String RealNameEncode = RealName;
        try {
            RealNameEncode = URLEncoder.encode(RealName, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        String apiUrl = String.format(ApiEnvironment.EmployeArchive_Search_Endpoint, CompanyId, RealNameEncode, page, ApiEnvironment.OnceLoadItemCount);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, new TypeToken<List<EmployeArchiveEntity>>() {
        }.getType());
        if (responseResult.isSuccess()) {
            return (List<EmployeArchiveEntity>) responseResult.result;
        } else {
            return null;
        }
    }
}
