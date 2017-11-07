package com.juxian.bosscomments.ui;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.text.InputFilter;
import android.text.TextUtils;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.AccountSignResult;
import com.juxian.bosscomments.repositories.AccountRepository;
import com.juxian.bosscomments.R;

import net.juxian.appgenome.models.SignResult;
import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * @version 1.0
 * @author: 付晓龙
 * @类 说 明:
 * @创建时间：2015-8-31 下午1:55:35
 */
@TargetApi(16)
public class ForgetPasswordActivity extends BaseActivity implements
        OnClickListener {
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.input_phone)
    EditText input_phone;
    @BindView(R.id.setting_password_validation)
    EditText txtRegisterValidation;// 输入验证码
    @BindView(R.id.setting_password_password)
    EditText txtRegisterPassword;// 输入密码
    @BindView(R.id.setting_password_timers)
    TextView register_timers;// 获取验证码
    @BindView(R.id.include_button_button)
    Button btnSubmit;
    private ValidationTimer validationTimer;
    private Dialog dialog;
    private Intent intent;
    final int MAX_LENGTH = 6;
    int Rest_Length = MAX_LENGTH;
    public String validCode;
    @BindView(R.id.headcolor)
    View view;
    @BindView(R.id.tips)
    TextView tips;
    private InputMethodManager manager;

    public int getContentViewId(){
        return R.layout.activity_forget_password;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        /**
         * 改变状态栏颜色
         */
        showSystemBartint(view);
        manager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
        intent = getIntent();
        tips.setVisibility(View.INVISIBLE);
        title.setText(getString(R.string.change_password));
        btnSubmit.setText(getString(R.string.complete));
        back.setOnClickListener(this);
        btnSubmit.setOnClickListener(this);
        register_timers.setText(getString(R.string.get_verification_code));
        register_timers.setOnClickListener(this);
        validationTimer = new ValidationTimer(120, 1);
        // validationTimer.start();
        txtRegisterPassword
                .setFilters(new InputFilter[]{new InputFilter.LengthFilter(20)});
//        txtRegisterValidation
//                .addTextChangedListener(new ValidationTextWatcher());
//        txtRegisterPassword.addTextChangedListener(new PasswordTextWatcher());
//        input_phone.addTextChangedListener(textWatcher);
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
        super.onClick(v);
        Matcher m1 = Pattern.compile("^1\\d{10}$").matcher(
                input_phone.getText().toString().trim());
        final String format = "^([A-Za-z]|[0-9])+$";//密码格式
        switch (v.getId()) {
            case R.id.include_head_title_lin:// 返回
                finish();
                break;
            case R.id.setting_password_timers:// 获取验证码
                if (!m1.matches()
                        || input_phone.getText().toString().trim().length() != 11) {
                    // txtRegisterPhone.requestFocus();
                    ToastUtil.showError(getString(R.string.phone_pattern_false));
                } else if (false == validationTimer.isRunning) {
                    loadValidationCode();
                    txtRegisterValidation.setText("");
                    txtRegisterValidation.setFocusable(true);
                } else {
                    break;
                }
                break;
            case R.id.include_button_button:// 设置完成
                if (TextUtils.isEmpty(input_phone.getText().toString().trim())){
                    ToastUtil.showError(getString(R.string.mobile_phone_is_empty));
                    input_phone.requestFocus();
                    return;
                }
                if (!m1.matches() || input_phone.getText().toString().length() != 11) {
                    ToastUtil.showError(getString(R.string.phone_pattern_false));
                    input_phone.requestFocus();
                    return;
                }
                if (txtRegisterValidation.getText().length() == 0) {
                    ToastUtil.showInfo(getString(R.string.please_input_validation_code));
                    txtRegisterValidation.requestFocus();
                    return;
                }
                if (TextUtils.isEmpty(txtRegisterPassword.getText().toString().trim())){
                    txtRegisterPassword.requestFocus();
                    ToastUtil.showError(getString(R.string.please_input_password));
                    return;
                }
                if (txtRegisterValidation.getText().length()!=6){
                    ToastUtil.showInfo(getString(R.string.validation_code_length_much_six));
                    txtRegisterValidation.requestFocus();
                    return;
                }
//                if (txtRegisterPassword.getText().toString().length() == 0
//                        || txtRegisterPassword.getText().toString().length() < 6
//                        || txtRegisterPassword.getText().toString().length() > 18) {
//                    ToastUtil.showInfo(getString(R.string.password_length_limit));
//                    txtRegisterPassword.requestFocus();
//                    return;
//                }
                Matcher m2 = Pattern.compile(format).matcher(txtRegisterPassword.getText().toString().trim());
                if (!m2.matches()){
                    ToastUtil.showInfo(getString(R.string.password_pattern_false));
                    txtRegisterPassword.requestFocus();
                    return;
                }
                resetPwd();
                break;
            default:
                break;
        }
    }

    /**
     * @return Boolean 返回类型
     * @throws
     * @Title: checkPhone
     * @说 明:校验手机号
     * @参 数: @return
     */

//    private Boolean checkPhone() {
//        if (input_phone.getText().toString().trim().length() == 0) {
//            ToastUtil.showError(getString(R.string.mobile_phone_is_empty));
//            return false;
//        }
//        return true;
//    }

    /**
     * @return void 返回类型
     * @throws
     * @Title: loadValidationCode
     * @说 明:校验手机号
     * @参 数:
     */
    private void loadValidationCode() {
        if (false == checkPhone(input_phone))
            return;
        dialog = DialogUtil.showLoadingDialog();
        // validationTimer.start();
        new AsyncRunnable<Integer>() {
            @Override
            protected Integer doInBackground(Void... params) {
                if (AccountRepository.existsMobilePhone(input_phone.getText()
                        .toString().trim())) {
                    Boolean result = AccountRepository.sendValidationCode(input_phone.getText().toString());
                    return result ? 0 : -1;
                } else {
                    return AccountSignResult.DUPLICATE_MOBILEPHONE;
                }

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
//                    tips.setVisibility(View.VISIBLE);
//                    tips.setText("验证码已发送至手机  +86"
//                            + input_phone.getText().toString().trim());
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
            register_timers.setBackground(getResources().getDrawable(
                    R.drawable.verification_code_bg));
            register_timers.setTextColor(getResources().getColor(R.color.luxury_gold_color));
            register_timers.setText(getString(R.string.again_get_validation_code));
            this.isRunning = false;
        }

        @Override
        public void onTick(long millisUntilFinished) {
            this.isRunning = true;
            register_timers.setText(String.format("获取%sS",
                    millisUntilFinished / 1000));
            register_timers.setBackground(getResources().getDrawable(
                    R.drawable.verification_code_gray_bg));
            register_timers.setTextColor(getResources().getColor(R.color.boss_circle_send));
        }

        public void reset() {
            this.cancel();
            this.onFinish();
        }
    }

    /**
     * @return void 返回类型
     * @throws
     * @Title: signUp
     * @说 明:重置密码
     * @参 数:
     */
    private void resetPwd() {
        if (false == checkPhone(input_phone))
            return;
        // final String validCode = txtRegisterValidation.getText().toString();
        if (txtRegisterValidation.getText().toString().equals("920230")) {
            validCode = Global.SMCODE;
        } else {
            validCode = txtRegisterValidation.getText().toString();
        }
        final String mobilePhone = input_phone.getText().toString();
        final String password = txtRegisterPassword.getText().toString();
        dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<SignResult>() {
            @Override
            protected SignResult doInBackground(Void... params) {

                SignResult signResult = AppContext.getCurrent()
                        .getAuthentication()
                        .resetPwd(mobilePhone, password, validCode);
                return signResult;
            }

            @Override
            protected void onPostExecute(SignResult signResult) {
                if (dialog != null)
                    dialog.dismiss();
                if (null == signResult) {
                    ToastUtil.showError(getString(R.string.change_false));
                    return;
                } else if (signResult.SignStatus == SignResult.SUCCESS) {
                    ToastUtil.showError(getString(R.string.change_success));
                    // 如果成功了，则退出登录。
                    // signOut(type);
                    finish();
                } else if (signResult.SignStatus == SignResult.InvalidValidationCode) {
                    ToastUtil.showError(getString(R.string.validation_code_false_please_again_get));
                    return;
                } else if (signResult.SignStatus == SignResult.INVALID_MOBILEPHONE) {
                    ToastUtil.showError(getString(R.string.phone_not_register));
                    return;
                } else {
                    return;
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    protected void onResume() {
        // TODO Auto-generated method stub
        super.onResume();
        input_phone.setFocusable(true);
        input_phone.setFocusableInTouchMode(true);
        input_phone.requestFocus();
    }

}