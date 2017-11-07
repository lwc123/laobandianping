package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.PersonalArchiveListAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.EmployeArchiveEntity;
import com.juxian.bosscomments.models.PrivatenessServiceContractEntity;
import com.juxian.bosscomments.models.ResultEntity;
import com.juxian.bosscomments.repositories.PrivatenessRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import handmark.pulltorefresh.library.PullToRefreshBase;
import handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * Created by nene on 2016/12/20.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/20 13:10]
 * @Version: [v1.0]
 */
public class PersonalArchiveListActivity extends RemoteDataActivity implements View.OnClickListener,PullToRefreshBase.OnRefreshListener2<ListView> {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView mRefreshListView;
    @BindView(R.id.show_or_not)
    RelativeLayout show_or_not;
    @BindView(R.id.archive_is_null)
    TextView archive_is_null;
    private View refreshListViewHeader;
    private List<EmployeArchiveEntity> entities;
    private PersonalArchiveListAdapter adapter;
    private TextView mArchiveNumber;
    private PrivatenessServiceContractEntity mPrivatenessServiceContractEntity;

    @Override
    public int getContentViewId() {
        return R.layout.activity_personal_archive_list;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.personal_my_archive));
        mRefreshListView.setMode(PullToRefreshBase.Mode.DISABLED);
        refreshListViewHeader = LayoutInflater.from(getApplicationContext()).inflate(R.layout.refresh_listview_footer,null);
        mRefreshListView.getRefreshableView().addHeaderView(refreshListViewHeader,null,false);
        mArchiveNumber = (TextView) refreshListViewHeader.findViewById(R.id.archive_number);
        TextView identity_number = (TextView) refreshListViewHeader.findViewById(R.id.identity_number);
        mPrivatenessServiceContractEntity = JsonUtil.ToEntity(AppConfig.getPersonalServiceContract(),PrivatenessServiceContractEntity.class);
        if (mPrivatenessServiceContractEntity != null) {
            identity_number.setText(mPrivatenessServiceContractEntity.IDCard);
        }
        show_or_not.setVisibility(View.GONE);
        entities = new ArrayList<>();
        adapter = new PersonalArchiveListAdapter(entities,getApplicationContext());
        mRefreshListView.setAdapter(adapter);
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
        mPrivatenessServiceContractEntity = JsonUtil.ToEntity(AppConfig.getPersonalServiceContract(),PrivatenessServiceContractEntity.class);
        GetPersonalMyArchives();
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mRefreshListView.setOnRefreshListener(this);
        mRefreshListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                if (mPrivatenessServiceContractEntity.ContractStatus == PrivatenessServiceContractEntity.Personal_Contract_Status_Effective){
                    Intent intent = new Intent(getApplicationContext(),WebViewDetailActivity.class);
                    intent.putExtra("DetailType","PersonalDetail");
                    intent.putExtra("ArchiveId", entities.get(i-2).ArchiveId);
                    startActivity(intent);
                } else {
                    Intent intent = new Intent(getApplicationContext(),PersonalOpenServiceActivity.class);
                    intent.putExtra("IDCard",mPrivatenessServiceContractEntity.IDCard);
                    intent.putExtra("ArchiveId",entities.get(i-2).ArchiveId);
                    startActivity(intent);
                }
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        IsReloadDataOnResume = true;
    }

    @Override
    public void onClick(View v) {
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

    private void GetPersonalMyArchives() {
        // 获取企业信息，根据之前保存的企业id查询
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<List<EmployeArchiveEntity>>() {
            @Override
            protected List<EmployeArchiveEntity> doInBackground(Void... params) {
                List<EmployeArchiveEntity> employeArchiveEntities = PrivatenessRepository.GetPersonalMyArchives();
                return employeArchiveEntities;
            }

            @Override
            protected void onPostExecute(List<EmployeArchiveEntity> employeArchiveEntities) {
                if (dialog != null)
                    dialog.dismiss();
                if (employeArchiveEntities != null) {
                    IsInitData = true;
                    if (employeArchiveEntities.size() != 0){
                        mArchiveNumber.setText("发现"+employeArchiveEntities.size()+"份您的工作档案");
                        entities.clear();
                        show_or_not.setVisibility(View.VISIBLE);
                        archive_is_null.setVisibility(View.GONE);
                        entities.addAll(employeArchiveEntities);
                        adapter.notifyDataSetChanged();
                    } else {
                        show_or_not.setVisibility(View.GONE);
                        archive_is_null.setVisibility(View.VISIBLE);
                    }
                } else {
                    onRemoteError();
                    show_or_not.setVisibility(View.GONE);
                    archive_is_null.setVisibility(View.VISIBLE);
                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }
}
