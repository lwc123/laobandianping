package com.juxian.bosscomments.ui;

import android.content.Intent;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.SearchCompanyAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.CCompanyEntity;
import com.juxian.bosscomments.repositories.CompanyReputationRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtils;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import handmark.pulltorefresh.library.PullToRefreshBase;
import handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * Created by nene on 2017/4/20.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/20 15:23]
 * @Version: [v1.0]
 */
public class SearchCompanyActivity extends RemoteDataActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.activity_search_edit)
    EditText mSearchEdit;
    @BindView(R.id.delete)
    ImageView mDelete;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView mRefreshListView;
    @BindView(R.id.show_or_not)
    RelativeLayout mIsShowListView;
    @BindView(R.id.content_is_null)
    LinearLayout mContentIsNull;
    @BindView(R.id.add)
    TextView mCreateCompany;
    private View headerView;
    private TextView headerContent;
    private SearchCompanyAdapter searchCompanyAdapter;
    private List<CCompanyEntity> entities;

    @Override
    public int getContentViewId() {
        return R.layout.activity_search_company;
    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);
        setSystemBarTintManager(this);
        initViewsData();
        initListener();
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText("搜索公司");
        entities = new ArrayList<>();
        mSearchEdit.setHint("请输入您想要点评的公司");
        headerView = LayoutInflater.from(this).inflate(R.layout.include_search_company_header, null);
        headerContent = (TextView) headerView.findViewById(R.id.header_content);
        headerContent.setText("您可以点评一下老东家");
        mRefreshListView.getRefreshableView().addHeaderView(headerView, null, false);
        mRefreshListView.setMode(PullToRefreshBase.Mode.DISABLED);

        searchCompanyAdapter = new SearchCompanyAdapter(entities, getApplicationContext());
        mRefreshListView.setAdapter(searchCompanyAdapter);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mDelete.setOnClickListener(this);
        mCreateCompany.setOnClickListener(this);
        mSearchEdit.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void afterTextChanged(Editable editable) {
                int number = editable.length();
                if (number > 0) {
                    mDelete.setVisibility(View.VISIBLE);
                } else {
                    mDelete.setVisibility(View.GONE);
                }
                if (number == 0) {
                    getSearchList("");
                }
                if (number >= 2) {
                    getSearchList(mSearchEdit.getText().toString().trim());
                }
            }
        });
        mRefreshListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
//                ToastUtil.showInfo(""+i);
                Intent intent = new Intent(getApplicationContext(), CompanyCircleWebViewActivity.class);
                intent.putExtra("WebViewType", "OpinionCreate");
                intent.putExtra("CompanyId", entities.get(i - 2).CompanyId);
                intent.putExtra("CompanyName", entities.get(i - 2).CompanyName);
                startActivity(intent);
                finish();
            }
        });
    }

    @Override
    public void loadPageData() {
        getSearchList("");
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.delete:
                mSearchEdit.setText("");
                break;
            case R.id.add:
                Intent intent = new Intent(this, OpenServiceActivity.class);
                intent.putExtra(Global.LISTVIEW_ITEM_TAG, "change");
                startActivity(intent);
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 100:
                if (resultCode == RESULT_OK) {
                    setResult(RESULT_OK);
                    finish();
                }
                break;
        }
    }

    private void getSearchList(final String Keyword) {
//        DialogUtils.showLoadingDialog();
        new AsyncRunnable<List<CCompanyEntity>>() {
            @Override
            protected List<CCompanyEntity> doInBackground(Void... params) {
                List<CCompanyEntity> CCompanyEntities = CompanyReputationRepository.getSearchList(Keyword);
                return CCompanyEntities;
            }

            @Override
            protected void onPostExecute(List<CCompanyEntity> CCompanyEntities) {
//                DialogUtils.hideLoadingDialog();
                if (CCompanyEntities != null) {
                    IsInitData = true;
                    if (CCompanyEntities.size() != 0) {
                        mIsShowListView.setVisibility(View.VISIBLE);
                        mContentIsNull.setVisibility(View.GONE);
                        if (TextUtils.isEmpty(Keyword)) {
                            headerContent.setVisibility(View.VISIBLE);
                        } else {
                            headerContent.setVisibility(View.GONE);
                        }
                        entities.clear();
                        entities.addAll(CCompanyEntities);
                        searchCompanyAdapter.notifyDataSetChanged();
                    } else {
                        if (TextUtils.isEmpty(Keyword)) {
                            entities.clear();
                            searchCompanyAdapter.notifyDataSetChanged();
                            headerContent.setVisibility(View.VISIBLE);
                            headerContent.setText("搜下您的老东家，看看对他的评价");
                            mIsShowListView.setVisibility(View.VISIBLE);
                            mContentIsNull.setVisibility(View.GONE);
                        } else {
                            mIsShowListView.setVisibility(View.GONE);
                            mContentIsNull.setVisibility(View.VISIBLE);
                        }
                    }
                } else {
                }
                mRefreshListView.onRefreshComplete();
            }

            protected void onPostError(Exception ex) {
                mRefreshListView.onRefreshComplete();
//                DialogUtils.hideLoadingDialog();
            }
        }.execute();
    }
}
