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

import net.juxian.appgenome.ActivityManager;
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
public class PayActivity extends BaseActivity implements OnClickListener,
        IPaymentHandler {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_button_button)
    Button pay;
    private Context context;

    @BindView(R.id.pay_weixin_selected)
    ImageView selectedWeiXin;
    @BindView(R.id.pay_zhifubao_selected)
    ImageView selectedZhifubao;
    @BindView(R.id.pay_jinku_selected)
    ImageView selectedJinKu;
    @BindView(R.id.pay_zhuanzhang_selected)
    ImageView selectedZhuanzhang;
    @BindView(R.id.headcolor)
    View view;
    @BindView(R.id.re_weixin_pay)
    RelativeLayout reWeiXinPay;
    @BindView(R.id.re_zhifubao_pay)
    RelativeLayout reZhiFuBaoPay;
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
    @BindView(R.id.line)
    View line;
    @BindView(R.id.re_zhuanzhang_pay)
    RelativeLayout reZhuanzhangPay;
    @BindView(R.id.line2)
    View line2;
    private String newMoney;
    private double AvailableBalance;

    private PaymentEntity paymentEntity;
    private int isSuccess = 0;
    private String mTag;
    public static final String OPEN_SERVICE = "OpenService",PAY_FEES = "PayFees",BUY = "Buy",OPEN_PERSONAL_SERVICE = "OpenPersonalService";
    private boolean mWhetherTheTransfer;
    private DecimalFormat df1 = new DecimalFormat("0");

    public int getContentViewId(){
        return R.layout.activity_pay;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_pay);
        ButterKnife.bind(this);
        context = PayActivity.this;
        // GetChannel();
        title.setText(getString(R.string.recharge));
        /**
         * 改变状态栏颜色
         */
        showSystemBartint(view);
        mTag = getIntent().getStringExtra(Global.LISTVIEW_ITEM_TAG);
        mWhetherTheTransfer = false;
        if (OPEN_SERVICE.equals(mTag)){
            line.setVisibility(View.GONE);
            reJinKuPay.setVisibility(View.GONE);
            title.setText(getString(R.string.pay));
            paymentEntity = new PaymentEntity();
            paymentEntity.CommodityExtension = getIntent().getStringExtra("OpenEnterpriseRequestEntity");
            paymentEntity.TradeType = PaymentEngine.TradeType_OrganizationToOrganization;
            paymentEntity.BizSource = PaymentEngine.BizSources_OpenEnterpriseService;
            paymentEntity.OwnerId = -1;
            paymentEntity.TradeMode = PaymentEngine.TradeMode_Payout;
            mPayMoney.setText(df1.format(getIntent().getDoubleExtra("CurrentPrice",0)));
            mTotalMoney.setText(df1.format(getIntent().getDoubleExtra("CurrentPrice",0)));
            paymentEntity.TotalFee = getIntent().getDoubleExtra("CurrentPrice",0);
            paymentEntity.CommoditySubject = "开通老板点评服务";
        } else if (BUY.equals(mTag)){
            // 购买背景调查
            title.setText("购买背景调查");
            GetCompanyWallet(AppConfig.getCurrentUseCompany());
            line.setVisibility(View.GONE);
            reJinKuPay.setVisibility(View.GONE);
            line2.setVisibility(View.GONE);
            reZhuanzhangPay.setVisibility(View.GONE);
            paymentEntity = JsonUtil.ToEntity(getIntent().getStringExtra("PaymentEntity"),PaymentEntity.class);
            mPayMoney.setText(df1.format(paymentEntity.TotalFee));
            mTotalMoney.setText(df1.format(paymentEntity.TotalFee));
            mPayExplain.setText("购买背景调查");
        } else if (OPEN_PERSONAL_SERVICE.equals(mTag)){
            line.setVisibility(View.GONE);
            reJinKuPay.setVisibility(View.GONE);
            line2.setVisibility(View.GONE);
            reZhuanzhangPay.setVisibility(View.GONE);
            title.setText(getString(R.string.pay));
            mPayMoney.setText("20");
            mTotalMoney.setText("20");
            paymentEntity = new PaymentEntity();
            paymentEntity.TradeType = PaymentEngine.TradeType_PersonalToOrganization;
            paymentEntity.BizSource = PaymentEngine.BizSources_OpenPersonalService;
            paymentEntity.TradeMode = PaymentEngine.TradeMode_Payout;
            paymentEntity.TotalFee = 20;
            paymentEntity.CommoditySubject = "开通老板点评会员";
            mPayExplain.setText("开通老板点评会员");
        } else if (PAY_FEES.equals(mTag)){
            // 续费
            title.setText(getString(R.string.pay));
            line.setVisibility(View.GONE);
            reJinKuPay.setVisibility(View.GONE);
            paymentEntity = JsonUtil.ToEntity(getIntent().getStringExtra("PaymentEntity"),PaymentEntity.class);
            mPayMoney.setText(df1.format(paymentEntity.TotalFee));
            mTotalMoney.setText(df1.format(paymentEntity.TotalFee));
            mPayExplain.setText("开通老板点评服务");
        }

        paymentEntity.PayWay = PaymentEngine.PayWays_Wechat; // 默认使用微信支付

        pay.setText(getString(R.string.go_pay));
        initListener();
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        pay.setOnClickListener(this);
        reWeiXinPay.setOnClickListener(this);
        reZhiFuBaoPay.setOnClickListener(this);
        reJinKuPay.setOnClickListener(this);
        reZhuanzhangPay.setOnClickListener(this);
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
                if (!mWhetherTheTransfer) {
                    this.pay();
                } else {
                    Intent intent = new Intent(getApplicationContext(),AboutUsActivity.class);
                    intent.putExtra("ShowType","BankInfo");
                    startActivity(intent);
                }
                break;
            case R.id.re_weixin_pay:
                selectedZhifubao.setImageResource(R.drawable.weixuanzhong);
                selectedWeiXin.setImageResource(R.drawable.xuanzhong);
                selectedJinKu.setImageResource(R.drawable.weixuanzhong);
                selectedZhuanzhang.setImageResource(R.drawable.weixuanzhong);
                mWhetherTheTransfer = false;
                paymentEntity.PayWay = PaymentEngine.PayWays_Wechat;
                break;
            case R.id.re_zhifubao_pay:
                selectedZhifubao.setImageResource(R.drawable.xuanzhong);
                selectedWeiXin.setImageResource(R.drawable.weixuanzhong);
                selectedJinKu.setImageResource(R.drawable.weixuanzhong);
                selectedZhuanzhang.setImageResource(R.drawable.weixuanzhong);
                mWhetherTheTransfer = false;
                paymentEntity.PayWay = PaymentEngine.PayWays_Alipay;
                break;
            case R.id.re_jinku_pay:
                if (AvailableBalance < paymentEntity.TotalFee){
                    ToastUtil.showInfo("企业金库余额不足，请选择其它支付方式");
                    return;
                }
                selectedZhifubao.setImageResource(R.drawable.weixuanzhong);
                selectedWeiXin.setImageResource(R.drawable.weixuanzhong);
                selectedJinKu.setImageResource(R.drawable.xuanzhong);
                selectedZhuanzhang.setImageResource(R.drawable.weixuanzhong);
                mWhetherTheTransfer = false;
                paymentEntity.PayWay = PaymentEngine.PayWays_Wallet;
                break;
            case R.id.re_zhuanzhang_pay:
                selectedZhifubao.setImageResource(R.drawable.weixuanzhong);
                selectedWeiXin.setImageResource(R.drawable.weixuanzhong);
                selectedJinKu.setImageResource(R.drawable.weixuanzhong);
                selectedZhuanzhang.setImageResource(R.drawable.xuanzhong);
                mWhetherTheTransfer = true;
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
            // 因为HomeActivity使用的是SingleTask模式，所以就算这个Activity已经存在了，我们再一次跳过去，也只是有一个，而不会有多个
//            Intent intent = new Intent(context, HomeActivity.class);
//            intent.putExtra("PaySuccessTag", "success");
//            startActivity(intent);
//            finish();
            if (OPEN_SERVICE.equals(mTag)) {
//                Log.e(Global.LOG_TAG,result.TargetBizTradeCode);
                Intent intent = new Intent(context, OpenServiceSuccessActivity.class);
                intent.putExtra(Global.LISTVIEW_ITEM_TAG,OPEN_SERVICE);
                intent.putExtra("OpenEnterpriseRequestEntity",paymentEntity.CommodityExtension);
                intent.putExtra("CompanyId",result.TargetBizTradeCode);
                setResult(RESULT_OK);
                startActivity(intent);
                finish();
            } else if (BUY.equals(mTag)){
                Intent intent = new Intent(context, OpenServiceSuccessActivity.class);
                intent.putExtra(Global.LISTVIEW_ITEM_TAG,BUY);
                intent.putExtra("RecordId",result.TargetBizTradeCode);
                setResult(RESULT_OK);
                startActivity(intent);
                finish();
            } else if (OPEN_PERSONAL_SERVICE.equals(mTag)){
                Intent intent = new Intent(context, OpenServiceSuccessActivity.class);
                intent.putExtra(Global.LISTVIEW_ITEM_TAG,OPEN_PERSONAL_SERVICE);
                intent.putExtra("ArchiveId",getIntent().getLongExtra("ArchiveId",0));
                setResult(RESULT_OK);
                startActivity(intent);
                finish();
            } else if (PAY_FEES.equals(mTag)){
                Intent intent = new Intent(context, OpenServiceSuccessActivity.class);
                intent.putExtra(Global.LISTVIEW_ITEM_TAG,PAY_FEES);
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
                if (entity != null){
                    AvailableBalance = entity.AvailableBalance;
                    mVaultMoney.setText("余额："+entity.AvailableBalance+"元");
                } else {
                    mVaultMoney.setText("余额：0元");
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
        switch (requestCode){
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
}
