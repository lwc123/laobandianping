package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.EnterpriseEntity;
import com.juxian.bosscomments.models.UserProfileEntity;
import com.juxian.bosscomments.modules.UserAuthentication;
import com.juxian.bosscomments.repositories.CompanyReputationRepository;
import com.juxian.bosscomments.utils.FileSizeUtil;
import com.juxian.bosscomments.utils.FileUtils;
import com.nostra13.universalimageloader.utils.StorageUtils;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.DialogUtils;
import net.juxian.appgenome.widget.ToastUtil;

import java.io.File;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * @version 1.0
 * @author: 付晓龙
 * @类 说 明:
 * @创建时间：2016-3-11 下午3:10:59
 */
public class SettingActivity extends BaseActivity implements OnClickListener, com.juxian.bosscomments.utils.DialogUtils.DialogListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    private static Context context;
//    @BindView(R.id.headcolor)
//    View view;
    @BindView(R.id.include_button_button)
    Button logout;
    private Dialog dialog;
    @BindView(R.id.cache)
    TextView cache;
    @BindView(R.id.re_clean_cache)
    RelativeLayout cleanCache;
    @BindView(R.id.suggestion_feedback)
    RelativeLayout suggestion_feedback;
    @BindView(R.id.department_problems)
    RelativeLayout FAQ;
    @BindView(R.id.department_about_us)
    RelativeLayout department_about_us;
    @BindView(R.id.line)
    View line;
    @BindView(R.id.updateText)
    TextView updateText;
    @BindView(R.id.change_identity)
    RelativeLayout mChangeIdentity;
    @BindView(R.id.change_identity_text)
    TextView mChangeIdentityText;
    @BindView(R.id.setting)
    LinearLayout mSetting;
    @BindView(R.id.advanced_settings)
    RelativeLayout mAdvancedSettings;
    @BindView(R.id.if_receive_message)
    CheckBox mOpenCommentFunction;// 高级设置中开关评论功能
    @BindView(R.id.line1)
    View line1;
    public UserAuthentication authentication;
    private int CompanyNumber;
    private long OpinionCompanyId;

    @Override
    public int getContentViewId() {
        return R.layout.activity_setting;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        context = getApplicationContext();
        initViewsData();
        initListener();
    }

    @Override
    public void initViewsData() {
        super.initViewsData();

        logout.setText(getString(R.string.system_setting_logout));
        updateText.setText("版本 " + AppConfig.getCurrentVersion().VersionName);
        if ("advanced".equals(getIntent().getStringExtra("Advanced"))){
            title.setText(getString(R.string.company_reputation_advanced_settings));
            mSetting.setVisibility(View.GONE);
            mAdvancedSettings.setVisibility(View.VISIBLE);
            updateText.setVisibility(View.GONE);
            OpinionCompanyId = getIntent().getLongExtra("OpinionCompanyId",0);
            mOpenCommentFunction.setChecked(getIntent().getBooleanExtra("IsCloseComment",false));
        } else {
            title.setText(getString(R.string.system_setting));
            mSetting.setVisibility(View.VISIBLE);
            mAdvancedSettings.setVisibility(View.GONE);
            updateText.setVisibility(View.VISIBLE);
            if ("personal".equals(getIntent().getStringExtra(Global.LISTVIEW_ITEM_TAG))) {
                mChangeIdentity.setVisibility(View.GONE);
                line1.setVisibility(View.GONE);
                mChangeIdentityText.setText(getString(R.string.my_company));
                CompanyNumber = getIntent().getIntExtra("CompanyNumber", 0);
                if (CompanyNumber < 1) {
                    mChangeIdentityText.setText(getString(R.string.build_new_company));
                }
            } else {
                mChangeIdentityText.setText(getString(R.string.change_identity));
            }
        }
        /**
         * 改变状态栏颜色
         */
//        showSystemBartint();
        setSystemBarTintManager(this);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        logout.setOnClickListener(this);
        cleanCache.setOnClickListener(this);
        suggestion_feedback.setOnClickListener(this);

        FAQ.setOnClickListener(this);
        mChangeIdentity.setOnClickListener(this);
        department_about_us.setOnClickListener(this);
        mOpenCommentFunction.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
                Log.e(Global.LOG_TAG,b+"");
                if (b){
                    com.juxian.bosscomments.utils.DialogUtils.showStandardDialog(SettingActivity.this,"否","是","功能开启后任何人将不能对\n您的公司进行点评和评论，是否开启？",SettingActivity.this);
                    advanceSettings(AppConfig.getCurrentUseCompany(),OpinionCompanyId,true);
                } else {
                    com.juxian.bosscomments.utils.DialogUtils.showStandardDialog(SettingActivity.this,"否","是","功能关闭后任何人将能对\n您的公司进行点评和评论，是否关闭？",SettingActivity.this);
                    advanceSettings(AppConfig.getCurrentUseCompany(),OpinionCompanyId,false);
                }
            }
        });
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_button_button:
                boolean isAuthenticated = authentication.isAuthenticated();
                if (!isAuthenticated) {
                    ToastUtil.showInfo("您还没有登录");
                    break;
                } else {
                    signOut();
                }
                break;
            case R.id.re_clean_cache:// 清理缓存
                File cacheDir = StorageUtils.getOwnCacheDirectory(context,
                        "com.juxian.bosscomments/Cache");
                FileUtils.deleteDir(cacheDir);
                File voiceCache = StorageUtils.getOwnCacheDirectory(context,
                        "com.juxian.bosscomments/OutVoice");
                FileUtils.deleteDir(voiceCache);
                File imageCache = StorageUtils.getOwnCacheDirectory(context,
                        "com.juxian.bosscomments/OutImage");
                FileUtils.deleteDir(imageCache);
                ToastUtil.showInfo("清理成功");
                cache.setText("0B");
                break;
            case R.id.suggestion_feedback:
                Intent mIntentFeedback = new Intent(getApplicationContext(), SuggestionFeedBackActivity.class);
                startActivityForResult(mIntentFeedback, 100);
                break;
            case R.id.department_about_us:
                Intent mDepartmentAboutUs = new Intent(getApplicationContext(), AboutUsActivity.class);
                mDepartmentAboutUs.putExtra("ShowType", "AboutUs");
                startActivity(mDepartmentAboutUs);
                break;
            case R.id.department_problems:
                Intent mDepartmentFAQ = new Intent(getApplicationContext(), AboutUsActivity.class);
                mDepartmentFAQ.putExtra("ShowType", "FAQ");
                startActivity(mDepartmentFAQ);
                break;
            case R.id.change_identity:
                if ("personal".equals(getIntent().getStringExtra(Global.LISTVIEW_ITEM_TAG))) {
                    if (CompanyNumber >= 1) {
                        Intent SelectOtherCompany = new Intent(getApplicationContext(), SelectOtherCompanyActivity.class);
                        SelectOtherCompany.putExtra(Global.LISTVIEW_ITEM_TAG, "personal");
                        SelectOtherCompany.putExtra("BackStatus", "select");
                        startActivityForResult(SelectOtherCompany, 600);
                    } else {
                        Intent toOpenService = new Intent(getApplicationContext(), OpenServiceActivity.class);
                        toOpenService.putExtra(Global.LISTVIEW_ITEM_TAG, "change");
                        startActivityForResult(toOpenService, 600);
                    }
                } else {
                    if ("18700000000".equals(AppContext.getCurrent().getCurrentAccount().getProfile().MobilePhone)) {
                        ToastUtil.showInfo("演示账号不能使用此功能");
                        return;
                    }
                    UserProfileEntity profileEntity = new UserProfileEntity();
                    changeUserIdentity(profileEntity);
                }
                break;
            default:
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
            case 600:
                if (resultCode == RESULT_OK) {
                    setResult(RESULT_OK);
                    finish();
                }
                break;
        }
    }

    /**
     * 企业切个人
     *
     * @param profileEntity
     */
    private final void changeUserIdentity(final UserProfileEntity profileEntity) {
        dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                return AppContext.getCurrent().getUserAuthentication().ChangeCurrentToUserProfile();
            }

            @Override
            protected void onPostExecute(Boolean result) {
                if (dialog != null)
                    dialog.dismiss();
                if (result == true) {
                    AppConfig.setCurrentUseCompany(0);
                    AppConfig.setCurrentProfileType(1);
                    Intent toSelect = new Intent(getApplicationContext(), CHomeActivity.class);
//                    Intent toSelect = new Intent(getApplicationContext(), PWorkbenchActivity.class);
                    startActivity(toSelect);
                } else {

                }
            }

            @Override
            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    private final void signOut() {
        dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                return AppContext.getCurrent().getAuthentication().signOut();
            }

            @Override
            protected void onPostExecute(Boolean result) {

                if (result == true) {
//                    MobclickAgent.onProfileSignOff();
                    AppConfig.setCurrentUseCompany(0);
                    AppConfig.setCurrentProfileType(0);
                    Intent toSelect = new Intent(getApplicationContext(), SignInActivity.class);
//                    Intent toSelect = new Intent(getApplicationContext(), LoginOrNewAccountActivity.class);
                    startActivity(toSelect);
                    setResult(RESULT_OK);
                    finish();
                } else {

                }
                if (dialog != null)
                    dialog.dismiss();

            }

            @Override
            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    @Override
    protected void onDestroy() {
        // TODO Auto-generated method stub
        super.onDestroy();
        try {
            unregisterReceiver(broadcastReceiver);
        } catch (Exception e1) {
            e1.printStackTrace();
        }
    }

    private BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {

        @Override
        public void onReceive(Context context, Intent intent) {
            String act = intent.getAction();
            if ("SettingActivity".equals(act)) {
                finish();
            }

        }
    };

    @Override
    protected void onResume() {
        // TODO Auto-generated method stub
        super.onResume();

        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("SettingActivity");
        registerReceiver(broadcastReceiver, intentFilter);

        File cacheDir = StorageUtils.getOwnCacheDirectory(context,
                "com.juxian.bosscomments");
        cache.setText(FileSizeUtil.getAutoFileOrFilesSize(cacheDir));

        authentication = AppContext.getCurrent()
                .getUserAuthentication();
    }

    private void advanceSettings(final long CompanyId,final long OpinionCompanyId,final boolean IsCloseComment) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean isSetting = CompanyReputationRepository.advanceSettings(CompanyId,OpinionCompanyId,IsCloseComment);
                return isSetting;
            }

            @Override
            protected void onPostExecute(Boolean isSetting) {
                if (dialog != null)
                    dialog.dismiss();
                if (isSetting){
                    if (IsCloseComment){
                        ToastUtil.showInfo("开启成功");
                    } else {
                        ToastUtil.showInfo("关闭成功");
                    }
                } else {

                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    @Override
    public void LeftBtMethod() {

    }

    @Override
    public void RightBtMethod() {
        if (mOpenCommentFunction.isChecked()){
            advanceSettings(AppConfig.getCurrentUseCompany(),OpinionCompanyId,true);
        } else {
            advanceSettings(AppConfig.getCurrentUseCompany(),OpinionCompanyId,false);
        }
    }
}
