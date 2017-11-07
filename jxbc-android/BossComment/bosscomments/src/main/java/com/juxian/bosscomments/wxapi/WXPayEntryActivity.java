package com.juxian.bosscomments.wxapi;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import com.juxian.bosscomments.modules.PaymentEngine;
import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.models.PaymentResult;
import com.tencent.mm.sdk.constants.ConstantsAPI;
import com.tencent.mm.sdk.modelbase.BaseReq;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.ToastUtil;

public class WXPayEntryActivity extends Activity implements IWXAPIEventHandler {
	
    private IWXAPI api;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
    	api = WXAPIFactory.createWXAPI(this, AppConfig.getMetaData("WXPAY_APPID"));
        api.handleIntent(getIntent(), this);
    }

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		setIntent(intent);
        api.handleIntent(intent, this);
	}

	@Override
	public void onReq(BaseReq req) {
	}

	@Override
	public void onResp(BaseResp resp) {
		LogManager.getLogger("Payment").d("2.01 onPayFinish, errCode: %s", resp.errCode);
		
		if (resp.getType() == ConstantsAPI.COMMAND_PAY_BY_WX) {
			final PaymentResult paymentResult = new PaymentResult();
			paymentResult.PayWay = PaymentEngine.PayWays_Wechat;
			paymentResult.PaidDetail = JsonUtil.ToJson(resp);
			LogManager.getLogger("Payment").d("2.02 result: %s", paymentResult.PaidDetail);
			this.finish();

			new AsyncRunnable<PaymentResult>() {
				@Override
				protected PaymentResult doInBackground(Void... params) {	
					PaymentResult result = PaymentEngine.paymentCompleted(paymentResult);
					return result;
				}

				protected void onPostExecute(PaymentResult result) {
					if(null == result) return;
					if(false == result.Success) {
						ToastUtil.showError("error:%s, msg:%s", result.ErrorCode, result.ErrorMessage);
					}
				};
			}.execute();
			
		}
		
		
	}
}