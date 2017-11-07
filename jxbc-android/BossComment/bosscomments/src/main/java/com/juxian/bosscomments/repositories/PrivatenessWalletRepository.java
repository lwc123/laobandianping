package com.juxian.bosscomments.repositories;

import com.android.volley.Request;
import com.android.volley.Response;
import com.google.gson.reflect.TypeToken;
import com.juxian.bosscomments.models.CompanyBankCardEntity;
import com.juxian.bosscomments.models.DrawMoneyRequestEntity;
import com.juxian.bosscomments.models.ResultEntity;
import com.juxian.bosscomments.models.TradeJournalEntity;
import com.juxian.bosscomments.models.WalletEntity;

import net.juxian.appgenome.webapi.WebApiClient;

import java.util.List;

/**
 * Created by nene on 2016/12/28.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/28 11:55]
 * @Version: [v1.0]
 */
public class PrivatenessWalletRepository {
    public static WalletEntity getCompanyWallet() {
        String apiUrl = String.format(ApiEnvironment.PrivatenessWallet_Wallet_Endpoint);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl,WalletEntity.class);
        if (responseResult.isSuccess()) {
            return (WalletEntity) responseResult.result;
        } else {
            return null;
        }
    }

    public static ResultEntity DrawMoneyRequestAdd(DrawMoneyRequestEntity entity) {
        Response<?> responseResult = WebApiClient.getSingleton().http(
                Request.Method.POST, ApiEnvironment.Privateness_DrawMoneyRequest_Endpoint, entity,
                ResultEntity.class);
        if (responseResult.isSuccess()) {
            return (ResultEntity) responseResult.result;
        } else {
            return null;
        }
    }

    public static List<CompanyBankCardEntity> getCompanyBankCardList() {
        String apiUrl = String.format(ApiEnvironment.Privateness_BankCardList_Endpoint);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl, new TypeToken<List<CompanyBankCardEntity>>() {
        }.getType());
        if (responseResult.isSuccess()) {
            return (List<CompanyBankCardEntity>) responseResult.result;
        } else {
            return null;
        }
    }

    public static List<TradeJournalEntity> getTradeHistory(int mode, int pageIndex) {
        String apiUrl = String.format(ApiEnvironment.PrivatenessWallet_TradeHistory_Endpoint,mode,pageIndex,ApiEnvironment.OnceLoadItemCount);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl,new TypeToken<List<TradeJournalEntity>>(){}.getType());
        if (responseResult.isSuccess()) {
            return (List<TradeJournalEntity>) responseResult.result;
        } else {
            return null;
        }
    }
}
