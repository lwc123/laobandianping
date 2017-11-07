package com.juxian.bosscomments.repositories;

import com.android.volley.VolleyError;
import com.juxian.bosscomments.AppContext;

import net.juxian.appgenome.webapi.WebApiClient;

import java.util.HashMap;
import java.util.Map;

public class JuXianApiClient extends WebApiClient {

	@Override
	public Map<String, String> getHeadersWithToken() {
		HashMap<String, String> headers = new HashMap<String, String>();
		headers.put(ApiEnvironment.DeviceKey, AppContext.getCurrent()
				.getDeviceKey());
		String accessToken = AppContext.getCurrent().getUserAuthentication()
				.loadSecureAccessToken();
		headers.put(ApiEnvironment.TokenKey, accessToken);
		return headers;
	}

	@Override
	public void onServerError(VolleyError error) {
		error.printStackTrace();
	}
}
