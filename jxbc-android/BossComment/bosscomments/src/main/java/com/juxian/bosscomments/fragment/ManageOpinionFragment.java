package com.juxian.bosscomments.fragment;

import android.app.Dialog;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ListView;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.AttentionCompanyAdapter;
import com.juxian.bosscomments.adapter.ManageOpinionAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.CCompanyEntity;
import com.juxian.bosscomments.models.EnterpriseEntity;
import com.juxian.bosscomments.models.OpinionEntity;
import com.juxian.bosscomments.models.OpinionTotalEntity;
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
public class ManageOpinionFragment extends BaseFragment implements PullToRefreshListView.OnRefreshListener2<ListView> {

    @BindView(R.id.refresh_listView)
    PullToRefreshListView mRefreshListView;
    private static final String PARAM = "param";
    private String mParam;
    private int pageIndex = 1;
    private ManageOpinionAdapter mAdapter;
    private List<OpinionEntity> mOpinionEntities;
    private boolean isAllSelect = false;
    private int AuditStatus;
    private static TextView mHideButton;
    private static TextView mAllSelectButton;
    private TextView textView;
    private static long mOpinionCompanyId;
    private Dialog dialog;

    public static ManageOpinionFragment newInstance(String param,TextView mManageOpinionLeftBt,TextView mManageOpinionRightBt,long OpinionCompanyId) {
        mAllSelectButton = mManageOpinionLeftBt;
        mHideButton = mManageOpinionRightBt;
        mOpinionCompanyId = OpinionCompanyId;
        ManageOpinionFragment fragment = new ManageOpinionFragment();
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
        View view = View.inflate(mActivity, R.layout.fragment_manage_opinion, null);
        //注入
        ButterKnife.bind(this, view);
        return view;
    }

    @Override
    public void initData() {
        super.initData();
        mOpinionEntities = new ArrayList<>();

        textView = new TextView(getActivity());
        AbsListView.LayoutParams layoutParams = new AbsListView.LayoutParams(AbsListView.LayoutParams.MATCH_PARENT,dp2px(16));
        textView.setLayoutParams(layoutParams);
        textView.setText("所有共0条点评");
        textView.setTextSize(12);
        textView.setTextColor(getResources().getColor(R.color.menu_color));
        textView.setGravity(Gravity.CENTER_VERTICAL);
        textView.setPadding(dp2px(15),0,0,0);
        mRefreshListView.getRefreshableView().addHeaderView(textView,null,false);

        mAdapter = new ManageOpinionAdapter(mOpinionEntities,getActivity(),mHideButton);
        mRefreshListView.setAdapter(mAdapter);
//        pageIndex = 1;
//        getConcernedMineList(pageIndex,0);
        mRefreshListView.setMode(PullToRefreshBase.Mode.BOTH);
        mRefreshListView.setOnRefreshListener(this);
    }

    @Override
    public void setData() {
        if ("OwnOpinion".equals(mParam)){
            AuditStatus = 1;
        } else {
            AuditStatus = 2;
        }
        Log.e(Global.LOG_TAG,"setData");
        pageIndex = 1;
        getEnterpriseOpinions(AppConfig.getCurrentUseCompany(),mOpinionCompanyId,AuditStatus,pageIndex,0,false);
    }

    public void setAllSelect(){
        if (isAllSelect){
            for (int i=0;i<mOpinionEntities.size();i++){
                mOpinionEntities.get(i).isSelectOpinion = false;
            }
            mAllSelectButton.setText("全选");
            isAllSelect = false;
        } else {
            for (int i=0;i<mOpinionEntities.size();i++){
                mOpinionEntities.get(i).isSelectOpinion = true;
            }
            mAllSelectButton.setText("取消全选");
            isAllSelect = true;
        }
        mAdapter.setOpinionListDatas(mOpinionEntities);
    }

    public void netWork(){
        EnterpriseEntity enterpriseEntity = new EnterpriseEntity();
        enterpriseEntity.CompanyId = AppConfig.getCurrentUseCompany();
        enterpriseEntity.OpinionIds = new ArrayList<>();
        for (int i=0;i<mOpinionEntities.size();i++){
            if (mOpinionEntities.get(i).isSelectOpinion) {
                enterpriseEntity.OpinionIds.add(mOpinionEntities.get(i).OpinionId);
            }
        }
        if ("OwnOpinion".equals(mParam)){
            hideOpinions(enterpriseEntity);
        } else {
            restoreOpinions(enterpriseEntity);
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        Log.e(Global.LOG_TAG,mParam);
        if ("OwnOpinion".equals(mParam)){
            AuditStatus = 1;
        } else {
            AuditStatus = 2;
        }
        pageIndex = 1;
        getEnterpriseOpinions(AppConfig.getCurrentUseCompany(),mOpinionCompanyId,AuditStatus,pageIndex,0,true);
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex = 1;
        getEnterpriseOpinions(AppConfig.getCurrentUseCompany(),mOpinionCompanyId,AuditStatus,pageIndex,0,false);
    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex++;
        getEnterpriseOpinions(AppConfig.getCurrentUseCompany(),mOpinionCompanyId,AuditStatus,pageIndex,1,false);
    }

    private void getEnterpriseOpinions(final long CompanyId,final long OpinionCompanyId,final int AuditStatus,final int page, final int tag, final boolean isShowDialog) {
        if (isShowDialog) {
            dialog = DialogUtil.showLoadingDialog();
        }
        new AsyncRunnable<OpinionTotalEntity>() {
            @Override
            protected OpinionTotalEntity doInBackground(Void... params) {
                OpinionTotalEntity opinionTotalEntity = CompanyReputationRepository.getEnterpriseOpinions(CompanyId,OpinionCompanyId,AuditStatus,page);
                return opinionTotalEntity;
            }

            @Override
            protected void onPostExecute(OpinionTotalEntity opinionTotalEntity) {
                if (dialog != null)
                    dialog.dismiss();
                if (opinionTotalEntity != null) {
                    if ("OwnOpinion".equals(mParam)){
                        textView.setText("所有共"+opinionTotalEntity.OpinionTotal+"条点评");
                    } else {
                        textView.setText("已隐藏"+opinionTotalEntity.OpinionTotal+"条点评");
                    }
//                    textView.setText("所有共"+opinionTotalEntity.OpinionTotal+"条点评");
                    if (opinionTotalEntity.Opinions.size() != 0) {
                        if (tag == 0) {
                            // 下拉刷新
                            mOpinionEntities.clear();
                        }
                        mOpinionEntities.addAll(opinionTotalEntity.Opinions);
                        mAdapter.notifyDataSetChanged();
                    } else {
                        if (tag == 0) {
                            // 下拉刷新
                            mOpinionEntities.clear();
                            mAdapter.notifyDataSetChanged();
                        }
                    }
                } else {
                }
                mRefreshListView.onRefreshComplete();
            }

            protected void onPostError(Exception ex) {
                mRefreshListView.onRefreshComplete();
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    private void hideOpinions(final EnterpriseEntity enterpriseEntity) {
        dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean isHide = CompanyReputationRepository.hideOpinions(enterpriseEntity);
                return isHide;
            }

            @Override
            protected void onPostExecute(Boolean isHide) {
                if (dialog != null)
                    dialog.dismiss();
                if (isHide){
                    pageIndex = 1;
                    getEnterpriseOpinions(AppConfig.getCurrentUseCompany(),mOpinionCompanyId,AuditStatus,pageIndex,0,false);
                } else {

                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    private void restoreOpinions(final EnterpriseEntity enterpriseEntity) {
        dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean isHide = CompanyReputationRepository.restoreOpinions(enterpriseEntity);
                return isHide;
            }

            @Override
            protected void onPostExecute(Boolean isHide) {
                if (dialog != null)
                    dialog.dismiss();
                if (isHide){
                    pageIndex = 1;
                    getEnterpriseOpinions(AppConfig.getCurrentUseCompany(),mOpinionCompanyId,AuditStatus,pageIndex,0,false);
                } else {

                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }
}
