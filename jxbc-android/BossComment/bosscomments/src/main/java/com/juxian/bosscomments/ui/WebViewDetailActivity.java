package com.juxian.bosscomments.ui;

import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
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
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.common.JsInterface;
import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.repositories.ApiEnvironment;

import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.webapi.WebApiClient;
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
public class WebViewDetailActivity extends BaseActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_re)
    RelativeLayout mChangeEmployeeData;
    @BindView(R.id.include_head_title_tab)
    ImageView mChangeImage;
    @BindView(R.id.webView)
    WebView webView;
    private String mUrl;
    //    private Dialog dialog;
    private int first = 1;
    private Intent mIntent;
    private PopupWindow popupWindow;
    private long mDetailId;// 有可能阶段评价、离任报告id
    private long mArchiveId;// 相应的档案ID
    private String mDetailType;
    private JsInterface mAppAppBridge;
    private ArchiveCommentEntity archiveCommentEntity;

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
        mIntent = getIntent();
        mChangeImage.setVisibility(View.VISIBLE);
        mChangeImage.setImageResource(R.drawable.list_select);
        mAppAppBridge = new JsInterface(this);

        archiveCommentEntity = JsonUtil.ToEntity(mIntent.getStringExtra("archiveCommentEntity"), ArchiveCommentEntity.class);
        mDetailId = mIntent.getLongExtra("DetailId", 0);
        mArchiveId = mIntent.getLongExtra("ArchiveId", 0);//档案ID
        mDetailType = mIntent.getStringExtra("DetailType");
        if ("Archive".equals(mDetailType)) {
//            ToastUtil.showInfo("档案详情");
            title.setText(getString(R.string.employee_record_detail));
            mUrl = String.format(ApiEnvironment.EmployeArchive_Archive_Endpoint, AppConfig.getCurrentUseCompany(), mArchiveId);
        } else if ("Comment".equals(mDetailType)) {
//            ToastUtil.showInfo("评价详情");
            title.setText(getString(R.string.stage_comment_detail));
            mUrl = String.format(ApiEnvironment.EmployeArchive_Comment_Endpoint, AppConfig.getCurrentUseCompany(), mDetailId);
        } else if ("BuySuccess".equals(mDetailType)) {
            mUrl = String.format(ApiEnvironment.BackgroundSurvey_BoughtDetail_Endpoint, AppConfig.getCurrentUseCompany(), getIntent().getStringExtra("RecordId"));
        } else if ("Report".equals(mDetailType)) {
//            ToastUtil.showInfo("离任报告详情");
            title.setText(getString(R.string.leave_post_report_detail));
            mUrl = String.format(ApiEnvironment.EmployeArchive_Report_Endpoint, AppConfig.getCurrentUseCompany(), mDetailId);
        } else {
            mUrl = String.format(ApiEnvironment.BackgroundSurvey_Personal_Detail_Endpoint, mArchiveId);
            mChangeImage.setVisibility(View.GONE);
            mChangeEmployeeData.setEnabled(false);
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mChangeEmployeeData.setOnClickListener(this);
    }

    public void initWebView() {
        webView.setVerticalScrollbarOverlay(true);
        // 设置WebView支持JavaScript
//        webView.clearCache(true);
//        webView.clearHistory();
        webView.getSettings().setJavaScriptEnabled(true);
        webView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
        webView.getSettings().setAppCacheEnabled(false);
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
//            webView.setLayerType(View.LAYER_TYPE_SOFTWARE, null);
//        }

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
        webView.loadUrl(mUrl, WebApiClient.getSingleton().getHeadersWithToken());
    }

    @Override
    protected void onRestart() {
        super.onRestart();
        webView.loadUrl(mUrl);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_head_title_re:
                if ("Archive".equals(mDetailType)) {
                    showPopupWindow(v, 2);
                } else if ("Comment".equals(mDetailType)) {
                    showPopupWindow(v, 1);
                } else if ("Report".equals(mDetailType)) {
                    showPopupWindow(v, 0);
                }
                break;
        }
    }

    public void showPopupWindow(View view, final int tag) {
        final View contentView = LayoutInflater.from(getApplicationContext()).inflate(R.layout.popupwindow_select_change_detail, null);
        RelativeLayout reChangeEmployeeRecord = (RelativeLayout) contentView.findViewById(R.id.re_change_employee_record);
        RelativeLayout reChangeCommentOrReport = (RelativeLayout) contentView.findViewById(R.id.re_change_comment_or_report);
        if (tag == 0) {
            // 离任报告详情
            TextView textView = (TextView) contentView.findViewById(R.id.select_expense_record);
            View view1 = (View) contentView.findViewById(R.id.line);
            textView.setText("修改离任报告");
            view1.setVisibility(View.GONE);
            reChangeEmployeeRecord.setVisibility(View.GONE);
        } else if (tag == 1){
            // 阶段评价详情
        } else {
            // 档案详情
            TextView textView = (TextView) contentView.findViewById(R.id.select_income_record);
            TextView textView1 = (TextView) contentView.findViewById(R.id.select_expense_record);
            textView.setText("修改员工档案");
            textView1.setText("修改评价/离任报告");
        }
        reChangeEmployeeRecord.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (tag == 2) {
                    Intent ChangeEmployeeRecord = new Intent(getApplicationContext(), AddEmployeeRecordActivity.class);
                    ChangeEmployeeRecord.putExtra(AddEmployeeRecordActivity.EMPLOYEE_RECORD_TYPE, "All");
                    ChangeEmployeeRecord.putExtra(AddEmployeeRecordActivity.OPERATION_TYPE, "Change");
                    ChangeEmployeeRecord.putExtra(AddEmployeeRecordActivity.ARCHIVE_ID, mArchiveId);
                    startActivity(ChangeEmployeeRecord);
                } else {

                    Intent AddBossCommentActivity = new Intent(getApplicationContext(), AddBossCommentActivity.class);
                    AddBossCommentActivity.putExtra("EmployeArchiveEntity", JsonUtil.ToJson(archiveCommentEntity.EmployeArchive));
                    AddBossCommentActivity.putExtra("isContinue", "continue");
                    startActivity(AddBossCommentActivity);

                }
                popupWindow.dismiss();
            }
        });
        reChangeCommentOrReport.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if ("Archive".equals(mDetailType)) {
                    Log.e(Global.LOG_TAG, getIntent().getIntExtra("CommentsNum", 0) + "");
                    if (getIntent().getIntExtra("CommentsNum", 0) == 0) {
                        ToastUtil.showInfo("暂无评价可以修改");
                    } else {
                        Intent Change = new Intent(getApplicationContext(), ChangeListActivity.class);
                        Change.putExtra("ArchiveId", mArchiveId);
                        startActivity(Change);
                    }
                } else if ("Comment".equals(mDetailType)) {
                    Intent Change = new Intent(getApplicationContext(), AddBossCommentActivity.class);
                    Change.putExtra("Tag", "Have");
                    Change.putExtra("Operation", "Change");
                    Change.putExtra("CommentId", mDetailId);
                    startActivity(Change);
                } else {
                    Intent Change = new Intent(getApplicationContext(), AddDepartureReportActivity.class);
                    Change.putExtra("Tag", "Have");
                    Change.putExtra("Operation", "Change");
                    Change.putExtra("CommentId", mDetailId);
                    startActivity(Change);
                }
                popupWindow.dismiss();
            }
        });

        popupWindow = new PopupWindow(contentView, LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT, true);
        popupWindow.setTouchable(true);
        popupWindow.setBackgroundDrawable(getResources().getDrawable(R.drawable.mask_icon_7));
        popupWindow.showAsDropDown(mChangeImage, 0, 12);

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
