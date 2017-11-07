package com.juxian.bosscomments.ui;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import handmark.pulltorefresh.library.PullToRefreshBase;
import handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import handmark.pulltorefresh.library.PullToRefreshListView;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.MySearchRecordAdapter;
import com.juxian.bosscomments.adapter.SearchResultAdapter;
import com.juxian.bosscomments.common.Global;

import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/10/25.
 *
 * @ProjectName: [LaoBanDianPing]
 * @Package: [com.juxian.bosscomments.ui]
 * @Description: 现在已无用
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/25 14:11]
 * @Version: [v1.0]
 */
public class MyAddCommentsActivity extends BaseActivity implements OnRefreshListener2<ListView>,View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView refreshListView;
    private List<String> entities;
    private SearchResultAdapter adapter;

    @Override
    public int getContentViewId() {
        return R.layout.activity_my_search_record;
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
        title.setText(getString(R.string.my_add_comments_title));
        refreshListView.setMode(PullToRefreshBase.Mode.DISABLED);
//        entities = new ArrayList<>();
//        for (int i=0;i<9;i++){
//            entities.add(i+"");
//        }
//        adapter = new SearchResultAdapter(entities,getApplicationContext());
//        refreshListView.setAdapter(adapter);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        refreshListView.setOnRefreshListener(this);
        refreshListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                // item的位置是从1开始
                Log.e(Global.LOG_TAG,i+"");
                ToastUtil.showInfo(""+i);
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
        }
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {

    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {

    }
}
