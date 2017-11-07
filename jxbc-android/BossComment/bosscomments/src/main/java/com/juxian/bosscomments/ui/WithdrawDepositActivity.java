package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.WithdrawAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.WalletEntity;
import com.juxian.bosscomments.repositories.PrivatenessWalletRepository;
import com.juxian.bosscomments.repositories.WalletRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.text.DecimalFormat;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/11/18.
 * 提现无银行卡页面
 *
 * @Description: 提现
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/18 14:07]
 * @Version: [v1.0]
 */
public class WithdrawDepositActivity extends BaseActivity implements View.OnClickListener {

    private InputMethodManager manager;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_button_button)
    Button Withdraws_btn;
    @BindView(R.id.company_vault_real)
    TextView company_vault;       //金库
    @BindView(R.id.can_be_withdrawal_amount_real)
    TextView can_be_withdrawal_amount;   //可提现
    @BindView(R.id.input_withdraw_amounte)
    EditText cash_count;       //要提现的金额
    //    @BindView(R.id.no_public_bank_account_info)
//    LinearLayout no_bank_account_info;
    @BindView(R.id.input_withdraw_company_name)
    EditText company_name;
    @BindView(R.id.input_withdraw_bank_name)
    EditText bank_name;
    @BindView(R.id.input_withdraw_bank_count)
    EditText bank_count;
    @BindView(R.id.bank_type)
    TextView mBankType;
    @BindView(R.id.withdraw_conmany_name)
    TextView mPersonalName;
    @BindView(R.id.company_vault)
    TextView mPersonalPocket;
    @BindView(R.id.explain_content)
    TextView mExplainContent;
    @BindView(R.id.include_head_title_re1)
    RelativeLayout mRechargeRecord;
    @BindView(R.id.include_head_title_tab2)
    TextView mRechargeRecordText;
    @BindView(R.id.withdraw_bank_name)
    TextView withdraw_bank_name;
    private DecimalFormat df1 = new DecimalFormat("0.00");

    private boolean haveNotes;
    public static final String MONEY_TAG = "withdrawal_account";
    private double can_withdrawal_amount;

    @Override
    public int getContentViewId() {
        return R.layout.activity_withdraw_deposit;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        manager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
        initViewsData();
        initListener();
        setSystemBarTintManager(this);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        // TODO Auto-generated method  stub
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
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.withdraw_deposit_title));
        Withdraws_btn.setText(getString(R.string.withdraw_deposit_title));
        if (!getIntent().getBooleanExtra("Personal", false)) {
            //新建账号跳转过来
            if (getIntent().getBooleanExtra("fromHaveBankCard", false)) {
                String money = getIntent().getStringExtra("withdraw");
                cash_count.setText(money);
                cash_count.setSelection(money.length());
            } else {
//          无卡第一次进入

            }
            GetCompanyWallet(AppConfig.getCurrentUseCompany());
        } else {
            title.setText(getString(R.string.personal_my_pocket));
            mBankType.setText(getString(R.string.personal_bank_account));
            mPersonalName.setText(getString(R.string.personal_open_account_name));
            company_name.setHint(getString(R.string.personal_please_input_open_account_name));
            mPersonalPocket.setText(getString(R.string.personal_pocket_vault));
            mExplainContent.setText(getString(R.string.personal_public_bank_account_explain));
            mRechargeRecordText.setText(getString(R.string.personal_recharge_record));
            bank_name.setHint(getString(R.string.personal_bank_name));
            withdraw_bank_name.setText(getString(R.string.personal_open_account_bank));
            if (getIntent().getBooleanExtra("fromHaveBankCard", false)) {
                cash_count.setText(getIntent().getStringExtra("withdraw"));
                cash_count.setSelection(getIntent().getStringExtra("withdraw").length());
            }
            mRechargeRecord.setVisibility(View.VISIBLE);
            mRechargeRecordText.setVisibility(View.VISIBLE);
            mRechargeRecord.setOnClickListener(this);
            GetPersonalWallet();
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        Withdraws_btn.setOnClickListener(this);
        cash_count.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                if (charSequence.toString().contains(".")) {
                    if (charSequence.length() - 1 - charSequence.toString().indexOf(".") > 2) {
                        charSequence = charSequence.toString().subSequence(0,
                                charSequence.toString().indexOf(".") + 3);
                        cash_count.setText(charSequence);
                        cash_count.setSelection(charSequence.length());
                    }
                }
                if (charSequence.toString().trim().substring(0).equals(".")) {
                    charSequence = "0" + charSequence;
                    cash_count.setText(charSequence);
                    cash_count.setSelection(2);
                }

                if (charSequence.toString().startsWith("0")
                        && charSequence.toString().trim().length() > 1) {
                    if (!charSequence.toString().substring(1, 2).equals(".")) {
                        cash_count.setText(charSequence.subSequence(0, 1));
                        cash_count.setSelection(1);
                        return;
                    }
                }
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                InputMethodManager imm = (InputMethodManager) getApplicationContext().getSystemService(Context.INPUT_METHOD_SERVICE);
                imm.hideSoftInputFromWindow(cash_count.getWindowToken(), 0); //强制隐藏键盘
                finish();
                break;

            case R.id.include_button_button:
                String conpanyName = company_name.getText().toString().trim();
                String bankName = bank_name.getText().toString().trim();
                String bankCount = bank_count.getText().toString().trim();
                String cash = null;
                if (TextUtils.isEmpty(cash_count.getText().toString().trim())) {
                    ToastUtil.showInfo("请输入提现金额");
                    return;
                }
                cash = cash_count.getText().toString().trim(); //要提现的金额
                String vault = company_vault.getText().toString().trim(); //金库的金额

                if (Double.parseDouble(cash) <= 0) {
                    ToastUtil.showInfo("输入提现金额错误");
                    return;
                }
                if (Double.parseDouble(cash) > Double.parseDouble(vault)) {
                    if (getIntent().getBooleanExtra("Personal", false)) {
                        ToastUtil.showInfo("提现金额不能大于口袋金额");
                    } else {
                        ToastUtil.showInfo("提现金额不能大于公司金库金额");
                    }
                    return;
                }
                if (Double.parseDouble(cash) > can_withdrawal_amount) {
                    ToastUtil.showInfo("提现金额不能大于可提现金额");
                    return;
                }
                if (TextUtils.isEmpty(conpanyName)) {
                    if (!getIntent().getBooleanExtra("Personal", false)) {
                        ToastUtil.showInfo("请输入公司名称");
                    } else {
                        ToastUtil.showInfo(getString(R.string.please_input_name));
                    }
                    return;
                }
                if (!getIntent().getBooleanExtra("Personal", false)) {
                    if (conpanyName.length() > 30) {
                        ToastUtil.showInfo("公司名称超出了30个字");
                        return;
                    }
                } else {
                    if (conpanyName.length() > 5) {
                        ToastUtil.showInfo("开户名超出了5个字");
                        return;
                    }
                }
                if (TextUtils.isEmpty(bankName)) {
                    if (!getIntent().getBooleanExtra("Personal", false)) {
                        ToastUtil.showInfo("请输入开户银行");
                    } else {
                        ToastUtil.showInfo(getString(R.string.personal_bank_name));
                    }
                    return;
                }
                if (bankName.length() > 30) {
                    ToastUtil.showInfo("开户银行超出了30个字");
                    return;
                }
                if (TextUtils.isEmpty(bankCount)) {
                    ToastUtil.showInfo("请输入银行账号");
                    return;
                }
                if (bankCount.length() > 30) {
                    ToastUtil.showInfo("银行账号格式错误");
                    return;
                }
                Intent intent = new Intent(this, WithdrawCashActivity.class);
                if (!getIntent().getBooleanExtra("Personal", false)) {
                    intent.putExtra("withdraw_type", "company");
                } else {
                    intent.putExtra("withdraw_type", "personal");
                }
                intent.putExtra("company_vault", vault);
                intent.putExtra("can_withdrawal_amount", df1.format(can_withdrawal_amount) + "元");
                intent.putExtra("cash", cash);
                intent.putExtra("company_name", conpanyName);
                intent.putExtra("bankName", bankName);
                intent.putExtra("bankCount", bankCount);
                startActivityForResult(intent, 100);

                break;
            case R.id.include_head_title_re1:
                Intent intent2 = new Intent(getApplicationContext(), PersonalRechargeRecordActivity.class);
                startActivity(intent2);
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 100:
                if (resultCode == RESULT_OK) {
                    setResult(RESULT_OK);
                    finish();
                }
                break;
        }
    }

    private void GetCompanyWallet(final long CompanyId) {
        // 获取企业信息，根据之前保存的企业id查询
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<WalletEntity>() {
            @Override
            protected WalletEntity doInBackground(Void... params) {
                WalletEntity entity = WalletRepository.getCompanyWallet(CompanyId);
                return entity;
            }

            @Override
            protected void onPostExecute(WalletEntity entity) {
                if (dialog != null)
                    dialog.dismiss();
                if (entity != null){
                    can_be_withdrawal_amount.setText(df1.format((entity.CanWithdrawBalance)) + "元");
                    company_vault.setText(df1.format(entity.AvailableBalance));
                    can_withdrawal_amount = entity.CanWithdrawBalance;
                } else {
                    can_be_withdrawal_amount.setText(0 + "");
                    company_vault.setText(0 + "");
                    can_withdrawal_amount = 0;
                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                company_vault.setText("0.00");
                can_be_withdrawal_amount.setText("0元");
                Log.e(Global.LOG_TAG, "net abnormal!");
            }
        }.execute();
    }

    private void GetPersonalWallet() {
        // 获取企业信息，根据之前保存的企业id查询
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<WalletEntity>() {
            @Override
            protected WalletEntity doInBackground(Void... params) {
                WalletEntity entity = PrivatenessWalletRepository.getCompanyWallet();
                return entity;
            }

            @Override
            protected void onPostExecute(WalletEntity entity) {
                if (dialog != null)
                    dialog.dismiss();
                if (entity != null) {
                    company_vault.setText(df1.format(entity.AvailableBalance));
                    can_withdrawal_amount = entity.CanWithdrawBalance;
                    can_be_withdrawal_amount.setText(df1.format(entity.CanWithdrawBalance) + "元");
                } else {
                    company_vault.setText("0.00");
                    can_be_withdrawal_amount.setText("0元");
                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                company_vault.setText("0.00");
                can_be_withdrawal_amount.setText("0元");
            }
        }.execute();
    }
}
