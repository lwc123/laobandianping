package com.juxian.bosscomments.repositories;

import com.android.volley.Response;
import com.juxian.bosscomments.models.PriceStrategyEntity;

import net.juxian.appgenome.webapi.WebApiClient;

/**
 * Created by nene on 2017/1/4.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/1/4 18:55]
 * @Version: [v1.0]
 */
public class PriceStrategyRepository {
    public static PriceStrategyEntity getCurrentActivityInfo(int ActivityType,String Version){
        String apiUrl = String.format(ApiEnvironment.PriceStrategy_CurrentActivity_Endpoint,ActivityType,Version);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl,PriceStrategyEntity.class);
        if (responseResult.isSuccess()) {
            return (PriceStrategyEntity) responseResult.result;
        } else {
            return null;
        }
    }
}
