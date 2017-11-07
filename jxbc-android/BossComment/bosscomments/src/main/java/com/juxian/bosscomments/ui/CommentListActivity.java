package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.ArchiveCommentListAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.repositories.ArchiveCommentRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.DialogUtils;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import handmark.pulltorefresh.library.PullToRefreshBase;
import handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * Created by nene on 2016/12/1.
 * 阶段评价列表页面，查询值返回回来之后，在此页面调用接口查询结果。离任报告页面一样
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/1 17:00]
 * @Version: [v1.0]
 */
public class CommentListActivity extends RemoteDataActivity implements View.OnClickListener, PullToRefreshBase.OnRefreshListener2<ListView> {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.content_is_null)
    LinearLayout mContentIsNull;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView mRefreshListView;
    @BindView(R.id.null_hint)
    TextView mNullHint;
    @BindView(R.id.add)
    Button mAdd;
    @BindView(R.id.include_head_title_tab2)
    TextView mAddCommentText;
    @BindView(R.id.include_head_title_re1)
    RelativeLayout mAddComment;
    @BindView(R.id.activity_search)
    RelativeLayout mSearchBox;
    @BindView(R.id.activity_search_text)
    TextView mSearchText;
    @BindView(R.id.show_or_not)
    RelativeLayout show_or_not;
    private List<ArchiveCommentEntity> entities;
    private ArchiveCommentListAdapter adapter;
    private int pageIndex = 1;

    @Override
    public int getContentViewId() {
        return R.layout.activity_comment_or_report_list;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void loadPageData() {
        pageIndex = 1;
        getSearchResult(AppConfig.getCurrentUseCompany(), 0, "", pageIndex, 0);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.employee_evaluate));
        mNullHint.setText(getString(R.string.null_employee_evaluate));
        mAddCommentText.setText(getString(R.string.add));
        mAddComment.setVisibility(View.VISIBLE);
        mAddCommentText.setVisibility(View.VISIBLE);
        mAdd.setText(getString(R.string.add_employee_evaluate));
        mRefreshListView.setMode(PullToRefreshBase.Mode.BOTH);

        entities = new ArrayList<>();
        adapter = new ArchiveCommentListAdapter(entities, getApplicationContext(), 0);
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
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mRefreshListView.setOnRefreshListener(this);
        mAdd.setOnClickListener(this);
        mAddComment.setOnClickListener(this);
        mSearchBox.setOnClickListener(this);
        mSearchText.setOnClickListener(this);
        mRefreshListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                Intent GoArchiveDetail = new Intent(getApplicationContext(), WebViewDetailActivity.class);
                GoArchiveDetail.putExtra("DetailType", "Comment");
                GoArchiveDetail.putExtra("archiveCommentEntity", JsonUtil.ToJson(entities.get(i - 1)));
                GoArchiveDetail.putExtra("ArchiveId", entities.get(i - 1).ArchiveId);
                GoArchiveDetail.putExtra("DetailId", entities.get(i - 1).CommentId);
                startActivity(GoArchiveDetail);
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        IsReloadDataOnResume = true;
//        checkNetStatus();
//        getSearchResult(AppConfig.getCurrentUseCompany(), 0, "", pageIndex, 0);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_head_title_re1:
                Intent AddEmployeeComments = new Intent(getApplicationContext(), AddBossCommentActivity.class);
                AddEmployeeComments.putExtra("Tag", "Null");
                startActivity(AddEmployeeComments);
                break;
            case R.id.add:
                Intent AddEmployeeComments1 = new Intent(getApplicationContext(), AddBossCommentActivity.class);
                AddEmployeeComments1.putExtra("Tag", "Null");
                startActivity(AddEmployeeComments1);
                break;
            case R.id.activity_search:
                Intent SearchEmployee = new Intent(getApplicationContext(), SearchEmployeeActivity.class);
                SearchEmployee.putExtra(SearchEmployeeActivity.SEARCH_TYPE, "SearchComment");
                startActivity(SearchEmployee);
                break;
            case R.id.activity_search_text:
                Intent SearchEmployee1 = new Intent(getApplicationContext(), SearchEmployeeActivity.class);
                SearchEmployee1.putExtra(SearchEmployeeActivity.SEARCH_TYPE, "SearchComment");
                startActivity(SearchEmployee1);
                break;
        }
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex = 1;
        getSearchResult(AppConfig.getCurrentUseCompany(), 0, "", pageIndex, 0);
    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex++;
        getSearchResult(AppConfig.getCurrentUseCompany(), 0, "", pageIndex, 1);
    }

    private void getSearchResult(final long companyId, final int CommentType, final String RealName, final int page, final int tag) {
//        if (dialogIndex<1) {
//            dialog = DialogUtil.showLoadingDialog();
//        }
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<List<ArchiveCommentEntity>>() {
            @Override
            protected List<ArchiveCommentEntity> doInBackground(Void... params) {
                List<ArchiveCommentEntity> commentList = ArchiveCommentRepository.getSearchResult(companyId, CommentType, RealName, page);
                return commentList;
            }

            @Override
            protected void onPostExecute(List<ArchiveCommentEntity> commentList) {
                IsInitData = true;
                if (dialog != null)
                    dialog.dismiss();
                if (commentList != null) {

                    if (commentList.size() != 0) {
                        if (tag == 0) {
                            // 下拉刷新
                            entities.clear();
                        }
                        entities.addAll(commentList);
                        show_or_not.setVisibility(View.VISIBLE);
                        mContentIsNull.setVisibility(View.GONE);
                        adapter.notifyDataSetChanged();
                    } else {
                        if (tag == 0) {
                            entities.clear();
                            entities.addAll(commentList);
                            adapter.notifyDataSetChanged();
                        } else {
                            ToastUtil.showInfo("暂无更多阶段评价");
                        }
                        if (entities.size() == 0) {
                            show_or_not.setVisibility(View.GONE);
                            mContentIsNull.setVisibility(View.VISIBLE);
                            mNullHint.setText("还没有阶段工作评价");
                        }
                    }
//                    mRefreshListView.setAdapter(adapter);
                } else {
//                    ToastUtil.showInfo("暂无数据");
                    if (tag == 0) {
                        show_or_not.setVisibility(View.GONE);
                        mContentIsNull.setVisibility(View.VISIBLE);
                        mNullHint.setText("还没有阶段工作评价");
                    } else {
                        ToastUtil.showInfo("暂无更多阶段评价");
                    }
                }
                mRefreshListView.onRefreshComplete();
            }

            protected void onPostError(Exception ex) {
//                ToastUtil.showError(getString(R.string.net_false_hint));
                mRefreshListView.onRefreshComplete();
                onRemoteError();
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }
}
