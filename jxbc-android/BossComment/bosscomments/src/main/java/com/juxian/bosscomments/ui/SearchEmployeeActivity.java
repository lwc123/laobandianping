package com.juxian.bosscomments.ui;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.juxian.bosscomments.R;
import net.juxian.appgenome.widget.ToastUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/11/28.
 * 纯查询页面
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/28 13:54]
 * @Version: [v1.0]
 */
public class SearchEmployeeActivity extends BaseActivity implements View.OnClickListener {

    private InputMethodManager manager;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.activity_search_edit)
    EditText mSearchEdit;
    @BindView(R.id.activity_search_clean)
    TextView mSearch;
    @BindView(R.id.delete)
    ImageView mDelete;
    public static final String SEARCH_TYPE = "SearchType";
    private Intent mIntent;
    private String SearchType;

    @Override
    public int getContentViewId() {
        return R.layout.activity_search_employee;
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
        mIntent = getIntent();
        SearchType = mIntent.getStringExtra(SEARCH_TYPE);
        if ("SearchCity".equals(SearchType)){
            title.setText(getString(R.string.search_city));
            mSearchEdit.setHint("请输入城市名称");
        } else if ("SearchComment".equals(SearchType)){
            title.setText(getString(R.string.search_comment));
            mSearchEdit.setHint("请输入员工姓名");
        } else if ("SearchReport".equals(SearchType)){
            title.setText(getString(R.string.search_report));
            mSearchEdit.setHint("请输入员工姓名");
        } else {
            title.setText(getString(R.string.search_employee));
            mSearchEdit.setHint("请输入员工姓名");
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mSearch.setOnClickListener(this);
        mDelete.setOnClickListener(this);
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
                if (number>0){
                    mDelete.setVisibility(View.VISIBLE);
                } else {
                    mDelete.setVisibility(View.GONE);
                }
            }
        });
        mSearchEdit.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView textView, int i, KeyEvent keyEvent) {
                if (i == EditorInfo.IME_ACTION_SEARCH){
                    if ("SearchCity".equals(SearchType)){
                        Intent ToResult = new Intent(getApplicationContext(),SearchCityResultActivity.class);
                        ToResult.putExtra("SearchContent",mSearchEdit.getText().toString().trim());
                        ToResult.putExtra(SEARCH_TYPE,SearchType);
                        startActivity(ToResult);
                        finish();
                    } else if ("SearchComment".equals(SearchType)){
                        Intent ToResult = new Intent(getApplicationContext(),SearchCRResultActivity.class);
                        ToResult.putExtra("SearchContent",mSearchEdit.getText().toString().trim());
                        ToResult.putExtra(SEARCH_TYPE,SearchType);
                        startActivity(ToResult);
                        finish();
                    } else if ("SearchReport".equals(SearchType)){
                        Intent ToResult = new Intent(getApplicationContext(),SearchCRResultActivity.class);
                        ToResult.putExtra("SearchContent",mSearchEdit.getText().toString().trim());
                        ToResult.putExtra(SEARCH_TYPE,SearchType);
                        startActivity(ToResult);
                        finish();
                    } else {
                        // 查询档案
                        Intent ToResult = new Intent(getApplicationContext(),SearchEmployeeResultActivity.class);
                        ToResult.putExtra("SearchContent",mSearchEdit.getText().toString().trim());
                        ToResult.putExtra(SEARCH_TYPE,SearchType);
                        if ("SelectArchive".equals(getIntent().getStringExtra("ArchiveList"))){
                            ToResult.putExtra("ArchiveList", "ReturnArchive");
                        }
                        startActivity(ToResult);
                        finish();
                    }
                    return true;
                }
                return false;
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
            case R.id.activity_search_clean:
//                ToastUtil.showInfo("搜索");
                if (TextUtils.isEmpty(mSearchEdit.getText().toString().trim())){
                    ToastUtil.showInfo(getString(R.string.please_input_search_content));
                    return;
                }
                // 搜索跳到档案列表结果页、评价列表结果页、离任报告列表结果页、城市结果页
                if ("SearchCity".equals(SearchType)){
                    Intent ToResult = new Intent(getApplicationContext(),SearchCityResultActivity.class);
                    ToResult.putExtra(SEARCH_TYPE,SearchType);
                    ToResult.putExtra("SearchContent",mSearchEdit.getText().toString().trim());
                    startActivity(ToResult);
                    finish();
                } else if ("SearchComment".equals(SearchType)){
                    Intent ToResult = new Intent(getApplicationContext(),SearchCRResultActivity.class);
                    ToResult.putExtra("SearchContent",mSearchEdit.getText().toString().trim());
                    ToResult.putExtra(SEARCH_TYPE,SearchType);
                    startActivity(ToResult);
                    finish();
                } else if ("SearchReport".equals(SearchType)){
                    Intent ToResult = new Intent(getApplicationContext(),SearchCRResultActivity.class);
                    ToResult.putExtra("SearchContent",mSearchEdit.getText().toString().trim());
                    ToResult.putExtra(SEARCH_TYPE,SearchType);
                    startActivity(ToResult);
                    finish();
                } else {
                    // 查询档案
                    Intent ToResult = new Intent(getApplicationContext(),SearchEmployeeResultActivity.class);
                    ToResult.putExtra("SearchContent",mSearchEdit.getText().toString().trim());
                    ToResult.putExtra(SEARCH_TYPE,SearchType);
                    if ("SelectArchive".equals(getIntent().getStringExtra("ArchiveList"))){
                        ToResult.putExtra("ArchiveList", "ReturnArchive");
                        ToResult.putExtra("CommentType", getIntent().getStringExtra("CommentType"));
                    }
                    startActivity(ToResult);
                    finish();
                }
                break;
            case R.id.delete:
                mSearchEdit.setText("");
                break;
            default:
        }
    }
}
