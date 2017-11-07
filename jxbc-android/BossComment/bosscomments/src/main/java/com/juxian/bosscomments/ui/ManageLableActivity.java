package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.EnterpriseEntity;
import com.juxian.bosscomments.repositories.CompanyReputationRepository;
import com.juxian.bosscomments.utils.DialogUtils;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2017/4/13.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/13 10:20]
 * @Version: [v1.0]
 */
public class ManageLableActivity extends RemoteDataActivity implements View.OnClickListener,DialogUtils.DialogListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.relativeLayout)
    RelativeLayout relativeLayout;
    @BindView(R.id.textView)
    EditText mEditView;
    @BindView(R.id.textView1)
    EditText mEditView1;
    @BindView(R.id.textView2)
    EditText mEditView2;
    @BindView(R.id.textView3)
    EditText mEditView3;
    @BindView(R.id.textView4)
    EditText mEditView4;
    @BindView(R.id.include_button_button)
    Button mSave;
    private int count = 1;
    private ArrayList<String> mLabels;

    @Override
    public int getContentViewId() {
        return R.layout.activity_manage_labal;
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);
        setSystemBarTintManager(this);
        initViewsData();
        initListener();
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.company_opinion_manage_label));
        mSave.setText(getString(R.string.save));
        mLabels = new ArrayList<>();
        mLabels = getIntent().getStringArrayListExtra("Labels");
        if (mLabels.size() == 1){
            mEditView.setText(mLabels.get(0));
        } else if (mLabels.size() == 2){
            mEditView.setText(mLabels.get(0));
            mEditView1.setText(mLabels.get(1));
        } else if (mLabels.size() == 3){
            mEditView.setText(mLabels.get(0));
            mEditView1.setText(mLabels.get(1));
            mEditView2.setText(mLabels.get(2));
        } else if (mLabels.size() == 4){
            mEditView.setText(mLabels.get(0));
            mEditView1.setText(mLabels.get(1));
            mEditView2.setText(mLabels.get(2));
            mEditView3.setText(mLabels.get(3));
        } else if (mLabels.size() >= 5){
            mEditView.setText(mLabels.get(0));
            mEditView1.setText(mLabels.get(1));
            mEditView2.setText(mLabels.get(2));
            mEditView3.setText(mLabels.get(3));
            mEditView4.setText(mLabels.get(4));
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);

        mSave.setOnClickListener(this);
    }

    @Override
    public void loadPageData() {

    }

    @Override
    public void onClick(View view) {
        switch (view.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_button_button:
//                ToastUtil.showInfo("保存");
                CompanyEntity companyEntity = JsonUtil.ToEntity(AppConfig.getAccountCompany(),CompanyEntity.class);
                if (companyEntity.ContractStatus == 2) {
                    if (mEditView.getText().toString().trim().length() > 10) {
                        ToastUtil.showInfo("标签最多10个字");
                        return;
                    }
                    if (mEditView1.getText().toString().trim().length() > 10) {
                        ToastUtil.showInfo("标签最多10个字");
                        return;
                    }
                    if (mEditView2.getText().toString().trim().length() > 10) {
                        ToastUtil.showInfo("标签最多10个字");
                        return;
                    }
                    if (mEditView3.getText().toString().trim().length() > 10) {
                        ToastUtil.showInfo("标签最多10个字");
                        return;
                    }
                    if (mEditView4.getText().toString().trim().length() > 10) {
                        ToastUtil.showInfo("标签最多10个字");
                        return;
                    }
                    EnterpriseEntity enterpriseEntity = new EnterpriseEntity();
                    enterpriseEntity.CompanyId = AppConfig.getCurrentUseCompany();
                    enterpriseEntity.OpinionCompanyId = getIntent().getLongExtra("OpinionCompanyId", 0);
                    enterpriseEntity.Labels = new ArrayList<>();
                    enterpriseEntity.Labels.add(mEditView.getText().toString().trim());
                    enterpriseEntity.Labels.add(mEditView1.getText().toString().trim());
                    enterpriseEntity.Labels.add(mEditView2.getText().toString().trim());
                    enterpriseEntity.Labels.add(mEditView3.getText().toString().trim());
                    enterpriseEntity.Labels.add(mEditView4.getText().toString().trim());
                    manageLabels(enterpriseEntity);
                } else {
                    DialogUtils.showRadiusDialog(this,true,"否","是","您尚未正式开通“老板点评企业服务”，该功能只对正式用户开发，是否开通？", this);
                }
                break;
        }
    }

    private void manageLabels(final EnterpriseEntity enterpriseEntity) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean IsSuccess = CompanyReputationRepository.manageLabels(enterpriseEntity);
                return IsSuccess;
            }

            @Override
            protected void onPostExecute(Boolean IsSuccess) {
                dialog.dismiss();
                if (IsSuccess){
                    finish();
                } else {

                }
            }

            protected void onPostError(Exception ex) {
                dialog.dismiss();
            }
        }.execute();
    }

    @Override
    public void LeftBtMethod() {

    }

    @Override
    public void RightBtMethod() {
        Intent toPay = new Intent(this, AboutUsActivity.class);
        toPay.putExtra("ShowType", "CreateCount");
        startActivity(toPay);
    }
}
