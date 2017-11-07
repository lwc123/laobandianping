package com.juxian.bosscomments.ui;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.common.JsInterface;
import com.juxian.bosscomments.models.PaymentEntity;
import com.juxian.bosscomments.models.WalletEntity;
import com.juxian.bosscomments.repositories.ApiEnvironment;
import com.juxian.bosscomments.repositories.WalletRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/10/26.
 * 查询老板点评
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/26 15:22]
 * @Version: [v1.0]
 */
public class SearchBossCommentActivity extends BaseActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_tab)
    ImageView mSearchImageView;
    @BindView(R.id.webView)
    WebView mWebView;
    private String mUrl;
    private boolean isBuySuccess;
//    private int first;
//    private Dialog dialog;
    private RelativeLayout mSearch;
    private Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if (msg.what == 1) {
                mSearch.setVisibility(View.VISIBLE);
            } else if (msg.what == 2) {
                mSearch.setVisibility(View.GONE);
            }
        }
    };

    @Override
    public int getContentViewId() {
        return R.layout.activity_search_bosscomment;
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
        title.setText(getString(R.string.background_investigation));
        mSearch = (RelativeLayout) findViewById(R.id.include_head_title_re);
        mSearchImageView.setImageResource(R.drawable.sousuo);
        mSearchImageView.setVisibility(View.VISIBLE);
        mSearch.setVisibility(View.GONE);
        mUrl = String.format(ApiEnvironment.BackgroundSurvey_List_Endpoint, AppConfig.getCurrentUseCompany());
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mSearch.setOnClickListener(this);
    }

    public void initWebView() {
        mWebView.setVerticalScrollbarOverlay(true);
        // 设置WebView支持JavaScript
        mWebView.getSettings().setJavaScriptEnabled(true);
        mWebView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
        mWebView.getSettings().setAppCacheEnabled(false);
        Log.i("JuXian", "详情页：" + mUrl);
        mWebView.setWebViewClient(new WebViewClient() {
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

//        mWebView.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);//设置js可以直接打开窗口，如window.open()，默认为false
//        mWebView.getSettings().setJavaScriptEnabled(true);//是否允许执行js，默认为false。设置true时，会提醒可能造成XSS漏洞
//        mWebView.getSettings().setSupportZoom(true);//是否可以缩放，默认true
//        mWebView.getSettings().setBuiltInZoomControls(false);//是否显示缩放按钮，默认false
//        mWebView.getSettings().setUseWideViewPort(false);//设置此属性，可任意比例缩放。大视图模式
//        mWebView.getSettings().setLoadWithOverviewMode(false);//和setUseWideViewPort(true)一起解决网页自适应问题
//        mWebView.getSettings().setAppCacheEnabled(true);//是否使用缓存
//        mWebView.getSettings().setDomStorageEnabled(true);//DOM Storage

//        mWebView.getSettings().setDefaultTextEncodingName("auto-detector");
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            mWebView.getSettings().setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        }

        mWebView.addJavascriptInterface(new JsInterface(this, mHandler), "AppBridge");
        // 添加客户端支持
        mWebView.setWebChromeClient(new WebChromeClient());
        mWebView.loadUrl(mUrl);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK && mWebView.canGoBack()) {
            mWebView.goBack();//返回上个页面
            return true;
        } else {
            return super.onKeyDown(keyCode, event);
        }
    }

    @Override
    protected void onRestart() {
        super.onRestart();
//        mUrl = String.format(ApiEnvironment.BackgroundSurvey_List_Endpoint, AppConfig.getCurrentUseCompany());
//        mWebView.loadUrl(mUrl);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                if (mWebView.canGoBack()) {
                    mWebView.goBack();
                    return;
                }
                InputMethodManager imm = (InputMethodManager) getApplicationContext().getSystemService(Context.INPUT_METHOD_SERVICE);
                imm.hideSoftInputFromWindow(mWebView.getWindowToken(), 0); //强制隐藏键盘
                finish();
                break;
            case R.id.include_head_title_re:
                mUrl = String.format(ApiEnvironment.BackgroundSurvey_Search_Endpoint, AppConfig.getCurrentUseCompany(), 1);
                mWebView.loadUrl(mUrl);
//                mWebView.reload();
                break;
            default:
        }
    }

    public static void goToBuyBackgroundSurvey(Activity activity, int requestCode, String pageParams) {
        GetCompanyWallet(activity,AppConfig.getCurrentUseCompany(),pageParams);
//        Intent intent = new Intent(activity, PayActivity.class);
//        intent.putExtra("PaymentEntity", pageParams);
//        intent.putExtra(Global.LISTVIEW_ITEM_TAG, PayActivity.BUY);
//        activity.startActivityForResult(intent, requestCode);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 100:
                if (resultCode == RESULT_OK) {
                    finish();
//                    mUrl = String.format(ApiEnvironment.BackgroundSurvey_List_Endpoint, AppConfig.getCurrentUseCompany());
//                    mWebView.loadUrl(mUrl);
                }
                break;
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mWebView != null) {
            mWebView.clearHistory();
            mWebView.clearCache(true);
            mWebView.freeMemory();
            mWebView.pauseTimers();

            ViewGroup parent = (ViewGroup) mWebView.getParent();
            if (parent != null) {
                parent.removeView(mWebView);
            }
            mWebView.removeAllViews();
            mWebView.destroy();
            mWebView = null;
        }
    }

    private static void GetCompanyWallet(final Activity activity,final long CompanyId,final String pageParams) {
        // 获取企业信息，根据之前保存的企业id查询
        new AsyncRunnable<WalletEntity>() {
            @Override
            protected WalletEntity doInBackground(Void... params) {
                WalletEntity entity = WalletRepository.getCompanyWallet(CompanyId);
                return entity;
            }

            @Override
            protected void onPostExecute(WalletEntity entity) {
                if (entity != null){
                    PaymentEntity paymentEntity = JsonUtil.ToEntity(pageParams,PaymentEntity.class);
                    if (entity.AvailableBalance>paymentEntity.TotalFee){
                        Intent intent = new Intent(activity, VaultPayActivity.class);
                        intent.putExtra("PaymentEntity", pageParams);
                        intent.putExtra(Global.LISTVIEW_ITEM_TAG, VaultPayActivity.BUY);
                        activity.startActivityForResult(intent, 100);
                    } else {
                        Intent intent = new Intent(activity, PayActivity.class);
                        intent.putExtra("PaymentEntity", pageParams);
                        intent.putExtra(Global.LISTVIEW_ITEM_TAG, PayActivity.BUY);
                        activity.startActivityForResult(intent, 100);
                    }
                } else {
                    Intent intent = new Intent(activity, PayActivity.class);
                    intent.putExtra("PaymentEntity", pageParams);
                    intent.putExtra(Global.LISTVIEW_ITEM_TAG, PayActivity.BUY);
                    activity.startActivityForResult(intent, 100);
                }
            }

            protected void onPostError(Exception ex) {
                Log.e(Global.LOG_TAG, "net abnormal!");
            }
        }.execute();
    }
}
