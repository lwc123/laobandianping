package com.juxian.bosscomments.ui;

import android.app.Activity;
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
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.common.JsInterface;
import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.repositories.ApiEnvironment;
import com.juxian.bosscomments.repositories.ArchiveCommentRepository;
import com.juxian.bosscomments.repositories.MessageRepository;
import com.juxian.bosscomments.utils.DialogUtils;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.webapi.WebApiClient;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Tam on 2016/12/12.
 * 审核离职报告页面
 */
public class AuditWebViewActivity extends BaseActivity {
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView mTitle;
    @BindView(R.id.audit_leaving_result)
    LinearLayout mAudit_leaving_result;
    @BindView(R.id.audit_leaving_result_notpass)
    TextView mAudit_result_notpass;
    @BindView(R.id.audit_leaving_result_pass)
    TextView mAudit_result_pass;
    @BindView(R.id.audit_leaving_webview)
    WebView mAudit_WebView;
    @BindView(R.id.audit_pass_by_who)
    TextView mAudit_pass_by_who;
    @BindView(R.id.audit_repeat)
    TextView repeat_submit;

    private String url;
    private String mLeavingTag;
    private MemberEntity currentMemberEntity;
    private long bizId;
    private int commentType;
    private long mCompanyId;
    private long MsgID;

    @Override
    public int getContentViewId() {
        return R.layout.activity_audit_webview;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        setSystemBarTintManager(this);
        initViewsData();
        initListener();
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                setResult(RESULT_OK);
                finish();
                break;
            case R.id.audit_leaving_result_notpass:
                //跳去审核不通过页面
                Intent intent = new Intent(this, AuditRejectReasonActivity.class);
                intent.putExtra("CommentId", bizId);
                intent.putExtra("CompanyId", mCompanyId);
                startActivity(intent);
                break;
            case R.id.audit_leaving_result_pass:
                DialogUtils.showStandardCheckDialog(this, "取消", "确定", "确定要通过审核？", new DialogUtils.CheckDialogListener() {
                    @Override
                    public void LeftBtMethod() {

                    }

                    @Override
                    public void RightBtMethod(boolean isSendSms) {
                        pass(mCompanyId, bizId, isSendSms);
                    }
                });
                break;
            case R.id.audit_repeat:
                if (commentType == 0) {
                    Intent Change = new Intent(AuditWebViewActivity.this, AddBossCommentActivity.class);
                    Change.putExtra("Tag", "Have");
                    Change.putExtra("Operation", "Change");
                    Change.putExtra("CommentId", bizId);
                    ((Activity) AuditWebViewActivity.this).startActivityForResult(Change, 100);
                } else {
                    Intent Change = new Intent(AuditWebViewActivity.this, AddDepartureReportActivity.class);
                    Change.putExtra("Tag", "Have");
                    Change.putExtra("Operation", "Change");
                    Change.putExtra("CommentId", bizId);
                    ((Activity) AuditWebViewActivity.this).startActivity(Change);
                }
                break;
        }

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 100) {
            if (resultCode == RESULT_OK) {
                setResult(RESULT_OK);
                finish();
            }
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mAudit_result_notpass.setOnClickListener(this);
        mAudit_result_pass.setOnClickListener(this);
        repeat_submit.setOnClickListener(this);

    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        mTitle.setText("详情");
        currentMemberEntity = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);//自己的信息
        mLeavingTag = getIntent().getStringExtra("CommentType");
        mCompanyId = getIntent().getLongExtra("CompanyId", 0);
        MsgID = getIntent().getLongExtra("MsgID", 0);
        bizId = getIntent().getLongExtra("BizId", 0);
//            传过来的条目实体
        if ("leaving_report".equals(mLeavingTag)) {
            //离职报告
            repeat_submit.setVisibility(View.GONE);
            url = String.format(ApiEnvironment.EmployeArchive_Report_Endpoint, mCompanyId, bizId);

        } else if ("audit".equals(mLeavingTag)) {
            //工作评价
            url = String.format(ApiEnvironment.EmployeArchive_Comment_Endpoint, mCompanyId, bizId);
        }
        initWebView(url);
        readMsg(MsgID);
    }

    @Override
    protected void onResume() {
        super.onResume();
        getSummmary(mCompanyId, bizId);
    }

    @Override
    protected void onRestart() {
        super.onRestart();

        mAudit_WebView.loadUrl(url);
    }

    private void initWebView(String url) {
        mAudit_WebView.setVerticalScrollbarOverlay(true);
        mAudit_WebView.setVerticalScrollBarEnabled(false);

        // 设置WebView支持JavaScript
        mAudit_WebView.getSettings().setJavaScriptEnabled(true);
        mAudit_WebView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
        mAudit_WebView.getSettings().setAppCacheEnabled(false);

        Log.i("JuXian", "详情页：" + url);
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
        mAudit_WebView.loadUrl(url, WebApiClient.getSingleton().getHeadersWithToken());
    }

    private void pass(final long CompanyId, final long CommentId, final boolean isSendSms) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean isPass = ArchiveCommentRepository.passArchiveComment(CompanyId, CommentId, isSendSms);
                return isPass;
            }

            @Override
            protected void onPostExecute(Boolean isPass) {
                if (dialog != null)
                    dialog.dismiss();
                if (isPass) {
                    ToastUtil.showInfo("评价已生效");
                    finish();
                } else {
                    ToastUtil.showInfo("审核失败");
                }
            }

            protected void onPostError(Exception ex) {
//                ToastUtil.showError(getString(R.string.net_false_hint));
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    private void getSummmary(final long CompanyId, final long CommentId) {
        new AsyncRunnable<ArchiveCommentEntity>() {
            @Override
            protected ArchiveCommentEntity doInBackground(Void... params) {
                ArchiveCommentEntity entivity = ArchiveCommentRepository.getSummary(CompanyId, CommentId);
                return entivity;
            }

            @Override
            protected void onPostExecute(ArchiveCommentEntity entivity) {
                if (entivity != null) {
//                    ToastUtil.showInfo("获取成功");
                    int SummaryAuditStatus = entivity.AuditStatus;
                    Log.e(Global.LOG_TAG,"SummaryAuditStatus-->"+SummaryAuditStatus);
                    commentType = entivity.CommentType;
                    if (SummaryAuditStatus == 1) { //审核中
                        repeat_submit.setVisibility(View.GONE);
                        if (entivity.PresenterId == currentMemberEntity.PassportId) {
                            mAudit_leaving_result.setVisibility(View.GONE);//通过和不通过
                        } else {
                            mAudit_leaving_result.setVisibility(View.VISIBLE);
                            mAudit_result_notpass.setText("审核不通过");
                            mAudit_result_pass.setText("审核通过");
                        }

                    } else if (SummaryAuditStatus == 2) {//审核通过
                        repeat_submit.setVisibility(View.GONE);
                        mAudit_leaving_result.setVisibility(View.GONE);
                    } else if (SummaryAuditStatus == 9) {//审核拒绝
                        mAudit_leaving_result.setVisibility(View.GONE);
                        if (entivity.PresenterId == currentMemberEntity.PassportId) {
                            repeat_submit.setVisibility(View.VISIBLE);
                        } else {
                            repeat_submit.setVisibility(View.GONE);
                        }
                    }
                }
            }

            protected void onPostError(Exception ex) {
            }
        }.execute();

    }

    public void readMsg(final long MsgID) {

        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean success = MessageRepository.readMsg(MsgID);
                return success;
            }

            @Override
            protected void onPostExecute(Boolean model) {
                if (model) {
//                    ToastUtil.showInfo("已读");
                } else {
                }
            }

            protected void onPostError(Exception ex) {
            }
        }.execute();
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
