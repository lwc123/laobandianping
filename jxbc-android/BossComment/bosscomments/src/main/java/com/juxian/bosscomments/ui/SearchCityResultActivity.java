package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.SearchCityAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.BizDictEntity;
import com.juxian.bosscomments.modules.DictionaryPool;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import handmark.pulltorefresh.library.PullToRefreshBase;
import handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * Created by nene on 2016/11/28.
 * 查询结果页，显示查询城市结果
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/28 13:54]
 * @Version: [v1.0]
 */
public class SearchCityResultActivity extends BaseActivity implements View.OnClickListener,PullToRefreshBase.OnRefreshListener2<ListView> {

    private InputMethodManager manager;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.activity_search)
    RelativeLayout mSearchBox;
    @BindView(R.id.activity_search_text)
    TextView mSearchText;
    @BindView(R.id.input_hint)
    TextView mSearchContent;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView mRefreshListView;
    @BindView(R.id.content_is_null)
    TextView content_is_null;
    @BindView(R.id.show_or_not)
    RelativeLayout show_or_not;
    private List<BizDictEntity> citys;
    private SearchCityAdapter adapter;
    private String SearchType;
    private String SearchContent;

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
        title.setText(getString(R.string.select_city));
        SearchType = getIntent().getStringExtra(SearchEmployeeActivity.SEARCH_TYPE);
        SearchContent = getIntent().getStringExtra("SearchContent");
        mSearchContent.setText(SearchContent);
        mRefreshListView.setMode(PullToRefreshBase.Mode.DISABLED);
        citys = new ArrayList<>();
        adapter = new SearchCityAdapter(citys,getApplicationContext());
        mRefreshListView.setAdapter(adapter);
        getTags(SearchContent);
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
                Intent intent = new Intent("SelectCityActivity");
                intent.putExtra("city",citys.get(i-1).Name);
                intent.putExtra("CityCode",citys.get(i-1).Code);
                sendBroadcast(intent);
                finish();
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
                Intent SearchEmployee = new Intent(getApplicationContext(), SearchEmployeeActivity.class);
                SearchEmployee.putExtra(SearchEmployeeActivity.SEARCH_TYPE,SearchType);
                startActivity(SearchEmployee);
                finish();
                break;
            case R.id.activity_search_text:
                Intent SearchEmployee1 = new Intent(getApplicationContext(), SearchEmployeeActivity.class);
                SearchEmployee1.putExtra(SearchEmployeeActivity.SEARCH_TYPE,SearchType);
                startActivity(SearchEmployee1);
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

    public void getTags(final String SearchContent) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<HashMap<String, List<BizDictEntity>>>() {

            @Override
            protected HashMap<String, List<BizDictEntity>> doInBackground(Void... params) {
                HashMap<String, List<BizDictEntity>> entities = DictionaryPool.loadCityDictionaries();
                return entities;
            }

            @Override
            protected void onPostExecute(HashMap<String, List<BizDictEntity>> entities) {
                if (dialog != null)
                    dialog.dismiss();
                if (entities != null){
                    for (int i=0;i<entities.get(DictionaryPool.Code_City).size();i++){
                        if (entities.get(DictionaryPool.Code_City).get(i).RelativeKeys.contains(SearchContent)){
                            citys.add(entities.get(DictionaryPool.Code_City).get(i));
                        }
                    }
                    if (citys.size() == 0){
                        content_is_null.setVisibility(View.VISIBLE);
                        show_or_not.setVisibility(View.GONE);
                        content_is_null.setText("没有找到您搜索的城市");
                    } else {
                        content_is_null.setVisibility(View.GONE);
                        show_or_not.setVisibility(View.VISIBLE);
                    }
                    adapter.notifyDataSetChanged();
                } else {

                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
            }

        }.execute();
    }
}
