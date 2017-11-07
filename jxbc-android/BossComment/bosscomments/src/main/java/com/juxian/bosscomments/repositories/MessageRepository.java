package com.juxian.bosscomments.repositories;

import com.android.volley.Response;
import com.google.gson.reflect.TypeToken;
import com.juxian.bosscomments.models.MessageEntity;

import net.juxian.appgenome.webapi.WebApiClient;

import java.util.List;

/**
 * Created by Tam on 2016/12/17.
 * 消息仓库
 */
public class MessageRepository {

    public static List<MessageEntity> getAppMessages(int Page) {
        String apiUrl = String.format(ApiEnvironment.Message_GetAppMsg_Endpoint, ApiEnvironment.OnceLoadItemCount, Page);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, new TypeToken<List<MessageEntity>>() {
        }.getType());
        if (responseResult.isSuccess()) {
            return (List<MessageEntity>) responseResult.result;
        } else {
            return null;
        }
    }

    public static List<MessageEntity> getList(int Page, int MessageType) {
        String apiUrl = String.format(ApiEnvironment.Message_GetList_Endpoint, ApiEnvironment.OnceLoadItemCount, Page, MessageType);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, new TypeToken<List<MessageEntity>>() {
        }.getType());
        if (responseResult.isSuccess()) {
            return (List<MessageEntity>) responseResult.result;
        } else {
            return null;
        }
    }

    public static boolean readMsg(long msgId) {
        String apiUrl = String.format(ApiEnvironment.Message_readMsg_Endpoint, msgId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, Boolean.class);

        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }

    public static boolean getUnreadNum(int MessageType) {
        String apiUrl = String.format(ApiEnvironment.Message_Unread_Endpoint, MessageType);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, Boolean.class);

        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }
}
