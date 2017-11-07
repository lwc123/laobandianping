package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.BizDictEntity;
import com.juxian.bosscomments.models.JobEntity;
import com.juxian.bosscomments.modules.DictionaryPool;
import com.juxian.bosscomments.repositories.JobRepository;
import com.pl.wheelview.WheelView;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/12/26.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/26 14:18]
 * @Version: [v1.0]
 */
public class AddRecruitInfoActivity extends RemoteDataActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_tab2)
    TextView post_position_text;
    @BindView(R.id.include_head_title_re1)
    RelativeLayout post_position;
    @BindView(R.id.include_button_button)
    Button post;
    @BindView(R.id.activity_experience_required)
    RelativeLayout mActivityExperienceRequired;
    @BindView(R.id.experience_required_text)
    TextView mExperienceRequiredText;
    @BindView(R.id.activity_education_required)
    RelativeLayout mActivityEducationRequired;
    @BindView(R.id.education_required_text)
    TextView mEducationRequiredText;
    @BindView(R.id.activity_company_info)
    RelativeLayout mActivityCompanyinfo;
    @BindView(R.id.activity_position_name)
    RelativeLayout activity_position_name;
    @BindView(R.id.activity_work_city)
    RelativeLayout activity_work_city;
    @BindView(R.id.activity_work_address)
    RelativeLayout activity_work_address;
    @BindView(R.id.activity_job_description)
    RelativeLayout activity_job_description;
    @BindView(R.id.activity_resume_receiving_mail)
    RelativeLayout activity_resume_receiving_mail;
    @BindView(R.id.activity_contact_number)
    RelativeLayout activity_contact_number;
    @BindView(R.id.position_name_text)
    TextView position_name_text;
    @BindView(R.id.work_address_text)
    TextView work_address_text;
    @BindView(R.id.resume_receiving_mail_text)
    TextView resume_receiving_mail_text;
    @BindView(R.id.contact_number_text)
    TextView contact_number_text;
    @BindView(R.id.salary_range_text)
    TextView salary_range_text;
    @BindView(R.id.job_description_text)
    ImageView job_description_text;
    @BindView(R.id.work_city_text)
    TextView work_city_text;
    @BindView(R.id.company_info_text)
    TextView mCompanyName;
    @BindView(R.id.delete_position)
    TextView mDeletePosition;
    @BindView(R.id.save_position)
    TextView mSavePosition;
    @BindView(R.id.bottom_bt)
    LinearLayout mBottomBt;
    private double SalaryRangeMin;
    private double SalaryRangeMax;
    private String mJobDescription;
    private ArrayList<String> mExperienceRequiredList;
    private ArrayList<String> mEducationRequiredList;
    private ArrayList<String> mExperienceRequiredListCode;
    private ArrayList<String> mEducationRequiredListCode;
    private String resultMsg;
    private DecimalFormat df1 = new DecimalFormat("0.00");
    boolean checked;
    private String Operation;
    private JobEntity mJobEntity;
    private String CityCode;
    private Dialog dialog;

    @Override
    public int getContentViewId() {
        return R.layout.activity_add_recruit_info;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.advertising));
        post_position_text.setText(getString(R.string.post));
        post_position.setVisibility(View.VISIBLE);
        post_position_text.setVisibility(View.VISIBLE);
        post.setText(getString(R.string.post));
        Operation = getIntent().getStringExtra("Operation");
        mExperienceRequiredList = new ArrayList();
        mExperienceRequiredListCode = new ArrayList<>();
        mEducationRequiredList = new ArrayList<>();
        mEducationRequiredListCode = new ArrayList<>();
        if ("EditPosition".equals(Operation)) {
            mBottomBt.setVisibility(View.VISIBLE);
            post.setVisibility(View.GONE);
            title.setText("修改职位");
            post_position_text.setText("保存");
        } else {
            mBottomBt.setVisibility(View.GONE);
            post.setVisibility(View.VISIBLE);
            mCompanyName.setText(getIntent().getStringExtra("CompanyName"));
        }
    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);
        initViewsData();
        initListener();
        setSystemBarTintManager(this);
    }

    @Override
    public void loadPageData() {
        getTags();
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        post_position.setOnClickListener(this);
        post.setOnClickListener(this);
        mActivityExperienceRequired.setOnClickListener(this);
        mActivityEducationRequired.setOnClickListener(this);
        mActivityCompanyinfo.setOnClickListener(this);
        activity_position_name.setOnClickListener(this);
        activity_work_city.setOnClickListener(this);
        activity_work_address.setOnClickListener(this);
        activity_job_description.setOnClickListener(this);
        activity_resume_receiving_mail.setOnClickListener(this);
        activity_contact_number.setOnClickListener(this);
        salary_range_text.setOnClickListener(this);
        if ("EditPosition".equals(Operation)) {
            mDeletePosition.setOnClickListener(this);
            mSavePosition.setOnClickListener(this);
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_head_title_re1:
                postPosition();
                break;
            case R.id.include_button_button:
                postPosition();
                break;
            case R.id.activity_experience_required:
                int index = mExperienceRequiredList.indexOf(mExperienceRequiredText.getText().toString().trim());
                if ("EditPosition".equals(Operation)) {
                    showSelectOneDialog("经验要求", mExperienceRequiredList, mExperienceRequiredText, index);
                } else {
                    showSelectOneDialog("经验要求", mExperienceRequiredList, mExperienceRequiredText, index);
                }
                break;
            case R.id.activity_education_required:
                int index1 = mEducationRequiredList.indexOf(mEducationRequiredText.getText().toString().trim());
                if ("EditPosition".equals(Operation)) {
                    showSelectOneDialog("学历要求", mEducationRequiredList, mEducationRequiredText, index1);
                } else {
                    showSelectOneDialog("学历要求", mEducationRequiredList, mEducationRequiredText, index1);
                }
                break;
            case R.id.activity_company_info://公司信息
                Intent intent = new Intent(this, RecruitInfoCompanyInfoActivity.class);
                startActivity(intent);
                break;
            case R.id.activity_position_name://职位名称
                Intent intentCommon_position = new Intent(this, RecruitInfoModifyCommonActivity.class);
                if ("EditPosition".equals(Operation)) {
                    intentCommon_position.putExtra("content", mJobEntity.JobName);
                }
                intentCommon_position.putExtra("intentCommon", "position");
                startActivityForResult(intentCommon_position, 110);
                break;
            case R.id.salary_range_text://薪资范围
                Intent intentCommon_salary = new Intent(this, RecruitInfoModifySalaryActivity.class);
                intentCommon_salary.putExtra("salaryBegin", (int) SalaryRangeMin);
                intentCommon_salary.putExtra("salaryEnd", (int) SalaryRangeMax);
                startActivityForResult(intentCommon_salary, 110);
                break;
            case R.id.activity_work_city://工作城市
                Intent SelectCity = new Intent(getApplicationContext(), SelectCityActivity.class);
                startActivityForResult(SelectCity, 100);
                break;
            case R.id.activity_work_address://工作地点
                Intent intentCommon_workplace = new Intent(this, RecruitInfoModifyCommonActivity.class);
                if ("EditPosition".equals(Operation)) {
                    intentCommon_workplace.putExtra("content", mJobEntity.JobLocation);
                }
                intentCommon_workplace.putExtra("intentCommon", "workplace");
                startActivityForResult(intentCommon_workplace, 110);
                break;
            case R.id.activity_job_description://职位描述
                Intent intentCommon_job_description = new Intent(this, RecruitInfoModifyPositionDescribeActivity.class);
//                intentCommon_job_description.putExtra("intentCommon", "workplace");
                if ("EditPosition".equals(Operation)) {
                    intentCommon_job_description.putExtra("content", mJobEntity.JobDescription);
                }
                startActivityForResult(intentCommon_job_description, 110);
                break;
            case R.id.activity_resume_receiving_mail://接受简历邮箱
                Intent intentCommon_mail = new Intent(this, RecruitInfoModifyCommonActivity.class);
                if ("EditPosition".equals(Operation)) {
                    intentCommon_mail.putExtra("content", mJobEntity.ContactEmail);
                }
                intentCommon_mail.putExtra("intentCommon", "mail");
                startActivityForResult(intentCommon_mail, 110);
                break;
            case R.id.activity_contact_number://联系电话
                Intent intentCommon_phone = new Intent(this, RecruitInfoModifyCommonActivity.class);
                if ("EditPosition".equals(Operation)) {
                    intentCommon_phone.putExtra("content", mJobEntity.ContactNumber);
                }
                intentCommon_phone.putExtra("intentCommon", "phone");
                startActivityForResult(intentCommon_phone, 110);
                break;
            case R.id.save_position:
                postPosition();
                break;
            case R.id.delete_position:
                deletePosition(AppConfig.getCurrentUseCompany(), getIntent().getLongExtra("JobId", 0));
                break;
        }
    }

    public void postPosition() {
        String positionName = position_name_text.getText().toString().trim();
        String salaryRange = salary_range_text.getText().toString().trim();
//        String experienceRequired = mExperienceRequiredText.getText().toString().trim();
//        String educationRequired = mEducationRequiredText.getText().toString().trim();

        String workCity = work_city_text.getText().toString().trim();
        String workAddress = work_address_text.getText().toString().trim();
        String resume_receiving_mail = resume_receiving_mail_text.getText().toString().trim();
        String contact_number = contact_number_text.getText().toString().trim();
        if (TextUtils.isEmpty(positionName)) {
            ToastUtil.showInfo(getString(R.string.please_input_position_name));
            return;
        }
        if (TextUtils.isEmpty(salaryRange)) {
            ToastUtil.showInfo(getString(R.string.please_input_salary_range));
            return;
        }
        if (TextUtils.isEmpty(mExperienceRequiredText.getText().toString().trim())) {
            ToastUtil.showInfo(getString(R.string.please_select_experience_required));
            return;
        }
        int pos = mExperienceRequiredList.indexOf(mExperienceRequiredText.getText().toString().trim());
        String experienceRequired = mExperienceRequiredListCode.get(pos);
        if (TextUtils.isEmpty(mEducationRequiredText.getText().toString().trim())) {
            ToastUtil.showInfo(getString(R.string.please_select_education_required));
            return;
        }
        int pos1 = mEducationRequiredList.indexOf(mEducationRequiredText.getText().toString().trim());
        String educationRequired = mEducationRequiredListCode.get(pos1);

        if (TextUtils.isEmpty(workCity)) {
            ToastUtil.showInfo(getString(R.string.please_select_work_city));
            return;
        }
        if (TextUtils.isEmpty(workAddress)) {
            ToastUtil.showInfo(getString(R.string.please_select_work_address));
            return;
        }
        if (TextUtils.isEmpty(mJobDescription)) {
            ToastUtil.showInfo(getString(R.string.please_input_job_description));
            return;
        }
        if (TextUtils.isEmpty(resume_receiving_mail)) {
            ToastUtil.showInfo(getString(R.string.please_input_resume_receiving_mail));
            return;
        }
        if (TextUtils.isEmpty(contact_number)) {
            ToastUtil.showInfo(getString(R.string.please_input_contact_number));
            return;
        }
        JobEntity entity = new JobEntity();
        if ("EditPosition".equals(Operation)) {
            entity = mJobEntity;
            entity.JobCity = CityCode;
            entity.JobName = positionName;
            entity.SalaryRangeMin = SalaryRangeMin;
            entity.SalaryRangeMax = SalaryRangeMax;
            entity.ExperienceRequire = experienceRequired;
            entity.EducationRequire = educationRequired;
            entity.JobLocation = workAddress;
            entity.JobDescription = mJobDescription;
            entity.ContactEmail = resume_receiving_mail;
            entity.ContactNumber = contact_number;
            updatePosition(entity);
        } else {
            entity.CompanyId = AppConfig.getCurrentUseCompany();
            entity.JobCity = CityCode;
            entity.JobName = positionName;
            entity.SalaryRangeMin = SalaryRangeMin;
            entity.SalaryRangeMax = SalaryRangeMax;
            entity.ExperienceRequire = experienceRequired;
            entity.EducationRequire = educationRequired;
            entity.JobLocation = workAddress;
            entity.JobDescription = mJobDescription;
            entity.ContactEmail = resume_receiving_mail;
            entity.ContactNumber = contact_number;
            addPosition(entity);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 110:
                if (resultCode == 100) {
                    resultMsg = data.getStringExtra("result");
                    position_name_text.setText(resultMsg);
                } else if (resultCode == 101) {
                    resultMsg = data.getStringExtra("result");
                    work_address_text.setText(resultMsg);
                } else if (resultCode == 102) {
                    resultMsg = data.getStringExtra("result");
                    resume_receiving_mail_text.setText(resultMsg);
                } else if (resultCode == 103) {
                    resultMsg = data.getStringExtra("result");
                    contact_number_text.setText(resultMsg);
                } else if (resultCode == 104) {
                    Double numberBegin = data.getDoubleExtra("numberBegin", 0);
                    Double numberEnd = data.getDoubleExtra("numberEnd", 0);
                    SalaryRangeMin = data.getIntExtra("salaryBegin", 0);
                    SalaryRangeMax = data.getIntExtra("salaryEnd", 0);
                    salary_range_text.setText(df1.format(numberBegin) + "k-" + df1.format(numberEnd) + "k");
                } else if (resultCode == 105) {
                    mJobDescription = data.getStringExtra("haveContent");
                    if (TextUtils.isEmpty(mJobDescription)) {
                        job_description_text.setImageResource(R.drawable.weixuanzhong1);
                        checked = true;
                    } else {
                        job_description_text.setImageResource(R.drawable.xuanzhong);
                        checked = false;
                    }
                }
                break;
            case 100:
                if (resultCode == RESULT_OK) {
                    work_city_text.setText(data.getStringExtra("city"));
                    CityCode = data.getStringExtra("CityCode");
                }
        }
    }

    public void showSelectOneDialog(String title, ArrayList<String> datas, final TextView content, final int defaultSelect) {
        final Dialog dl = new Dialog(this);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(true);
        View dialog_view = View.inflate(getApplicationContext(), R.layout.advertise_one_wheelview, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        setWindowParams(dialogWindow);
        dl.show();
        final WheelView mExperienceRequired = (WheelView) dialog_view.findViewById(R.id.experience_required);
        TextView mBtnConfirm = (TextView) dialog_view.findViewById(R.id.btn_confirm);
        TextView cancel = (TextView) dialog_view.findViewById(R.id.cancel);
        TextView start_time = (TextView) dialog_view.findViewById(R.id.start_time);
        start_time.setText(title);
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
            }
        });
        mBtnConfirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                content.setText(mExperienceRequired.getSelectedText());
                dl.dismiss();
            }
        });
        mExperienceRequired.setCyclic(false);
        mExperienceRequired.setData(datas);
        if (defaultSelect==-1){
            mExperienceRequired.setDefault(2);
        }else {
            mExperienceRequired.setDefault(defaultSelect);
        }

    }

    public void addPosition(final JobEntity entity) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Long>() {
            @Override
            protected Long doInBackground(Void... params) {
                // 每次登录成功之后，保存token，并且返回登录信息
                Long jobId = JobRepository.addPosition(entity);
                Log.e("job", jobId + "");
                return jobId;
            }

            @Override
            protected void onPostExecute(Long jobId) {
                if (dialog != null)
                    dialog.dismiss();
                if (jobId > 0) {
                    ToastUtil.showInfo("发布成功");
                    finish();
                } else {
                    ToastUtil.showInfo("发布失败");
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    public void getJobDetail(final long CompanyId, final long JobId) {
        new AsyncRunnable<JobEntity>() {
            @Override
            protected JobEntity doInBackground(Void... params) {
                // 每次登录成功之后，保存token，并且返回登录信息
                JobEntity jobEntity = JobRepository.getJobDetail(CompanyId, JobId);
                return jobEntity;
            }

            @Override
            protected void onPostExecute(JobEntity jobEntity) {
                if (dialog != null)
                    dialog.dismiss();
                if (jobEntity != null) {
                    IsInitData = true;
                    mJobEntity = jobEntity;
                    mCompanyName.setText(jobEntity.Company.CompanyName);
                    position_name_text.setText(jobEntity.JobName);
                    SalaryRangeMin = jobEntity.SalaryRangeMin;
                    SalaryRangeMax = jobEntity.SalaryRangeMax;
                    salary_range_text.setText(df1.format(jobEntity.SalaryRangeMin / 1000) + "k-" + df1.format(jobEntity.SalaryRangeMax / 1000) + "k");
                    mExperienceRequiredText.setText(jobEntity.ExperienceRequireText);
                    mEducationRequiredText.setText(jobEntity.EducationRequireText);
                    work_city_text.setText(jobEntity.JobCityText);
                    CityCode = jobEntity.JobCity;
                    work_address_text.setText(jobEntity.JobLocation);
                    resume_receiving_mail_text.setText(jobEntity.ContactEmail);
                    contact_number_text.setText(jobEntity.ContactNumber);
                    job_description_text.setImageResource(R.drawable.xuanzhong);
                    mJobDescription = jobEntity.JobDescription;
                } else {
                    onRemoteError();
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }

    public void updatePosition(final JobEntity entity) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                // 每次登录成功之后，保存token，并且返回登录信息
                Boolean isSuccess = JobRepository.updatePosition(entity);
                return isSuccess;
            }

            @Override
            protected void onPostExecute(Boolean isSuccess) {
                if (dialog != null)
                    dialog.dismiss();
                if (isSuccess) {
                    ToastUtil.showInfo("编辑成功");
                    finish();
                } else {
//                    ToastUtil.showInfo("编辑失败");
                    onRemoteError();
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }

    public void deletePosition(final long CompanyId, final long JobId) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                // 每次登录成功之后，保存token，并且返回登录信息
                Boolean isSuccess = JobRepository.deleteJobTitle(CompanyId, JobId);
                return isSuccess;
            }

            @Override
            protected void onPostExecute(Boolean isSuccess) {
                if (dialog != null)
                    dialog.dismiss();
                if (isSuccess) {
                    ToastUtil.showInfo("删除成功");
                    setResult(RESULT_OK);
                    finish();
                } else {
//                    ToastUtil.showInfo("删除失败");
                    onRemoteError();
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }

    public void getTags() {
        dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<HashMap<String, List<BizDictEntity>>>() {

            @Override
            protected HashMap<String, List<BizDictEntity>> doInBackground(Void... params) {
                HashMap<String, List<BizDictEntity>> entities = DictionaryPool.loadAdvertiseDictionaries();
                return entities;
            }

            @Override
            protected void onPostExecute(HashMap<String, List<BizDictEntity>> entities) {
                if (entities != null) {
                    if (entities.size() != 0) {
                        List<BizDictEntity> bizDictEntities = entities.get(DictionaryPool.Code_Resume_WorkYear);
                        for (int i = 0; i < bizDictEntities.size(); i++) {
                            mExperienceRequiredList.add(bizDictEntities.get(i).Name);
                            mExperienceRequiredListCode.add(bizDictEntities.get(i).Code);
                        }
                        List<BizDictEntity> bizDictEntities1 = entities.get(DictionaryPool.Code_Ccademic);
                        for (int i = 0; i < bizDictEntities1.size(); i++) {
                            mEducationRequiredList.add(bizDictEntities1.get(i).Name);
                            mEducationRequiredListCode.add(bizDictEntities1.get(i).Code);
                        }
                        if ("EditPosition".equals(Operation)) {
                            getJobDetail(AppConfig.getCurrentUseCompany(), getIntent().getLongExtra("JobId", 0));
                        } else {
                            if (dialog != null)
                                dialog.dismiss();
                        }
                    } else {
                        if (dialog != null)
                            dialog.dismiss();
                    }
                } else {
                    if (dialog != null)
                        dialog.dismiss();
                }

            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }

        }.execute();
    }
}
