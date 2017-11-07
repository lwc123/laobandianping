package net.juxian.appgenome.webapi;

import android.net.Uri;
import android.text.TextUtils;

import com.android.volley.DefaultRetryPolicy;
import com.android.volley.NetworkResponse;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyLog;

/**
 * Created by nene on 2016/5/17.
 *
 * @ProjectName: [JuXianLing]
 * @Package: [net.juxian.appgenome.webapi]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/5/17 8:54]
 * @Version: [v1.0]
 */
public abstract class BaseRequest<T> extends Request<T> {

    private final Response.Listener<T> mListener;

    public BaseRequest(String url, Response.Listener<T> listener, Response.ErrorListener errorListener) {
        this(-1, url, listener, errorListener);
    }

    public BaseRequest(int method, String url, Response.Listener<T> listener, Response.ErrorListener errorListener) {
        super(method,url, errorListener);
        this.mListener = listener;

        setRetryPolicy(new DefaultRetryPolicy(WebApiClient.DEFAULT_TIMEOUT_MS,
                WebApiClient.DEFAULT_MAX_RETRIES,
                DefaultRetryPolicy.DEFAULT_BACKOFF_MULT));

        if (Method.GET != method) {
            // post请求的时候，不用请求缓存
            this.setShouldCache(false);
            this.setRetryPolicy(new DefaultRetryPolicy(
                    WebApiClient.DEFAULT_TIMEOUT_MS, 0,
                    DefaultRetryPolicy.DEFAULT_BACKOFF_MULT));
        }
    }

    @Override
    protected abstract Response<T> parseNetworkResponse(NetworkResponse networkResponse);

    @Override
    protected void deliverResponse(T response) {
        mListener.onResponse(response);
    }
}
