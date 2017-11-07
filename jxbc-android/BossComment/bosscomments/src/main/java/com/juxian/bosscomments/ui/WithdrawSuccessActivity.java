package com.juxian.bosscomments.ui;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.widget.TextView;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Tam on 2016/12/16.
 * 提现成功页面
 */
public class WithdrawSuccessActivity extends BaseActivity {
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.emoji)
    ImageView emoji;
    private String withdraw_type;

    @Override
    public int getContentViewId() {
        return R.layout.activity_audit_withdraw_success;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        setSystemBarTintManager(this);
        initViewsData();
        initListener();
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText("企业提现");
        withdraw_type = getIntent().getStringExtra("withdraw_type");
        if ("personal".equals(withdraw_type)){
            title.setText(getString(R.string.personal_my_pocket));
        } else {
            title.setText("企业提现");
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        finish();
    }
}
