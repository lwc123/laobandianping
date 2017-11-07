package com.juxian.bosscomments.ui;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.models.UserProfileEntity;
import com.juxian.bosscomments.repositories.CompanyMemberRepository;
import com.juxian.bosscomments.repositories.CompanyRepository;
import com.juxian.bosscomments.utils.SignInUtils;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/11/17.
 *
 * @Description: 选择用户身份
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/17 14:11]
 * @Version: [v1.0]
 */
public class SelectUserIdentityActivity extends BaseActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.company_identity)
    TextView mCompanyIdentity;
    @BindView(R.id.person_identity)
    TextView mPersonIdentity;

    @Override
    public int getContentViewId() {
        return R.layout.activity_select_user_identity;
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
        title.setText("选择身份");
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mCompanyIdentity.setOnClickListener(this);
        mPersonIdentity.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.company_identity:
                // 有企业身份，需要判断有几个企业，0个则去开户，1个直接进入工作台（这家公司认证是否被拒绝，去认证流程；认证中或者已认证，进入工作台），多个去选择公司
                UserProfileEntity userProfileEntity = new UserProfileEntity();
                userProfileEntity.CurrentOrganizationId = 0;
                changeUserIdentity(userProfileEntity);
                break;
            case R.id.person_identity:
                changeUserIdentity();
                break;
        }
    }
    /**
     * 企业切个人
     *
     */
    private final void changeUserIdentity() {
        final Dialog dialog = DialogUtil.showLoadingDialog();
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
                    AppConfig.setCurrentProfileType(1);
                    AppConfig.setCurrentUseCompany(0);
                    Intent PersonalWorkBench = new Intent(getApplicationContext(), CHomeActivity.class);
                    setResult(RESULT_OK);
                    startActivity(PersonalWorkBench);
                    finish();
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
                    AppConfig.setCurrentUseCompany(0);
                    AppConfig.setCurrentProfileType(2);
                    Intent toAttestation = new Intent(getApplicationContext(), OpenServiceActivity.class);
                    setResult(RESULT_OK);
                    startActivity(toAttestation);
                    finish();
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
}
