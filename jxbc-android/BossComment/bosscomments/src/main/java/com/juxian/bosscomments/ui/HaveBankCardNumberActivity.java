package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
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
import com.juxian.bosscomments.models.CompanyBankCardEntity;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.WalletEntity;
import com.juxian.bosscomments.repositories.PrivatenessWalletRepository;
import com.juxian.bosscomments.repositories.WalletRepository;
import com.juxian.bosscomments.repositories.WithdrawRepository;
import com.juxian.bosscomments.widget.ResultListView;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/11/18.
 *
 * @Description: 提现（已有银行卡账号信息）
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/18 14:07]
 * @Version: [v1.0]
 */
public class HaveBankCardNumberActivity extends BaseActivity implements View.OnClickListener {

    private InputMethodManager manager;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_button_button)
    Button submit_btn;
    @BindView(R.id.company_vault_real)
    TextView company_vault;
    @BindView(R.id.can_be_withdrawal_amount_real)
    TextView can_be_withdrawal_amount;
    @BindView(R.id.input_withdraw_amounte)
    EditText input_money;
    @BindView(R.id.create_public_bank_count)
    TextView create_public_bank_count;
    @BindView(R.id.let_public_bank_account_info)
    ResultListView mResultListView;
    @BindView(R.id.bank_type)
    TextView mBankType;
    @BindView(R.id.company_vault)
    TextView mPersonalPocket;
    @BindView(R.id.include_head_title_re1)
    RelativeLayout mRechargeRecord;
    @BindView(R.id.include_head_title_tab2)
    TextView mRechargeRecordText;
    private List<CompanyBankCardEntity> CompanyBankCardEntityList;
    //    private List CompanyBankCardEntityList;
    public static final String MONEY_TAG = "withdrawal_account";
    private DecimalFormat df1 = new DecimalFormat("0.00");
    private WithdrawAdapter withdrawAdapter;
    private double can_withdrawal_amount;

    @Override
    public int getContentViewId() {
        return R.layout.activity_have_bank_card_number;
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
        // TODO Auto-generated method stub
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
        submit_btn.setText(getString(R.string.withdraw_deposit_title));
        if (!getIntent().getBooleanExtra("Personal", false)) {
            GetCompanyWallet(AppConfig.getCurrentUseCompany());
        } else {
            title.setText(getString(R.string.personal_my_pocket));
            mBankType.setText(getString(R.string.personal_bank_account));
            mPersonalPocket.setText(getString(R.string.personal_pocket_vault));
            mRechargeRecordText.setText(getString(R.string.personal_recharge_record));
            mRechargeRecord.setVisibility(View.VISIBLE);
            mRechargeRecordText.setVisibility(View.VISIBLE);
            mRechargeRecord.setOnClickListener(this);
            GetPersonalWallet();
        }
        CompanyBankCardEntityList = new ArrayList<>();
        withdrawAdapter = new WithdrawAdapter(CompanyBankCardEntityList, this);
        mResultListView.setAdapter(withdrawAdapter);

    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        submit_btn.setOnClickListener(this);
        create_public_bank_count.setOnClickListener(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (!getIntent().getBooleanExtra("Personal", false)) {
            getCompanyBankCardList(AppConfig.getCurrentUseCompany());
        } else {
            getCompanyBankCardList(0);
        }
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                InputMethodManager imm = (InputMethodManager) getApplicationContext().getSystemService(Context.INPUT_METHOD_SERVICE);
                imm.hideSoftInputFromWindow(input_money.getWindowToken(), 0); //强制隐藏键盘
                finish();
                break;
            case R.id.include_button_button:
                //到提现界面
                if (TextUtils.isEmpty(input_money.getText().toString().trim())) {
                    ToastUtil.showInfo("请输入提现金额");
                    return;
                }
                if (Double.parseDouble(input_money.getText().toString().trim()) <= 0) {
                    ToastUtil.showInfo("输入提现金额错误");
                    return;
                }
                if (Double.parseDouble(input_money.getText().toString().trim()) > Double.parseDouble(company_vault.getText().toString().trim())) {
                    ToastUtil.showInfo("提现金额不能大于公司金库金额");
                    return;
                }
                if (Double.parseDouble(input_money.getText().toString().trim()) > can_withdrawal_amount) {
                    ToastUtil.showInfo("提现金额不能大于可提现金额");
                    return;
                }
                CompanyBankCardEntity companyBankCardEntity = CompanyBankCardEntityList.get(withdrawAdapter.getSelectedItem());
                Intent intent = new Intent(this, WithdrawCashActivity.class);
                if (!getIntent().getBooleanExtra("Personal", false)) {
                    intent.putExtra("withdraw_type", "company");
                } else {
                    intent.putExtra("withdraw_type", "personal");
                }
                intent.putExtra("cash", input_money.getText().toString().trim());
                intent.putExtra("company_vault", company_vault.getText().toString().trim());
                intent.putExtra("company_name", companyBankCardEntity.CompanyName);
                intent.putExtra("bankName", companyBankCardEntity.BankName);
                intent.putExtra("bankCount", companyBankCardEntity.BankCard);
                intent.putExtra("can_withdrawal_amount", can_be_withdrawal_amount.getText().toString().trim());
                startActivityForResult(intent, 100);
                break;
            case R.id.create_public_bank_count:
                //新建账户
                if (TextUtils.isEmpty(input_money.getText().toString().trim())) {
                    ToastUtil.showInfo("请填写提现金额");
                    return;
                }
                if (Double.parseDouble(input_money.getText().toString().trim()) <= 0) {
                    ToastUtil.showInfo("输入提现金额错误");
                    return;
                }
                if (Double.parseDouble(input_money.getText().toString().trim()) > Double.parseDouble(company_vault.getText().toString().trim())) {
                    ToastUtil.showInfo("提现金额不能大于公司金库金额");
                    return;
                }
                if (Double.parseDouble(input_money.getText().toString().trim()) > can_withdrawal_amount) {
                    ToastUtil.showInfo("提现金额不能大于可提现金额");
                    return;
                }
                Intent intent1 = new Intent(this, WithdrawDepositActivity.class);
                if (!getIntent().getBooleanExtra("Personal", false)) {
                    intent1.putExtra("fromHaveBankCard", true);
                    intent1.putExtra("withdraw", input_money.getText().toString().trim());
                    startActivityForResult(intent1, 100);
                } else {
                    intent1.putExtra("Personal", true);
                    intent1.putExtra("fromHaveBankCard", true);
                    intent1.putExtra("withdraw", input_money.getText().toString().trim());
                    startActivityForResult(intent1, 100);
                }
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
                    company_vault.setText(df1.format(entity.AvailableBalance));
                    can_be_withdrawal_amount.setText(df1.format((entity.CanWithdrawBalance)) + "元");
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

    private void getCompanyBankCardList(final long companyId) {
        new AsyncRunnable<List<CompanyBankCardEntity>>() {
            @Override
            protected List<CompanyBankCardEntity> doInBackground(Void... params) {
                List<CompanyBankCardEntity> cardtList = null;
                if (!getIntent().getBooleanExtra("Personal", false)) {
                    cardtList = WithdrawRepository.getCompanyBankCardList(companyId);
                } else {
                    cardtList = PrivatenessWalletRepository.getCompanyBankCardList();
                }
                return cardtList;
            }

            @Override
            protected void onPostExecute(List<CompanyBankCardEntity> cardtList) {
                if (cardtList != null) {
                    if (cardtList.size() != 0) {
                        CompanyBankCardEntityList.clear();
                        CompanyBankCardEntityList.addAll(cardtList);
                        for (int i = 0; i < CompanyBankCardEntityList.size(); i++) {
                            if (i == 0) {
                                CompanyBankCardEntityList.get(i).isChecked = true;
                            } else {
                                CompanyBankCardEntityList.get(i).isChecked = false;
                            }
                        }
                        withdrawAdapter.notifyDataSetChanged();
                    }
                } else {

                }
            }

            protected void onPostError(Exception ex) {
            }
        }.execute();
    }


    private void GetPersonalWallet() {
        // 获取企业信息，根据之前保存的企业id查询
        new AsyncRunnable<WalletEntity>() {
            @Override
            protected WalletEntity doInBackground(Void... params) {
                WalletEntity entity = PrivatenessWalletRepository.getCompanyWallet();
                return entity;
            }

            @Override
            protected void onPostExecute(WalletEntity entity) {
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
                company_vault.setText("0.00");
                can_be_withdrawal_amount.setText("0元");
            }
        }.execute();
    }
}
