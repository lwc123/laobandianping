package net.juxian.appgenome.webapi;

import android.util.Log;

import com.android.volley.NetworkResponse;
import com.android.volley.ParseError;
import com.android.volley.Response;
import com.android.volley.Response.ErrorListener;
import com.android.volley.Response.Listener;
import com.android.volley.VolleyLog;
import com.android.volley.toolbox.HttpHeaderParser;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.utils.JsonUtil;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.Type;

public class GsonRequest<T> extends BaseRequest<T> {

	private static final String PROTOCOL_CONTENT_TYPE = String.format("application/json; charset=%s", new Object[]{"utf-8"});

	private Type entityType;
	private Gson gson;
	private String mRequestBody = null;

	public GsonRequest(String url, Type type, Listener<T> listener,
			ErrorListener errorListener) {
		this(Method.GET, url, null, type, listener, errorListener);
	}

	public GsonRequest(int method, String url, String json, Type type,
			Listener<T> listener, ErrorListener errorListener) {
		super(method, url, listener, errorListener);

		this.entityType = type;
		this.mRequestBody = json;
		gson = JsonUtil.BuildGson();
	}

	@SuppressWarnings("unchecked")
	@Override
	protected Response<T> parseNetworkResponse(NetworkResponse response) {
		try {
			String json = new String(response.data,
					HttpHeaderParser.parseCharset(response.headers));
			LogManager.getLogger(WebApiClient.TAG).v(">>>>>>> %s", json);
			Log.i("JuXian", json);
			return Response.success((T) (gson.fromJson(json, this.entityType)),
					HttpHeaderParser.parseCacheHeaders(response));
		} catch (UnsupportedEncodingException e) {
			return Response.error(new ParseError(e));
		} catch (JsonSyntaxException e) {
			return Response.error(new ParseError(e));
		}
	}

	@Override
	public String getBodyContentType() {
		return PROTOCOL_CONTENT_TYPE;
	}

	@Override
	public byte[] getBody() {
		try {
			return this.mRequestBody == null?null:this.mRequestBody.getBytes("utf-8");
		} catch (UnsupportedEncodingException var2) {
			VolleyLog.wtf("Unsupported Encoding while trying to get the bytes of %s using %s", new Object[]{this.mRequestBody, "utf-8"});
			return null;
		}
	}

}
