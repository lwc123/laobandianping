package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.ArchiveCommentListAdapter;
import com.juxian.bosscomments.adapter.SearchCRResultAdapter;
import com.juxian.bosscomments.adapter.SearchEmployeeAdapter;
import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.models.EmployeArchiveEntity;
import com.juxian.bosscomments.repositories.ArchiveCommentRepository;

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
 * Created by nene on 2016/11/28.
 * 查询结果页，评价、离任报告等的查询结果
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/28 13:54]
 * @Version: [v1.0]
 */
public class SearchCRResultActivity extends BaseActivity implements View.OnClickListener,PullToRefreshBase.OnRefreshListener2<ListView> {

    private InputMethodManager manager;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.activity_search)
    RelativeLayout mSearchBox;
    @BindView(R.id.activity_search_text)
    TextView mSearchText;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView mRefreshListView;
    @BindView(R.id.content_is_null)
    LinearLayout mContentIsNull;
    @BindView(R.id.content_is_null_content)
    TextView mContentIsNullContent;
    @BindView(R.id.show_or_not)
    RelativeLayout show_or_not;
    @BindView(R.id.input_hint)
    TextView mInputHint;
    private List<ArchiveCommentEntity> entities;
    private ArchiveCommentListAdapter adapter;
    private String mTag;
    private String SearchType;
    private String mSearchContent;
    private int mCommentType;
    private int pageIndex;

    @Override
    public int getContentViewId() {
        return R.layout.activity_search_employee_result;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        manager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
        initViewsData();
        initListener();
        setSystemBarTintManager(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
//        title.setText(getString(R.string.search_employee));
        SearchType = getIntent().getStringExtra(SearchEmployeeActivity.SEARCH_TYPE);
        mSearchContent = getIntent().getStringExtra("SearchContent");
        mInputHint.setText(mSearchContent);
        if ("SearchComment".equals(SearchType)){
            title.setText(getString(R.string.search_comment));
            mCommentType = 0;
        } else {
            title.setText(getString(R.string.search_report));
            mCommentType = 1;
        }
        pageIndex = 1;
        mRefreshListView.setMode(PullToRefreshBase.Mode.DISABLED);
        entities = new ArrayList<>();
        mTag = "ShowDetail";
        if ("SearchComment".equals(SearchType)){
            adapter = new ArchiveCommentListAdapter(entities,this,0);
        } else {
            adapter = new ArchiveCommentListAdapter(entities,this,1);
        }

        mRefreshListView.setAdapter(adapter);
        getSearchResult(AppConfig.getCurrentUseCompany(),mCommentType,mSearchContent,pageIndex,0);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mSearchBox.setOnClickListener(this);
        mSearchText.setOnClickListener(this);
        mRefreshListView.setOnRefreshListener(this);
        mRefreshListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                if ("SearchComment".equals(SearchType)){
                    Intent GoArchiveDetail = new Intent(getApplicationContext(), WebViewDetailActivity.class);
                    GoArchiveDetail.putExtra("DetailType","Comment");
                    GoArchiveDetail.putExtra("DetailId",entities.get(i-1).CommentId);
                    startActivity(GoArchiveDetail);
                } else {
                    Intent GoArchiveDetail = new Intent(getApplicationContext(), WebViewDetailActivity.class);
                    GoArchiveDetail.putExtra("DetailType","Report");
                    GoArchiveDetail.putExtra("DetailId",entities.get(i-1).CommentId);
                    startActivity(GoArchiveDetail);
                }
            }
        });
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        // TODO Auto-generated method stub
        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            if (getCurrentFocus() != null
                    && getCurrentFocus().getWindowToken() != null) {
                manager.hideSoftInputFromWindow(getCurrentFocus()
                        .getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
            }
        }
        return super.onTouchEvent(event);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.activity_search:
                backSearch();
                break;
            case R.id.activity_search_text:
                backSearch();
                break;
            default:
        }
    }

    public void backSearch(){
        if ("SearchComment".equals(SearchType)){
            // 查询员工阶段评价
            Intent SearchEmployee = new Intent(getApplicationContext(), SearchEmployeeActivity.class);
            SearchEmployee.putExtra(SearchEmployeeActivity.SEARCH_TYPE,"SearchComment");
            startActivity(SearchEmployee);
            finish();
        } else {
            // 查询员工离任报告
            Intent SearchEmployee = new Intent(getApplicationContext(), SearchEmployeeActivity.class);
            SearchEmployee.putExtra(SearchEmployeeActivity.SEARCH_TYPE, "SearchReport");
            startActivity(SearchEmployee);
            finish();
        }
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex = 1;
        getSearchResult(AppConfig.getCurrentUseCompany(),mCommentType,mSearchContent,pageIndex,0);
    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex++;
        getSearchResult(AppConfig.getCurrentUseCompany(),mCommentType,mSearchContent,pageIndex,1);
    }

    private void getSearchResult(final long companyId,final int CommentType,final String RealName,final int page,final int tag) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<List<ArchiveCommentEntity>>() {
            @Override
            protected List<ArchiveCommentEntity> doInBackground(Void... params) {
                List<ArchiveCommentEntity> commentList = ArchiveCommentRepository.getSearchResult(companyId,CommentType,RealName,page);
                return commentList;
            }

            @Override
            protected void onPostExecute(List<ArchiveCommentEntity> commentList) {
                if (dialog != null)
                    dialog.dismiss();
                if (commentList != null) {
//                    ToastUtil.showInfo("获取成功");
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
                            // 下拉刷新
                            entities.clear();
                            entities.addAll(commentList);
                            adapter.notifyDataSetChanged();
                        }
                        show_or_not.setVisibility(View.GONE);
                        mContentIsNull.setVisibility(View.VISIBLE);
                        if ("SearchComment".equals(SearchType)){
                            mContentIsNullContent.setText("没有找到员工的阶段评价");
                        } else {
                            mContentIsNullContent.setText("没有找到员工的离任报告");
                        }
                    }
//                    mRefreshListView.setAdapter(adapter);
                } else {
//                    ToastUtil.showInfo("暂无数据");
                    show_or_not.setVisibility(View.GONE);
                    mContentIsNull.setVisibility(View.VISIBLE);
                    if ("SearchComment".equals(SearchType)){
                        mContentIsNullContent.setText("没有找到员工的阶段评价");
                    } else {
                        mContentIsNullContent.setText("没有找到员工的离任报告");
                    }
                }
                mRefreshListView.onRefreshComplete();
            }

            protected void onPostError(Exception ex) {
                mRefreshListView.onRefreshComplete();
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }
}
