package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.ChangeListAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.models.EmployeArchiveEntity;
import com.juxian.bosscomments.repositories.ArchiveCommentRepository;
import com.juxian.bosscomments.repositories.EmployeArchiveRepository;

import net.juxian.appgenome.ActivityManager;
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
 * Created by nene on 2016/12/1.
 * 修改档案或离任报告列表
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/1 16:11]
 * @Version: [v1.0]
 */
public class ChangeListActivity extends RemoteDataActivity implements View.OnClickListener, PullToRefreshBase.OnRefreshListener2<ListView> {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView mRefreshListView;
    private View refreshListViewHeader;
    private ChangeListAdapter adapter;
    private List<ArchiveCommentEntity> entities;
    private long ArchiveId;
    private TextView content_hint;
    private Dialog dialog;

    @Override
    public int getContentViewId() {
        return R.layout.activity_change_list;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.change));
        ArchiveId = getIntent().getLongExtra("ArchiveId", 0);
        mRefreshListView.setMode(PullToRefreshBase.Mode.DISABLED);
        refreshListViewHeader = LayoutInflater.from(getApplicationContext()).inflate(R.layout.refresh_listview_header, null);
        mRefreshListView.getRefreshableView().addHeaderView(refreshListViewHeader, null, false);
        content_hint = (TextView) refreshListViewHeader.findViewById(R.id.content_hint);
        entities = new ArrayList<>();
        adapter = new ChangeListAdapter(entities, getApplicationContext());
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
        getArhciveDetail(AppConfig.getCurrentUseCompany(), ArchiveId);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mRefreshListView.setOnRefreshListener(this);
        mRefreshListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                ArchiveCommentEntity entity = entities.get(i - 2);
                if (entity.CommentType == 0) {
                    Intent Change = new Intent(getApplicationContext(), AddBossCommentActivity.class);
                    Change.putExtra("Tag", "Have");
                    Change.putExtra("Operation", "Change");
                    Change.putExtra("CommentId", entity.CommentId);
                    startActivity(Change);
                } else {
                    Intent Change = new Intent(getApplicationContext(), AddDepartureReportActivity.class);
                    Change.putExtra("Tag", "Have");
                    Change.putExtra("Operation", "Change");
                    Change.putExtra("CommentId", entity.CommentId);
                    startActivity(Change);
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
        switch (v.getId()) {
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

    private void getAllComments(final long CompanyId, final long ArchiveId, final Dialog dialog) {
        new AsyncRunnable<List<ArchiveCommentEntity>>() {
            @Override
            protected List<ArchiveCommentEntity> doInBackground(Void... params) {
                List<ArchiveCommentEntity> commentList = ArchiveCommentRepository.getAllComments(CompanyId, ArchiveId);
                return commentList;
            }

            @Override
            protected void onPostExecute(List<ArchiveCommentEntity> commentList) {
                if (dialog.isShowing())
                    dialog.dismiss();
                if (commentList != null) {
                    IsInitData = true;
//                    content_hint.setText("选择" + commentList.get(0).EmployeArchive.RealName + "的评价/离任报告修改");
                    entities.clear();
                    entities.addAll(commentList);
                    adapter.notifyDataSetChanged();
                } else {
                    onRemoteError();
                }
            }

            protected void onPostError(Exception ex) {
                if (dialog.isShowing())
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }

    public void getArhciveDetail(final long CompanyId,final long ArchiveId){
        dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<EmployeArchiveEntity>() {
            @Override
            protected EmployeArchiveEntity doInBackground(Void... params) {
                EmployeArchiveEntity entity = EmployeArchiveRepository.getArchiveDetail(CompanyId,ArchiveId);
                return entity;
            }

            @Override
            protected void onPostExecute(EmployeArchiveEntity entity) {
                if (entity!=null){
                    if (TextUtils.isEmpty(entity.RealName)){

                    } else {
                        content_hint.setText("选择" + entity.RealName + "的评价/离任报告修改");
                    }
                    getAllComments(CompanyId, ArchiveId, dialog);
                } else {
                    if (dialog.isShowing())
                        dialog.dismiss();
                    onRemoteError();
                }
            }

            protected void onPostError(Exception ex) {
                if (dialog.isShowing())
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }
}
