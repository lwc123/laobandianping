package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.RechargeRecordAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.TradeJournalEntity;
import com.juxian.bosscomments.modules.PaymentEngine;
import com.juxian.bosscomments.repositories.PrivatenessRepository;
import com.juxian.bosscomments.repositories.PrivatenessWalletRepository;
import com.juxian.bosscomments.repositories.WalletRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import handmark.pulltorefresh.library.PullToRefreshBase;
import handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * Created by nene on 2016/10/25.
 *
 * @Description: 个人端交易记录
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/25 10:06]
 * @Version: [v1.0]
 */
public class PersonalRechargeRecordActivity extends BaseActivity implements OnRefreshListener2<ListView>, View.OnClickListener {

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
        title.setText(getString(R.string.boss_comment_recharge));
        refreshListView.setMode(Mode.BOTH);
        entities = new ArrayList<>();
        mMode = PaymentEngine.TradeMode_All;
        getTradeHistory(0, mMode, pageIndex);
        adapter = new RechargeRecordAdapter(entities, getApplicationContext(),"Personal");
        refreshListView.setAdapter(adapter);
        mSelectRecordImage.setImageResource(R.drawable.list_select);
        mSelectRecordImage.setVisibility(View.VISIBLE);
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
        super.onClick(v);
        switch (v.getId()) {
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
        getTradeHistory(0, mMode, pageIndex);
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex = 1;
        getTradeHistory(0, mMode, pageIndex);
    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex++;
        getTradeHistory(1, mMode, pageIndex);
    }

    private void getTradeHistory(final int tag, final int mode, final int pageIndex) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<List<TradeJournalEntity>>() {
            @Override
            protected List<TradeJournalEntity> doInBackground(Void... params) {
                List<TradeJournalEntity> mTradeJournalList = PrivatenessWalletRepository.getTradeHistory(mode, pageIndex);
                return mTradeJournalList;
            }

            @Override
            protected void onPostExecute(List<TradeJournalEntity> mTradeJournalList) {
                if (dialog != null)
                    dialog.dismiss();
                if (mTradeJournalList != null) {
                    if (mTradeJournalList.size() != 0) {
                        if (tag == 0) {
                            entities.clear();
                        }
//                        show_or_not.setVisibility(View.VISIBLE);
//                        content_is_null.setVisibility(View.GONE);
                        entities.addAll(mTradeJournalList);
                        adapter.notifyDataSetChanged();
                    } else {
                        if (tag == 0) {
                            entities.clear();
                            entities.addAll(mTradeJournalList);
                            adapter.notifyDataSetChanged();
//                            if (entities.size() == 0) {
//                                show_or_not.setVisibility(View.GONE);
//                                content_is_null.setVisibility(View.VISIBLE);
//                            }
                        } else {
                            ToastUtil.showInfo("暂无更多交易记录");
                        }
                    }
                } else {

                }
                refreshListView.onRefreshComplete();
            }

            protected void onPostError(Exception ex) {
                Log.e(Global.LOG_TAG, "net abnormal!");
                refreshListView.onRefreshComplete();
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    public void showPopupWindow(View view) {
        final View contentView = LayoutInflater.from(getApplicationContext()).inflate(R.layout.popupwindow_select_personal_recharge, null);
        RelativeLayout reIncomeRecord = (RelativeLayout) contentView.findViewById(R.id.re_income_record);
        RelativeLayout reWithdrawDepositRecord = (RelativeLayout) contentView.findViewById(R.id.re_withdraw_deposit_record);
        reIncomeRecord.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pageIndex = 1;
                mMode = PaymentEngine.TradeMode_Payoff;
                getTradeHistory(0, PaymentEngine.TradeMode_Payout, pageIndex);
                popupWindow.dismiss();
            }
        });
        reWithdrawDepositRecord.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                pageIndex = 1;
                mMode = PaymentEngine.TradeMode_Withdraw;
                getTradeHistory(0, PaymentEngine.TradeMode_Payout, pageIndex);
                popupWindow.dismiss();
            }
        });
        popupWindow = new PopupWindow(contentView, LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT, true);
        popupWindow.setTouchable(true);
        popupWindow.setBackgroundDrawable(getResources().getDrawable(R.drawable.mask_icon_7));
        popupWindow.showAsDropDown(mSelectRecordImage, 0, 12);

    }
}
