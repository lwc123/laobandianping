package com.juxian.bosscomments.ui;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.common.JsInterface;
import com.juxian.bosscomments.repositories.ApiEnvironment;
import com.juxian.bosscomments.utils.PermissionUtils;
import com.juxian.bosscomments.utils.checkSelfPermissionUtils;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Tam on 2017/1/9.
 */
public class AboutUsActivity extends BaseActivity {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.about_us)
    WebView mAudit_WebView;
    private String url;
    private String mShowType;
    private Intent mIntent;
    private static String mPageParams;
    private static Context context;

    @Override
    public int getContentViewId() {
        return R.layout.activity_about_us;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        context = this;
        initViewsData();
        initListener();
        setSystemBarTintManager(this);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.department_about_us));
//        url = String.format(ApiEnvironment.);
        mIntent = getIntent();
        mShowType = mIntent.getStringExtra("ShowType");
        if ("AboutUs".equals(mShowType)) {
            title.setText(getString(R.string.department_about_us));
            url = ApiEnvironment.About_Us_Endpoint;
        } else if ("BankInfo".equals(mShowType)) {
            title.setText("公司转账");
            url = ApiEnvironment.company_Transfer_Endpoint;
        } else if ("FAQ".equals(mShowType)) {
            title.setText("常见问题");
            url = ApiEnvironment.Common_Problem_Endpoint;
        } else if ("RolePowerExplain".equals(mShowType)) {
            title.setText("角色权限说明");
            url = ApiEnvironment.Role_Permission_Illustrate_Endpoint;
        } else if ("GoldExplain".equals(mShowType)) {
            title.setText("金币说明");
            url = ApiEnvironment.Gold_Explain_Endpoint;
        } else if ("CreateCount".equals(mShowType)) {
            title.setText("公司开户");
            url = String.format(ApiEnvironment.Company_RenewalEnterpriseService_Endpoint, AppConfig.getCurrentUseCompany(),AppConfig.getCurrentVersion().VersionName);
        } else {
            title.setText("联系我们");
            url = ApiEnvironment.Contact_Us_Endpoint;
        }
        initWebView(url);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if ("CreateCount".equals(mShowType)) {
            if (keyCode == KeyEvent.KEYCODE_BACK && mAudit_WebView.canGoBack()) {
                mAudit_WebView.goBack();//返回上个页面
                return true;
            } else {
                return super.onKeyDown(keyCode, event);
            }
        } else {
            return super.onKeyDown(keyCode, event);
        }
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                if ("CreateCount".equals(mShowType)) {
                    if (mAudit_WebView.canGoBack()) {
                        mAudit_WebView.goBack();
                        return;
                    } else {
                        finish();
                    }
                } else {
                    finish();
                }
                break;
            default:
                break;
        }
    }

    public static void goToPayFee(Activity activity, int requestCode, String pageParams) {
        Intent intent = new Intent(activity, PayActivity.class);
        intent.putExtra("PaymentEntity", pageParams);
        intent.putExtra(Global.LISTVIEW_ITEM_TAG, PayActivity.PAY_FEES);
        activity.startActivityForResult(intent, 100);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode){
            case 100:
                if (resultCode == RESULT_OK){
                    finish();
                }
                break;
        }
    }

    private void initWebView(String mUrl) {
        mAudit_WebView.setVerticalScrollbarOverlay(true);
        mAudit_WebView.setVerticalScrollBarEnabled(false);

        // 设置WebView支持JavaScript
        mAudit_WebView.getSettings().setJavaScriptEnabled(true);
        mAudit_WebView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
        mAudit_WebView.getSettings().setAppCacheEnabled(false);

        Log.i("JuXian", "详情页：" + mUrl);
        mAudit_WebView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                return super.shouldOverrideUrlLoading(view, url);
            }

            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                super.onPageStarted(view, url, favicon);


            }

            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);


            }

        });
        mAudit_WebView.addJavascriptInterface(new JsInterface(this), "AppBridge");
//         添加客户端支持
        mAudit_WebView.setWebChromeClient(new WebChromeClient());
        mAudit_WebView.loadUrl(mUrl);
    }

    public static void playPhone(Activity activity, String pageParams) {
        mPageParams = pageParams;
        if (Build.VERSION.SDK_INT < 23) {
            try {
                Intent intent = new Intent(Intent.ACTION_DIAL);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                intent.setData(Uri.parse(pageParams));
                activity.startActivity(intent);
            } catch (Exception e) {

            } finally {
                if (ContextCompat.checkSelfPermission(activity, Manifest.permission.CALL_PHONE) != PackageManager.PERMISSION_GRANTED) {
                    checkSelfPermissionUtils.checkPermission(activity, Manifest.permission.CALL_PHONE);
                }
            }
//            if (ContextCompat.checkSelfPermission(activity, Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED) {
//                Intent intent = new Intent(Intent.ACTION_DIAL);
//                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//                intent.setData(Uri.parse(pageParams));
//                activity.startActivity(intent);
//            }
        } else {
            if (ContextCompat.checkSelfPermission(activity, Manifest.permission.CALL_PHONE) != PackageManager.PERMISSION_GRANTED) {
                PermissionUtils.requestPermission(activity, PermissionUtils.CODE_CALL_PHONE, mPermissionGrant);
            } else {
                Intent intent = new Intent(Intent.ACTION_DIAL);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                intent.setData(Uri.parse(pageParams));
                activity.startActivity(intent);
            }
        }
    }

    private static PermissionUtils.PermissionGrant mPermissionGrant = new PermissionUtils.PermissionGrant() {
        @Override
        public void onPermissionGranted(int requestCode) {
            switch (requestCode) {
                case PermissionUtils.CODE_RECORD_AUDIO:
                    break;
                case PermissionUtils.CODE_GET_ACCOUNTS:
                    break;
                case PermissionUtils.CODE_READ_PHONE_STATE:
                    break;
                case PermissionUtils.CODE_CALL_PHONE:
                    Intent intent = new Intent(Intent.ACTION_DIAL);
                    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    intent.setData(Uri.parse(mPageParams));
                    context.startActivity(intent);
                    break;
                case PermissionUtils.CODE_CAMERA:
                    break;
                case PermissionUtils.CODE_ACCESS_FINE_LOCATION:
                    break;
                case PermissionUtils.CODE_ACCESS_COARSE_LOCATION:
                    break;
                case PermissionUtils.CODE_READ_EXTERNAL_STORAGE:
                    break;
                case PermissionUtils.CODE_WRITE_EXTERNAL_STORAGE:
                    break;
                default:
                    break;
            }
        }
    };

    @Override
    public void onRequestPermissionsResult(final int requestCode, @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        PermissionUtils.requestPermissionsResult(this, requestCode, permissions, grantResults, mPermissionGrant);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mAudit_WebView != null) {
            mAudit_WebView.clearHistory();
            mAudit_WebView.clearCache(true);
            mAudit_WebView.freeMemory();
            mAudit_WebView.pauseTimers();

            ViewGroup parent = (ViewGroup) mAudit_WebView.getParent();
            if (parent != null) {
                parent.removeView(mAudit_WebView);
            }
            mAudit_WebView.removeAllViews();
            mAudit_WebView.destroy();
            mAudit_WebView = null;
        }
    }
}
