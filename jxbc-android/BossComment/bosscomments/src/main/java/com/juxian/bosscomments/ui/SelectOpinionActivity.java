package com.juxian.bosscomments.ui;

import android.content.Intent;
import android.view.View;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.SearchCompanyAdapter;
import com.juxian.bosscomments.models.CCompanyEntity;

import net.juxian.appgenome.utils.JsonUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import handmark.pulltorefresh.library.PullToRefreshBase;
import handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * Created by nene on 2017/4/24.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/24 10:40]
 * @Version: [v1.0]
 */
public class SelectOpinionActivity extends RemoteDataActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView mRefreshListView;
    private List<CCompanyEntity> cCompanyEntities;
    private SearchCompanyAdapter mAdapter;
    private List<String> CompanyStrs;

    @Override
    public int getContentViewId() {
        return R.layout.activity_change_list;
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
        title.setText("选择公司口碑");
        cCompanyEntities = new ArrayList<>();
        CompanyStrs = new ArrayList<>();
        CompanyStrs = getIntent().getStringArrayListExtra("Companys");
        for (int i=0;i<CompanyStrs.size();i++){
            CCompanyEntity entity = JsonUtil.ToEntity(CompanyStrs.get(i),CCompanyEntity.class);
            cCompanyEntities.add(entity);
        }
        mRefreshListView.setMode(PullToRefreshBase.Mode.DISABLED);
        mAdapter = new SearchCompanyAdapter(cCompanyEntities,this);
        mRefreshListView.setAdapter(mAdapter);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mRefreshListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                Intent intent = new Intent(getApplicationContext(), CompanyDetailActivity.class);
                intent.putExtra("FromResource","FromB");
                intent.putExtra("CompanyId",cCompanyEntities.get(i-1).CompanyId);
                startActivity(intent);
            }
        });
    }

    @Override
    public void loadPageData() {

    }

    @Override
    public void onClick(View view) {
        switch (view.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
        }
    }
}
