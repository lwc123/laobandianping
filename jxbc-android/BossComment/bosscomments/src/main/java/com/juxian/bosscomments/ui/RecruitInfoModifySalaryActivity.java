package com.juxian.bosscomments.ui;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
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
public class RecruitInfoModifySalaryActivity extends BaseActivity {
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_tab2)
    TextView mSure;
    @BindView(R.id.activity_recruit_common_edtbegin)
    EditText activity_recruit_common_edtbegin;
    @BindView(R.id.activity_recruit_common_edtend)
    EditText activity_recruit_common_edtend;
    @BindView(R.id.include_button_button)
    Button include_button_button;
    private String numberBegin;
    private String numberEnd;

    @Override
    public int getContentViewId() {
        return R.layout.activity_recruit_info_number;
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
        title.setText("薪资范围");
        mSure.setVisibility(View.VISIBLE);
        mSure.setText("确定");
        include_button_button.setText("确定");
        if (getIntent().getIntExtra("salaryBegin",0)!=0){
            activity_recruit_common_edtbegin.setText(getIntent().getIntExtra("salaryBegin",0)+"");
            activity_recruit_common_edtbegin.setSelection((getIntent().getIntExtra("salaryBegin",0)+"").length());
        }
        if (getIntent().getIntExtra("salaryEnd",0)!=0){
            activity_recruit_common_edtend.setText(getIntent().getIntExtra("salaryEnd",0)+"");
        }
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_head_title_tab2:
                numberBegin = activity_recruit_common_edtbegin.getText().toString().trim();
                numberEnd = activity_recruit_common_edtend.getText().toString().trim();
                if (TextUtils.isEmpty(numberBegin)) {
                    ToastUtil.showInfo("请输入月薪小值");
                    return;
                }
                if (TextUtils.isEmpty(numberEnd)) {
                    ToastUtil.showInfo("请输入月薪大值");
                    return;
                }
                if (Integer.parseInt(numberBegin) >Integer.parseInt(numberEnd)) {
                    ToastUtil.showInfo("月薪大值小于月薪小值，请重新输入");
                    return;
                }
                if (Integer.parseInt(numberBegin) < 3000) {
                    ToastUtil.showInfo("月薪不能小于3000元");
                    return;
                }
                if (Integer.parseInt(numberEnd) > 1000000) {
                    ToastUtil.showInfo("月薪不能大于1000000元");
                    return;
                }
                Intent intent = getIntent();
                intent.putExtra("salaryBegin",Integer.parseInt(numberBegin));
                intent.putExtra("salaryEnd",Integer.parseInt(numberEnd));
                intent.putExtra("numberBegin", Double.parseDouble(numberBegin) / 1000);
                intent.putExtra("numberEnd", Double.parseDouble(numberEnd) / 1000);
                setResult(104, intent);
                finish();
                break;
            case R.id.include_button_button:
                numberBegin = activity_recruit_common_edtbegin.getText().toString().trim();
                numberEnd = activity_recruit_common_edtend.getText().toString().trim();
                if (TextUtils.isEmpty(numberBegin)) {
                    ToastUtil.showInfo("请输入月薪小值");
                    return;
                }
                if (TextUtils.isEmpty(numberEnd)) {
                    ToastUtil.showInfo("请输入月薪大值");
                    return;
                }
                if (Integer.parseInt(numberBegin) >Integer.parseInt(numberEnd)) {
                    ToastUtil.showInfo("月薪大值小于月薪小值，请重新输入");
                    return;
                }
                if (Integer.parseInt(numberBegin) < 3000) {
                    ToastUtil.showInfo("月薪不能小于3000元");
                    return;
                }
                if (Integer.parseInt(numberEnd) > 1000000) {
                    ToastUtil.showInfo("月薪不能大于1000000元");
                    return;
                }
                Intent intent1 = getIntent();
                intent1.putExtra("salaryBegin",Integer.parseInt(numberBegin));
                intent1.putExtra("salaryEnd",Integer.parseInt(numberEnd));
                intent1.putExtra("numberBegin", Double.parseDouble(numberBegin) / 1000);
                intent1.putExtra("numberEnd", Double.parseDouble(numberEnd) / 1000);
                setResult(104, intent1);
                finish();
                break;
        }
    }
}
