package com.juxian.bosscomments.repositories;

import com.android.volley.Response;
import com.juxian.bosscomments.models.PaymentEntity;
import com.juxian.bosscomments.models.PaymentResult;

import net.juxian.appgenome.webapi.WebApiClient;

public class PaymentRepository {
	
	/**
	 * 创建交易记录，获取签名参数
	 */
	public static PaymentResult createTrade(PaymentEntity entity) {
		Response<?> responseResult = WebApiClient.getSingleton().httpPost(
				ApiEnvironment.Payment_CreateTrade_Endpoint, entity, PaymentResult.class);
		if (responseResult.isSuccess()) {
			return (PaymentResult) responseResult.result;  
		} else {
			return null;
		}
	}	
	
	/**
	 * 支付完成，同步支付结果
	 */
	public static PaymentResult paymentCompleted(PaymentResult result) {
		Response<?> responseResult = WebApiClient.getSingleton().httpPost(
				ApiEnvironment.Payment_PaymentCompleted_Endpoint, result, PaymentResult.class);
		if (responseResult.isSuccess()) {
			return (PaymentResult) responseResult.result;
		} else {
			return null;
		}
	}

	/**
	 * 钱包支付
	 * @return
     */
	public static PaymentResult getPayWithWalletResult(PaymentEntity payment){
		String apiUrl = String.format(ApiEnvironment.Wallet_Pay_Endpoint,payment.OwnerId,payment.TradeCode);
		Response<?> responseResult = WebApiClient.getSingleton().httpPost(
				apiUrl, null, PaymentResult.class);
		if (responseResult.isSuccess()){
			return (PaymentResult) responseResult.result;
		} else {
			return null;
		}
	}
}
