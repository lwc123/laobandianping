package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.PersonalJobSearchAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.JobEntity;
import com.juxian.bosscomments.repositories.JobRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import handmark.pulltorefresh.library.PullToRefreshBase;
import handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * Created by Tam on 2016/12/29.
 */
public class PersonalJobSearchListActivity extends RemoteDataActivity implements View.OnClickListener, AdapterView.OnItemClickListener, PullToRefreshBase.OnRefreshListener2<ListView> {
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView refreshListView;
    @BindView(R.id.input_hint)
    TextView input_hint;
    @BindView(R.id.search)
    View search;

    private List<JobEntity> entities;
    private PersonalJobSearchAdapter personalJobSearchAdapter;
    private int pageIndex;
    private String JobName, JobCity, Industry, SalaryRange;

    @Override
    public int getContentViewId() {
        return R.layout.activity_personal_job_search_list;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        input_hint.setOnClickListener(this);
        search.setOnClickListener(this);
        refreshListView.setOnRefreshListener(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.personal_job_list_title));
        entities = new ArrayList<>();
        input_hint.setText(getString(R.string.plaase_input_keyword1));
        personalJobSearchAdapter = new PersonalJobSearchAdapter(entities, this);
        refreshListView.setAdapter(personalJobSearchAdapter);
        refreshListView.setOnItemClickListener(this);
        refreshListView.setMode(PullToRefreshBase.Mode.BOTH);
        pageIndex = 1;
        JobName = "";
        JobCity = "";
        Industry = "";
        SalaryRange = "";
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
        getSearchJobList(JobName, JobCity, Industry, SalaryRange, pageIndex, 10, 0);
    }

    @Override
    protected void onResume() {
        super.onResume();
        IsReloadDataOnResume = true;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.search:
                Intent intent = new Intent(this, PersonalJobSearchActivity.class);
                startActivityForResult(intent, 110);
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 110:
                if (resultCode == RESULT_OK) {
                    if (data != null) {
                        JobName = data.getStringExtra("JobName");
                        JobCity = data.getStringExtra("JobCity");
                        Industry = data.getStringExtra("JobField");

                        SalaryRange = data.getStringExtra("JobSalaty");
                        pageIndex = 1;
//                        getSearchJobList(JobName, JobCity, Industry, SalaryRange, pageIndex, 10, 0);
                    }
                }
        }
    }

    public void getSearchJobList(final String JobName, final String JobCity, final String Industry, final String SalaryRange, final int Page, final int Size, final int tag) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<List<JobEntity>>() {
            @Override
            protected List<JobEntity> doInBackground(Void... params) {
                // 每次登录成功之后，保存token，并且返回登录信息
                List<JobEntity> jobEntities = JobRepository.jobSearch(JobName, JobCity, Industry, SalaryRange, Page, Size);
                return jobEntities;
            }

            @Override
            protected void onPostExecute(List<JobEntity> jobEntities) {
                if (dialog != null)
                    dialog.dismiss();
                if (jobEntities != null) {
                    IsInitData = true;
                    if (jobEntities.size() > 0) {
                        if (tag == 0) {
                            entities.clear();
                        }
                        entities.addAll(jobEntities);
                        personalJobSearchAdapter.notifyDataSetChanged();
                    } else {
                        if (tag == 0) {
                            entities.clear();
                            entities.addAll(jobEntities);
                            personalJobSearchAdapter.notifyDataSetChanged();
                        }
                        if (tag != 0) {
                            ToastUtil.showInfo("暂无更多职位信息");
                        }
                    }
                } else {
                    onRemoteError();
                }
                refreshListView.onRefreshComplete();
            }

            @Override
            protected void onPostError(Exception ex) {
                refreshListView.onRefreshComplete();
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }

    @Override
    public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
        Intent intent = new Intent(getApplicationContext(), JTDetailWebViewActivity.class);
        intent.putExtra("CompanyId", entities.get(i - 1).CompanyId);
        intent.putExtra("JobId", entities.get(i - 1).JobId);
        intent.putExtra("JobName", entities.get(i - 1).JobName);
        startActivity(intent);
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex = 1;
        getSearchJobList(JobName, JobCity, Industry, SalaryRange, pageIndex, 10, 0);
    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex++;
        getSearchJobList(JobName, JobCity, Industry, SalaryRange, pageIndex, 10, 1);
    }
}
