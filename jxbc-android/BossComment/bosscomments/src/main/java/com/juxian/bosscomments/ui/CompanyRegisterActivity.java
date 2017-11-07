package com.juxian.bosscomments.ui;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.AccountSign;
import com.juxian.bosscomments.models.AccountSignResult;
import com.juxian.bosscomments.presenter.CompanyRegisterPresenter;
import com.juxian.bosscomments.presenter.CompanyRegisterPresenterImpl;
import com.juxian.bosscomments.utils.DialogUtils;
import com.juxian.bosscomments.view.CompanyRegisterView;
import com.juxian.bosscomments.view.LoadValidationCodeView;

import net.juxian.appgenome.models.SignResult;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/11/17.
 *
 * @ProjectName: [BossComment]
 * @Package: [com.juxian.bosscomments.ui]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/17 13:04]
 * @Version: [v1.0]
 */
@TargetApi(16)
public class CompanyRegisterActivity extends RemoteDataActivity implements View.OnClickListener, CompanyRegisterView, LoadValidationCodeView {

    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.input_your_phone)
    EditText input_your_phone;
    @BindView(R.id.input_validation_code)
    EditText input_validation_code;
    @BindView(R.id.setting_password_password)
    EditText setting_password_password;
    @BindView(R.id.setting_password_timers)
    TextView register_timers;// 获取验证码
    @BindView(R.id.include_button_button)
    Button btnSubmit;
    @BindView(R.id.agreement)
    TextView agreement;
    @BindView(R.id.privacy)
    TextView privacy;
    @BindView(R.id.go_login)
    TextView go_login;
    @BindView(R.id.agreement_check)
    CheckBox mAgreementCheck;
    @BindView(R.id.select_check)
    LinearLayout mSelectCheck;
    @BindView(R.id.scrollview)
    ScrollView scrollview;
    private ValidationTimer validationTimer;
    private Dialog mValidationCodeDialog;
    private Dialog mSignUpDialog;
    private InputMethodManager manager;
    private CompanyRegisterPresenter mCompanyRegisterPresenter;
    private Dialog dl;
    private int SelectedProfileType;
    Handler myHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case 1:
                    ToastUtil.showError(getString(R.string.return_is_empty));
                    btnSubmit.setText(getString(R.string.register));
                    break;
                case 2:
//                    MobclickAgent.onEvent(getApplicationContext(), "NewRegister", "常规注册");
                    ToastUtil.showInfo(getString(R.string.register_success));
                    break;
                case 3:
//                    ToastUtil.showError(getString(R.string.the_phone_has_already_been_registered));
                    DialogUtils.showAlreadyRegisterDialog(CompanyRegisterActivity.this);
//                    showProgresbarDialog();
                    btnSubmit.setText(getString(R.string.register));
                    break;
                case 5:
                    btnSubmit.setText("注册中...");
                    break;
                case 6:
                    btnSubmit.setText(getString(R.string.register));
                    break;
                case 7:
                    btnSubmit.setText(getString(R.string.register));
                    break;
                case 8:
                    btnSubmit.setText(getString(R.string.register));
                    break;
                case 9:
                    ToastUtil.showError(getString(R.string.validation_code_false_please_again_get));
                    btnSubmit.setText(getString(R.string.register));
                    break;

                default:
                    break;
            }
        }
    };

    @Override
    public int getContentViewId() {
        if (getIntent().getIntExtra("SelectedProfileType", 0) == 2) {
            return R.layout.activity_company_register;
        } else {
            return R.layout.activity_personal_register;
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);

    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        IsInitData = true;
        title.setText(getString(R.string.company_register));
        register_timers.setText(getString(R.string.get_verification_code));
        btnSubmit.setText(getString(R.string.register));
        SelectedProfileType = getIntent().getIntExtra("SelectedProfileType", 0);
        if (SelectedProfileType == 2) {
            title.setText(getString(R.string.company_register));
            agreement.setText(getString(R.string.company_agreement));
            privacy.setText(getString(R.string.company_user_privacy_agreement));
        } else if (SelectedProfileType == 1) {
            title.setText(getString(R.string.person_register));
            input_your_phone.setHint(getString(R.string.please_input_your_mobile_phone));
            agreement.setText(getString(R.string.personal_agreement));
            privacy.setText(getString(R.string.personal_user_privacy_agreement));
        }
        mCompanyRegisterPresenter = new CompanyRegisterPresenterImpl(getApplicationContext(), this, this);
    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);

        manager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
        initViewsData();
        validationTimer = new ValidationTimer(120, 1);
        initListener();
        if (SelectedProfileType == 2) {
            setSystemBarTintManager(this,R.color.head_title_register_bg);
        } else if (SelectedProfileType == 1) {
            setSystemBarTintManager(this,R.color.head_title_register_bg);
        }
    }

    @Override
    public void loadPageData() {

    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        btnSubmit.setOnClickListener(this);
        register_timers.setOnClickListener(this);
        go_login.setOnClickListener(this);
        agreement.setOnClickListener(this);
        privacy.setOnClickListener(this);
        mSelectCheck.setOnClickListener(this);
        scrollview.setOnTouchListener(new View.OnTouchListener() {

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                // TODO Auto-generated method stub
                Global.CloseKeyBoard(input_your_phone);
                return false;
            }
        });
    }

    /**
     * 点击空白区域去除软键盘
     */
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
        Matcher m1 = Pattern.compile("^1\\d{10}$").matcher(input_your_phone.getText().toString());
        final String format = "^([A-Za-z]|[0-9]){6,18}$";//密码格式
        switch (v.getId()) {
            case R.id.include_head_title_lin:// 返回
                finish();
                break;
            case R.id.setting_password_timers:// 获取验证码
                if (TextUtils.isEmpty(input_your_phone.getText().toString())) {
                    ToastUtil.showInfo(getString(R.string.mobile_phone_is_empty));
                    input_your_phone.requestFocus();
                    return;
                }
                if (!m1.matches() || input_your_phone.getText().toString().length() != 11) {
                    // txtRegisterPhone.requestFocus();
                    ToastUtil.showError(getString(R.string.phone_pattern_false));
                } else if (false == validationTimer.isRunning) {
//                    loadValidationCode();
                    mCompanyRegisterPresenter.loadValidationCode(input_your_phone.getText().toString().trim());
                    input_validation_code.setText("");
                    input_validation_code.setFocusable(true);
                } else {
                    break;
                }
                break;
            case R.id.include_button_button:// 注册完成
                if (TextUtils.isEmpty(input_your_phone.getText().toString())) {
                    ToastUtil.showInfo(getString(R.string.mobile_phone_is_empty));
                    input_your_phone.requestFocus();
                    return;
                }
                if (!m1.matches() || input_your_phone.getText().toString().length() != 11) {
                    ToastUtil.showInfo(getString(R.string.phone_pattern_false));
                    input_your_phone.requestFocus();
                    return;
                }
                if (TextUtils.isEmpty(input_validation_code.getText().toString())) {
                    ToastUtil.showInfo(getString(R.string.please_input_validation_code));
                    input_validation_code.requestFocus();
                    return;
                }
                if (input_validation_code.getText().toString().length() != 6) {
                    ToastUtil.showInfo(getString(R.string.validation_code_length_much_six));
                    input_validation_code.requestFocus();
                    return;
                }
                if (TextUtils.isEmpty(setting_password_password.getText().toString().trim())) {
                    setting_password_password.requestFocus();
                    ToastUtil.showError(getString(R.string.please_input_password));
                    return;
                }
                Matcher m2 = Pattern.compile(format).matcher(setting_password_password.getText().toString().trim());
                if (!m2.matches()) {
                    ToastUtil.showInfo(getString(R.string.please_input_signin_password));
                    setting_password_password.requestFocus();
                    return;
                }
                if (!mAgreementCheck.isChecked()) {
                    ToastUtil.showInfo(getString(R.string.please_agree_bosscomment_agreement));
                    return;
                }
//                mCompanyRegisterPresenter.signUp();
                AccountSign account = new AccountSign();
                account.MobilePhone = input_your_phone.getText().toString().trim();
                account.Password = setting_password_password.getText().toString().trim();
                account.ValidationCode = input_validation_code.getText().toString().trim();
                account.SelectedProfileType = SelectedProfileType;
                mCompanyRegisterPresenter.signUp(account, myHandler);
                break;
            case R.id.go_login:
                InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
                imm.toggleSoftInput(0, InputMethodManager.HIDE_NOT_ALWAYS);
                Intent SignIn = new Intent(getApplicationContext(), SignInActivity.class);
                startActivityForResult(SignIn, 100);
//                startActivity(SignIn);
//                finish();
                break;
            case R.id.agreement:
                if (SelectedProfileType == 2){
                    Intent intent = new Intent(getApplicationContext(),RegisterAgreementActivity.class);
                    intent.putExtra("DetailType","CompanyAgreement");
                    startActivity(intent);
                } else if (SelectedProfileType == 1) {
                    Intent intent = new Intent(getApplicationContext(),RegisterAgreementActivity.class);
                    intent.putExtra("DetailType","PersonalAgreement");
                    startActivity(intent);
                }
                break;
            case R.id.privacy:
                if (SelectedProfileType == 2){
                    Intent intent = new Intent(getApplicationContext(),RegisterAgreementActivity.class);
                    intent.putExtra("DetailType","CompanyPrivacy");
                    startActivity(intent);
                } else if (SelectedProfileType == 1) {
                    Intent intent = new Intent(getApplicationContext(),RegisterAgreementActivity.class);
                    intent.putExtra("DetailType","PersonalPrivacy");
                    startActivity(intent);
                }
                break;
            case R.id.select_check:
                if (mAgreementCheck.isChecked()) {
                    mAgreementCheck.setChecked(false);
                } else {
                    mAgreementCheck.setChecked(true);
                }
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

    /**
     * 点击注册的时候，用于判断该手机号是否已经注册，要是注册，则提示用户去登录
     */
    public void showProgresbarDialog() {
        dl = new Dialog(this);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(true);
        View dialog_view = View.inflate(getApplicationContext(), R.layout.dialog_tips, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = dp2px(260);
        dialogWindow.setAttributes(lp);
        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dl.show();
        TextView close = (TextView) dialog_view.findViewById(R.id.dialog_tips_cancel);
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
            }
        });
        TextView login = (TextView) dialog_view.findViewById(R.id.dialog_tips_ok);
        login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent SignIn = new Intent(getApplicationContext(), SignInActivity.class);
                startActivity(SignIn);
                dl.dismiss();
                CompanyRegisterActivity.this.finish();
            }
        });
    }

    @Override
    public void CompanyRegisterResult(SignResult signResult) {
        Log.e("TAG", signResult.SignStatus + "," + signResult.toString() + "," + signResult.SUCCESS);
        AccountSignResult accountSignResult = (AccountSignResult) signResult;
        if (null == signResult) {
            Message message = new Message();
            message.what = 1;
            myHandler.sendMessage(message);
            onRemoteError();
        } else if (signResult.SignStatus == SignResult.SUCCESS) {
            Message message = new Message();
            message.what = 2;
            myHandler.sendMessage(message);
            // 如果注册成功，则自动登录
//                    MobclickAgent.onEvent(context, "LogIn", "注册成功后登录");
//                    MobclickAgent.onProfileSignIn("" + AppContext.getCurrent().getCurrentAccount().getProfile().MobilePhone);
            int MultipleProfiles = accountSignResult.Account.MultipleProfiles;
            if ((MultipleProfiles & 1) == 1) {
                // 有个人身份
                Intent PersonalWorkBench = new Intent(getApplicationContext(), CHomeActivity.class);
//                Intent PersonalWorkBench = new Intent(getApplicationContext(), PWorkbenchActivity.class);
                setResult(RESULT_OK);
                startActivity(PersonalWorkBench);
                finish();
            } else if ((MultipleProfiles & 2) == 2) {
                // 注册的是企业身份
                AppConfig.set("loginName",input_your_phone.getText().toString().trim());
                AppConfig.set("loginPassword",setting_password_password.getText().toString().trim());
                Intent OpenService = new Intent(getApplicationContext(), OpenServiceActivity.class);
                setResult(RESULT_OK);
                startActivity(OpenService);
                finish();
            }
        } else if (signResult.SignStatus == SignResult.DUPLICATE_MOBILEPHONE) {
            Message message = new Message();
            message.what = 3;
            myHandler.sendMessage(message);

        } else if (signResult.SignStatus == SignResult.InvalidValidationCode) {
            Message message = new Message();
            message.what = 9;
            myHandler.sendMessage(message);
        } else if (signResult.SignStatus == SignResult.DUPLICATE_ENTNAME) {
            ToastUtil.showError(getString(R.string.company_name_already_existing));
            Message message = new Message();
            message.what = 7;
            myHandler.sendMessage(message);
        } else {
            ToastUtil.showError(signResult.ErrorMessage);
            Message message = new Message();
            message.what = 6;
            myHandler.sendMessage(message);
        }
    }

    @Override
    public void CompanyRegisterFailture(String msg, Exception e) {
        onRemoteError();
    }

    @Override
    public void showOpenAccountProgress() {
        mSignUpDialog = DialogUtil.showLoadingDialog();
    }

    @Override
    public void hideOpenAccountProgress() {
        if (mSignUpDialog != null)
            mSignUpDialog.dismiss();
    }

    @Override
    public void returnLoadValidationCode(Integer result) {
        if (result == AccountSignResult.DUPLICATE_MOBILEPHONE) {
//            ToastUtil.showError(getString(R.string.the_phone_has_already_been_registered));
            // 在获取验证码的时候就可以知道该手机号是否已经注册
//            showProgresbarDialog();
            DialogUtils.showProgresbarDialog(CompanyRegisterActivity.this,input_your_phone.getText().toString().trim());
            validationTimer.reset();
        } else {
//            onRemoteError();
        }
    }

    @Override
    public void returnLoadValidationCodeFailure(String msg, Exception e) {
        onRemoteError();
    }

    @Override
    public void showLoadValidationCodeProgress() {
        mValidationCodeDialog = DialogUtil.showLoadingDialog();
        validationTimer.start();
    }

    @Override
    public void hideLoadValidationCodeProgress() {
        mValidationCodeDialog.dismiss();
    }

    /**
     * @author 付晓龙
     * @ClassName: ValidationTimer
     * @说明:点击获取验证码计算时间
     * @date 2015-9-1 下午1:34:39
     */
    class ValidationTimer extends CountDownTimer {
        private boolean isRunning = false;

        public ValidationTimer(long millisInFuture, long countDownInterval) {
            super(millisInFuture * 1000, countDownInterval * 1000);
        }

        @Override
        public void onFinish() {
//            if (SelectedProfileType == 2) {
                register_timers.setBackground(getResources().getDrawable(
                        R.drawable.verification_code_bg));
                register_timers.setTextColor(getResources().getColor(R.color.luxury_gold_color));
//            } else if (SelectedProfileType == 1) {
//                register_timers.setBackground(getResources().getDrawable(R.drawable.button_bg_validation_code));
//            }

            register_timers.setText(getString(R.string.again_get_validation_code));
            this.isRunning = false;
        }

        @Override
        public void onTick(long millisUntilFinished) {
            this.isRunning = true;
            register_timers.setText(String.format("获取%sS",
                    millisUntilFinished / 1000));
//            if (SelectedProfileType == 2) {
                register_timers.setBackground(getResources().getDrawable(
                        R.drawable.verification_code_gray_bg));
                register_timers.setTextColor(getResources().getColor(R.color.boss_circle_send));
//            } else if (SelectedProfileType == 1) {
//                register_timers.setBackground(getResources().getDrawable(R.drawable.btn_gray));
//            }

        }

        public void reset() {
            this.cancel();
            this.onFinish();
        }
    }
}
