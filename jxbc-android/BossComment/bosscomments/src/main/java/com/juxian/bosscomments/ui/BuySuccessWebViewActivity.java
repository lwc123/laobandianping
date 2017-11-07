package com.juxian.bosscomments.ui;

import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.JsInterface;
import com.juxian.bosscomments.repositories.ApiEnvironment;

import net.juxian.appgenome.widget.ToastUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/12/12.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/12 16:35]
 * @Version: [v1.0]
 */
public class BuySuccessWebViewActivity extends BaseActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.webView)
    WebView webView;
    private String mUrl;
    private Intent mIntent;
    private long mArchiveId;// 相应的档案ID

    @Override
    public int getContentViewId() {
        return R.layout.activity_webview_detail;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        initViewsData();
        initListener();
        initWebView();
        setSystemBarTintManager(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText("背景调查报告");

        mIntent = getIntent();
        mArchiveId = mIntent.getLongExtra("ArchiveId",0);

        mUrl = String.format(ApiEnvironment.BackgroundSurvey_BoughtDetail_Endpoint, AppConfig.getCurrentUseCompany(),getIntent().getStringExtra("RecordId"));
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
    }

    public void initWebView() {
        webView.setVerticalScrollbarOverlay(true);
        // 设置WebView支持JavaScript
        webView.getSettings().setJavaScriptEnabled(true);
        webView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
        webView.getSettings().setAppCacheEnabled(false);
        Log.i("JuXian", "详情页：" + mUrl);
        webView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                return super.shouldOverrideUrlLoading(view, url);
            }

            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                super.onPageStarted(view, url, favicon);
//                if (first == 1) {
//                    dialog = DialogUtil.showLoadingDialog();
//                }

            }

            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
//                if (first == 1) {
//                    dialog.dismiss();
//                    first++;
//                }
            }
        });

        // 在js中调用本地java方法
        // webView.addJavascriptInterface(new JsInterface(this),
        // "AndroidWebView");

        webView.addJavascriptInterface(new JsInterface(this), "AppBridge");
        // 添加客户端支持
        webView.setWebChromeClient(new WebChromeClient());
        webView.loadUrl(mUrl);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            Intent intent = new Intent(getApplicationContext(),SearchBossCommentActivity.class);
            startActivity(intent);
            finish();
            return true;
        } else {
            return super.onKeyDown(keyCode, event);
        }
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()){
            case R.id.include_head_title_lin:
                Intent intent = new Intent(getApplicationContext(),SearchBossCommentActivity.class);
                startActivity(intent);
                finish();
                break;
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (webView != null) {
            webView.clearHistory();
            webView.clearCache(true);
            webView.freeMemory();
            webView.pauseTimers();

            ViewGroup parent = (ViewGroup) webView.getParent();
            if (parent != null) {
                parent.removeView(webView);
            }
            webView.removeAllViews();
            webView.destroy();
            webView = null;
        }
    }
}
