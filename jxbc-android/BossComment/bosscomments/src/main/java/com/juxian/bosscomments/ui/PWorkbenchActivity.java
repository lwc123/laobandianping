package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.PrivatenessServiceContractEntity;
import com.juxian.bosscomments.models.PrivatenessSummaryEntity;
import com.juxian.bosscomments.models.VersionEntity;
import com.juxian.bosscomments.repositories.PrivatenessRepository;
import com.juxian.bosscomments.repositories.UserRepository;
import com.juxian.bosscomments.utils.DialogUtils;

import net.juxian.appgenome.ActivityManager;
import net.juxian.appgenome.utils.AppConfigUtil;
import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/12/16.
 * 个人工作台
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/16 17:07]
 * @Version: [v1.0]
 */
public class PWorkbenchActivity extends BaseActivity implements View.OnClickListener, DialogUtils.DialogListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.unread_msg_number)
    TextView unreadLabel;
    @BindView(R.id.my_archive)
    TextView mMyArchive;
    @BindView(R.id.apply_job)
    TextView mApplyJob;
    @BindView(R.id.my_pocket)
    TextView mMyPocket;
    @BindView(R.id.invite_register)
    RelativeLayout mInviteRegister;
    @BindView(R.id.personal_message)
    TextView mPersonalMessage;
    @BindView(R.id.personal_setting)
    TextView mPersonalSetting;
    @BindView(R.id.invite_prize)
    ImageView mInvitePrize;
    private boolean ExistBankCard;
    private long exitTime = 0;
    private PrivatenessServiceContractEntity mPrivatenessServiceContractEntity;
    private int CompanyNumber;

    @Override
    public int getContentViewId() {
        return R.layout.activity_personal_workbench;
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
        title.setText(getString(R.string.app_name));
        back.setVisibility(View.GONE);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
        layoutParams.leftMargin = getMetrics().widthPixels / 6 + dp2px(9);
        layoutParams.topMargin = dp2px(20);
        mInvitePrize.setLayoutParams(layoutParams);
        initNumLable();
    }

    @Override
    public void initListener() {
        super.initListener();
        mMyArchive.setOnClickListener(this);
        mApplyJob.setOnClickListener(this);
        mMyPocket.setOnClickListener(this);
        mInviteRegister.setOnClickListener(this);
        mPersonalMessage.setOnClickListener(this);
        mPersonalSetting.setOnClickListener(this);
    }

    /**
     * 未读消息数Lable初始化
     */
    private void initNumLable() {
        WindowManager manager = getWindowManager();
        DisplayMetrics outMetrics = new DisplayMetrics();
        manager.getDefaultDisplay().getMetrics(outMetrics);
        int width2 = outMetrics.widthPixels;
        int height2 = outMetrics.heightPixels;
        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(dp2px(18), dp2px(18));
        params.leftMargin = (width2 / 6) * 3;
        params.topMargin = dp2px(10);
        unreadLabel.setLayoutParams(params);
    }

    @Override
    protected void onResume() {
        super.onResume();
        GetPersonalSummary();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            if (System.currentTimeMillis() - exitTime > 2000) {
                ToastUtil.showInfo(this.getResources().getString(
                        R.string.app_exit_confirm));
                exitTime = System.currentTimeMillis();
            } else {
                ActivityManager.finishAll();
                this.finish();

            }
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.my_archive:
                mPrivatenessServiceContractEntity = JsonUtil.ToEntity(AppConfig.getPersonalServiceContract(), PrivatenessServiceContractEntity.class);
                if (mPrivatenessServiceContractEntity != null) {
                    Intent PersonalArchiveList = new Intent(getApplicationContext(), PersonalArchiveListActivity.class);
                    startActivity(PersonalArchiveList);
                } else {
                    Intent toMyArchive = new Intent(getApplicationContext(), MyArchiveActivity.class);
                    startActivity(toMyArchive);
                }
                break;
            case R.id.apply_job:
                Intent intent = new Intent(this, PersonalJobSearchListActivity.class);
                startActivity(intent);
                break;
            case R.id.my_pocket:
                if (ExistBankCard) {
                    Intent WithdrawDeposit = new Intent(getApplicationContext(), HaveBankCardNumberActivity.class);
                    WithdrawDeposit.putExtra("Personal", true);
                    startActivity(WithdrawDeposit);
                } else {
                    Intent toMyPocket = new Intent(getApplicationContext(), WithdrawDepositActivity.class);
                    toMyPocket.putExtra("Personal", true);
                    startActivity(toMyPocket);
                }
                break;
            case R.id.invite_register:
                Intent toInvite = new Intent(getApplicationContext(), PersonalInviteActivity.class);
                startActivity(toInvite);
                break;
            case R.id.personal_message:
                // 暂时无个人角色信息
                Intent toMessageList = new Intent(getApplicationContext(), MessageListActivity.class);
                startActivity(toMessageList);
                break;
            case R.id.personal_setting:
                Intent toSetting = new Intent(getApplicationContext(), SettingActivity.class);
                toSetting.putExtra(Global.LISTVIEW_ITEM_TAG, "personal");
                toSetting.putExtra("CompanyNumber", CompanyNumber);
                startActivityForResult(toSetting, 100);
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 100:
                if (resultCode == RESULT_OK) {
                    finish();
                }
                break;
        }
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
                if (entity != null) {
                    ExistBankCard = entity.ExistBankCard;
                    if (entity.PrivatenessServiceContract.IDCard != null) {
                        AppConfig.setPersonalServiceContract(JsonUtil.ToJson(entity.PrivatenessServiceContract));
                    } else {
                        AppConfig.setPersonalServiceContract(null);
                    }
                    CompanyNumber = entity.myCompanys;
                    if (entity.UnreadMessageNum > 0) {
                        unreadLabel.setVisibility(View.VISIBLE);
                        unreadLabel.setText(entity.UnreadMessageNum + "");
                    } else {
                        unreadLabel.setVisibility(View.GONE);
                    }
                    if (CheckUpdata) {
                        String versionCode = AppConfigUtil.getCurrentVersion().VersionName;
                        IsEsistsVersion(versionCode, "android");
                    }
                } else {
                    AppConfig.setPersonalServiceContract(null);
                    unreadLabel.setVisibility(View.GONE);
                }
            }

            protected void onPostError(Exception ex) {
                Log.e(Global.LOG_TAG, "net abnormal!");
            }
        }.execute();
    }

    private int UpdataAppType;
    private String UpdataAppUrl;
    private boolean CheckUpdata = true;

    private void IsEsistsVersion(final String VersionCode, final String Apptype) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<VersionEntity>() {
            @Override
            protected VersionEntity doInBackground(Void... params) {
                VersionEntity entity = UserRepository.ExistsVersion(VersionCode, Apptype);
                return entity;
            }

            @Override
            protected void onPostExecute(VersionEntity entity) {
                if (dialog != null)
                    dialog.dismiss();
                if (entity != null) {
                    UpdataAppType = entity.UpgradeType;
                    UpdataAppUrl = entity.DownloadUrl;
                    if (UpdataAppType == 1) {//不提示

                    } else if (UpdataAppType == 2) {//建议更新
                        showUpdataDialog(true, "暂不升级", "前往升级", entity.Description);
                        CheckUpdata = false;
                    } else if (UpdataAppType == 3) {//强制更新
                        showUpdataDialog(false, "", "前往升级", entity.Description);
                        CheckUpdata = false;
                    }
                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                Log.e(Global.LOG_TAG, "net abnormal!");
            }
        }.execute();
    }

    private void showUpdataDialog(boolean showLeftBt, String leftBtString, String rightBtString, String descripe) {
        DialogUtils.showRadiusDialog(this, showLeftBt, leftBtString, rightBtString, descripe, this);
    }

    @Override
    public void LeftBtMethod() {

    }

    @Override
    public void RightBtMethod() {
        if (UpdataAppType == 2 || UpdataAppType == 3) {
            Intent intent = new Intent();
            intent.setAction("android.intent.action.VIEW");
            Uri content_url = Uri.parse(UpdataAppUrl);
            intent.setData(content_url);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
        }
    }
}
