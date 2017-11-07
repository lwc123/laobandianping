package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.DrawMoneyRequestEntity;
import com.juxian.bosscomments.models.ResultEntity;
import com.juxian.bosscomments.repositories.PrivatenessWalletRepository;
import com.juxian.bosscomments.repositories.WithdrawRepository;
import com.juxian.bosscomments.widget.Button;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Tam on 2016/12/16.
 * 提现审核页面
 */
public class WithdrawCashActivity extends BaseActivity {
    @BindView(R.id.include_button_button)
    Button submit;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.company_vault_real)
    TextView company_vault_real; //金库
    @BindView(R.id.input_withdraw_amounte)
    TextView input_withdraw_amounte;//提现金额
    @BindView(R.id.can_be_withdrawal_amount_real)
    TextView can_be_withdrawal_amount_real;
    @BindView(R.id.input_withdraw_company_name)
    TextView input_withdraw_company_name;
    @BindView(R.id.input_withdraw_bank_name)
    TextView input_withdraw_bank_name;
    @BindView(R.id.input_withdraw_bank_count)
    TextView input_withdraw_bank_count;
    @BindView(R.id.company_vault)
    TextView mCompanyVault;
    @BindView(R.id.bank_type)
    TextView mBankType;
    @BindView(R.id.withdraw_conmany_name)
    TextView withdraw_conmany_name;
    @BindView(R.id.withdraw_bank_name)
    TextView withdraw_bank_name;
    private String cash;
    private String company_name;
    private String bankName;
    private String bankCount;
    private CompanyEntity mCompanyEntity;
    private String withdraw_type;

    @Override
    public int getContentViewId() {
        return R.layout.activity_audit_withdrawcash;
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
        submit.setText("提交申请");
        title.setText("提现");

        withdraw_type = getIntent().getStringExtra("withdraw_type");
        if ("personal".equals(withdraw_type)) {
            mCompanyVault.setText(getString(R.string.personal_pocket_vault));
            mBankType.setText(getString(R.string.personal_bank_account));
            title.setText(getString(R.string.personal_my_pocket));
            withdraw_conmany_name.setText(getString(R.string.personal_open_account_name_audit));
            withdraw_bank_name.setText(getString(R.string.personal_open_account_bank_audit));
        }
        String company_vault = getIntent().getStringExtra("company_vault");
//        String can_withdrawal_amount = getIntent().getStringExtra("can_withdrawal_amount");
        cash = getIntent().getStringExtra("cash");
        company_name = getIntent().getStringExtra("company_name");
        bankName = getIntent().getStringExtra("bankName");
        bankCount = getIntent().getStringExtra("bankCount");
        company_vault_real.setText(company_vault);
        input_withdraw_amounte.setText(cash);
        input_withdraw_company_name.setText(company_name);
        input_withdraw_bank_name.setText(bankName);
        input_withdraw_bank_count.setText(bankCount);
        can_be_withdrawal_amount_real.setText(getIntent().getStringExtra("can_withdrawal_amount"));
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        submit.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_button_button://提交
                DrawMoneyRequestEntity withdrawEntity = new DrawMoneyRequestEntity();
                if ("personal".equals(withdraw_type)) {
                    withdrawEntity.BankName = bankName;
                    withdrawEntity.BankCard = bankCount;
                    withdrawEntity.MoneyNumber = Double.parseDouble(cash);
                    withdrawEntity.CompanyName = company_name;
                } else {

                    withdrawEntity.BankName = bankName;
                    withdrawEntity.BankCard = bankCount;
                    withdrawEntity.MoneyNumber = Double.parseDouble(cash);
                    withdrawEntity.CompanyId = AppConfig.getCurrentUseCompany();
                    withdrawEntity.CompanyName = company_name;
                    Log.e(Global.LOG_TAG, withdrawEntity.MoneyNumber + "");

                }
                PostAddMoneyWithdrw(withdrawEntity);
                break;
        }
    }

    private void PostAddMoneyWithdrw(final DrawMoneyRequestEntity entity) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<ResultEntity>() {
            @Override
            protected ResultEntity doInBackground(Void... params) {
                ResultEntity entity1 = null;
                if ("personal".equals(withdraw_type)) {
                    entity1 = PrivatenessWalletRepository.DrawMoneyRequestAdd(entity);
                } else {
                    entity1 = WithdrawRepository.DrawMoneyRequestAdd(entity);
                }
                return entity1;
            }

            @Override
            protected void onPostExecute(ResultEntity entity1) {
                if (dialog != null)
                    dialog.dismiss();
                if (entity1 == null) {
                    ToastUtil.showInfo("网络错误");
                } else {
                    if (entity1.Success) {
                        ToastUtil.showInfo("提交成功");
                        Intent intent = new Intent(getApplicationContext(), WithdrawSuccessActivity.class);
                        if ("personal".equals(withdraw_type)) {
                            intent.putExtra("withdraw_type", "personal");
                        } else {
                            intent.putExtra("withdraw_type", "company");
                        }
                        setResult(RESULT_OK);
                        startActivity(intent);
                        finish();
                    } else {
                        ToastUtil.showInfo(entity1.ErrorMessage);
                    }
                }

            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                ToastUtil.showError(getString(R.string.net_false_hint));
            }
        }.execute();
    }
}
