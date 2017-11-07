package com.juxian.bosscomments.ui;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.repositories.CompanyRepository;
import com.juxian.bosscomments.widget.RoundAngleImageView;
import com.nostra13.universalimageloader.core.ImageLoader;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/12/1.
 * 所有员工档案页（没有任何档案）
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/1 15:39]
 * @Version: [v1.0]
 */
public class NullRecordListViewActivity extends BaseActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_tab2)
    TextView mNewBuildText;
    @BindView(R.id.include_head_title_re1)
    RelativeLayout mNewBuild;
    @BindView(R.id.build_staff_on_active_duty_record)
    LinearLayout mBuildActiveRecord;
    @BindView(R.id.build_separated_employees_record)
    LinearLayout mBuildSeparatedRecord;
    @BindView(R.id.user_photo)
    RoundAngleImageView mCompanyLogo;
    @BindView(R.id.company_name)
    TextView mCompanyName;
    @BindView(R.id.legal_person)
    TextView mLegalPerson;
    @BindView(R.id.employee_count)
    TextView mEmployeeCount;
    @BindView(R.id.leave_office_employee_count)
    TextView mDepartEmployeeCount;
    @BindView(R.id.authentication_image)
    ImageView mAlreadyAuthentication;
    @BindView(R.id.authentication)
    TextView mAuthentication;

    @Override
    public int getContentViewId() {
        return R.layout.activity_all_employee_record_null;
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
        mNewBuildText.setText(getString(R.string.new_build));
        mNewBuild.setVisibility(View.VISIBLE);
        mNewBuildText.setVisibility(View.VISIBLE);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
//        mAddRecord.setOnClickListener(this);
        mNewBuild.setOnClickListener(this);
        mBuildActiveRecord.setOnClickListener(this);
        mBuildSeparatedRecord.setOnClickListener(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        GetMineMessage(AppConfig.getCurrentUseCompany());
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_head_title_re1:
                Intent AddEmployeeRecord = new Intent(getApplicationContext(),AddEmployeeRecordActivity.class);
                AddEmployeeRecord.putExtra(AddEmployeeRecordActivity.EMPLOYEE_RECORD_TYPE,"All");
                AddEmployeeRecord.putExtra(AddEmployeeRecordActivity.OPERATION_TYPE,"Build");
                startActivity(AddEmployeeRecord);
                break;
            case R.id.build_staff_on_active_duty_record:
                Intent AddOnActiveRecord = new Intent(getApplicationContext(),AddEmployeeRecordActivity.class);
                AddOnActiveRecord.putExtra(AddEmployeeRecordActivity.EMPLOYEE_RECORD_TYPE,"OnActive");
                AddOnActiveRecord.putExtra(AddEmployeeRecordActivity.OPERATION_TYPE,"Build");
                startActivity(AddOnActiveRecord);
                break;
            case R.id.build_separated_employees_record:
                Intent AddSeparatedEmployeeRecord = new Intent(getApplicationContext(),AddEmployeeRecordActivity.class);
                AddSeparatedEmployeeRecord.putExtra(AddEmployeeRecordActivity.EMPLOYEE_RECORD_TYPE,"Departure");
                AddSeparatedEmployeeRecord.putExtra(AddEmployeeRecordActivity.OPERATION_TYPE,"Build");
                startActivity(AddSeparatedEmployeeRecord);
                break;
            default:
        }
    }

    private void GetMineMessage(final long CompanyId) {
        // 获取企业信息，根据之前保存的企业id查询
        new AsyncRunnable<CompanyEntity>() {
            @Override
            protected CompanyEntity doInBackground(Void... params) {
                CompanyEntity entity = CompanyRepository.getSummary(CompanyId);
                return entity;
            }

            @Override
            protected void onPostExecute(CompanyEntity entity) {
                if (entity != null) {
                    if (entity.AuditStatus == 2) {
                        mAlreadyAuthentication.setVisibility(View.VISIBLE);
                        mAuthentication.setVisibility(View.GONE);
                    } else {
                        mAlreadyAuthentication.setVisibility(View.GONE);
                        mAuthentication.setVisibility(View.VISIBLE);
                    }
                    mEmployeeCount.setText("在职员工：" + entity.EmployedNum + "人");
                    mDepartEmployeeCount.setText("离任员工：" + entity.DimissionNum + "人");
                    if (!TextUtils.isEmpty(entity.CompanyName)) {
                        mCompanyName.setText(entity.CompanyName);
                    } else {
                        mCompanyName.setText("");
                    }
                    if (!TextUtils.isEmpty(entity.LegalName)) {
                        mLegalPerson.setText(entity.LegalName);
                    } else {
                        mLegalPerson.setText("");
                    }
                } else {
                    Log.e(Global.LOG_TAG, "NULL");
                }
            }

            protected void onPostError(Exception ex) {
                Log.e(Global.LOG_TAG, "net abnormal!");
            }
        }.execute();
    }
}
