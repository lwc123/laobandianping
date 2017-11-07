package com.juxian.bosscomments.ui;

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputType;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;

import java.text.DecimalFormat;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/11/18.
 *
 * @Description: 充值，填写金额界面
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/18 10:45]
 * @Version: [v1.0]
 */
public class InputMoneyActivity extends BaseActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.service_type)
    TextView service_type;
    @BindView(R.id.sure_company_name)
    EditText sure_company_name;
    @BindView(R.id.should_pay)
    TextView should_pay;
    @BindView(R.id.setting_password_submit)
    Button mGoPay;
    private String TotalMoney;

    @Override
    public int getContentViewId() {
        return R.layout.activity_input_money;
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
        title.setText(getString(R.string.recharge));
        service_type.setText(getString(R.string.input_recharge_money));
        sure_company_name.setHint(getString(R.string.please_recharge_money));
        sure_company_name.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mGoPay.setOnClickListener(this);
        sure_company_name.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                if (charSequence.toString().contains(".")) {
                    if (charSequence.length() - 1 - charSequence.toString().indexOf(".") > 2) {
                        charSequence = charSequence.toString().subSequence(0,
                                charSequence.toString().indexOf(".") + 3);
                        sure_company_name.setText(charSequence);
                        sure_company_name.setSelection(charSequence.length());
                    }
                }
                if (charSequence.toString().trim().substring(0).equals(".")) {
                    charSequence = "0" + charSequence;
                    sure_company_name.setText(charSequence);
                    sure_company_name.setSelection(2);
                }

                if (charSequence.toString().startsWith("0")
                        && charSequence.toString().trim().length() > 1) {
                    if (!charSequence.toString().substring(1, 2).equals(".")) {
                        sure_company_name.setText(charSequence.subSequence(0, 1));
                        sure_company_name.setSelection(1);
                        return;
                    }
                }

            }

            @Override
            public void afterTextChanged(Editable editable) {
//                if (SelectRechargeMethodActivity.RECHARGE_NUMBER.equals(tag)) {
//                    DecimalFormat df1 = new DecimalFormat("0.00");
//                    if (!TextUtils.isEmpty(sure_company_name.getText().toString().trim())) {
//                        TotalMoney = df1.format(20 * Double.parseDouble(sure_company_name.getText().toString().trim()));
//                        should_pay.setText(TotalMoney + "元");
//                    } else {
//                        should_pay.setText("0元");
//                    }
//                } else {
                should_pay.setText(sure_company_name.getText().toString().trim() + "元");
//                }
            }
        });
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.setting_password_submit:
                Intent mIntentPay = new Intent(getApplicationContext(), PayActivity.class);
                startActivity(mIntentPay);
                break;

        }
    }
}
