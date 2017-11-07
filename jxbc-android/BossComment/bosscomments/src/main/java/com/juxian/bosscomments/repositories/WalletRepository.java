package com.juxian.bosscomments.repositories;

import com.android.volley.Response;
import com.google.gson.reflect.TypeToken;
import com.juxian.bosscomments.models.PaymentResult;
import com.juxian.bosscomments.models.TradeJournalEntity;
import com.juxian.bosscomments.models.WalletEntity;

import net.juxian.appgenome.webapi.WebApiClient;

import java.util.List;

/**
 * Created by nene on 2016/12/15.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/15 20:25]
 * @Version: [v1.0]
 */
public class WalletRepository {

    public static List<TradeJournalEntity> getTradeHistory(long CompangyId,int mode, int pageIndex) {
        String apiUrl = String.format(ApiEnvironment.Wallet_OrganizationTradeHistory_Endpoint,CompangyId,mode,pageIndex,ApiEnvironment.OnceLoadItemCount);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl,new TypeToken<List<TradeJournalEntity>>(){}.getType());
        if (responseResult.isSuccess()) {
            return (List<TradeJournalEntity>) responseResult.result;
        } else {
            return null;
        }
    }

    public static WalletEntity getCompanyWallet(long CompangyId) {
        String apiUrl = String.format(ApiEnvironment.CompanyWallet_Wallet_Endpoint,CompangyId);
        Response<?> responseResult = WebApiClient.getSingleton().httpGet(apiUrl,WalletEntity.class);
        if (responseResult.isSuccess()) {
            return (WalletEntity) responseResult.result;
        } else {
            return null;
        }
    }
}
