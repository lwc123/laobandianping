package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.util.Log;
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
import com.juxian.bosscomments.common.JsInterface;
import com.juxian.bosscomments.models.JobEntity;
import com.juxian.bosscomments.repositories.ApiEnvironment;
import com.juxian.bosscomments.repositories.JobRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/12/29.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/29 14:10]
 * @Version: [v1.0]
 */
public class JTDetailWebViewActivity extends BaseActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.webView)
    WebView webView;
    @BindView(R.id.change_position_status)
    TextView mEditPosition;
    @BindView(R.id.edit_position)
    TextView mChangePositionStatus;
    @BindView(R.id.bottom_bt)
    LinearLayout mBottomBt;
    private String mUrl;
//    private Dialog dialog;
//    private int first = 1;
    private int mPositionStatus;
    private String DetailType;

    @Override
    public int getContentViewId() {
        return R.layout.activity_jt_detail_webview;
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
        setSystemBarTintManager(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getIntent().getStringExtra("JobName"));
        DetailType = getIntent().getStringExtra("DetailType");
        if ("company".equals(DetailType)){
            mUrl = String.format(ApiEnvironment.Job_HtmlDetail_Endpoint,AppConfig.getCurrentUseCompany(),getIntent().getLongExtra("JobId",0),0);
        } else {
            title.setText("职位详情");
            mBottomBt.setVisibility(View.GONE);
            mUrl = String.format(ApiEnvironment.Job_HtmlDetail_Endpoint,getIntent().getLongExtra("CompanyId",0),getIntent().getLongExtra("JobId",0),1);
        }
        initWebView();
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mEditPosition.setOnClickListener(this);
        mChangePositionStatus.setOnClickListener(this);
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
    protected void onResume() {
        super.onResume();
        if ("company".equals(DetailType)) {
            getJobDetail(AppConfig.getCurrentUseCompany(), getIntent().getLongExtra("JobId", 0));
        }
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.change_position_status:
                Intent intent = new Intent(getApplicationContext(),AddRecruitInfoActivity.class);
                intent.putExtra("JobId",getIntent().getLongExtra("JobId",0));
                intent.putExtra("Operation","EditPosition");
                startActivityForResult(intent,100);
                break;
            case R.id.edit_position:
                if (mPositionStatus == 0){
                    changeJobStatus(AppConfig.getCurrentUseCompany(),getIntent().getLongExtra("JobId",0),0);
                } else {
                    changeJobStatus(AppConfig.getCurrentUseCompany(),getIntent().getLongExtra("JobId",0),1);
                }
                break;
        }
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

    public void getJobDetail(final long CompanyId, final long JobId) {
        new AsyncRunnable<JobEntity>() {
            @Override
            protected JobEntity doInBackground(Void... params) {
                // 每次登录成功之后，保存token，并且返回登录信息
                JobEntity jobEntity = JobRepository.getJobDetail(CompanyId, JobId);
                return jobEntity;
            }

            @Override
            protected void onPostExecute(JobEntity jobEntity) {
                if (jobEntity != null){
                    mPositionStatus = jobEntity.DisplayState;
                    if (jobEntity.DisplayState == 0){
                        mChangePositionStatus.setText("关闭职位");
                    } else {
                        mChangePositionStatus.setText("开启职位");
                    }
                } else {

                }
            }

            @Override
            protected void onPostError(Exception ex) {
            }
        }.execute();
    }

    public void changeJobStatus(final long CompanyId, final long JobId, final int status) {
        final Dialog dialog1 = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                // 每次登录成功之后，保存token，并且返回登录信息
                Boolean changeStatus = false;
                if (status == 0) {
                    changeStatus = JobRepository.closeJobTitle(CompanyId, JobId);
                } else {
                    changeStatus = JobRepository.openJobTitle(CompanyId, JobId);
                }
                return changeStatus;
            }

            @Override
            protected void onPostExecute(Boolean changeStatus) {
                if (dialog1 != null)
                    dialog1.dismiss();
                if (changeStatus){
                    if (status == 0){
                        ToastUtil.showInfo("关闭成功");
                    } else {
                        ToastUtil.showInfo("开启成功");
                    }
                    finish();
                } else {
                    if (status == 0){
                        ToastUtil.showInfo("关闭失败");
                    } else {
                        ToastUtil.showInfo("开启失败");
                    }
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                if (dialog1 != null)
                    dialog1.dismiss();
            }
        }.execute();
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
