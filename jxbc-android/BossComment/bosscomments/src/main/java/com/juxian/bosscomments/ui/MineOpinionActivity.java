package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.CompanyListAdapter;
import com.juxian.bosscomments.listener.ClickLikedListener;
import com.juxian.bosscomments.models.ConsoleEntity;
import com.juxian.bosscomments.models.OpinionEntity;
import com.juxian.bosscomments.models.OpinionTotalEntity;
import com.juxian.bosscomments.repositories.CompanyReputationRepository;
import com.juxian.bosscomments.utils.apiutils.LikedUtils;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.DialogUtils;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import handmark.pulltorefresh.library.PullToRefreshBase;
import handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * Created by nene on 2017/4/22.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/22 15:03]
 * @Version: [v1.0]
 */
public class MineOpinionActivity extends RemoteDataActivity implements View.OnClickListener,ClickLikedListener,LikedUtils.ClickLikedCallBackListener,PullToRefreshBase.OnRefreshListener2<ListView> {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView mRefreshListView;
    private CompanyListAdapter mAdapter;
    private List<OpinionEntity> mCompanyEntities;
    private int pageIndex = 1;
    private TextView textView;
    private Dialog dialog;

    @Override
    public int getContentViewId() {
        return R.layout.activity_mine_opinion;
    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);
        setSystemBarTintManager(this);
        initViewsData();
        initListener();
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.personal_my_comment));
        mCompanyEntities = new ArrayList<>();

        textView = new TextView(this);
        AbsListView.LayoutParams layoutParams = new AbsListView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,dp2px(18));
        textView.setLayoutParams(layoutParams);
//        ConsoleEntity entity = JsonUtil.ToEntity(AppConfig.getConsoleIndex(), ConsoleEntity.class);
//        textView.setText("共"+entity.OpinionTotal+"条点评");
        textView.setTextSize(12);
        textView.setTextColor(getResources().getColor(R.color.menu_color));
        textView.setGravity(Gravity.CENTER_VERTICAL);
        textView.setPadding(dp2px(20),0,0,0);
        mRefreshListView.getRefreshableView().addHeaderView(textView,null,false);
        mRefreshListView.setMode(PullToRefreshBase.Mode.BOTH);

        mAdapter = new CompanyListAdapter(mCompanyEntities, this, this,"Mine");
        mRefreshListView.setAdapter(mAdapter);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mRefreshListView.setOnRefreshListener(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        IsReloadDataOnResume = true;
    }

    @Override
    public void loadPageData() {
        pageIndex = 1;
        getCompanyReputationList(pageIndex,0,true);
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
        }
    }

    private void getCompanyReputationList(final int page, final int tag, final boolean isShowDialog) {
        if (isShowDialog) {
            dialog = DialogUtil.showLoadingDialog();
        }
        new AsyncRunnable<OpinionTotalEntity>() {
            @Override
            protected OpinionTotalEntity doInBackground(Void... params) {
                OpinionTotalEntity opinionTotalEntity = CompanyReputationRepository.getMineOpinionList(page);
                return opinionTotalEntity;
            }

            @Override
            protected void onPostExecute(OpinionTotalEntity opinionTotalEntity) {
                if (dialog != null)
                    dialog.dismiss();
                if (opinionTotalEntity != null) {
                    textView.setText("共"+opinionTotalEntity.OpinionTotal+"条点评");
                    if (opinionTotalEntity.Opinions.size() != 0) {
                        if (tag == 0) {
                            // 下拉刷新
                            mCompanyEntities.clear();
                        }
                        mCompanyEntities.addAll(opinionTotalEntity.Opinions);
                        mAdapter.notifyDataSetChanged();
                    } else {

                    }
                } else {
                    onRemoteError();
                }
                mRefreshListView.onRefreshComplete();
            }

            protected void onPostError(Exception ex) {
                mRefreshListView.onRefreshComplete();
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }

    @Override
    public void clickLiked(long OpinionId, int position) {
        LikedUtils.opinionLiked(OpinionId,position,this);
    }

    @Override
    public void clickLikedCallBack(int position) {
        if (mCompanyEntities.get(position).IsLiked){
            mCompanyEntities.get(position).IsLiked = false;
            mCompanyEntities.get(position).LikedCount = mCompanyEntities.get(position).LikedCount-1;
        } else {
            mCompanyEntities.get(position).IsLiked = true;
            mCompanyEntities.get(position).LikedCount = mCompanyEntities.get(position).LikedCount+1;
        }
        mAdapter.setCompanyListDatas(mCompanyEntities);
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex = 1;
        getCompanyReputationList(pageIndex,0,false);
    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex++;
        getCompanyReputationList(pageIndex,1,false);
    }
}
