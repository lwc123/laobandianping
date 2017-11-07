package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.SearchEmployeeAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.models.EmployeArchiveEntity;
import com.juxian.bosscomments.repositories.ArchiveCommentRepository;
import com.juxian.bosscomments.repositories.EmployeArchiveRepository;

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
 * 查询结果页，显示对档案的查询结果
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/28 13:54]
 * @Version: [v1.0]
 */
public class SearchEmployeeResultActivity extends BaseActivity implements View.OnClickListener,PullToRefreshBase.OnRefreshListener2<ListView> {

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
    @BindView(R.id.show_or_not)
    RelativeLayout show_or_not;
    @BindView(R.id.content_is_null)
    LinearLayout content_is_null;
    @BindView(R.id.content_is_null_content)
    TextView content_is_null_content;
    @BindView(R.id.input_hint)
    TextView mInputHint;
    private List<EmployeArchiveEntity> entities;
    private SearchEmployeeAdapter adapter;
    private String mTag;
    private String mSearchContent;
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
        title.setText(getString(R.string.search_employee));
        mRefreshListView.setMode(PullToRefreshBase.Mode.BOTH);
        entities = new ArrayList<>();
//        mTag = "ShowDetail";
        if (TextUtils.isEmpty(getIntent().getStringExtra("ArchiveList"))){
            mTag = "ShowDetail";
        } else {
            mTag = "ReturnArchive";
        }
        adapter = new SearchEmployeeAdapter(entities,this,mTag,getIntent().getStringExtra("CommentType"));
        mRefreshListView.setAdapter(adapter);
        mSearchContent = getIntent().getStringExtra("SearchContent");
        mInputHint.setText(mSearchContent);
        pageIndex = 1;
        getSearchResult(AppConfig.getCurrentUseCompany(),mSearchContent,pageIndex,0);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mSearchBox.setOnClickListener(this);
        mSearchText.setOnClickListener(this);
        mRefreshListView.setOnRefreshListener(this);
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
                // 查询员工档案
                Intent SearchEmployee = new Intent(getApplicationContext(), SearchEmployeeActivity.class);
                SearchEmployee.putExtra(SearchEmployeeActivity.SEARCH_TYPE,"SearchEmployee");
                if ("ReturnArchive".equals(getIntent())){
                    SearchEmployee.putExtra("ArchiveList", "SelectArchive");
                    SearchEmployee.putExtra("CommentType", getIntent().getStringExtra("CommentType"));
                }
                startActivity(SearchEmployee);
                finish();
                break;
            case R.id.activity_search_text:
                Intent SearchEmployee1 = new Intent(getApplicationContext(), SearchEmployeeActivity.class);
                SearchEmployee1.putExtra(SearchEmployeeActivity.SEARCH_TYPE,"SearchEmployee");
                if ("ReturnArchive".equals(getIntent())){
                    SearchEmployee1.putExtra("ArchiveList", "SelectArchive");
                    SearchEmployee1.putExtra("CommentType", getIntent().getStringExtra("CommentType"));
                }
                startActivity(SearchEmployee1);
                finish();
                break;
            default:
        }
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex = 1;
        getSearchResult(AppConfig.getCurrentUseCompany(),mSearchContent,pageIndex,0);
    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex++;
        getSearchResult(AppConfig.getCurrentUseCompany(),mSearchContent,pageIndex,1);
    }

    private void getSearchResult(final long companyId,final String RealName,final int page,final int tag) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<List<EmployeArchiveEntity>>() {
            @Override
            protected List<EmployeArchiveEntity> doInBackground(Void... params) {
                List<EmployeArchiveEntity> EmployeArchiveEntityList = EmployeArchiveRepository.getSearchResult(companyId,RealName,page);
                return EmployeArchiveEntityList;
            }

            @Override
            protected void onPostExecute(List<EmployeArchiveEntity> EmployeArchiveEntityList) {
                if (dialog != null)
                    dialog.dismiss();
                if (EmployeArchiveEntityList != null){
                    if (EmployeArchiveEntityList.size() != 0) {
                        if (tag == 0) {
                            entities.clear();
                        }
                        entities.addAll(EmployeArchiveEntityList);
                        adapter.notifyDataSetChanged();
                        show_or_not.setVisibility(View.VISIBLE);
                        content_is_null.setVisibility(View.GONE);
                    } else {
                        if (tag == 0) {
                            entities.clear();
                            entities.addAll(EmployeArchiveEntityList);
                            adapter.notifyDataSetChanged();
                        }
                        if(entities.size() == 0) {
                            show_or_not.setVisibility(View.GONE);
                            content_is_null.setVisibility(View.VISIBLE);
                            content_is_null_content.setText("没有找到你需要的员工");
                        }
                    }
                } else {
                    show_or_not.setVisibility(View.GONE);
                    content_is_null.setVisibility(View.VISIBLE);
                    content_is_null_content.setText("没有找到你需要的员工");
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
