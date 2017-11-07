package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.OpenEnterpriseRequestEntity;
import com.juxian.bosscomments.models.PrivatenessSummaryEntity;
import com.juxian.bosscomments.models.UserProfileEntity;
import com.juxian.bosscomments.repositories.PrivatenessRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.Timer;
import java.util.TimerTask;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/11/29.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/29 10:19]
 * @Version: [v1.0]
 */
public class OpenServiceSuccessActivity extends RemoteDataActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.automatic_skip_hint)
    TextView mAutomaticSkipHint;
    private String mTag;
    private String mRecordId;

    @Override
    public int getContentViewId() {
        return R.layout.activity_open_service_success;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.pay));
        back.setVisibility(View.GONE);
        mTag = getIntent().getStringExtra(Global.LISTVIEW_ITEM_TAG);
        if (PayActivity.OPEN_SERVICE.equals(mTag)) {
            AppConfig.setCurrentProfileType(2);
            if (TextUtils.isEmpty(getIntent().getStringExtra("CompanyId"))){
//                ToastUtil.showInfo("");
            } else {
                AppConfig.setCurrentUseCompany(Long.parseLong(getIntent().getStringExtra("CompanyId")));
            }
        } else if (PayActivity.BUY.equals(mTag)){
            mRecordId = getIntent().getStringExtra("RecordId");
        } else if (PayActivity.OPEN_PERSONAL_SERVICE.equals(mTag)){

        } else if (PayActivity.PAY_FEES.equals(mTag)){

        }
    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);
        initViewsData();
        initListener();
        setSystemBarTintManager(this);
    }

    @Override
    public void loadPageData() {
        if (PayActivity.OPEN_PERSONAL_SERVICE.equals(mTag)){
            GetPersonalSummary();
        } else if (PayActivity.BUY.equals(mTag)){
            timer.schedule(task, 1000, 1000); // 1s后执行task,经过1s再次执行
        } else if (PayActivity.PAY_FEES.equals(mTag)){
            timer.schedule(task, 1000, 1000);
        } else {
            UserProfileEntity userProfileEntity = new UserProfileEntity();
            userProfileEntity.CurrentOrganizationId = Long.parseLong(getIntent().getStringExtra("CompanyId"));
            changeUserIdentity(userProfileEntity);
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);

    }

    Handler handler = new Handler() {
        public void handleMessage(Message msg) {
            if (msg.what == 1) {
                // 开通服务成功之后，自动跳转至认证界面
                Intent intent = new Intent(getApplicationContext(),InputBasicInformationActivity.class);
                OpenEnterpriseRequestEntity entity = JsonUtil.ToEntity(getIntent().getStringExtra("OpenEnterpriseRequestEntity"), OpenEnterpriseRequestEntity.class);
                intent.putExtra("Company",entity.CompanyName);
                intent.putExtra("CompanyId",getIntent().getStringExtra("CompanyId"));
                startActivity(intent);
                finish();
            } else if (msg.what == 2){
                Intent intent = new Intent(getApplicationContext(),BuySuccessWebViewActivity.class);
                intent.putExtra("RecordId",getIntent().getStringExtra("RecordId"));
                startActivity(intent);
                finish();
            } else if (msg.what == 3){
                finish();
            }
            super.handleMessage(msg);
        }
    };
    Timer timer = new Timer();
    TimerTask task = new TimerTask() {

        @Override
        public void run() {
            // 需要做的事:发送消息
            Message message = new Message();
            if (PayActivity.OPEN_SERVICE.equals(mTag)) {
                message.what = 1;
                handler.sendMessage(message);
            } else if (PayActivity.BUY.equals(mTag)){
                message.what = 2;
                handler.sendMessage(message);
            } else if (PayActivity.PAY_FEES.equals(mTag)){
                message.what = 3;
                handler.sendMessage(message);
            }
        }
    };

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
        }
    }

    private void stopTimer(){

        if (timer != null) {
            timer.cancel();
            timer = null;
        }

        if (task != null) {
            task.cancel();
            task = null;
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        stopTimer();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }


    private void GetPersonalSummary() {
        // 获取企业信息，根据之前保存的企业id查询
        new AsyncRunnable<PrivatenessSummaryEntity>() {
            @Override
            protected PrivatenessSummaryEntity doInBackground(Void... params) {
                PrivatenessSummaryEntity entity = PrivatenessRepository.GetPersonalSummary();
                return entity;
            }

            @Override
            protected void onPostExecute(PrivatenessSummaryEntity entity) {
                if (entity != null){
                    if (entity.PrivatenessServiceContract.IDCard != null){
                        AppConfig.setPersonalServiceContract(JsonUtil.ToJson(entity.PrivatenessServiceContract));
                        // 跳去详情
//                        Intent intent = new Intent(getApplicationContext(),WebViewDetailActivity.class);
//                        intent.putExtra("DetailType","PersonalDetail");
//                        intent.putExtra("ArchiveId", getIntent().getLongExtra("ArchiveId",0));
//                        startActivity(intent);
                        finish();
                    } else {
                        AppConfig.setPersonalServiceContract(null);
                        finish();
                    }

                } else {
                    onRemoteError();
                }
            }

            protected void onPostError(Exception ex) {
                onRemoteError();
                Log.e(Global.LOG_TAG, "net abnormal!");
            }
        }.execute();
    }

    private final void changeUserIdentity(final UserProfileEntity profileEntity) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                return AppContext.getCurrent().getUserAuthentication().ChangeCurrentToOrganizationProfile(profileEntity);
            }

            @Override
            protected void onPostExecute(Boolean result) {
                if (dialog != null)
                    dialog.dismiss();
                if (result == true) {
                    Intent intent = new Intent(getApplicationContext(),InputBasicInformationActivity.class);
                    OpenEnterpriseRequestEntity entity = JsonUtil.ToEntity(getIntent().getStringExtra("OpenEnterpriseRequestEntity"), OpenEnterpriseRequestEntity.class);
                    intent.putExtra("Company",entity.CompanyName);
                    intent.putExtra("CompanyId",getIntent().getStringExtra("CompanyId"));
                    startActivity(intent);
                    finish();
                } else {
                    onRemoteError();
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }
}
