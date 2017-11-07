package com.juxian.bosscomments.repositories;

import com.android.volley.Request;
import com.android.volley.Response;
import com.juxian.bosscomments.models.FeedbackEntity;
import com.juxian.bosscomments.models.ResultEntity;

import net.juxian.appgenome.webapi.WebApiClient;

/**
 * Created by nene on 2017/2/7.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/2/7 10:00]
 * @Version: [v1.0]
 */
public class FeedbackRepository {
    public static Integer getFeedbackFrequency() {
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(ApiEnvironment.Feedback_Frequency_Endpoint, Integer.class);
        if (responseResult.isSuccess()) {
            return (Integer) responseResult.result;
        } else {
            return -1;
        }
    }

    public static ResultEntity postFeedback(FeedbackEntity entity){
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.Feedback_Add_Endpoint, entity,
                ResultEntity.class);
        if (responseResult.isSuccess()) {
            return (ResultEntity) responseResult.result;
        } else {
            return null;
        }
    }
}
