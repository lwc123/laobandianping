package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Paint;
import android.os.Build;
import android.os.Bundle;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.AccountSignResult;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.PriceStrategyEntity;
import com.juxian.bosscomments.models.OpenEnterpriseRequestEntity;
import com.juxian.bosscomments.models.UserProfileEntity;
import com.juxian.bosscomments.modules.UserAuthentication;
import com.juxian.bosscomments.repositories.EnterpriseServiceRepository;
import com.juxian.bosscomments.repositories.PriceStrategyRepository;
import com.juxian.bosscomments.repositories.UserRepository;
import com.juxian.bosscomments.utils.SignInUtils;
import com.juxian.bosscomments.utils.SystemBarTintManager;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.ActivityManager;
import net.juxian.appgenome.models.SignResult;
import net.juxian.appgenome.socialize.ThirdPassport;
import net.juxian.appgenome.utils.AnalyticsUtil;
import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/11/17.
 *
 * @ProjectName: [BossComment]
 * @Package: [com.juxian.bosscomments.ui]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/17 15:48]
 * @Version: [v1.0]
 */
public class OpenServiceActivity extends RemoteDataActivity implements View.OnClickListener {

    //    @BindView(R.id.include_head_title_title)
//    TextView title;
    @BindView(R.id.back)
    ImageView back;
    @BindView(R.id.sure_company_name)
    EditText mCompanyName;
    @BindView(R.id.sure_your_name)
    EditText mYourName;
    @BindView(R.id.sure_your_position)
    EditText mYourPosition;
    @BindView(R.id.spring_festival_preference)
    TextView mPreferencePrice;// 特惠价格
    @BindView(R.id.total_price)
    TextView mOriginalPrice;// 原价
    @BindView(R.id.discount)
    TextView mDiscount;// 折扣
    @BindView(R.id.include_button_button)
    Button mGoPay;
    private InputMethodManager manager;
    @BindView(R.id.headcolor)
    View mView;
    @BindView(R.id.scrollview)
    ScrollView scrollview;
    @BindView(R.id.activity_head_img)
    ImageView mActivityHeadImg;
    @BindView(R.id.activity_icon)
    ImageView mActivityIcon;
    @BindView(R.id.preferential)
    LinearLayout mPreferential;
    @BindView(R.id.need_help)
    TextView need_help;
    @BindView(R.id.activity_name)
    TextView mActivityName;
    @BindView(R.id.product_demonstration)
    TextView mProductDemonstration;
    @BindView(R.id.activity_content)
    LinearLayout mActivityContent;
    private SystemBarTintManager tintManager;
    private DecimalFormat df1 = new DecimalFormat("0");
    private DecimalFormat df2 = new DecimalFormat("0.0");
    private SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat("yyyy年MM月dd日");
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_OPEN_SERVICE_OPTIONS;
    DisplayImageOptions options1 = Global.Constants.DEFAULT_OPEN_SERVICE_ICON_OPTIONS;
    private double mCurrentPrice;
    private String Version;
    private Dialog dialog;
    private boolean isCharge;//判断是否需要付费
    private boolean IsDemonstration;

    @Override
    public int getContentViewId() {
        return R.layout.activity_open_service;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void loadPageData() {
        getActivityInfo(1, Version);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
//        title.setText(getString(R.string.open_service));
        mPreferential.setVisibility(View.GONE);
        mDiscount.setVisibility(View.GONE);
//        mGoPay.setText(getString(R.string.go_pay));
        mGoPay.setText(getString(R.string.next_step));
        mGoPay.setEnabled(false);
        Version = AppConfig.getCurrentVersion().VersionName;
    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);
        manager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
        initViewsData();
        initListener();
//        setSystemBarTintManager(this);
        /**
         * 改变状态栏颜色
         */
        showSystemBartint(mView);
        tintManager = new SystemBarTintManager(this);
        tintManager.setStatusBarTintEnabled(true);
        tintManager.setStatusBarTintResource(R.color.main_color);
        tintManager.setStatusBarTintResource(R.color.transparency_color);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            mView.setVisibility(View.GONE);
        } else {
            mView.setVisibility(View.GONE);
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
//        back.setVisibility(View.GONE);
        mGoPay.setOnClickListener(this);
        need_help.setOnClickListener(this);
        mProductDemonstration.setOnClickListener(this);
        scrollview.setOnTouchListener(new View.OnTouchListener() {

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                // TODO Auto-generated method stub
                Global.CloseKeyBoard(mCompanyName);
                return false;
            }
        });
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        // TODO Auto-generated method stub
        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            if (getCurrentFocus() != null
                    && getCurrentFocus().getWindowToken() != null) {
                manager.hideSoftInputFromWindow(getCurrentFocus()
                        .getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
            }
        }
        return super.onTouchEvent(event);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.back:
                if ("change".equals(getIntent().getStringExtra(Global.LISTVIEW_ITEM_TAG)))
                    finish();
                else {
                    IsDemonstration = false;
                    signOut();
                }
                break;
            case R.id.include_button_button:
                if (TextUtils.isEmpty(mCompanyName.getText().toString().trim())) {
                    ToastUtil.showInfo(getString(R.string.please_input_company_name));
                    return;
                }
                if (mCompanyName.getText().toString().trim().length() > 30) {
                    ToastUtil.showInfo(getString(R.string.company_name_length_limit));
                    return;
                }
                if (TextUtils.isEmpty(mYourName.getText().toString().trim())) {
                    ToastUtil.showInfo(getString(R.string.please_input_your_name));
                    return;
                }
                if (mYourName.getText().toString().trim().length() > 5) {
                    ToastUtil.showInfo(getString(R.string.name_length_limit));
                    mYourName.requestFocus();
                    return;
                }
                if (TextUtils.isEmpty(mYourPosition.getText().toString().trim())) {
                    ToastUtil.showInfo(getString(R.string.please_input_your_position));
                    return;
                }
                if (mYourPosition.getText().toString().trim().length() > 20) {
                    ToastUtil.showInfo(getString(R.string.your_position_length_limit));
                    mYourPosition.requestFocus();
                    return;
                }
                if (mCurrentPrice >= 0) {
                    checkCompanyName(mCompanyName.getText().toString().trim());
                }
                break;
            case R.id.need_help:
                Intent intent = new Intent(getApplicationContext(), AboutUsActivity.class);
                intent.putExtra("ShowType", "NeedHelp");
                startActivity(intent);
                break;
            case R.id.product_demonstration:
                IsDemonstration = true;
                signOut();
//                signIn();
                break;
            default:
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 100:
                if (resultCode == RESULT_OK) {
                    setResult(RESULT_OK);
                    finish();
                }
                break;
        }
    }

    public void checkCompanyName(final String CompanyName) {
        dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean resultEntity = UserRepository.checkCompanyName(CompanyName);
                return resultEntity;
            }

            @Override
            protected void onPostExecute(Boolean result) {
                if (!result) {
                    OpenEnterpriseRequestEntity entity = new OpenEnterpriseRequestEntity();
                    entity.CompanyName = mCompanyName.getText().toString().trim();
                    entity.RealName = mYourName.getText().toString().trim();
                    entity.JobTitle = mYourPosition.getText().toString().trim();
                    entity.OpinionCompanyId = getIntent().getLongExtra("OpinionCompanyId",0);
                    if (!isCharge) {
                        CreateNewCompany(entity);
                    } else {
                        Intent mIntentPay = new Intent(getApplicationContext(), PayActivity.class);
                        mIntentPay.putExtra(Global.LISTVIEW_ITEM_TAG, PayActivity.OPEN_SERVICE);
                        mIntentPay.putExtra("OpenEnterpriseRequestEntity", JsonUtil.ToJson(entity));
                        mIntentPay.putExtra("CurrentPrice", mCurrentPrice);
                        startActivityForResult(mIntentPay, 100);
                    }
                } else {
                    if (dialog.isShowing())
                        dialog.dismiss();
                    ToastUtil.showInfo(getString(R.string.company_already_exist));
                }
            }

            protected void onPostError(Exception ex) {
                Log.e(Global.LOG_TAG,"1:"+ex.toString());
                if (dialog.isShowing())
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }

    public void getActivityInfo(final int ActivityType, final String Version) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<PriceStrategyEntity>() {
            @Override
            protected PriceStrategyEntity doInBackground(Void... params) {
                PriceStrategyEntity resultEntity = PriceStrategyRepository.getCurrentActivityInfo(ActivityType, Version);
                return resultEntity;
            }

            @Override
            protected void onPostExecute(PriceStrategyEntity result) {
                if (dialog != null)
                    dialog.dismiss();
                IsInitData = true;
                if (result != null) {
                    if (result.IsActivity) {
                        mGoPay.setEnabled(true);
                        if (result.AndroidOriginalPrice == 0) {
                            isCharge = false;
                            mGoPay.setText(getString(R.string.next_step));
                            mActivityContent.setVisibility(View.GONE);
                        } else {
                            isCharge = true;
                            mGoPay.setText(getString(R.string.go_pay));
                            mActivityContent.setVisibility(View.VISIBLE);
                            if (!TextUtils.isEmpty(result.ActivityName)) {
                                mActivityName.setText(result.ActivityName + "：");
                            } else {
                                mActivityName.setText("活动价格：");
                            }
                            mPreferential.setVisibility(View.VISIBLE);
                            mDiscount.setVisibility(View.VISIBLE);
                            mCurrentPrice = result.AndroidPreferentialPrice;
                            mOriginalPrice.getPaint().setFlags(Paint.STRIKE_THRU_TEXT_FLAG);

                            mOriginalPrice.setTextColor(getResources().getColor(R.color.menu_color));
                            mOriginalPrice.setText(df1.format(result.AndroidOriginalPrice) + "元");
                            mPreferencePrice.setText(df1.format(result.AndroidPreferentialPrice) + "元");
                            if (!TextUtils.isEmpty(result.AndroidActivityDescription)) {
                                mDiscount.setText(result.AndroidActivityDescription);
                            } else {
                                mDiscount.setText("用良心点评您的员工");
                            }
                        }
                        if (!TextUtils.isEmpty(result.ActivityHeadFigure)) {
                            ImageLoader.getInstance().displayImage(result.ActivityHeadFigure, mActivityHeadImg, options, animateFirstListener);
                        }
                        if (!TextUtils.isEmpty(result.ActivityIcon)) {
                            ImageLoader.getInstance().displayImage(result.ActivityIcon, mActivityIcon, options1, animateFirstListener);
                        }
                    } else {
                        mCurrentPrice = result.AndroidOriginalPrice;
                        mOriginalPrice.setTextColor(getResources().getColor(R.color.juxian_red));
                        mOriginalPrice.setText(df1.format(result.AndroidOriginalPrice) + "元");
                        mPreferential.setVisibility(View.GONE);
                        if (!TextUtils.isEmpty(result.ActivityDescription)) {
                            mDiscount.setText(result.ActivityDescription);
                        } else {
                            mDiscount.setText("用良心点评您的员工");
                        }
                        mActivityContent.setVisibility(View.VISIBLE);
                        mDiscount.setVisibility(View.VISIBLE);
                    }
                } else {
                    mCurrentPrice = 5000;
                    mActivityContent.setVisibility(View.VISIBLE);
                    mPreferential.setVisibility(View.GONE);
                    mDiscount.setVisibility(View.GONE);
                    onRemoteError();
                }
            }

            protected void onPostError(Exception ex) {
                onRemoteError();
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    private final void signOut() {
        final Dialog dialog = DialogUtil.showLoadingDialog();
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
                    if (IsDemonstration){
                        signIn();
                    } else {
                        Intent toSelect = new Intent(getApplicationContext(), SignInActivity.class);
//                    Intent toSelect = new Intent(getApplicationContext(), LoginOrNewAccountActivity.class);
                        startActivity(toSelect);
                        setResult(RESULT_OK);
                        finish();
                    }
                } else {
                    onRemoteError();
                }
                if (dialog != null)
                    dialog.dismiss();

            }

            @Override
            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }

    // 登录
    private void signIn() {
        final String loginName = "18700000000";
        final String password = "974539";

        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<SignResult>() {
            @Override
            protected SignResult doInBackground(Void... params) {
                // 每次登录成功之后，保存token，并且返回登录信息
                SignResult signResult = AppContext.getCurrent().getAuthentication().signIn(loginName, password);
                return signResult;
            }

            @Override
            protected void onPostExecute(SignResult signResult) {
                if (dialog != null)
                    dialog.dismiss();
                AccountSignResult accountSignResult = (AccountSignResult) signResult;
                if (null == accountSignResult || accountSignResult.SignStatus != accountSignResult.SUCCESS) {
//                    ToastUtil.showError(signResult.ErrorMessage);
                    ToastUtil.showError(getString(R.string.user_account_or_pwd_error));
                } else {
                    AnalyticsUtil.onEvent(AnalyticsUtil.EVENT_ACCOUNT_SIGNIN, ThirdPassport.Platform_JuXian);
                    {
//                        AppConfig.setCurrentUseCompany(0);
//                        MobclickAgent.onEvent(context, "LogIn", "密码登录");//用于统计登录成功
//                        MobclickAgent.onProfileSignIn("" + AppContext.getCurrent().getCurrentAccount().getProfile().MobilePhone);
                        onSignInSuccess();

                    }
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                onRemoteError();
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    public void onSignInSuccess() {
        UserAuthentication authentication = AppContext.getCurrent().getUserAuthentication();
        if (authentication.isInitializedIdentity()) {
            if (AppContext.getCurrent().isAuthenticated()) {
                UserProfileEntity entity = authentication.getCurrentAccount().getProfile();

                SignInUtils.SignInSuccess(this, authentication);
            } else {
                return;
            }
        } else {

            return;
        }
    }

    public void CreateNewCompany(final OpenEnterpriseRequestEntity entity) {
        new AsyncRunnable<CompanyEntity>() {
            @Override
            protected CompanyEntity doInBackground(Void... params) {
                CompanyEntity resultEntity = UserRepository.CreateNewCompany(entity);
                return resultEntity;
            }

            @Override
            protected void onPostExecute(CompanyEntity result) {
                if (result != null) {
                    AppConfig.setCurrentProfileType(2);
                    AppConfig.setCurrentUseCompany(result.CompanyId);
                    UserProfileEntity userProfileEntity = new UserProfileEntity();
                    // B端公司ID
                    userProfileEntity.CurrentOrganizationId = result.CompanyId;
                    changeUserIdentity(userProfileEntity,entity);
                } else {
                    if (dialog != null)
                        dialog.dismiss();
                    onRemoteError();
                }
            }

            protected void onPostError(Exception ex) {
                Log.e(Global.LOG_TAG,"2:"+ex.toString());
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }


    private final void changeUserIdentity(final UserProfileEntity profileEntity,final OpenEnterpriseRequestEntity entity) {
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                return AppContext.getCurrent().getUserAuthentication().ChangeCurrentToOrganizationProfile(profileEntity);
            }

            @Override
            protected void onPostExecute(Boolean result) {
                if (dialog != null)
                    dialog.dismiss();
                if (result) {
                    Intent intent = new Intent(getApplicationContext(),InputBasicInformationActivity.class);
                    intent.putExtra("Company",entity.CompanyName);
                    intent.putExtra("CompanyId",profileEntity.CurrentOrganizationId+"");
                    setResult(RESULT_OK);
                    startActivity(intent);
                    finish();
                } else {
                    onRemoteError();
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                Log.e(Global.LOG_TAG,"3:"+ex.toString());
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }
}
