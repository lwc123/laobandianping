package com.juxian.bosscomments.ui;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;

import net.juxian.appgenome.widget.ToastUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Tam on 2016/12/28.
 */
public class RecruitInfoModifyCommonActivity extends BaseActivity {
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_tab2)
    TextView mSure;
    @BindView(R.id.activity_recruit_common_edt)
    EditText activity_recruit_common_edt;
    @BindView(R.id.activity_recruit_common_tip)
    TextView activity_recruit_common_tip;
    @BindView(R.id.include_button_button)
    TextView include_button_button;
    private String type;

    @Override
    public int getContentViewId() {
        return R.layout.activity_recruit_common;
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
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mSure.setOnClickListener(this);
        include_button_button.setOnClickListener(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        mSure.setText("确定");
        mSure.setVisibility(View.VISIBLE);
        include_button_button.setText("确定");
        type = getIntent().getStringExtra("intentCommon");
        if ("position".equals(type)) {
            title.setText("职位名称");
            mSure.setVisibility(View.GONE);
        } else if ("workplace".equals(type)) {
            title.setText("工作地点");
            activity_recruit_common_edt.setHint("请填写工作地点");
            activity_recruit_common_tip.setVisibility(View.GONE);
        } else if ("mail".equals(type)) {
            title.setText("接受简历邮箱");
            activity_recruit_common_edt.setHint("请填写接收邮箱");
            activity_recruit_common_tip.setText("此项必填，填写后将在人才端公开");
        } else if ("phone".equals(type)) {
            activity_recruit_common_edt.setHint("请填写联系方式");
            activity_recruit_common_tip.setText("此项必填，填写后将在人才端公开");
            title.setText("联系方式");
        }
        if (!TextUtils.isEmpty(getIntent().getStringExtra("content"))){
            activity_recruit_common_edt.setText(getIntent().getStringExtra("content"));
            activity_recruit_common_edt.setSelection(getIntent().getStringExtra("content").length());
        }
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        String msg = activity_recruit_common_edt.getText().toString().trim();
        Intent intent = getIntent();
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_head_title_tab2:
                if ("position".equals(type)) {
                    if (TextUtils.isEmpty(msg)) {
                        ToastUtil.showInfo(getString(R.string.please_input_position_name));
                        return;
                    }
                    if (msg.length()>20){
                        ToastUtil.showInfo(getString(R.string.position_name_length_limit));
                        return;
                    }
                    intent.putExtra("result", msg);
                    setResult(100, intent);
                    finish();
                } else if ("workplace".equals(type)) {
                    if (TextUtils.isEmpty(msg)) {
                        ToastUtil.showInfo(getString(R.string.please_select_work_address));
                        return;
                    }
                    if (msg.length()>100){
                        ToastUtil.showInfo(getString(R.string.work_address_length_limit));
                        return;
                    }
                    intent.putExtra("result", msg);
                    setResult(101, intent);
                    finish();


                } else if ("mail".equals(type)) {
                    if (TextUtils.isEmpty(msg)) {
                        ToastUtil.showInfo(getString(R.string.please_input_resume_receiving_mail));
                        return;
                    }
                    if (msg.length()>200){
                        ToastUtil.showInfo(getString(R.string.resume_receiving_mail_length_limit));
                        return;
                    }
                    intent.putExtra("result", msg);
                    setResult(102, intent);
                    finish();


                } else if ("phone".equals(type)) {
                    if (TextUtils.isEmpty(msg)) {
                        ToastUtil.showInfo(getString(R.string.please_input_contact_number));
                        return;
                    }
                    if (msg.length()>30){
                        ToastUtil.showInfo(getString(R.string.contact_number_length_limit));
                        return;
                    }
                    intent.putExtra("result", msg);
                    setResult(103, intent);
                    finish();

                }
                break;
            case R.id.include_button_button:
                if ("position".equals(type)) {
                    if (TextUtils.isEmpty(msg)) {
                        ToastUtil.showInfo(getString(R.string.please_input_position_name));
                        return;
                    }
                    if (msg.length()>20){
                        ToastUtil.showInfo(getString(R.string.position_name_length_limit));
                        return;
                    }
                    intent.putExtra("result", msg);
                    setResult(100, intent);
                    finish();
                } else if ("workplace".equals(type)) {
                    if (TextUtils.isEmpty(msg)) {
                        ToastUtil.showInfo(getString(R.string.please_select_work_address));
                        return;
                    }
                    if (msg.length()>100){
                        ToastUtil.showInfo(getString(R.string.work_address_length_limit));
                        return;
                    }
                    intent.putExtra("result", msg);
                    setResult(101, intent);
                    finish();


                } else if ("mail".equals(type)) {
                    if (TextUtils.isEmpty(msg)) {
                        ToastUtil.showInfo(getString(R.string.please_input_resume_receiving_mail));
                        return;
                    }
                    if (msg.length()>200){
                        ToastUtil.showInfo(getString(R.string.resume_receiving_mail_length_limit));
                        return;
                    }
                    intent.putExtra("result", msg);
                    setResult(102, intent);
                    finish();


                } else if ("phone".equals(type)) {
                    if (TextUtils.isEmpty(msg)) {
                        ToastUtil.showInfo(getString(R.string.please_input_contact_number));
                        return;
                    }
                    if (msg.length()>30){
                        ToastUtil.showInfo(getString(R.string.contact_number_length_limit));
                        return;
                    }
                    intent.putExtra("result", msg);
                    setResult(103, intent);
                    finish();

                }
                break;
        }
    }
}
