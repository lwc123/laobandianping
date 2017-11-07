package com.juxian.bosscomments.ui;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;

import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.ToastUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/12/21.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/21 19:47]
 * @Version: [v1.0]
 */
public class PersonalOpenServiceActivity extends BaseActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.personal_identity_number)
    TextView personal_identity_number;
    @BindView(R.id.include_button_button)
    Button mGoPay;
    private String IDCard;

    @Override
    public int getContentViewId() {
        return R.layout.activity_personal_open_service;
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
        title.setText(getString(R.string.personal_my_archive));
        mGoPay.setText(getString(R.string.go_pay));
        IDCard = getIntent().getStringExtra("IDCard");
        personal_identity_number.setText(IDCard);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mGoPay.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_button_button:
                Intent mIntentPay = new Intent(getApplicationContext(), PayActivity.class);
                mIntentPay.putExtra(Global.LISTVIEW_ITEM_TAG,PayActivity.OPEN_PERSONAL_SERVICE);
                mIntentPay.putExtra("ArchiveId",getIntent().getLongExtra("ArchiveId",0));
                startActivityForResult(mIntentPay,100);
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode){
            case 100:
                if (resultCode == RESULT_OK){
                    finish();
                }
                break;
        }
    }
}
