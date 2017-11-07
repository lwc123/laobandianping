package com.juxian.bosscomments.ui;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.AccountSign;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/10/17.
 *
 * @ProjectName: [LaoBanDianPing]
 * @Package: [com.juxian.bosscomments.ui]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/17 15:21]
 * @Version: [v1.0]
 */
public class LoginOrNewAccountActivity extends BaseActivity {

    @BindView(R.id.login)
    TextView login;
    @BindView(R.id.register)
    TextView register;
    @BindView(R.id.person_register)
    TextView person_register;
    public static final int LOGIN_TAG = 200;
    public static final int REGISTER_TAG = 100;

    @Override
    public int getContentViewId() {
        return R.layout.activity_login_or_new_account;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        initListener();
        setSystemBarTintManager(this, R.color.transparency_color);
    }

    @Override
    public void initListener() {
        super.initListener();
        login.setOnClickListener(this);
        register.setOnClickListener(this);
        person_register.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.login:
                Intent toLogin = new Intent(getApplicationContext(), SignInActivity.class);
                startActivityForResult(toLogin, LOGIN_TAG);
//                Intent toSelect = new Intent(getApplicationContext(),SelectCompanyActivity.class);
//                startActivity(toSelect);
                break;
            case R.id.register:
//                Intent toRegister = new Intent(getApplicationContext(),InputBasicInformationActivity.class);
//                startActivityForResult(toRegister,REGISTER_TAG);
                Intent toCompanyRegister = new Intent(getApplicationContext(), CompanyRegisterActivity.class);
                toCompanyRegister.putExtra("SelectedProfileType", AccountSign.ORGANIZATION_PROFILE);
                startActivityForResult(toCompanyRegister, REGISTER_TAG);
                break;
            case R.id.person_register:
                Intent toPersonRegister = new Intent(getApplicationContext(), CompanyRegisterActivity.class);
                toPersonRegister.putExtra("SelectedProfileType", AccountSign.USER_PROFILE);
                startActivityForResult(toPersonRegister, REGISTER_TAG);
//                Intent Legal = new Intent(getApplicationContext(),ApplySubmittedActivity.class);
//                startActivityForResult(Legal,REGISTER_TAG);
                break;
            default:
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            finish();
        }
    }
}
