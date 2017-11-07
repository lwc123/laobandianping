package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.models.ResultEntity;
import com.juxian.bosscomments.repositories.CompanyMemberRepository;
import com.juxian.bosscomments.utils.DialogUtils;
import com.juxian.bosscomments.utils.MobileUtils;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/10/25.
 * 添加授权人
 *
 * @ProjectName: [LaoBanDianPing]
 * @Package: [com.juxian.bosscomments.ui]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/25 13:08]
 * @Version: [v1.0]
 */
public class AddAccreditPersonActivity extends RemoteDataActivity implements View.OnClickListener, DialogUtils.DialogListener {

    private InputMethodManager manager;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.edit_one_content)
    EditText edit_phone;
    @BindView(R.id.edit_two_content)
    EditText edit_name;
    @BindView(R.id.edit_three_content)
    EditText edit_position;
    @BindView(R.id.input_one_text)
    TextView input_one_text;
    @BindView(R.id.input_two_text)
    TextView input_two_text;
    @BindView(R.id.input_three_text)
    TextView input_three_text;
    @BindView(R.id.include_button_button)
    Button sure_accredit;
    @BindView(R.id.add_accredit_person_rg)
    RadioGroup mAddAccreditRg;
    @BindView(R.id.add_accredit_person_rb1)
    RadioButton add_accredit_person_rb1;
    @BindView(R.id.add_accredit_person_rb2)
    RadioButton add_accredit_person_rb2;
    @BindView(R.id.add_accredit_person_rb3)
    RadioButton add_accredit_person_rb3;
    @BindView(R.id.role_power_explain)
    TextView roleExplain;
    @BindView(R.id.activity_change_accredit_role)
    View mViewRole;
    private int mCurrentSeleteRole;
    private int mCurrentRole;
    private long mCurrentMemberId;
    private String mTag;
    private MemberEntity mMemberEntity;// 获取修改的角色信息
    private MemberEntity currentMember;

    @Override
    public int getContentViewId() {
        return R.layout.activity_add_accredit_person;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.add_new_accredit_person));
        sure_accredit.setText(getString(R.string.save));

        input_one_text.setText("姓名");
        input_two_text.setText("手机");
        input_three_text.setText("职位");
        edit_name.setHint(getString(R.string.please_input_accredit_person_phone));
        edit_phone.setHint(getString(R.string.please_input_accredit_person_name));
        edit_position.setHint(getString(R.string.please_input_accredit_person_position));
        currentMember = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);//自己的信息
        mCurrentRole = currentMember.Role;
        if (currentMember.Role == MemberEntity.CompanyMember_Role_Boss) {//老板
            add_accredit_person_rb1.setVisibility(View.VISIBLE);
        } else {
            add_accredit_person_rb1.setVisibility(View.GONE);
        }
        if ("FromSelectAuditor".equals(getIntent().getStringExtra("FromSelectAuditor"))) {
            add_accredit_person_rb1.setVisibility(View.GONE);
            add_accredit_person_rb3.setVisibility(View.GONE);
            add_accredit_person_rb2.setChecked(true);
            mCurrentSeleteRole = MemberEntity.CompanyMember_Role_Senior;
            add_accredit_person_rb2.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
//                    add_accredit_person_rb2.setChecked(true);
                    ToastUtil.showInfo("只有高管才可以审核离任报告，其它角色都不可以哦~");
                }
            });
        }
        changeAccreditPerson();

    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);
        manager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
        initViewsData();
        initListener();
        setSystemBarTintManager(this);
    }

    @Override
    public void loadPageData() {
        IsInitData = true;
    }

    private void changeAccreditPerson() {
        mTag = getIntent().getStringExtra(Global.LISTVIEW_ITEM_TAG);
        if ("change".equals(mTag)) {
            title.setText(getString(R.string.please_change_role));

            mMemberEntity = JsonUtil.ToEntity(getIntent().getStringExtra("MemberEntity"), MemberEntity.class);  //传过来的成员信息

            edit_name.setText(mMemberEntity.MobilePhone);
            edit_phone.setText(mMemberEntity.RealName);
            edit_position.setText(mMemberEntity.JobTitle);
            edit_name.setEnabled(false);
            mCurrentMemberId = currentMember.MemberId;
            //当前是管理员
            if (currentMember.Role == MemberEntity.CompanyMember_Role_Admin) {
                //修改自己
                if (mCurrentMemberId == mMemberEntity.MemberId) {
                    mViewRole.setVisibility(View.GONE);
                } else {
                    //修改高管或者建立档员
                    if (mMemberEntity.Role == MemberEntity.CompanyMember_Role_Senior || mMemberEntity.Role == MemberEntity.CompanyMember_Role_XiaoMi) {
                        add_accredit_person_rb1.setVisibility(View.GONE);

                        if (mMemberEntity.Role == MemberEntity.CompanyMember_Role_Senior) {
                            add_accredit_person_rb2.setChecked(true);
                        } else if (mMemberEntity.Role == MemberEntity.CompanyMember_Role_XiaoMi) {
                            add_accredit_person_rb3.setChecked(true);
                        }
                    }
                }
            } else if (currentMember.Role == MemberEntity.CompanyMember_Role_Boss) {//老板
                add_accredit_person_rb1.setVisibility(View.VISIBLE);
                if (mMemberEntity.Role == MemberEntity.CompanyMember_Role_Senior) {
                    add_accredit_person_rb2.setChecked(true);
                } else if (mMemberEntity.Role == MemberEntity.CompanyMember_Role_XiaoMi) {
                    add_accredit_person_rb3.setChecked(true);
                } else {
                    add_accredit_person_rb1.setChecked(true);
                }
            }
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        roleExplain.setOnClickListener(this);
        sure_accredit.setOnClickListener(this);

        mAddAccreditRg.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup radioGroup, int i) {
                RadioButton radioButton = (RadioButton) AddAccreditPersonActivity.this.findViewById(radioGroup.getCheckedRadioButtonId());
                switch (radioGroup.getCheckedRadioButtonId()) {
                    case R.id.add_accredit_person_rb1:
                        mCurrentSeleteRole = MemberEntity.CompanyMember_Role_Admin;
                        break;
                    case R.id.add_accredit_person_rb2:
                        mCurrentSeleteRole = MemberEntity.CompanyMember_Role_Senior;
                        break;
                    case R.id.add_accredit_person_rb3:
                        mCurrentSeleteRole = MemberEntity.CompanyMember_Role_XiaoMi;
                        break;
                }
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
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_button_button:
                //点击保存按钮
                if (TextUtils.isEmpty(edit_name.getText().toString().trim())) {
                    ToastUtil.showInfo(getString(R.string.mobile_phone_is_empty));
                    return;
                }
                if (!MobileUtils.checkPhoneNum(edit_name.getText().toString().trim())) {
                    ToastUtil.showInfo(getString(R.string.phone_pattern_false));
                    return;
                }
                if (TextUtils.isEmpty(edit_phone.getText().toString().trim())) {
                    ToastUtil.showInfo("请输入姓名");
                    return;
                }
                if (edit_phone.getText().toString().trim().length() > 5) {
                    ToastUtil.showInfo(getString(R.string.employee_record_name_limit));
                    return;
                }
                if (TextUtils.isEmpty(edit_position.getText().toString().trim())) {
                    ToastUtil.showInfo(getString(R.string.please_input_work));
                    return;
                }
                if (edit_position.getText().toString().trim().length() > 30) {
                    ToastUtil.showInfo(getString(R.string.please_input_work_max_length));
                    return;
                }
                if ("change".equals(mTag)) {
                    //管理员修改自己
                    if (mCurrentRole == MemberEntity.CompanyMember_Role_Admin && mCurrentMemberId != mMemberEntity.MemberId) {
                        if (!add_accredit_person_rb2.isChecked() && !add_accredit_person_rb3.isChecked()) {
                            ToastUtil.showInfo(getString(R.string.please_select_role));
                            return;
                        }
                    }
                } else {
                    //添加管理员
                    if (mCurrentRole == MemberEntity.CompanyMember_Role_Admin) {
                        if (!add_accredit_person_rb2.isChecked() && !add_accredit_person_rb3.isChecked()) {
                            ToastUtil.showInfo(getString(R.string.please_select_role));
                            return;
                        }
                    }
                }
                if (mCurrentRole == MemberEntity.CompanyMember_Role_Boss) {
                    if (!add_accredit_person_rb2.isChecked() && !add_accredit_person_rb3.isChecked() && !add_accredit_person_rb1.isChecked()) {
                        ToastUtil.showInfo(getString(R.string.please_select_role));
                        return;
                    }
                }
                String phone = edit_name.getText().toString().trim();
                String name = edit_phone.getText().toString().trim();
                String position = edit_position.getText().toString().trim();

                if ("change".equals(mTag)) {
                    //修改的条目是管理员
                    if (mMemberEntity.Role == MemberEntity.CompanyMember_Role_Admin) {
                        mMemberEntity.RealName = name;
                        mMemberEntity.JobTitle = position;
                        if (mCurrentSeleteRole > 0) {
                            mMemberEntity.Role = mCurrentSeleteRole;
                        }
                    } else if (mMemberEntity.Role == MemberEntity.CompanyMember_Role_Senior || mMemberEntity.Role == MemberEntity.CompanyMember_Role_XiaoMi) {//修改的是高管和建档员
                        mMemberEntity.RealName = name;
                        mMemberEntity.JobTitle = position;
                        if (mCurrentSeleteRole > 0) {
                            mMemberEntity.Role = mCurrentSeleteRole;
                        }
                    }
                    PostUpdateCompanyMember(mMemberEntity);

                } else {
                    //添加授权人
                    MemberEntity entity = new MemberEntity();
                    entity.CompanyId = AppConfig.getCurrentUseCompany();
                    entity.MobilePhone = phone;
                    entity.RealName = name;
                    entity.JobTitle = position;
                    entity.Role = mCurrentSeleteRole;
                    PostAddCompanyMember(entity);
                }
                break;
            case R.id.role_power_explain:
//                Intent RolePowerExplain = new Intent(getApplicationContext(), RolePowerExplainActivity.class);
//                startActivity(RolePowerExplain);
                Intent RolePowerExplain = new Intent(getApplicationContext(), AboutUsActivity.class);
                RolePowerExplain.putExtra("ShowType", "RolePowerExplain");
                startActivity(RolePowerExplain);
                break;
            default:
        }
    }

    /**
     * 添加授权人
     * @param entity
     */
    private void PostAddCompanyMember(final MemberEntity entity) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<ResultEntity>() {
            @Override
            protected ResultEntity doInBackground(Void... params) {
                ResultEntity resultEntity = CompanyMemberRepository.addCompanyMember(entity);
                return resultEntity;
            }

            @Override
            protected void onPostExecute(ResultEntity resultEntity) {
                if (dialog != null)
                    dialog.dismiss();
                if (resultEntity != null) {
                    if (resultEntity.Success) {
                        DialogUtils.showStandardDialog(AddAccreditPersonActivity.this, "关闭", "继续添加", "已发短信告知账号及密码", AddAccreditPersonActivity.this);
                    } else {
                        ToastUtil.showInfo(resultEntity.ErrorMessage);
                    }
//                    ToastUtil.showInfo("添加成功");
//                    finish();
                } else {
                    onRemoteError();
                }
            }

            protected void onPostError(Exception ex) {
//                ToastUtil.showError(getString(R.string.net_false_hint));
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }

    /**
     * 修改授权人
     * @param entity
     */
    private void PostUpdateCompanyMember(final MemberEntity entity) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean success = CompanyMemberRepository.updateCompanyMember(entity);
                return success;
            }

            @Override
            protected void onPostExecute(Boolean model) {
                if (dialog != null)
                    dialog.dismiss();
//                onRemoteError();
                if (model == true) {
                    ToastUtil.showInfo("修改成功");
                    finish();
                } else {
                    onRemoteError();
                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }

    @Override
    public void LeftBtMethod() {
        setResult(RESULT_OK);
        finish();
    }

    @Override
    public void RightBtMethod() {
        mAddAccreditRg.clearCheck();
        add_accredit_person_rb1.setChecked(false);
        add_accredit_person_rb2.setChecked(false);
        add_accredit_person_rb3.setChecked(false);
        edit_phone.setText("");
        edit_name.setText("");
        edit_position.setText("");
        edit_phone.requestFocus();
        edit_phone.setFocusable(true);
        edit_phone.setFocusableInTouchMode(true);
    }
}
