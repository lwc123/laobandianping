package com.juxian.bosscomments.ui;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.SingleTypeAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.CCompanyEntity;
import com.juxian.bosscomments.models.TopicEntity;
import com.juxian.bosscomments.repositories.CompanyReputationRepository;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

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
 * Created by nene on 2017/4/19.
 * 某类型的公司列表
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/19 15:06]
 * @Version: [v1.0]
 */
public class SingleTypeCompanyActivity extends RemoteDataActivity implements View.OnClickListener,PullToRefreshBase.OnRefreshListener2<ListView> {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView mRefreshListView;
    private View mSingleTypeCompanyHeaderView;
    private ImageView mHeaderImage;
    private int pageIndex;
    private List<CCompanyEntity> mCompanyEntities;
    private SingleTypeAdapter mAdapter;
    private long TopicId;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_OPEN_SERVICE_OPTIONS;
    private Dialog dialog;

    @Override
    public int getContentViewId() {
        return R.layout.activity_single_type_company;
    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);
        initViewsData();
        initListener();
        setSystemBarTintManager(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        TopicId = getIntent().getLongExtra("TopicId",0);
        title.setText(getIntent().getStringExtra("TopicTitle"));
        mCompanyEntities = new ArrayList<>();
        mRefreshListView.setMode(PullToRefreshBase.Mode.BOTH);
        mSingleTypeCompanyHeaderView = LayoutInflater.from(getApplicationContext()).inflate(R.layout.include_single_type_header,null);
        mRefreshListView.getRefreshableView().addHeaderView(mSingleTypeCompanyHeaderView,null,false);
        mHeaderImage = (ImageView) mSingleTypeCompanyHeaderView.findViewById(R.id.header_banner);

        mAdapter = new SingleTypeAdapter(mCompanyEntities,getApplicationContext());
        mRefreshListView.setAdapter(mAdapter);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mRefreshListView.setOnRefreshListener(this);
        mRefreshListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                Intent intent = new Intent(SingleTypeCompanyActivity.this, CompanyDetailActivity.class);
                intent.putExtra("CompanyId",mCompanyEntities.get(i-2).CompanyId);
                startActivity(intent);
            }
        });
    }

    @Override
    public void loadPageData() {
        pageIndex = 1;
        getCompanyReputationList(TopicId,pageIndex,0,true);
    }

    @Override
    protected void onResume() {
        super.onResume();
        IsReloadDataOnResume = true;
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
        }
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex = 1;
        getCompanyReputationList(TopicId,pageIndex,0,false);
    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex++;
        getCompanyReputationList(TopicId,pageIndex,1,false);
    }

    private void getCompanyReputationList(final long TopicId,final int pageIndex,final int tag,boolean isShowDialog) {
        if (isShowDialog){
            dialog = DialogUtil.showLoadingDialog();
        }
        new AsyncRunnable<TopicEntity>() {
            @Override
            protected TopicEntity doInBackground(Void... params) {
                TopicEntity topicEntity = CompanyReputationRepository.getTopicDetail(TopicId,pageIndex);
                return topicEntity;
            }

            @Override
            protected void onPostExecute(TopicEntity topicEntity) {
                if (dialog != null)
                    dialog.dismiss();
                if (topicEntity != null){
                    ImageLoader.getInstance().displayImage(topicEntity.HeadFigure,mHeaderImage,options,animateFirstListener);
                    if (topicEntity.Companys.size()>0){
                        if (tag == 0){
                            mCompanyEntities.clear();
                        }
                        mCompanyEntities.addAll(topicEntity.Companys);
                        mAdapter.notifyDataSetChanged();
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
}
