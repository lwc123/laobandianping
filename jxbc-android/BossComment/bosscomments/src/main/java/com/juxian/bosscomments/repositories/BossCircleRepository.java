package com.juxian.bosscomments.repositories;

import com.android.volley.Request;
import com.android.volley.Response;
import com.google.gson.reflect.TypeToken;
import com.juxian.bosscomments.models.BossDynamicCommentEntity;
import com.juxian.bosscomments.models.BossDynamicEntity;

import net.juxian.appgenome.webapi.WebApiClient;

import java.util.List;

/**
 * Created by Tam on 2016/12/23.
 */
public class BossCircleRepository {
    public static List<BossDynamicEntity> getBossCircleHome(long CompanyId, int pageIndex) {
        String apiUrl = String.format(ApiEnvironment.BossDynamic_home_Endpoint, CompanyId, ApiEnvironment.OnceLoadItemCount, pageIndex);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, new TypeToken<List<BossDynamicEntity>>() {
        }.getType());
        if (responseResult.isSuccess()) {
            return (List<BossDynamicEntity>) responseResult.result;
        } else {
            return null;
        }
    }

    public static List<BossDynamicEntity> getBossCircleMyDynamic(long CompanyId, int Size, int pageIndex) {
        String apiUrl = String.format(ApiEnvironment.BossDynamic_myDynamic_Endpoint, CompanyId, Size, pageIndex);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, new TypeToken<List<BossDynamicEntity>>() {
        }.getType());
        if (responseResult.isSuccess()) {
            return (List<BossDynamicEntity>) responseResult.result;
        } else {
            return null;
        }
    }

    public static long postBossCircleAddDynamic(BossDynamicEntity entity) {
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.BossDynamic_add_Endpoint, entity,
                Long.class);
        if (responseResult.isSuccess()) {
            return (Long) responseResult.result;
        } else {
            return 0;
        }
    }

    public static boolean getBossCircleDeleteDynamic(long CompanyId, long DynamicId) {
        String apiUrl = String.format(ApiEnvironment.BossDynamic_del_Endpoint, CompanyId, DynamicId);
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, apiUrl, null,
                Boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }

    public static Boolean getBossCircleLikedDynamic(long CompanyId, long DynamicId) {
        String apiUrl = String.format(ApiEnvironment.BossDynamic_liked_Endpoint, CompanyId, DynamicId);
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, apiUrl, null,
                Boolean.class);
        if (responseResult.isSuccess()) {
            return (Boolean) responseResult.result;
        } else {
            return false;
        }
    }

    public static long postBossCircleCommentdDynamic(BossDynamicCommentEntity entity) {
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.BossDynamic_comment_Endpoint, entity,
                Long.class);
        if (responseResult.isSuccess()) {
            return (Long) responseResult.result;
        } else {
            return 0;
        }
    }

}
