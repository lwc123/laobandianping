package com.juxian.bosscomments.ui;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.widget.TextView;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Tam on 2016/12/12.
 */
public class RolePowerExplainActivity extends BaseActivity {
    @BindView(R.id.include_head_title_back)
    ImageView mBack;
    @BindView(R.id.include_head_title_title)
    TextView mTitle;

    @Override
    public int getContentViewId() {
        return R.layout.activity_role_power_explain;
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
        mTitle.setText(R.string.add_manager);

    }

    @Override
    public void initListener() {
        super.initListener();
        mBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
    }

}
