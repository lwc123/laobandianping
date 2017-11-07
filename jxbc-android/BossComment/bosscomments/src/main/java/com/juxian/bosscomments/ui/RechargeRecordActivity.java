package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

import handmark.pulltorefresh.library.PullToRefreshBase;
import handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import handmark.pulltorefresh.library.PullToRefreshListView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.adapter.RechargeRecordAdapter;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.PaymentEntity;
import com.juxian.bosscomments.models.TradeJournalEntity;
import com.juxian.bosscomments.modules.PaymentEngine;
import com.juxian.bosscomments.repositories.WalletRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/10/25.
 *
 * @Description: 消费记录
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/25 10:06]
 * @Version: [v1.0]
 */
public class RechargeRecordActivity extends RemoteDataActivity implements OnRefreshListener2<ListView>,View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView refreshListView;
    @BindView(R.id.include_head_title_re)
    RelativeLayout mSelectRecordType;
    @BindView(R.id.include_head_title_tab)
    ImageView mSelectRecordImage;
    @BindView(R.id.show_or_not)
    RelativeLayout show_or_not;
    @BindView(R.id.content_is_null)
    LinearLayout content_is_null;
    private View refreshListViewFooter;
    private List<TradeJournalEntity> entities;
    private RechargeRecordAdapter adapter;
    private int pageIndex = 1;
    private PopupWindow popupWindow;
    private int mMode;

    @Override
    public int getContentViewId() {
        return R.layout.activity_recharge_record;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        IsReloadDataOnResume = false;
        title.setText(getString(R.string.boss_comment_recharge));
        refreshListView.setMode(Mode.BOTH);
        entities = new ArrayList<>();
        mMode = PaymentEngine.TradeMode_All;
//        getTradeHistory(0, AppConfig.getCurrentUseCompany(),mMode,pageIndex);
        adapter = new RechargeRecordAdapter(entities,getApplicationContext(),"Company");
        refreshListView.setAdapter(adapter);
        mSelectRecordImage.setImageResource(R.drawable.list_select);
        mSelectRecordImage.setVisibility(View.VISIBLE);
    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);
        setSystemBarTintManager(this);
        initViewsData();
        initListener();
    }

    @Override
    public void loadPageData() {
        pageIndex = 1;
        getTradeHistory(0, AppConfig.getCurrentUseCompany(),mMode,pageIndex);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        refreshListView.setOnRefreshListener(this);
        mSelectRecordType.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_head_title_re:
                showPopupWindow(v);
                break;
            default:
        }
    }

    @Override
    protected void onRestart() {
        super.onRestart();
        entities.clear();
        pageIndex = 1;
        getTradeHistory(0,AppConfig.getCurrentUseCompany(),mMode,pageIndex);
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex = 1;
        getTradeHistory(0,AppConfig.getCurrentUseCompany(),mMode,pageIndex);
    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex++;
        getTradeHistory(1,AppConfig.getCurrentUseCompany(),mMode,pageIndex);
    }

    private void getTradeHistory(final int tag,final long CompanyId,final int mode,final int pageIndex) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<List<TradeJournalEntity>>() {
            @Override
            protected List<TradeJournalEntity> doInBackground(Void... params) {
                List<TradeJournalEntity> mTradeJournalList = WalletRepository.getTradeHistory(CompanyId,mode,pageIndex);
                return mTradeJournalList;
            }

            @Override
            protected void onPostExecute(List<TradeJournalEntity> mTradeJournalList) {
                if (dialog != null)
                    dialog.dismiss();
                if (mTradeJournalList!=null){
                    IsInitData = true;
                    if (mTradeJournalList.size() != 0){
                        if (tag == 0){
                            entities.clear();
                        }
                        show_or_not.setVisibility(View.VISIBLE);
                        content_is_null.setVisibility(View.GONE);
                        entities.addAll(mTradeJournalList);
                        adapter.notifyDataSetChanged();
                    } else {
                        if (tag == 0){
                            entities.clear();
                            entities.addAll(mTradeJournalList);
                            adapter.notifyDataSetChanged();
                            if (entities.size() == 0){
                                show_or_not.setVisibility(View.GONE);
                                content_is_null.setVisibility(View.VISIBLE);
                            }
                        } else {
                            ToastUtil.showInfo("暂无更多交易记录");
                        }
                    }
                } else {
                    onRemoteError();
                }
                refreshListView.onRefreshComplete();
            }

            protected void onPostError(Exception ex) {
                Log.e(Global.LOG_TAG,"net abnormal!");
                refreshListView.onRefreshComplete();
                onRemoteError();
                if (dialog != null)
                    dialog.dismiss();
//                resultCheckNetStatus();
            }
        }.execute();
    }

    public void showPopupWindow(View view) {
        final View contentView = LayoutInflater.from(getApplicationContext()).inflate(R.layout.popupwindow_select_consume_type, null);
        RelativeLayout reIncomeRecord = (RelativeLayout) contentView.findViewById(R.id.re_income_record);
        RelativeLayout reExpenseRecord = (RelativeLayout) contentView.findViewById(R.id.re_expense_record);
        RelativeLayout reWithdrawDepositRecord = (RelativeLayout) contentView.findViewById(R.id.re_withdraw_deposit_record);
        reIncomeRecord.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pageIndex = 1;
                mMode = PaymentEngine.TradeMode_Payoff;
                getTradeHistory(0,AppConfig.getCurrentUseCompany(), mMode,pageIndex);
                popupWindow.dismiss();
            }
        });
        reExpenseRecord.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pageIndex = 1;
                mMode = PaymentEngine.TradeMode_Action_Buy;
                getTradeHistory(0,AppConfig.getCurrentUseCompany(),PaymentEngine.TradeMode_Action_Buy,pageIndex);
                popupWindow.dismiss();
            }
        });
        reWithdrawDepositRecord.setVisibility(View.GONE);
        reWithdrawDepositRecord.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pageIndex = 1;
                mMode = PaymentEngine.TradeMode_Action_Withdraw;
                getTradeHistory(0,AppConfig.getCurrentUseCompany(),PaymentEngine.TradeMode_Action_Withdraw,pageIndex);
                popupWindow.dismiss();
            }
        });
        popupWindow = new PopupWindow(contentView, LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT, true);
        popupWindow.setTouchable(true);
        popupWindow.setBackgroundDrawable(getResources().getDrawable(R.drawable.mask_icon_7));
        popupWindow.showAsDropDown(mSelectRecordImage, 0, 12);

    }
}
