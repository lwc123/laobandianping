package com.juxian.bosscomments.repositories;

import com.android.volley.Response;

import net.juxian.appgenome.webapi.WebApiClient;

/**
 * Created by nene on 2017/2/14.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/2/14 14:21]
 * @Version: [v1.0]
 */
public class ApiTestRepository {

    public static Integer getBossCircleHome(int time) {
        String apiUrl = String.format(ApiEnvironment.ApiTest_Timeout_Endpoint, time);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, Integer.class);
        if (responseResult.isSuccess()) {
            return (Integer) responseResult.result;
        } else {
            return -1;
        }
    }
}
