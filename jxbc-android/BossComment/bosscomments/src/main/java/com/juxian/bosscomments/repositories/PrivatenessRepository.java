package com.juxian.bosscomments.repositories;

import com.android.volley.Request;
import com.android.volley.Response;
import com.google.gson.reflect.TypeToken;
import com.juxian.bosscomments.models.EmployeArchiveEntity;
import com.juxian.bosscomments.models.InvitedRegisterEntity;
import com.juxian.bosscomments.models.MessageEntity;
import com.juxian.bosscomments.models.PrivatenessArchiveSummaryEntity;
import com.juxian.bosscomments.models.PrivatenessSummaryEntity;
import com.juxian.bosscomments.models.ResultEntity;

import net.juxian.appgenome.webapi.WebApiClient;

import java.util.List;

/**
 * Created by nene on 2016/12/26.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/26 16:47]
 * @Version: [v1.0]
 */
public class PrivatenessRepository {

    /**
     * 获取用户摘要信息，用于页面"我"
     */
    public static PrivatenessSummaryEntity GetPersonalSummary() {
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(
                ApiEnvironment.Privateness_Summary_Endpoint, PrivatenessSummaryEntity.class);
        if (responseResult.isSuccess()) {
            return (PrivatenessSummaryEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 获取个人端我的档案摘要信息
     * @return
     */
    public static PrivatenessArchiveSummaryEntity GetPersonalArchiveSummary() {
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(
                ApiEnvironment.Privateness_ArchiveSummary_Endpoint, PrivatenessArchiveSummaryEntity.class);
        if (responseResult.isSuccess()) {
            return (PrivatenessArchiveSummaryEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 个人端绑定我的身份证号
     * @param IDCard
     * @return
     */
    public static ResultEntity bindingIDCard(String IDCard){
        String apiUrl = String.format(ApiEnvironment.Privateness_BindingIDCard_Endpoint,IDCard);
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, apiUrl, null,
                ResultEntity.class);
        if (responseResult.isSuccess()) {
            return (ResultEntity) responseResult.result;
        } else {
            return null;
        }
    }

    /**
     * 获取个人端我的档案列表
     * @return
     */
    public static List<EmployeArchiveEntity> GetPersonalMyArchives() {
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(
                ApiEnvironment.Privateness_MyArchives_Endpoint, new TypeToken<List<EmployeArchiveEntity>>() {}.getType());
        if (responseResult.isSuccess()) {
            return (List<EmployeArchiveEntity>) responseResult.result;
        } else {
            return null;
        }
    }

    public static List<MessageEntity> getPersonalMessages(int Page) {
        String apiUrl = String.format(ApiEnvironment.Privateness_MyMsg_Endpoint, ApiEnvironment.OnceLoadItemCount, Page);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, new TypeToken<List<MessageEntity>>() {
        }.getType());
        if (responseResult.isSuccess()) {
            return (List<MessageEntity>) responseResult.result;
        } else {
            return null;
        }
    }

    public static InvitedRegisterEntity getInviteRegister(){
        String apiUrl = String.format(ApiEnvironment.Priveteness_InviteRegister_Endpoint);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl,InvitedRegisterEntity.class);
        if (responseResult.isSuccess()) {
            return (InvitedRegisterEntity) responseResult.result;
        } else {
            return null;
        }
    }
}
