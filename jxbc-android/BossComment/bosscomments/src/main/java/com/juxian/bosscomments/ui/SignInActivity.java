package com.juxian.bosscomments.ui;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.Message;
import android.text.InputFilter;
import android.text.Spanned;
import android.text.TextUtils;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.AccountSign;
import com.juxian.bosscomments.models.AccountSignResult;
import com.juxian.bosscomments.models.UserProfileEntity;
import com.juxian.bosscomments.modules.UserAuthentication;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.repositories.AccountRepository;
import com.juxian.bosscomments.utils.SignInUtils;

import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.models.SignResult;
import net.juxian.appgenome.socialize.ThirdPassport;
import net.juxian.appgenome.utils.AnalyticsUtil;
import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import butterknife.BindView;
import butterknife.ButterKnife;

@TargetApi(16)
public class SignInActivity extends BaseActivity implements OnClickListener {

    private InputMethodManager manager;
    @BindView(R.id.activity_signin_register)
    TextView quick_register;
    @BindView(R.id.activity_forget_password)
    TextView activity_forget_password;
    @BindView(R.id.company_register)
    TextView company_register;
    @BindView(R.id.person_register)
    TextView person_register;
    @BindView(R.id.register_bts)
    LinearLayout mRegisterBts;
    @BindView(R.id.login_method_change)
    TextView mLoginMethodChange;
    @BindView(R.id.setting_password_timers)
    TextView mVerificationCode;
    private final int MAX_LENGTH = 11;
    public static final int LOGIN_TAG = 200;
    public static final int REGISTER_TAG = 100;
    Handler myHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case 1:
                    btnSignIn.setText("登录中...");
                    break;

                default:
                    break;
            }
        }

        ;
    };

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

    private Button btnSignIn;
    @BindView(R.id.signIn_name)
    EditText txtName;
    @BindView(R.id.signIn_pass)
    EditText txtPass;
    @BindView(R.id.pwd_image)
    ImageView mPwdImage;
    private Dialog dialog;
    private String mLoginType;
    private ValidationTimer validationTimer;

    public int getContentViewId() {
        return R.layout.activity_signin;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);

        manager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);

        LogManager.getLogger("JuXian:Auth").i("SignInActivity...");
        initView();

        txtPass.setFilters(new InputFilter[]{filter});

        initListener();
        setSystemBarTintManager(this, R.color.transparency_color);
//        setSystemBarTintManager(this, R.color.main_color);
    }

    private InputFilter filter = new InputFilter() {
        @Override
        public CharSequence filter(CharSequence source, int start, int end,
                                   Spanned dest, int dstart, int dend) {
            if (source.equals(" ")) {
                ToastUtil.showInfo(getString(R.string.password_not_input_space));
                return "";
            } else
                return null;
        }
    };

    @Override
    protected void onResume() {
        super.onResume();
        txtName.setFocusable(true);
        txtName.setFocusableInTouchMode(true);
        txtName.requestFocus();

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

    public void initView() {
        btnSignIn = (Button) findViewById(R.id.include_button_button);
        btnSignIn.setText(getString(R.string.login));

        mLoginType = "VerificationCode";// 默认使用验证码登录
        mRegisterBts.setVisibility(View.GONE);
        activity_forget_password.setVisibility(View.GONE);
        txtPass.setHint("请输入验证码");
        mPwdImage.setImageResource(R.drawable.reset_pwd_code);
        validationTimer = new ValidationTimer(120, 1);

        if (AppConfig.get("mobilePhone") != null) {
            Log.i("JuXian", AppConfig.get("mobilePhone") + "");
            txtName.setText(AppConfig.get("mobilePhone") + "");
        }
        if (!TextUtils.isEmpty(getIntent().getStringExtra("phone"))) {
            txtName.setText(getIntent().getStringExtra("phone"));
        }
    }

    @Override
    public void initListener() {
        quick_register.setOnClickListener(this);
        activity_forget_password.setOnClickListener(this);
        btnSignIn.setOnClickListener(this);
        company_register.setOnClickListener(this);
        person_register.setOnClickListener(this);
        mLoginMethodChange.setOnClickListener(this);
        mVerificationCode.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {

        // ^\\s*\\w+(?:\\.{0,1}[\\w-]+)*@[a-zA-Z0-9]+(?:[-.][a-zA-Z0-9]+)*\\.[a-zA-Z]+\\s*$
        String ssString = "^1\\d{10}$";
        String vvString = "^\\w+(?:\\.{0,1}[\\w-]+)*@[a-zA-Z0-9]+(?:[-.][a-zA-Z0-9]+)*\\.[a-zA-Z]+$";
        String userName = txtName.getText().toString().trim();
        String userPass = txtPass.getText().toString().trim();
        final String format = "^([A-Za-z]|[0-9]){6,18}$";//密码格式

        switch (v.getId()) {
//            case R.id.include_head_title_lin:
//                finish();
//                break;
            case R.id.include_button_button:
                if (TextUtils.isEmpty(userName)) {
                    ToastUtil.showError(getString(R.string.mobile_phone_is_empty));
                    return;
                } else {
                    Matcher m = Pattern.compile(ssString).matcher(userName);
                    if (!m.matches() || txtName.getText().toString().length() != 11) {
                        ToastUtil.showError(getString(R.string.phone_pattern_false));
                        return;
                    }
                }
                if ("VerificationCode".equals(mLoginType)) {
                    if (TextUtils.isEmpty(userPass)) {
                        ToastUtil.showError("请输入验证码");
                        return;
                    }
                    shortcutSignIn();
                } else {
                    if (TextUtils.isEmpty(userPass)) {
                        ToastUtil.showError(getString(R.string.please_input_password));
                        return;
                    }
                    Matcher m1 = Pattern.compile(format).matcher(userPass);
                    if (!m1.matches()) {
                        ToastUtil.showInfo(getString(R.string.password_pattern_false));
                        return;
                    }
                    signIn();
                }

                break;
            case R.id.activity_signin_register:
                finish();
                break;
            case R.id.activity_forget_password:
                Intent mFotgetIntent = new Intent(getApplicationContext(), ForgetPasswordActivity.class);
                startActivity(mFotgetIntent);
                break;
            case R.id.company_register:
                Intent toCompanyRegister = new Intent(getApplicationContext(), CompanyRegisterActivity.class);
                toCompanyRegister.putExtra("SelectedProfileType", AccountSign.ORGANIZATION_PROFILE);
                startActivityForResult(toCompanyRegister, REGISTER_TAG);
                break;
            case R.id.person_register:
                Intent toPersonRegister = new Intent(getApplicationContext(), CompanyRegisterActivity.class);
                toPersonRegister.putExtra("SelectedProfileType", AccountSign.USER_PROFILE);
                startActivityForResult(toPersonRegister, REGISTER_TAG);
                break;
            case R.id.login_method_change:
                txtPass.setText("");
                if ("VerificationCode".equals(mLoginType)) {
                    mLoginType = "UsePassword";
                    txtPass.setHint(getString(R.string.please_input_password));
                    mLoginMethodChange.setText("快速登录");
                    mPwdImage.setImageResource(R.drawable.sign_in_pwd);
                    mVerificationCode.setVisibility(View.GONE);
                    mRegisterBts.setVisibility(View.GONE);
                    activity_forget_password.setVisibility(View.VISIBLE);
                } else {
                    mLoginType = "VerificationCode";
                    txtPass.setHint("请输入验证码");
                    mLoginMethodChange.setText("使用密码登录");
                    mPwdImage.setImageResource(R.drawable.reset_pwd_code);
                    mVerificationCode.setVisibility(View.VISIBLE);
                    mRegisterBts.setVisibility(View.GONE);
                    activity_forget_password.setVisibility(View.GONE);
                }
                break;
            case R.id.setting_password_timers:// 获取验证码
                Matcher m2 = Pattern.compile(ssString).matcher(userName);
                if (!m2.matches() || txtName.getText().toString().trim().length() != 11) {
                    ToastUtil.showError(getString(R.string.phone_pattern_false));
                } else if (false == validationTimer.isRunning) {
                    loadValidationCode();
                    txtPass.setText("");
                    txtPass.setFocusable(true);
                } else {
                    break;
                }
            default:
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 200:
                setResult(RESULT_OK);
                finish();
                break;
            case 100:
                if (resultCode == RESULT_OK) {
                    finish();
                }
                break;
        }
    }

    // 登录
    private void signIn() {
        final String loginName = txtName.getText().toString();
        final String password = txtPass.getText().toString();

        dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<SignResult>() {
            @Override
            protected SignResult doInBackground(Void... params) {
                Message message = new Message();
                message.what = 1;
                myHandler.sendMessage(message);
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
                    btnSignIn.setText(getString(R.string.login));
                } else {
                    AnalyticsUtil.onEvent(AnalyticsUtil.EVENT_ACCOUNT_SIGNIN, ThirdPassport.Platform_JuXian);
                    {
                        AppConfig.set("mobilePhone", txtName.getText().toString() + "");
                        btnSignIn.setText(getString(R.string.login_success));
                        AppConfig.set("loginName", loginName);
                        AppConfig.set("loginPassword", password);
//                        MobclickAgent.onEvent(context, "LogIn", "密码登录");//用于统计登录成功
//                        MobclickAgent.onProfileSignIn("" + AppContext.getCurrent().getCurrentAccount().getProfile().MobilePhone);
                        onSignInSuccess();

                    }
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                Log.e(Global.LOG_TAG, ex.toString());
                ToastUtil.showError(getString(R.string.net_false_hint));
                btnSignIn.setText(getString(R.string.login));
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    // 判断用户登录是否为手机号
    public static boolean isNumeric(String str) {
        for (int i = str.length(); --i >= 0; ) {
            if (!Character.isDigit(str.charAt(i))) {
                return false;
            }
        }
        return true;
    }

    private void shortcutSignIn() {
        final String loginName = txtName.getText().toString();
        final String validationCode = txtPass.getText().toString();

        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<SignResult>() {
            @Override
            protected SignResult doInBackground(Void... params) {
                Message message = new Message();
                message.what = 1;
                myHandler.sendMessage(message);
                // 每次登录成功之后，保存token，并且返回登录信息
                SignResult signResult = AppContext.getCurrent()
                        .getAuthentication().shortcutSignIn(loginName, validationCode);
                return signResult;
            }

            @Override
            protected void onPostExecute(SignResult signResult) {
                dialog.dismiss();
                if (null == signResult || signResult.SignStatus != SignResult.SUCCESS) {
                    ToastUtil.showError(signResult.ErrorMessage);
                    btnSignIn.setText(getString(R.string.login));
                } else {
                    AnalyticsUtil.onEvent(AnalyticsUtil.EVENT_ACCOUNT_SIGNIN, ThirdPassport.Platform_JuXian);
                    AppConfig.set("mobilePhone", txtName.getText().toString() + "");
                    btnSignIn.setText(getString(R.string.login_success));
                    AppConfig.set("loginName", loginName);
                    onSignInSuccess();
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                ToastUtil.showError("网络异常，请检查网络");
                btnSignIn.setText(getString(R.string.login));
                dialog.dismiss();
            }
        }.execute();
    }

    /**
     * @return void 返回类型
     * @throws
     * @Title: loadValidationCode
     * @说 明:校验手机号
     * @参 数:
     */
    private void loadValidationCode() {
        if (false == checkPhone(txtName))
            return;
        dialog = DialogUtil.showLoadingDialog();
        // validationTimer.start();
        new AsyncRunnable<Integer>() {
            @Override
            protected Integer doInBackground(Void... params) {
                Boolean result = AccountRepository.sendValidationCode(txtName.getText().toString());
                return result ? 0 : -1;
            }

            @Override
            protected void onPostExecute(Integer result) {
                if (dialog != null)
                    dialog.dismiss();
                if (result == AccountSignResult.DUPLICATE_MOBILEPHONE) {
                    ToastUtil.showError(getString(R.string.phone_not_register));
                    validationTimer.reset();
                }
                if (result == 0) {
                    ToastUtil.showInfo("发送成功");
                    validationTimer.start();
                }
                if (result == -1) {
                    ToastUtil.showError(getString(R.string.request_failed));
                    validationTimer.reset();
                }
            }
        }.execute();
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
            mVerificationCode.setBackground(getResources().getDrawable(
                    R.drawable.verification_code_bg));
            mVerificationCode.setTextColor(getResources().getColor(R.color.luxury_gold_color));
            mVerificationCode.setText(getString(R.string.again_get_validation_code));
            this.isRunning = false;
        }

        @Override
        public void onTick(long millisUntilFinished) {
            this.isRunning = true;
            mVerificationCode.setText(String.format("获取%sS",
                    millisUntilFinished / 1000));
            mVerificationCode.setBackground(getResources().getDrawable(
                    R.drawable.verification_code_gray_bg));
            mVerificationCode.setTextColor(getResources().getColor(R.color.boss_circle_send));
        }

        public void reset() {
            this.cancel();
            this.onFinish();
        }
    }
}
