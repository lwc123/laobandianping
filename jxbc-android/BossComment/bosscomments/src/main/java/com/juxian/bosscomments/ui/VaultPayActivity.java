package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.PaymentEntity;
import com.juxian.bosscomments.models.PaymentResult;
import com.juxian.bosscomments.models.WalletEntity;
import com.juxian.bosscomments.modules.IPaymentHandler;
import com.juxian.bosscomments.modules.PaymentEngine;
import com.juxian.bosscomments.repositories.WalletRepository;
import com.juxian.bosscomments.utils.DialogUtils;

import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.text.DecimalFormat;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * @version 1.0
 * @author: 付晓龙
 * @类 说 明:选择支付方式
 * @创建时间：2016-2-17 下午4:23:54
 */
public class VaultPayActivity extends BaseActivity implements OnClickListener,
        IPaymentHandler,DialogUtils.DialogListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_button_button)
    Button pay;
    private Context context;

    @BindView(R.id.pay_jinku_selected)
    ImageView selectedJinKu;
    @BindView(R.id.headcolor)
    View view;
    private Dialog dialog;
    @BindView(R.id.pay_money)
    TextView mPayMoney;
    @BindView(R.id.pay_explain)
    TextView mPayExplain;
    @BindView(R.id.activity_pay_money)
    TextView mTotalMoney;
    @BindView(R.id.re_jinku_pay)
    RelativeLayout reJinKuPay;
    @BindView(R.id.vault_money)
    TextView mVaultMoney;
    private String newMoney;

    private PaymentEntity paymentEntity;
    private String mTag;
    public static final String OPEN_SERVICE = "OpenService", ONLY_RECHARGE = "OnlyRecharge", BUY = "Buy", OPEN_PERSONAL_SERVICE = "OpenPersonalService";
    private boolean mWhetherTheTransfer;
    private DecimalFormat df1 = new DecimalFormat("0");

    public int getContentViewId() {
        return R.layout.activity_pay_vault;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_pay);
        ButterKnife.bind(this);
        context = VaultPayActivity.this;
        /**
         * 改变状态栏颜色
         */
        showSystemBartint(view);
        mTag = getIntent().getStringExtra(Global.LISTVIEW_ITEM_TAG);
        mWhetherTheTransfer = false;

        // 购买背景调查
        title.setText("支付");
        GetCompanyWallet(AppConfig.getCurrentUseCompany());
        paymentEntity = JsonUtil.ToEntity(getIntent().getStringExtra("PaymentEntity"), PaymentEntity.class);
        mPayMoney.setText(df1.format(paymentEntity.TotalFee));
        mTotalMoney.setText(df1.format(paymentEntity.TotalFee));
        Log.e(Global.LOG_TAG,paymentEntity.toString());
        if (!TextUtils.isEmpty(paymentEntity.CommoditySubject)) {
            mPayExplain.setText(paymentEntity.CommoditySubject);
        } else {
            mPayExplain.setText("购买背景调查");
        }

        paymentEntity.PayWay = PaymentEngine.PayWays_Wallet; // 默认使用微信支付

        pay.setText("确定扣除金币");
        initListener();
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        pay.setOnClickListener(this);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        return super.onKeyDown(keyCode, event);

    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_button_button:// 支付购买
                DialogUtils.showStandardDialog(this,"关闭","确定","确认使用企业金库支付？",this);
                break;
            default:
                break;
        }
    }

    private void pay() {
        dialog = DialogUtil.showLoadingDialog();
        PaymentEngine.pay(paymentEntity, this, dialog);
    }

    @Override
    public void onPaymentCompleted(PaymentResult result) {
        if (null != dialog)
            dialog.dismiss();
        if (result == null) {
            return;
        }
        LogManager.getLogger("Payment").d("9-9 onPaymentCompleted => %s",
                JsonUtil.ToJson(result));

        if (result.Success) {
            ToastUtil.showInfo(getString(R.string.pay_success));
            if (OPEN_SERVICE.equals(mTag)) {
//                Log.e(Global.LOG_TAG,result.TargetBizTradeCode);
                Intent intent = new Intent(context, OpenServiceSuccessActivity.class);
                intent.putExtra(Global.LISTVIEW_ITEM_TAG, OPEN_SERVICE);
                intent.putExtra("OpenEnterpriseRequestEntity", paymentEntity.CommodityExtension);
                intent.putExtra("CompanyId", result.TargetBizTradeCode);
                setResult(RESULT_OK);
                startActivity(intent);
                finish();
            } else if (BUY.equals(mTag)) {
                Intent intent = new Intent(context, OpenServiceSuccessActivity.class);
                intent.putExtra(Global.LISTVIEW_ITEM_TAG, BUY);
                intent.putExtra("RecordId", result.TargetBizTradeCode);
                setResult(RESULT_OK);
                startActivity(intent);
                finish();
            } else if (OPEN_PERSONAL_SERVICE.equals(mTag)) {
                Intent intent = new Intent(context, OpenServiceSuccessActivity.class);
                intent.putExtra(Global.LISTVIEW_ITEM_TAG, OPEN_PERSONAL_SERVICE);
                intent.putExtra("ArchiveId", getIntent().getLongExtra("ArchiveId", 0));
                setResult(RESULT_OK);
                startActivity(intent);
                finish();
            }

        } else {
            if (TextUtils.equals(result.ErrorCode, "8000")) {
                ToastUtil.showError(getString(R.string.pay_wait));

            } else {
                ToastUtil.showError(getString(R.string.pay_false));
            }
        }
    }

    private void GetCompanyWallet(final long CompanyId) {
        // 获取企业信息，根据之前保存的企业id查询
        new AsyncRunnable<WalletEntity>() {
            @Override
            protected WalletEntity doInBackground(Void... params) {
                WalletEntity entity = WalletRepository.getCompanyWallet(CompanyId);
                return entity;
            }

            @Override
            protected void onPostExecute(WalletEntity entity) {
                if (entity != null) {
                    mVaultMoney.setText("余额：" + entity.AvailableBalance + "金币");
                } else {
                    mVaultMoney.setText("余额：0金币");
                }
            }

            protected void onPostError(Exception ex) {
                Log.e(Global.LOG_TAG, "net abnormal!");
            }
        }.execute();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 100:
                if (resultCode == RESULT_OK)
                    finish();
                break;
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void LeftBtMethod() {

    }

    @Override
    public void RightBtMethod() {
        if (!mWhetherTheTransfer) {
            this.pay();
        } else {
            Intent intent = new Intent(getApplicationContext(), AboutUsActivity.class);
            intent.putExtra("ShowType", "BankInfo");
            startActivity(intent);
        }
    }
}
