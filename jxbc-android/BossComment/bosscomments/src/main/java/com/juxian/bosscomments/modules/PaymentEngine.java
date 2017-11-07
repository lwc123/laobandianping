package com.juxian.bosscomments.modules;

import android.app.Dialog;
import android.util.Log;

import com.alipay.sdk.app.PayTask;
import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.models.PaymentEntity;
import com.juxian.bosscomments.models.PaymentResult;
import com.juxian.bosscomments.repositories.PaymentRepository;
import com.tencent.mm.sdk.modelpay.PayReq;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

import net.juxian.appgenome.ActivityManager;
import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;

import org.json.JSONException;
import org.json.JSONObject;

public class PaymentEngine {
	public static final int TradeMode_All = 0;
	public static final int TradeMode_Payoff = 1;
	public static final int TradeMode_Payout = 2;
	public static final int TradeMode_Withdraw = 3;
	public static final int TradeMode_Action_Buy = 21;
	public static final int TradeMode_Action_Withdraw = 22;

	public static final String PayWays_Wallet = "Wallet";
	public static final String PayWays_Alipay = "Alipay";
	public static final String PayWays_Wechat = "Wechat";
	public static final String PayWays_AppleIAP = "AppleIAP";

	public static final String BizSources_Deposit = "Deposit";// 充值
	public static final String BizSources_OpenEnterpriseService = "OpenEnterpriseService";// 开通企业服务
	public static final String BizSources_OpenPersonalService = "OpenPersonalService";// 开通个人服务

	public static final int TradeType_PersonalToPersonal = 1;
	public static final int TradeType_PersonalToOrganization = 2;
	public static final int TradeType_OrganizationToPersonal = 3;
	public static final int TradeType_OrganizationToOrganization = 4;

	private static IPaymentHandler paymentHandler;
	private static PaymentEntity lastPaymentEntity;

	public static PaymentResult mockPay(PaymentEntity payment) {
		PaymentResult result = null;
		result = new PaymentResult();
		result.Success = true;
		result.ErrorCode = "0";
		result.ErrorMessage = "参数错误，不能支付";
		return result;
	}

	public static void pay(PaymentEntity payment, IPaymentHandler handler,
			final Dialog dialog) {
		paymentHandler = handler;
		lastPaymentEntity = payment;
		new AsyncRunnable<PaymentResult>() {
			@Override
			protected PaymentResult doInBackground(Void... params) {
				PaymentResult result = pay(lastPaymentEntity);
				return result;
			}

			protected void onPostExecute(final PaymentResult result) {
				Log.i("Payment", "1");
				if (result.Success == false) {
					if (dialog != null) {
						dialog.dismiss();
					}
				}
				if (null != paymentHandler && (lastPaymentEntity.PayWay.equals(PayWays_Alipay)||lastPaymentEntity.PayWay.equals(PayWays_Wallet))) {
					paymentHandler.onPaymentCompleted(result);
					Log.i("Payment", "2");
					paymentHandler = null;
					lastPaymentEntity = null;
				}
			}
		}.execute();

	}

	public static PaymentResult paymentCompleted(PaymentResult paymentData) {
		Log.i("Payment", "3");
		if (paymentData.PayWay.equals(PayWays_Wechat)) {
			PaymentResult paidDetail = parsePaidResultWithWechat(paymentData.PaidDetail);
			paidDetail.PayWay = PayWays_Wechat;
			LogManager.getLogger("Payment").d("3.1 paymentCompleted : %s",
					JsonUtil.ToJson(paidDetail));

			final PaymentResult paymentResult = (null != paidDetail && paidDetail.Success) ? PaymentRepository
					.paymentCompleted(paidDetail) : null;
			if (null != paymentResult) {
				LogManager.getLogger("Payment").d("3.2 paymentCompleted : %s",
						JsonUtil.ToJson(paidDetail));
				if (false == paymentResult.Success) {
					paymentResult.ErrorMessage = "支付失败";
				}
			}

			if (null != paymentHandler) {
				LogManager.getLogger("Payment").d("9-2 End pay flow /////////");
				ActivityManager.getCurrent().runOnUiThread(new Runnable() {
					@Override
					public void run() {
						paymentHandler.onPaymentCompleted(paymentResult);
						paymentHandler = null;
						lastPaymentEntity = null;
					}
				});
			}
			return paymentResult;
		}

		return null;
	}

	private static PaymentResult pay(PaymentEntity payment) {
		if (payment.TradeMode < 1)
			payment.TradeMode = TradeMode_Payout;
		if (payment.CommodityQuantity < 1)
			payment.CommodityQuantity = 1;

		LogManager.getLogger("Payment").d("0 start pay flow (%s) .........",
				JsonUtil.ToJson(payment));

		PaymentResult paymentResult = null;

		PaymentResult trade = PaymentRepository.createTrade(payment);
		LogManager.getLogger("Payment").d("1 createTrade : %s",
				JsonUtil.ToJson(trade));
		if (null != trade && trade.Success) {
			payment.TradeCode = trade.TradeCode;
			payment.SignedParams = trade.SignedParams;
			paymentResult = payWithWay(payment);
			LogManager.getLogger("Payment").d("2 payWithWay : %s",
					JsonUtil.ToJson(paymentResult));

			if (null != paymentResult && paymentResult.Success) {
				paymentResult = PaymentRepository
						.paymentCompleted(paymentResult);
				LogManager.getLogger("Payment").d("3 paymentCompleted : %s",
						JsonUtil.ToJson(paymentResult));
				if (false == paymentResult.Success) {
					paymentResult.ErrorMessage = "支付失败";
				}

				LogManager.getLogger("Payment").d("9-1 End pay flow //////");
			}
		}
		if (null == paymentResult) {
			paymentResult = new PaymentResult();
			paymentResult.Success = false;
			paymentResult.ErrorCode = "0";
			paymentResult.ErrorMessage = "参数错误，不能支付";
		}

		return paymentResult;
	}

	private static PaymentResult payWithWay(PaymentEntity payment) {
		PaymentResult result = null;
		if (payment.PayWay.equals(PayWays_Alipay))
			result = payWithAlipay(payment);
		else if (payment.PayWay.equals(PayWays_Wechat))
			result = payWithWechat(payment);
		else if (payment.PayWay.equals(PayWays_Wallet))
			result = payWithWallet(payment);

		if (null != result)
			result.TradeCode = payment.TradeCode;
		return result;
	}

	private static PaymentResult payWithAlipay(PaymentEntity payment) {
		PayTask alipay = new PayTask(ActivityManager.getCurrent());
		String paidResult = alipay.pay(payment.SignedParams, true);

		LogManager.getLogger("Payment").d("02 paidResult : %s",
				JsonUtil.ToJson(paidResult));

		PaymentResult result = parsePaidResultWithAlipay(paidResult);
		result.PayWay = PayWays_Alipay;
		return result;
	}

	private static PaymentResult payWithWallet(PaymentEntity payment) {
//		PayTask alipay = new PayTask(ActivityManager.getCurrent());
//		String paidResult = alipay.pay(payment.SignedParams, true);

		PaymentResult result = PaymentRepository.getPayWithWalletResult(payment);
		LogManager.getLogger("Payment").d("03 paidResult : %s",
				JsonUtil.ToJson(result));
		result.PayWay = PayWays_Wallet;
		return result;
	}

	public static PaymentResult parsePaidResultWithAlipay(String paidResult) {
		String resultStatus = null;
		String paidDetail = null;

		String[] resultParams = paidResult.split(";");
		for (String resultParam : resultParams) {
			if (resultParam.startsWith("resultStatus={")) {
				resultStatus = resultParam.substring(
						resultParam.indexOf("resultStatus={")
								+ "resultStatus={".length(),
						resultParam.lastIndexOf("}"));
			} else if (resultParam.startsWith("result={")) {
				paidDetail = resultParam.substring(
						resultParam.indexOf("result={") + "result={".length(),
						resultParam.lastIndexOf("}"));
			}
		}

		if (resultStatus.equals("9000")) {
			PaymentResult result = new PaymentResult();
			result.Success = true;
			result.PaidDetail = paidDetail;
			return result;
		} else {
			PaymentResult result = new PaymentResult();
			result.Success = false;
			result.ErrorCode = resultStatus;
			return result;
		}
	}

	private static PaymentResult payWithWechat(PaymentEntity payment) {
		final PayReq req = new PayReq();
		try {
			JSONObject json = new JSONObject(payment.SignedParams);
			req.appId = json.getString("appid");
			req.partnerId = json.getString("partnerid");
			req.prepayId = json.getString("prepayid");
			req.nonceStr = json.getString("noncestr");
			req.timeStamp = json.getString("timestamp");
			req.packageValue = json.getString("package");
			req.sign = json.getString("sign");
		} catch (JSONException e) {
			e.printStackTrace();
		}
		LogManager.getLogger("Payment").d("wechat req ：%s",
				JsonUtil.ToJson(req));
		String appId = AppConfig.getMetaData("WXPAY_APPID");
		IWXAPI wxAPI = WXAPIFactory.createWXAPI(ActivityManager.getCurrent(),
				appId, false);
		wxAPI.registerApp(appId);
		LogManager.getLogger("Payment").d("Start Wechat ...");
		wxAPI.sendReq(req);
		// 微信是异步调起的，可以分两个流程，第一个流程：生成参数，调起微信，此时第一个流程可以结束，因此返回空。第二个流程就是微信调用我们的app，从返回结果处开始
		return null;
	}

	private static PaymentResult parsePaidResultWithWechat(String paidResult) {
		int errCode = -1;
		try {
			JSONObject json = new JSONObject(paidResult);
			errCode = json.getInt("errCode");
		} catch (JSONException e) {
			e.printStackTrace();
		}

		if (errCode == 0) {
			PaymentResult result = new PaymentResult();
			result.Success = true;
			result.TradeCode = lastPaymentEntity.TradeCode;
			result.PaidDetail = String.format(
					"<xml><out_trade_no>%s</out_trade_no></xml>",
					result.TradeCode);
			return result;
		} else {
			PaymentResult result = new PaymentResult();
			result.Success = false;
			result.ErrorCode = String.valueOf(errCode);
			result.ErrorMessage = "订单支付失败";
			return result;
		}
	}
}
