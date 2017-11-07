package com.juxian.bosscomments.ui;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;

import net.juxian.appgenome.widget.ToastUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Tam on 2016/12/28.
 */
public class RecruitInfoModifyPositionDescribeActivity extends BaseActivity {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_tab2)
    TextView mSure;
    @BindView(R.id.include_head_title_re1)
    RelativeLayout mSureBt;
    @BindView(R.id.include_button_button)
    Button include_button_button;
    @BindView(R.id.feedback_content)
    EditText feedback_content;

    @Override
    public int getContentViewId() {
        return R.layout.activity_recruit_position_describe;
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
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_head_title_re1:
                String content = feedback_content.getText().toString().trim();
                if (TextUtils.isEmpty(content)) {
                    ToastUtil.showInfo(getString(R.string.please_input_job_description));
                    return;
                }
                if (content.length() > 5000) {
                    ToastUtil.showInfo("最多输入5000字");
                    return;
                }
                Intent intent = getIntent();
                intent.putExtra("haveContent", content);
                setResult(105, intent);
                finish();
                break;
            case R.id.include_button_button:
                String content1 = feedback_content.getText().toString().trim();
                if (TextUtils.isEmpty(content1)) {
                    ToastUtil.showInfo(getString(R.string.please_input_job_description));
                    return;
                }
                if (content1.length() > 5000) {
                    ToastUtil.showInfo("最多输入5000字");
                    return;
                }
                Intent intent1 = getIntent();
                intent1.putExtra("haveContent", content1);
                setResult(105, intent1);
                finish();
                break;

        }
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText("职位描述");
        mSure.setText(getString(R.string.ok));
        include_button_button.setText(getString(R.string.ok));
        mSureBt.setVisibility(View.VISIBLE);
        mSure.setVisibility(View.VISIBLE);
        if (!TextUtils.isEmpty(getIntent().getStringExtra("content"))){
            feedback_content.setText(getIntent().getStringExtra("content"));
            feedback_content.setSelection(getIntent().getStringExtra("content").length());
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mSureBt.setOnClickListener(this);
        include_button_button.setOnClickListener(this);

    }
}
