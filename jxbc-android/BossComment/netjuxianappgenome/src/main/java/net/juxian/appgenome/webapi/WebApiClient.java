package net.juxian.appgenome.webapi;

import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Map;

import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.ObjectIOCFactory;
import net.juxian.appgenome.utils.JsonUtil;

import com.android.volley.Response;
import com.android.volley.Request.Method;
import com.android.volley.VolleyError;

public class WebApiClient {
	public static final String TAG = LogManager.Default_Tag + ":WebApi" ;
    public static final int DEFAULT_TIMEOUT_MS = 24*1000;
    public static final int DEFAULT_MAX_RETRIES = 0;

	public static WebApiClient getSingleton() {
		return ObjectIOCFactory.getSingleton(WebApiClient.class);
	}

	private NetworkDispatcher networkDispatcher = null;
	public VolleyError LastError = null;

	protected WebApiClient() {
		this.networkDispatcher = new NetworkDispatcher();
	}

	public <T> Response<?> httpGet(String url, Type type) {
		GsonRequest<T> request = new GsonRequest<T>(url, type, null, null) {
			@Override
			public Map<String, String> getHeaders() {
				return getHeadersWithToken();
			}
		};
		return this.performRequest(request);
	}
	
	public <T> Response<?> httpPost(String url, Object entity, Type type) {
		String json = JsonUtil.ToJson(entity);
		GsonRequest<T> request = new GsonRequest<T>(Method.POST, url, json, type,
				null, null) {
			@Override
			public Map<String, String> getHeaders() {
				return getHeadersWithToken();
			}
		};
		return this.performRequest(request);
	}

	public <T> Response<?> httpFormPost(String url, Map<String,String> requestParams, Type type) {
		FormRequest<T> request = new FormRequest<T>(url, requestParams, type, null, null);
		Response<?> response = this.networkDispatcher.performRequest(request);
		this.LastError = response.error;
		if(null != this.LastError) {
			this.onServerError(this.LastError);
		}
		return  response;
	}

	public <T> Response<?> http(int method, String url, Object entity, Type type) {
		String json = JsonUtil.ToJson(entity);
		GsonRequest<T> request = new GsonRequest<T>(method, url, json, type,
				null, null) {
			@Override
			public Map<String, String> getHeaders() {
				return getHeadersWithToken();
			}
		};
		return this.performRequest(request);
	}

	public <T> Response<?> performRequest(GsonRequest<?> request) {
		Response<?> response = this.networkDispatcher.performRequest(request);
		this.LastError = response.error;
		if(null != this.LastError) {
			this.onServerError(this.LastError);
		}
		return  response;
	}

	public Map<String, String> getHeadersWithToken() {
		HashMap<String, String> headers = new HashMap<String, String>();
//		headers.put(WebApiClient.DeviceKey, AppContext.getCurrent()
//				.getDeviceKey());
		// String accessToken = AppContext.getCurrent().loadSecureAccessToken();
		// headers.put(ApiEnvironment.TokenKey, accessToken);
		return headers;
	}

	public void onServerError(VolleyError error) {
		error.printStackTrace();
	}
}
