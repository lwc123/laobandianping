package net.juxian.appgenome.webapi;

import java.io.File;

import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.utils.AppConfigUtil;
import net.juxian.appgenome.utils.FileUtil;
import net.juxian.appgenome.utils.JsonUtil;

import com.android.volley.AuthFailureError;
import com.android.volley.Cache;
import com.android.volley.Network;
import com.android.volley.NetworkResponse;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.DiskBasedCache;

public class NetworkDispatcher {
	private static final String DEFAULT_CACHE_DIR = "network";
	private static final int DEFAULT_DISK_USAGE_BYTES = 8 * 1024 * 1024;

	static {
		// VolleyLog.setTag(ApiEnvironment.TAG);
	}

	public Network network = null;
	private Cache cache = null;

	public NetworkDispatcher() {
		if (null == this.network)
			this.network = NetworkQueue.buildNetwork();

		File cacheDir = new File(FileUtil.getCachePath(DEFAULT_CACHE_DIR));
		this.cache = new DiskBasedCache(cacheDir, DEFAULT_DISK_USAGE_BYTES);
		this.cache.initialize();
	}

	public <T> Response<?> performRequest(BaseRequest<?> request) {
		try {
			LogManager.getLogger(WebApiClient.TAG).d(
					"Request=> [method:%s] %s [headers:%s, bodyLength:%s]",
					request.getMethod(), request.getUrl(), JsonUtil.ToJson(request.getHeaders()),
					null == request.getBody() ? 0 : request.getBody().length);
		} catch (AuthFailureError e) {
			e.printStackTrace();
		}

		Response<?> response = null;

		// 判断请求是否有缓存，如果有则直接从缓存中取出请求结果
		if (request.shouldCache()) {
			Cache.Entry cacheEntry = this.cache.get(request.getCacheKey());
			if (null != cacheEntry
					&& (false == cacheEntry.isExpired() || AppConfigUtil.NETWORK_DISABLE == AppConfigUtil.getNetworkStatus())) {
				// parseNetworkResponse用于分析服务器响应的方法
				response = request.parseNetworkResponse(new NetworkResponse(
						cacheEntry.data, cacheEntry.responseHeaders));
				LogManager.getLogger(WebApiClient.TAG).d(
						"Response:cache=> %s", request.getUrl());
				return response;
			}
		}

		response = this.performNetworkRequest(request);
		if (response.isSuccess()) {
			if (request.shouldCache() && null != response.cacheEntry) {
				this.cache.put(request.getCacheKey(), response.cacheEntry);
				LogManager.getLogger(WebApiClient.TAG).d("cache result => %s:%s"
						, response.cacheEntry.ttl, FileUtil.getCachePath(DEFAULT_CACHE_DIR));
			}

			LogManager.getLogger(WebApiClient.TAG).d("Response:network=> %s",	request.getUrl());
		} else
			LogManager.getLogger(WebApiClient.TAG).w(response.error,
					"Response:error=> %s", request.getUrl());

		return response;
	}

	private <T> Response<?> performNetworkRequest(BaseRequest<?> request) {
		try {
			// Network是请求网络的接口，performRequest方法用于接收请求参数，请求参数直接传到Request里
			NetworkResponse networkResponse = this.network
					.performRequest(request);
			Response<?> response = request
					.parseNetworkResponse(networkResponse);
			return response;
		} catch (VolleyError error) {
			error.printStackTrace();
			LogManager.getLogger(WebApiClient.TAG).e(error, "Response:error=> VolleyError %s", request.getUrl());
			return Response.error(error);
		} catch (Exception ex) {
			ex.printStackTrace();
			LogManager.getLogger(WebApiClient.TAG).e(ex, "Response:error=> Exception %s", request.getUrl());
			return Response.error(new VolleyError(ex.getMessage()));
		}
	}
}
