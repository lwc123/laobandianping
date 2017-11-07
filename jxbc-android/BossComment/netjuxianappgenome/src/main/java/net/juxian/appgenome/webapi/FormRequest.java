package net.juxian.appgenome.webapi;

import android.util.Log;

import com.android.volley.NetworkResponse;
import com.android.volley.ParseError;
import com.android.volley.Response;
import com.android.volley.toolbox.HttpHeaderParser;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.utils.JsonUtil;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.Type;
import java.util.Map;

/**
 * Created by nene on 2016/5/17.
 *
 * @ProjectName: [JuXianLing]
 * @Package: [net.juxian.appgenome.webapi]
 * @Description: 百度LBS网络请求类，只使用post方式，不能保存本地缓存
 * @Author: [ZZQ]
 * @CreateDate: [2016/5/17 8:58]
 * @Version: [v1.0]
 */
public class FormRequest<T> extends BaseRequest<T> {

    private Type entityType;
    private Gson gson;
    private Map<String,String> params;

    public FormRequest(String url, Map<String,String> params, Type type,
                       Response.Listener<T> listener, Response.ErrorListener errorListener) {
        super(Method.POST, url, listener, errorListener);

        this.entityType = type;
        this.params = params;
        gson = JsonUtil.BuildGson();
    }

    @Override
    public Map<String, String> getParams() {
        return this.params;
    }

    @SuppressWarnings("unchecked")
    @Override
    protected Response<T> parseNetworkResponse(NetworkResponse response) {
        try {
            // 得到返回的数据
            String json = new String(response.data,
                    HttpHeaderParser.parseCharset(response.headers));
            LogManager.getLogger(WebApiClient.TAG).v(">>>>>>> %s", json);
            Log.i("JuXian", json);
            // 转化成对象
            return Response.success((T) (gson.fromJson(json, this.entityType)),
                    HttpHeaderParser.parseCacheHeaders(response));
        } catch (UnsupportedEncodingException e) {
            return Response.error(new ParseError(e));
        } catch (JsonSyntaxException e) {
            return Response.error(new ParseError(e));
        }
    }
}
