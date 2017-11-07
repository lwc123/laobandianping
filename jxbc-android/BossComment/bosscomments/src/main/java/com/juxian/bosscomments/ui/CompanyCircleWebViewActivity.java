package com.juxian.bosscomments.ui;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
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
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.common.JsInterface;
import com.juxian.bosscomments.models.CCompanyEntity;
import com.juxian.bosscomments.models.OpinionEntity;
import com.juxian.bosscomments.modules.PaymentEngine;
import com.juxian.bosscomments.repositories.ApiEnvironment;
import com.juxian.bosscomments.repositories.CompanyReputationRepository;
import com.juxian.bosscomments.widget.CustomTitleShareBoard;
import com.nostra13.universalimageloader.core.ImageLoader;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.webapi.WebApiClient;
import net.juxian.appgenome.widget.CustomShareBoard;
import net.juxian.appgenome.widget.DialogUtils;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2017/4/14.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/14 11:03]
 * @Version: [v1.0]
 */
public class CompanyCircleWebViewActivity extends RemoteDataActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView mTitle;
    @BindView(R.id.company_detail)
    WebView mCompanyDetail;
    @BindView(R.id.company_detail_bts)
    LinearLayout mCompanyDetailBts;
    @BindView(R.id.company_detail_left_bt)
    TextView mLeftBt;
    @BindView(R.id.company_detail_right_bt)
    TextView mRightBt;
    @BindView(R.id.include_head_title_re)
    RelativeLayout mOperationRl;
    @BindView(R.id.include_head_title_tab)
    ImageView mOperationImage;
    private String mUrl, WebViewType;
    private long OpinionId;
    private static long mCompanyId;
    private OpinionEntity mOpinionEntity;
    private PopupWindow popupWindow;
    private static String CreateResource;
    private String mFromResource;

    @Override
    public int getContentViewId() {
        return R.layout.activity_company_circle_webview;
    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);
        initViewsData();
        initListener();
        setSystemBarTintManager(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        WebViewType = getIntent().getStringExtra("WebViewType");
        mOperationImage.setImageResource(R.drawable.ic_share);
        mOperationImage.setVisibility(View.VISIBLE);
        if ("OpinionDetail".equals(WebViewType)) {
            mTitle.setText("点评详情");
            mCompanyDetailBts.setVisibility(View.VISIBLE);
            mLeftBt.setText("点评这家公司");
            mRightBt.setText("写写评论");
            OpinionId = getIntent().getLongExtra("OpinionId", 0);
            mFromResource = getIntent().getStringExtra("FromResource");
            if ("FromB".equals(mFromResource)){
                mLeftBt.setVisibility(View.GONE);
                mRightBt.setText("对此点评进行回复");
                mOperationImage.setVisibility(View.GONE);
            }
//            getCompanyReputationList(OpinionId);
            mOpinionEntity = JsonUtil.ToEntity(getIntent().getStringExtra("OpinionEntity"),OpinionEntity.class);
            mUrl = String.format(ApiEnvironment.Opinion_OpinionDetail_Endpoint, OpinionId);
        } else if ("OpinionCreate".equals(WebViewType)) {
            mTitle.setText("添加点评");
            CreateResource = getIntent().getStringExtra("CreateResource");
            OpinionId = getIntent().getLongExtra("CompanyId", 0);
            mCompanyId = getIntent().getLongExtra("CompanyId", 0);
            mOperationImage.setVisibility(View.GONE);
            mOperationRl.setVisibility(View.GONE);
            mUrl = String.format(ApiEnvironment.Opinion_CreatePage_Endpoint, OpinionId);
        } else if ("ClaimCompany".equals(WebViewType)) {
            OpinionId = getIntent().getLongExtra("CompanyId", 0);
            mCompanyId = getIntent().getLongExtra("CompanyId", 0);
            mUrl = String.format(ApiEnvironment.Opinion_ClaimCompany_Endpoint, OpinionId, getIntent().getStringExtra("CompanyName"));
        }
        initWebView(mUrl);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mLeftBt.setOnClickListener(this);
        mRightBt.setOnClickListener(this);
        if ("FromB".equals(mFromResource)){

        } else {
            mOperationRl.setOnClickListener(this);
        }
    }

    @Override
    public void loadPageData() {

    }

    private void initWebView(String url) {
        mCompanyDetail.setVerticalScrollbarOverlay(true);
        mCompanyDetail.setVerticalScrollBarEnabled(false);

        // 设置WebView支持JavaScript
        mCompanyDetail.getSettings().setJavaScriptEnabled(true);
        mCompanyDetail.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
        mCompanyDetail.getSettings().setAppCacheEnabled(false);

        Log.i("JuXian", "详情页：" + url);
        mCompanyDetail.setWebViewClient(new WebViewClient() {
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
        mCompanyDetail.addJavascriptInterface(new JsInterface(this), "AppBridge");
//         添加客户端支持
        mCompanyDetail.setWebChromeClient(new WebChromeClient());
        mCompanyDetail.loadUrl(url, WebApiClient.getSingleton().getHeadersWithToken());
    }

    public static void goToCompanyDetail(Activity activity, int requestCode, String pageParams) {
        if ("CompanyDetail".equals(CreateResource)) {
            activity.finish();
        } else {
            Intent intent = new Intent(activity, CompanyDetailActivity.class);
            intent.putExtra("CompanyId", mCompanyId);
            activity.startActivity(intent);
            activity.finish();
        }
    }

    public static void goToOpenService(Activity activity, int requestCode, String pageParams) {
        Intent intent = new Intent(activity, OpenServiceActivity.class);
        intent.putExtra("OpinionCompanyId",mCompanyId);
        intent.putExtra(Global.LISTVIEW_ITEM_TAG, "change");
        activity.startActivity(intent);
//        activity.startActivityForResult(intent,requestCode);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode){
            case 200:
                if (resultCode == RESULT_OK){
                    setResult(RESULT_OK);
                    finish();
                }
                break;
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        IsReloadDataOnResume = true;
    }

    @Override
    protected void onRestart() {
        super.onRestart();
        mCompanyDetail.loadUrl(mUrl, WebApiClient.getSingleton().getHeadersWithToken());
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.company_detail_left_bt:
                Intent postOpinion = new Intent(getApplicationContext(), CompanyCircleWebViewActivity.class);
                postOpinion.putExtra("WebViewType", "OpinionCreate");
                postOpinion.putExtra("CompanyId", mOpinionEntity.CompanyId);
                postOpinion.putExtra("CompanyName", mOpinionEntity.Company.CompanyName);
                startActivity(postOpinion);
                break;
            case R.id.company_detail_right_bt:
                Intent replyComment = new Intent(getApplicationContext(), PostCommentActivity.class);
                replyComment.putExtra("FromResource",mFromResource);
                replyComment.putExtra("OpinionId", OpinionId);
                replyComment.putExtra("CompanyId", mOpinionEntity.CompanyId);
                startActivity(replyComment);
                break;
            case R.id.include_head_title_re:
//                showPopupWindow(view);
                String shareTitle = mOpinionEntity.Title;
                String content = mOpinionEntity.Content;
                String UserAvatar = mOpinionEntity.Company.CompanyLogo;
                String shareUrl = mUrl;
                CustomTitleShareBoard shareBoard = new CustomTitleShareBoard(
                        CompanyCircleWebViewActivity.this, getApplicationContext(), shareTitle, content,
                        UserAvatar, shareUrl);
                shareBoard.showAsDropDown(mOperationImage, 0, 12);
                break;
            default:
                break;
        }
    }

//    private void getCompanyReputationList(final long OpinionId) {
//        new AsyncRunnable<OpinionEntity>() {
//            @Override
//            protected OpinionEntity doInBackground(Void... params) {
//                OpinionEntity opinionEntity = CompanyReputationRepository.getCompanyReputationDetail(OpinionId);
//                return opinionEntity;
//            }
//
//            @Override
//            protected void onPostExecute(OpinionEntity opinionEntity) {
//                if (opinionEntity != null) {
//                    IsInitData = true;
//                    mOpinionEntity = opinionEntity;
//                } else {
//                    onRemoteError();
//                }
//            }
//
//            protected void onPostError(Exception ex) {
//                onRemoteError();
//            }
//        }.execute();
//    }

    public void showPopupWindow(View view) {
        final View contentView = LayoutInflater.from(getApplicationContext()).inflate(R.layout.popupwindow_select_consume_type, null);
        RelativeLayout reIncomeRecord = (RelativeLayout) contentView.findViewById(R.id.re_income_record);
        TextView select_income_record = (TextView) contentView.findViewById(R.id.select_income_record);
        select_income_record.setText("分享给微信好友");
        RelativeLayout reExpenseRecord = (RelativeLayout) contentView.findViewById(R.id.re_expense_record);
        TextView select_expense_record = (TextView) contentView.findViewById(R.id.select_expense_record);
        select_expense_record.setText("发送至朋友圈");
        RelativeLayout reWithdrawDepositRecord = (RelativeLayout) contentView.findViewById(R.id.re_withdraw_deposit_record);
        reIncomeRecord.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        });
        reExpenseRecord.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        });
        reWithdrawDepositRecord.setVisibility(View.GONE);
        reWithdrawDepositRecord.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        });
        popupWindow = new PopupWindow(contentView, LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT, true);
        popupWindow.setTouchable(true);
        popupWindow.setBackgroundDrawable(getResources().getDrawable(R.drawable.mask_icon_7));
        popupWindow.showAsDropDown(mOperationImage, 0, 12);

    }
}
