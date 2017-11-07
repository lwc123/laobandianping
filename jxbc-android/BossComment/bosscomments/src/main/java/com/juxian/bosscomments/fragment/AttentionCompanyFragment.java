package com.juxian.bosscomments.fragment;

import android.app.Dialog;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ListView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.AttentionCompanyAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.CCompanyEntity;
import com.juxian.bosscomments.models.ConcernedTotalEntity;
import com.juxian.bosscomments.models.OpinionEntity;
import com.juxian.bosscomments.repositories.CompanyReputationRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.DialogUtils;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import handmark.pulltorefresh.library.PullToRefreshBase;
import handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * Created by nene on 2017/4/17.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/17 17:14]
 * @Version: [v1.0]
 */
public class AttentionCompanyFragment extends BaseFragment implements PullToRefreshListView.OnRefreshListener2<ListView> {

    @BindView(R.id.refresh_listView)
    PullToRefreshListView mRefreshListView;
    private static final String PARAM = "param";
    private String mParam;
    private int pageIndex = 1;
    private AttentionCompanyAdapter mAdapter;
    private List<CCompanyEntity> mAttentionEntities;
    private Dialog dialog;

    public static AttentionCompanyFragment newInstance(String param) {
        AttentionCompanyFragment fragment = new AttentionCompanyFragment();
        Bundle args = new Bundle();
        args.putString(PARAM, param);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mParam = getArguments().getString(PARAM);
        }
    }

    @Override
    public View initViews() {
        View view = View.inflate(mActivity, R.layout.fragment_attention_company, null);
        //注入
        ButterKnife.bind(this, view);
        return view;
    }

    @Override
    public void initData() {
        super.initData();
        mAttentionEntities = new ArrayList<>();
        mRefreshListView.setMode(PullToRefreshBase.Mode.BOTH);
        mAdapter = new AttentionCompanyAdapter(mAttentionEntities,getActivity());
        mRefreshListView.setAdapter(mAdapter);
        pageIndex = 1;
//        getConcernedMineList(pageIndex,0);

        mRefreshListView.setOnRefreshListener(this);
    }

    @Override
    public void setData() {
        pageIndex = 1;
        getConcernedMineList(pageIndex,0,true);
    }

    @Override
    public void onResume() {
        super.onResume();
        pageIndex = 1;
        getConcernedMineList(pageIndex,0,false);
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex = 1;
        getConcernedMineList(pageIndex,0,false);
    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex++;
        getConcernedMineList(pageIndex,1,false);
    }

    private void getConcernedMineList(final int page, final int tag,final boolean isShowDialog) {
        if (isShowDialog) {
            dialog = DialogUtil.showLoadingDialog();
        }
        new AsyncRunnable<ConcernedTotalEntity>() {
            @Override
            protected ConcernedTotalEntity doInBackground(Void... params) {
                ConcernedTotalEntity concernedTotalEntity = CompanyReputationRepository.getConcernedMineList(page);
                return concernedTotalEntity;
            }

            @Override
            protected void onPostExecute(ConcernedTotalEntity concernedTotalEntity) {
                if (dialog != null)
                    dialog.dismiss();
                if (concernedTotalEntity != null) {
                    if (concernedTotalEntity.Companies.size() != 0) {
                        if (tag == 0) {
                            // 下拉刷新
                            mAttentionEntities.clear();
                        }
                        mAttentionEntities.addAll(concernedTotalEntity.Companies);
//                        mAdapter.notifyDataSetChanged();
                        mAdapter.setAttentionCompanyData(mAttentionEntities,concernedTotalEntity.ConcernedTotal);
                    } else {

                    }
                } else {
                }
                mRefreshListView.onRefreshComplete();
            }

            protected void onPostError(Exception ex) {
                Log.e(Global.LOG_TAG,ex.toString());
                mRefreshListView.onRefreshComplete();
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }
}
