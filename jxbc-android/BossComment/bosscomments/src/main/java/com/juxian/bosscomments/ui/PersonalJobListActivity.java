package com.juxian.bosscomments.ui;

import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.PersonalJobListAdapter;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import handmark.pulltorefresh.library.PullToRefreshBase;
import handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * Created by nene on 2016/12/19.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/19 19:29]
 * @Version: [v1.0]
 */
public class PersonalJobListActivity extends BaseActivity implements View.OnClickListener,PullToRefreshBase.OnRefreshListener2<ListView> {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView refreshListView;
    private PersonalJobListAdapter adapter;
    private List<String> entities;

    @Override
    public int getContentViewId() {
        return R.layout.activity_personal_job_list;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        initViewsData();
        initListener();
        setSystemBarTintManager(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.personal_job_list_title));
        refreshListView.setMode(PullToRefreshBase.Mode.DISABLED);
        entities = new ArrayList<>();
        adapter = new PersonalJobListAdapter(entities,getApplicationContext());
        refreshListView.setAdapter(adapter);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        refreshListView.setOnRefreshListener(this);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
        }
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {

    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {

    }
}
