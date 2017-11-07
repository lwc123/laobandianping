package com.juxian.bosscomments.repositories;

import com.android.volley.Request;
import com.android.volley.Response;
import com.google.gson.reflect.TypeToken;
import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.models.ArchiveCommentLogEntity;
import com.juxian.bosscomments.models.ResultEntity;
import com.juxian.bosscomments.models.StageSectionEntity;

import net.juxian.appgenome.webapi.WebApiClient;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

/**
 * Created by nene on 2016/12/13.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/13 17:25]
 * @Version: [v1.0]
 */
public class ArchiveCommentRepository {
    public static long addArchiveComment(ArchiveCommentEntity entity) {
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.ArchiveComment_Add_Endpoint, entity,
                Long.class);
        if (responseResult.isSuccess()) {
            return (Long) responseResult.result;
        } else {
            return 0;
        }
    }

    public static boolean passArchiveComment(long CompanyId, long CommentId, boolean isSendSms) {
        String apiUrl = String.format(ApiEnvironment.ArchiveComment_AuditPass_Endpoint, CompanyId, CommentId, isSendSms);
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, apiUrl, null, Boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }

    public static boolean rejectArchiveComment(ArchiveCommentEntity entity) {
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.ArchiveComment_AuditReject_Endpoint, entity,
                Boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }

    public static List<ArchiveCommentEntity> getMyComments(long CompanyId, int AuditStatus, int pageIndex) {
        String apiUrl = String.format(ApiEnvironment.ArchiveComment_MyCommentList_Endpoint, CompanyId, AuditStatus, pageIndex, ApiEnvironment.OnceLoadItemCount);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, new TypeToken<List<ArchiveCommentEntity>>() {
        }.getType());
        if (responseResult.isSuccess()) {
            return (List<ArchiveCommentEntity>) responseResult.result;
        } else {
            return null;
        }
    }

    public static List<ArchiveCommentEntity> getSearchResult(long CompanyId, int CommentType, String RealName, int page) {
        String RealNameEncode = RealName;
        try {
            RealNameEncode = URLEncoder.encode(RealName, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        String apiUrl = String.format(ApiEnvironment.ArchiveComment_Search_Endpoint, CompanyId, CommentType, RealNameEncode, page, ApiEnvironment.OnceLoadItemCount);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, new TypeToken<List<ArchiveCommentEntity>>() {
        }.getType());
        if (responseResult.isSuccess()) {
            return (List<ArchiveCommentEntity>) responseResult.result;
        } else {
            return null;
        }
    }

    public static ArchiveCommentEntity getCommentDetail(long CompanyId, long CommentId) {
        String apiUrl = String.format(ApiEnvironment.ArchiveComment_Detail_Endpoint, CompanyId, CommentId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, ArchiveCommentEntity.class);
        if (responseResult.isSuccess()) {
            return (ArchiveCommentEntity) responseResult.result;
        } else {
            return null;
        }
    }

    public static boolean updateArchiveComment(ArchiveCommentEntity entity) {
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.ArchiveComment_Update_Endpoint, entity,
                Boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }

    public static ArchiveCommentEntity getSummary(long CompanyId, long CommentId) {
        String apiUrl = String.format(ApiEnvironment.ArchiveComment_Summary_Endpoint, CompanyId, CommentId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, ArchiveCommentEntity.class);
        if (responseResult.isSuccess()) {
            return (ArchiveCommentEntity) responseResult.result;
        } else {
            return null;
        }
    }

    public static List<ArchiveCommentEntity> getAllComments(long CompanyId, long ArchiveId) {
        String apiUrl = String.format(ApiEnvironment.ArchiveComment_All_Endpoint, CompanyId, ArchiveId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, new TypeToken<List<ArchiveCommentEntity>>() {
        }.getType());
        if (responseResult.isSuccess()) {
            return (List<ArchiveCommentEntity>) responseResult.result;
        } else {
            return null;
        }
    }

    public static List<StageSectionEntity> existsStageSection(long CompanyId, long ArchiveId) {
        String apiUrl = String.format(ApiEnvironment.ArchiveComment_ExistsStageSection_Endpoint, CompanyId, ArchiveId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, new TypeToken<List<StageSectionEntity>>() {}.getType());
        if (responseResult.isSuccess()) {
            return (List<StageSectionEntity>) responseResult.result;
        } else {
            return null;
        }
    }

    public static List<ArchiveCommentLogEntity> getLogList(long CompanyId, long CommentId) {
        String apiUrl = String.format(ApiEnvironment.ArchiveComment_Loglist_Endpoint, CompanyId, CommentId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, new TypeToken<List<ArchiveCommentLogEntity>>() {}.getType());
        if (responseResult.isSuccess()) {
            return (List<ArchiveCommentLogEntity>) responseResult.result;
        } else {
            return null;
        }
    }
}
