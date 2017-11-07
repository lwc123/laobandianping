package com.juxian.bosscomments.common;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.webkit.JavascriptInterface;
import android.widget.RelativeLayout;

import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.models.PaymentEntity;
import com.juxian.bosscomments.ui.AboutUsActivity;
import com.juxian.bosscomments.ui.CompanyCircleWebViewActivity;
import com.juxian.bosscomments.ui.ModifyRecordActivity;
import com.juxian.bosscomments.ui.PayActivity;
import com.juxian.bosscomments.ui.SearchBossCommentActivity;
import com.juxian.bosscomments.ui.WebViewDetailActivity;
import com.umeng.analytics.MobclickAgent;

import net.juxian.appgenome.utils.JsonUtil;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;

public class JsInterface {
	private Context mContext;
	private Activity activity;
	private boolean isAuthenticated;
	public static String mSourceType;
	public static String mSourceId;
	private Handler mHandler;

	public JsInterface(Context context) {
		this.mContext = context;
		this.activity = (Activity) context;
	}

	public JsInterface(Context context,Handler mHandler) {
		this.mContext = context;
		this.activity = (Activity) context;
		this.mHandler = mHandler;
	}

	// 在JS中调用这个方法，h5界面从js中拿到token
	@JavascriptInterface
	public String getAppInfo() {
		return getHeaders();
	}

	@JavascriptInterface
	public String getHeaders() {
		JSONObject jsonObject = new JSONObject();
		String token = AppContext.getCurrent().getUserAuthentication()
				.loadSecureAccessToken();
		try {
			jsonObject.put("device", AppContext.getCurrent().getDeviceKey());
			jsonObject.put("token", token);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		Log.i(Global.LOG_TAG, "封装好的json" + jsonObject.toString());
		return jsonObject.toString();
	}

	/**
	 * H5页面中调用这个方法
	 * 
	 * @param pageName
	 *            区分操作的名称
	 * @param pageParams
	 *            传递过来的参数
	 */
	@JavascriptInterface
	public void gotoNativePage(String pageName, String pageParams) {
		JSONObject jsonObject;
		Log.e(Global.LOG_TAG,pageName);
		if (pageName.equals("BuyBackgroundSurvey")) {
			isAuthenticated = AppContext.getCurrent().getUserAuthentication().isAuthenticated();

//			String sourceId = null, sourceType = null;
//			try {
//				jsonObject = new JSONObject(pageParams);
//				sourceType = jsonObject.getString("sourceType");
//				sourceId = jsonObject.getString("sourceId");
//				mSourceType = sourceType;
//				mSourceId = sourceId;
//			} catch (JSONException e1) {
//				// TODO Auto-generated catch block
//				e1.printStackTrace();
//			}
//			PaymentEntity paymentEntity = JsonUtil.ToEntity(pageParams, PaymentEntity.class);
//			Intent intent = new Intent(mContext, PayActivity.class);
//			intent.putExtra("PaymentEntity",pageParams);
//			intent.putExtra(Global.LISTVIEW_ITEM_TAG,PayActivity.BUY);
//			activity.startActivity(intent);
			Log.e(Global.LOG_TAG,pageParams);
			SearchBossCommentActivity.goToBuyBackgroundSurvey(activity,100,pageParams);
		} else if ("ShowSearchButton".equals(pageName)){
			if ("true".equals(pageParams)) {
				Message message = mHandler.obtainMessage();
				message.what = 1;
				mHandler.sendMessage(message);
			} else if ("false".equals(pageParams)){
				Message message = mHandler.obtainMessage();
				message.what = 2;
				mHandler.sendMessage(message);
			} else {
				Message message = mHandler.obtainMessage();
				message.what = 2;
				mHandler.sendMessage(message);
			}
		} else if ("CommentChangedHistory".equals(pageName)){
			Intent intent = new Intent(activity, ModifyRecordActivity.class);
			intent.putExtra("CommentId",pageParams);
			activity.startActivity(intent);
		} else if ("tel".equals(pageName)){
			// 权限需要特殊处理，做判断
			// <uses-permission Android:name="android.permission.CALL_PHONE"/>
			AboutUsActivity.playPhone(activity,pageParams);
		} else if ("RenewalEnterpriseService".equals(pageName)){
			AboutUsActivity.goToPayFee(activity,100,pageParams);
		} else if ("OpinionSuccess".equals(pageName)){
			CompanyCircleWebViewActivity.goToCompanyDetail(activity,100,pageParams);
		} else if ("openService".equals(pageName)){
			CompanyCircleWebViewActivity.goToOpenService(activity,200,pageParams);
		}
	}
}
