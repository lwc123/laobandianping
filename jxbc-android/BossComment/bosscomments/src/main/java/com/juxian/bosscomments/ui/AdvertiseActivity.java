package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.AdvertiseHomeAdapter;
import com.juxian.bosscomments.models.JobEntity;
import com.juxian.bosscomments.repositories.JobRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import handmark.pulltorefresh.library.PullToRefreshBase;
import handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * Created by Tam on 2016/12/19.
 * 招聘首页
 */
public class AdvertiseActivity extends RemoteDataActivity implements View.OnClickListener, PullToRefreshBase.OnRefreshListener2<ListView> {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView mPullToRefreshListView;
    @BindView(R.id.include_head_title_tab2)
    TextView post_position_text;
    @BindView(R.id.include_head_title_re1)
    RelativeLayout post_position;
    @BindView(R.id.show_or_not)
    RelativeLayout show_or_not;
    @BindView(R.id.null_position)
    LinearLayout null_position;
    @BindView(R.id.include_button_button)
    Button post_bt;
    private List<JobEntity> entities;
    private View refreshListViewHeader;
    private AdvertiseHomeAdapter advertiseHomeAdapter;
    private int pageIndex;

    @Override
    public int getContentViewId() {
        return R.layout.activity_advertise_home;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.advertise));
        post_position_text.setText(getString(R.string.advertising));
        post_position.setVisibility(View.VISIBLE);
        post_position_text.setVisibility(View.VISIBLE);
        post_bt.setText(getString(R.string.advertising));
        show_or_not.setVisibility(View.GONE);
        refreshListViewHeader = LayoutInflater.from(getApplicationContext()).inflate(R.layout.refresh_listview_header, null);
        mPullToRefreshListView.getRefreshableView().addHeaderView(refreshListViewHeader, null, false);
        mPullToRefreshListView.setMode(PullToRefreshBase.Mode.BOTH);
        TextView content_hint = (TextView) refreshListViewHeader.findViewById(R.id.content_hint);
        content_hint.setText("已发布职位");
        entities = new ArrayList<>();
        advertiseHomeAdapter = new AdvertiseHomeAdapter(entities, this);
        mPullToRefreshListView.setAdapter(advertiseHomeAdapter);
    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);
        initViewsData();
        initListener();
        setSystemBarTintManager(this);
    }

    @Override
    public void loadPageData() {
        pageIndex = 1;
        getJobList(AppConfig.getCurrentUseCompany(), pageIndex, 0);
    }

    @Override
    protected void onResume() {
        super.onResume();
        IsReloadDataOnResume = true;
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        post_position.setOnClickListener(this);
        post_bt.setOnClickListener(this);
        mPullToRefreshListView.setOnRefreshListener(this);
        mPullToRefreshListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                Intent intent = new Intent(getApplicationContext(), JTDetailWebViewActivity.class);
                intent.putExtra("DetailType", "company");
                intent.putExtra("JobId", entities.get(i - 2).JobId);
                intent.putExtra("JobName", entities.get(i - 2).JobName);
                startActivity(intent);
            }
        });
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_head_title_re1:
                //跳转去发布页面
                Intent toAddRecruitInfo = new Intent(getApplicationContext(), AddRecruitInfoActivity.class);
                toAddRecruitInfo.putExtra("CompanyName", getIntent().getStringExtra("CompanyName"));
                startActivity(toAddRecruitInfo);
                break;
            case R.id.include_button_button:
                Intent toAddRecruitInfo1 = new Intent(getApplicationContext(), AddRecruitInfoActivity.class);
                toAddRecruitInfo1.putExtra("CompanyName", getIntent().getStringExtra("CompanyName"));
                startActivity(toAddRecruitInfo1);
                break;
        }
    }

    public void getJobList(final long CompanyId, final int pageIndex, final int tag) {

        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<List<JobEntity>>() {
            @Override
            protected List<JobEntity> doInBackground(Void... params) {
                // 每次登录成功之后，保存token，并且返回登录信息
                List<JobEntity> jobEntities = JobRepository.getJobList(CompanyId, pageIndex);
                return jobEntities;
            }

            @Override
            protected void onPostExecute(List<JobEntity> jobEntities) {
//                Log.e(Global.LOG_TAG, "onPostExecute");
                if (dialog!=null) {
                    dialog.dismiss();
                }
                IsInitData = true;
                if (jobEntities != null) {
                    if (jobEntities.size() > 0) {
                        if (tag == 0) {
                            entities.clear();
                        }
                        entities.addAll(jobEntities);
                        show_or_not.setVisibility(View.VISIBLE);
                        null_position.setVisibility(View.GONE);
                        advertiseHomeAdapter.notifyDataSetChanged();
                    } else {
                        if (tag == 0) {
                            entities.clear();
                            entities.addAll(jobEntities);
                            advertiseHomeAdapter.notifyDataSetChanged();
                        }
                        if (entities.size() == 0) {
                            show_or_not.setVisibility(View.GONE);
                            null_position.setVisibility(View.VISIBLE);
                        }
                    }
                } else {
                    show_or_not.setVisibility(View.GONE);
                    null_position.setVisibility(View.VISIBLE);
                }
                mPullToRefreshListView.onRefreshComplete();
            }

            @Override
            protected void onPostError(Exception ex) {
//                Log.e(Global.LOG_TAG, "onPostError");
                if (dialog!=null) {
                    dialog.dismiss();
                }
                onRemoteError();
                mPullToRefreshListView.onRefreshComplete();
            }
        }.execute();
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex = 1;
        getJobList(AppConfig.getCurrentUseCompany(), pageIndex, 0);
    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex++;
        getJobList(AppConfig.getCurrentUseCompany(), pageIndex, 1);
    }
}
