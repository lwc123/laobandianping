package com.juxian.bosscomments.repositories;

import com.android.volley.Request;
import com.android.volley.Response;
import com.google.gson.reflect.TypeToken;
import com.juxian.bosscomments.models.CCompanyEntity;
import com.juxian.bosscomments.models.ConcernedTotalEntity;
import com.juxian.bosscomments.models.ConsoleEntity;
import com.juxian.bosscomments.models.EnterpriseEntity;
import com.juxian.bosscomments.models.OpinionEntity;
import com.juxian.bosscomments.models.OpinionReplyEntity;
import com.juxian.bosscomments.models.OpinionTotalEntity;
import com.juxian.bosscomments.models.ResultEntity;
import com.juxian.bosscomments.models.TopicEntity;

import net.juxian.appgenome.webapi.WebApiClient;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

/**
 * Created by nene on 2017/4/17.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/17 11:29]
 * @Version: [v1.0]
 */
public class CompanyReputationRepository {

    /**
     * 口碑列表
     * @param pageIndex
     * @return
     */
    public static OpinionTotalEntity getCompanyReputationList(int pageIndex) {
        String apiUrl = String.format(ApiEnvironment.Opinion_Index_Endpoint, pageIndex,ApiEnvironment.OnceLoadItemCount);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, OpinionTotalEntity.class);
        if (responseResult.isSuccess()) {
            return (OpinionTotalEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 我的口碑列表
     * @param pageIndex
     * @return
     */
    public static OpinionTotalEntity getMineOpinionList(int pageIndex) {
        String apiUrl = String.format(ApiEnvironment.Opinion_Mine_Endpoint, pageIndex,ApiEnvironment.OnceLoadItemCount);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, OpinionTotalEntity.class);
        if (responseResult.isSuccess()) {
            return (OpinionTotalEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 我的关注列表
     * @param pageIndex
     * @return
     */
    public static ConcernedTotalEntity getConcernedMineList(int pageIndex) {
        String apiUrl = String.format(ApiEnvironment.Concerned_Mine_Endpoint, pageIndex,ApiEnvironment.OnceLoadItemCount);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, ConcernedTotalEntity.class);
        if (responseResult.isSuccess()) {
            return (ConcernedTotalEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 我的关注列表
     * @param Keyword
     * @return
     */
    public static List<CCompanyEntity> getSearchList(String Keyword) {
        String KeywordEncode = Keyword;
        try {
            KeywordEncode = URLEncoder.encode(Keyword, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        String apiUrl = String.format(ApiEnvironment.Company_Search_Endpoint, KeywordEncode);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, new TypeToken<List<CCompanyEntity>>() {
        }.getType());
        if (responseResult.isSuccess()) {
            return (List<CCompanyEntity>) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * Banner集合
     * @return
     */
    public static List<TopicEntity> getCompanyReputationBannerList() {
        String apiUrl = String.format(ApiEnvironment.Topic_Index_Endpoint);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, new TypeToken<List<TopicEntity>>() {
        }.getType());
        if (responseResult.isSuccess()) {
            return (List<TopicEntity>) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 添加公司点评（口碑）
     * @param entity
     * @return
     */
    public static ResultEntity createCompanyComment(OpinionEntity entity){
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.Opinion_Create_Endpoint, entity,
                ResultEntity.class);
        if (responseResult.isSuccess()) {
            return (ResultEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 添加点评评论
     * @param entity
     * @return
     */
    public static ResultEntity createCompanyCommentReply(OpinionReplyEntity entity){
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.Reply_Create_Endpoint, entity,
                ResultEntity.class);
        if (responseResult.isSuccess()) {
            return (ResultEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 口碑详情
     * @param ReputationId
     * @return
     */
    public static OpinionEntity getCompanyReputationDetail(long ReputationId) {
        String apiUrl = String.format(ApiEnvironment.Opinion_Detail_Endpoint, ReputationId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, OpinionEntity.class);
        if (responseResult.isSuccess()) {
            return (OpinionEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 公司详情
     * @param CompanyId
     * @return
     */
    public static CCompanyEntity getCompanyDetail(long CompanyId,int page) {
        String apiUrl = String.format(ApiEnvironment.Company_Detail_Endpoint, CompanyId,page,15);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, CCompanyEntity.class);
        if (responseResult.isSuccess()) {
            return (CCompanyEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 点赞
     * @return
     */
    public static boolean opinionLiked(long OpinionId){
        String apiUrl = String.format(ApiEnvironment.Opinion_Liked_Endpoint, OpinionId);
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, apiUrl, null,
                boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }
    /**
     * 关注/取消关注
     * @param CompanyId
     * @return
     */
    public static boolean concernedAttention(long CompanyId){
        String apiUrl = String.format(ApiEnvironment.Concerned_Attention_Endpoint, CompanyId);
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, apiUrl, null,
                boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }

    /**
     * 专题详情
     * @return
     */
    public static TopicEntity getTopicDetail(long TopicId,int Page) {
        String apiUrl = String.format(ApiEnvironment.Topic_Detail_Endpoint, TopicId,Page,ApiEnvironment.OnceLoadItemCount);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, TopicEntity.class);
        if (responseResult.isSuccess()) {
            return (TopicEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 我的关注列表
     * @return
     */
    public static ConsoleEntity getConsole() {
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(ApiEnvironment.Console_Index_Endpoint, ConsoleEntity.class);
        if (responseResult.isSuccess()) {
            return (ConsoleEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * B端企业认领口碑公司列表
     * @return
     */
    public static List<CCompanyEntity> getClaimList(final long CompanyId) {
        String apiUrl = String.format(ApiEnvironment.Enterprise_Claim_Endpoint,CompanyId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, new TypeToken<List<CCompanyEntity>>(){}.getType());
        if (responseResult.isSuccess()) {
            return (List<CCompanyEntity>) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * B端口碑列表
     * @return
     */
    public static OpinionTotalEntity getEnterpriseOpinions(long CompanyId,long OpinionCompanyId,int AuditStatus,int pageIndex) {
        String apiUrl = String.format(ApiEnvironment.Enterprise_Opinions_Endpoint,CompanyId,OpinionCompanyId,AuditStatus,pageIndex,15);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, OpinionTotalEntity.class);
        if (responseResult.isSuccess()) {
            return (OpinionTotalEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 隐藏选中的点评
     * @param enterpriseEntity
     * @return
     */
    public static boolean hideOpinions(EnterpriseEntity enterpriseEntity){
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.Enterprise_HideOpinions_Endpoint, enterpriseEntity,
                boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }

    /**
     * 隐藏选中的点评
     * @param enterpriseEntity
     * @return
     */
    public static boolean restoreOpinions(EnterpriseEntity enterpriseEntity){
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.Enterprise_RestoreOpinions_Endpoint, enterpriseEntity,
                boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }

    /**
     * 高级设置
     * @return
     */
    public static boolean advanceSettings(long CompanyId,long OpinionCompanyId,boolean IsCloseComment){
        String apiUrl = String.format(ApiEnvironment.Enterprise_Settings_Endpoint,CompanyId,OpinionCompanyId,IsCloseComment);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }

    /**
     * 管理口碑公司标签
     * @param enterpriseEntity
     * @return
     */
    public static boolean manageLabels(EnterpriseEntity enterpriseEntity){
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.Enterprise_Labels_Endpoint, enterpriseEntity,
                boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }

    /**
     * 公司官方回复点评
     * @param entity
     * @return
     */
    public static ResultEntity enterpriseReply(OpinionReplyEntity entity){
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.Enterprise_Reply_Endpoint, entity,
                ResultEntity.class);
        if (responseResult.isSuccess()) {
            return (ResultEntity) responseResult.result;
        } else {
            return null;
        }
    }
}
