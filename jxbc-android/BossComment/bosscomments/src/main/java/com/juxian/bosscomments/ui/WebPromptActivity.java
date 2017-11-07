package com.juxian.bosscomments.ui;

import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/12/9.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/9 15:21]
 * @Version: [v1.0]
 */
public class WebPromptActivity extends BaseActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;

    @Override
    public int getContentViewId() {
        return R.layout.activity_web_prompt;
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
        title.setText(getString(R.string.bosscomments_web));
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
        }
    }
}
