package com.juxian.bosscomments.repositories;

import com.android.volley.Request;
import com.android.volley.Response;
import com.google.gson.reflect.TypeToken;
import com.juxian.bosscomments.models.CompanyBankCardEntity;
import com.juxian.bosscomments.models.DrawMoneyRequestEntity;
import com.juxian.bosscomments.models.ResultEntity;

import net.juxian.appgenome.webapi.WebApiClient;

import java.util.List;

/**
 * Created by Tam on 2016/12/20.
 * 提现
 */
public class WithdrawRepository {

    public static ResultEntity DrawMoneyRequestAdd(DrawMoneyRequestEntity entity) {
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.DrawMoneyRequest_add_Endpoint, entity,
                ResultEntity.class);
        if (responseResult.isSuccess()) {
            return (ResultEntity) responseResult.result;
        } else {
            return null;
        }
    }

    public static List<CompanyBankCardEntity> getCompanyBankCardList(long CompanyId) {
        String apiUrl = String.format(ApiEnvironment.DrawMoneyRequest_BankCardList_Endpoint, CompanyId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, new TypeToken<List<CompanyBankCardEntity>>() {
        }.getType());
        if (responseResult.isSuccess()) {
            return (List<CompanyBankCardEntity>) responseResult.result;
        } else {
            return null;
        }
    }
}
