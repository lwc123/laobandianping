package com.juxian.bosscomments.repositories;

import android.util.Log;

import com.android.volley.Request.Method;
import com.android.volley.Response;
import com.juxian.bosscomments.models.OpenAccountRequest;
import com.juxian.bosscomments.modules.DeviceInfo;
import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.models.AccountSign;
import com.juxian.bosscomments.models.AccountSignResult;

import net.juxian.appgenome.socialize.ThirdPassport;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.utils.TextUtil;
import net.juxian.appgenome.webapi.GsonRequest;
import net.juxian.appgenome.webapi.WebApiClient;

import java.util.HashMap;
import java.util.Map;

public class AccountRepository {
	// 在UserAuthentication中initAccessToken()调用
	public static AccountSignResult createNew() {
		DeviceInfo info = DeviceInfo.BuildDeviceInfo();
		String json = JsonUtil.ToJson(info);
		GsonRequest<AccountSignResult> request = new GsonRequest<AccountSignResult>(
				Method.POST, ApiEnvironment.Account_CreateNew_Endpoint, json,
				AccountSignResult.class, null, null) {
			@Override
			public Map<String, String> getHeaders() {
				HashMap<String, String> headers = new HashMap<String, String>();
				headers.put(ApiEnvironment.DeviceKey, AppContext.getCurrent()
						.getDeviceKey());
				return headers;
			}
		};
		// performRequest返回的是一个泛型，进行强转变成Response对象
		Response<?> responseResult = WebApiClient.getSingleton()
				.performRequest(request);

		// Response<?> responseResult =
		// WebApiClient.getSingleton().http(Method.POST,ApiEnvironment.Account_CreateNew_Endpoint,
		// info, AccountSignResult.class);
		if (responseResult.isSuccess()) {
			// 如果是成功，则将成功的信息 返回
			AccountSignResult result = (AccountSignResult) responseResult.result;
			return result;
		} else {
			return null;
		}
	}

	public static AccountSignResult signInByToken() {
		Response<?> responseResult = WebApiClient.getSingleton().http(
				Method.POST, ApiEnvironment.Account_SignInByToken_Endpoint,
				null, AccountSignResult.class);
		if (responseResult.isSuccess()) {
			AccountSignResult result = (AccountSignResult) responseResult.result;
			return result;
		} else {
			return null;
		}
	}

	public static AccountSignResult signIn(String loginName, String password) {
		AccountSign account = new AccountSign();
		account.MobilePhone = loginName;
		account.Password = password;

		Response<?> responseResult = WebApiClient.getSingleton().http(
				Method.POST, ApiEnvironment.Account_SignIn_Endpoint, account,
				AccountSignResult.class);
		if (responseResult.isSuccess()) {
			return (AccountSignResult) responseResult.result;
		} else {
			return null;
		}
	}

	/**
	 * 快速登录
	 * @param mobilePhone
	 * @param validationCode
     * @return
     */
	public static AccountSignResult shortcutSignIn(String mobilePhone, String validationCode) {
		AccountSign account = new AccountSign();
		account.MobilePhone = mobilePhone;
		account.ValidationCode = validationCode;

		Response<?> responseResult = WebApiClient.getSingleton().httpPost(ApiEnvironment.Account_ShortcutSignIn_Endpoint, account,
				AccountSignResult.class);
		if (responseResult.isSuccess()) {
			return (AccountSignResult) responseResult.result;
		} else {
			return null;
		}
	}

	public static AccountSignResult bindThirdAccount(ThirdPassport thirdPassport) {
		Response<?> responseResult = WebApiClient.getSingleton().http(
				Method.POST, ApiEnvironment.Account_BindThirdPassport_Endpoint,
				thirdPassport, AccountSignResult.class);
		if (responseResult.isSuccess()) {
			return (AccountSignResult) responseResult.result;
		} else {
			return null;
		}
	}

	public static AccountSignResult signUp(String mobilePhone, String password, String validationCode, int SelectedProfileType) {
		AccountSign account = new AccountSign();
		account.MobilePhone = mobilePhone;
		account.Password = password;
		account.ValidationCode = validationCode;
		account.SelectedProfileType = SelectedProfileType;
		Log.i("JuXian", "注册时候的account" + account.toString());
		Response<?> responseResult = WebApiClient.getSingleton().http(
				Method.POST, ApiEnvironment.Account_SignUp_Endpoint, account,
				AccountSignResult.class);
		if (responseResult.isSuccess()) {
			return (AccountSignResult) responseResult.result;
		} else {
			return null;
		}
	}

	/**
	 * 开户申请
	 * @param openAccountRequest
	 * @return
	 */
	public static boolean openAccount(OpenAccountRequest openAccountRequest){
		Response<?> responseResult = WebApiClient.getSingleton()
				.httpPost(ApiEnvironment.Account_OpenAccount_Endpoint, openAccountRequest,
						boolean.class);
		if (responseResult.isSuccess()) {
			return (Boolean) responseResult.result;
		} else {
			return false;
		}
	}

	public static AccountSignResult resetPwd(String mobilePhone,
			String password, String identifyingCode) {
		AccountSign account = new AccountSign();
		account.MobilePhone = mobilePhone;
		account.Password = password;
		account.ValidationCode = identifyingCode;
		Response<?> responseResult = WebApiClient.getSingleton().http(
				Method.POST, ApiEnvironment.Account_ResetPwd_Endpoint, account,
				AccountSignResult.class);
		if (responseResult.isSuccess()) {
			return (AccountSignResult) responseResult.result;
		} else {
			return null;
		}
	}

	public static Boolean signOut() {
		Response<?> responseResult = WebApiClient.getSingleton().http(
				Method.POST, ApiEnvironment.Account_SignOut_Endpoint, null,
				Boolean.class);
		// Log.i("JuXuan","退出失败了哦"+responseResult.isSuccess());
		if (responseResult.isSuccess()) {
			return (Boolean) responseResult.result;
		} else {
			return false;
		}
	}

	public static Boolean existsMobilePhone(String mobilePhone) {
		if (TextUtil.isNullOrEmpty(mobilePhone))
			return false;

		String apiUrl = String.format(
				ApiEnvironment.Account_ExistsMobilePhone_Endpoint,
				TextUtil.urlEncode(mobilePhone));
		Response<?> responseResult = WebApiClient.getSingleton().httpGet(
				apiUrl, Boolean.class);
		if (responseResult.isSuccess()) {
			return (Boolean) responseResult.result;
		} else {
			return false;
		}
	}

	public static Boolean sendValidationCode(String mobilePhone) {
		if (TextUtil.isNullOrEmpty(mobilePhone))
			return false;

		String apiUrl = String.format(
				ApiEnvironment.Account_SendValidationCode_Endpoint,
				TextUtil.urlEncode(mobilePhone));
		Response<?> responseResult = WebApiClient.getSingleton().httpPost(
				apiUrl, null, Boolean.class);
		if (responseResult.isSuccess()) {
			return (Boolean) responseResult.result;
		} else {
			return false;
		}
	}
}
