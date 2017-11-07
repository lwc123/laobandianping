package com.juxian.bosscomments.ui;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.SelectCompanyAdapter;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.utils.SignInUtils;

import net.juxian.appgenome.utils.JsonUtil;
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
 * @Description: 选择公司界面
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/25 11:11]
 * @Version: [v1.0]
 */
public class SelectCompanyActivity extends BaseActivity implements OnRefreshListener2<ListView>,View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView refreshListView;
    private View refreshListViewHeader;
    private List<MemberEntity> entities;
    private List<String> memberEntities;
    private SelectCompanyAdapter adapter;

    @Override
    public int getContentViewId() {
        return R.layout.activity_select_company;
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
        title.setText(getString(R.string.company_login));
        back.setVisibility(View.GONE);
        refreshListView.setMode(Mode.DISABLED);
        refreshListViewHeader = LayoutInflater.from(getApplicationContext()).inflate(R.layout.refresh_select_company_header,null);
        refreshListView.getRefreshableView().addHeaderView(refreshListViewHeader,null,false);
        entities = new ArrayList<>();
        memberEntities = new ArrayList<>();
        memberEntities = getIntent().getStringArrayListExtra("AllCompany");
        for (int i=0;i<memberEntities.size();i++){
            MemberEntity entity = JsonUtil.ToEntity(memberEntities.get(i),MemberEntity.class);
            entities.add(entity);
        }
        adapter = new SelectCompanyAdapter(entities,getApplicationContext(),"login");
        refreshListView.setAdapter(adapter);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        refreshListView.setOnRefreshListener(this);
        refreshListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                SignInUtils.judgeStatus(SelectCompanyActivity.this,entities.get(i-2));
            }
        });
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
            default:
        }
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {

    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {

    }
}
