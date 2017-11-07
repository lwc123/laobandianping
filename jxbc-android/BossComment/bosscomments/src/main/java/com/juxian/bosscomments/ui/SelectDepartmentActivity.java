package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.TagAdapter;
import com.juxian.bosscomments.models.DepartmentEntity;
import com.juxian.bosscomments.repositories.DepartmentRepository;
import com.juxian.bosscomments.widget.FlowLayout;
import com.juxian.bosscomments.widget.TagFlowLayout;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/11/22.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/22 18:50]
 * @Version: [v1.0]
 */
public class SelectDepartmentActivity extends BaseActivity implements View.OnClickListener {

    private InputMethodManager manager;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.id_flowlayout)
    TagFlowLayout mFlowLayout;
    @BindView(R.id.input_department_name)
    EditText mInputDepartmentName;
    @BindView(R.id.include_button_button)
    Button mComplete;
    private List<String> mVals;
    private LayoutInflater mInflater;
    private TagAdapter adapter;

    @Override
    public int getContentViewId() {
        return R.layout.activity_select_department;
    }

    private Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            mFlowLayout.setAdapter(new TagAdapter<String>((String[]) msg.obj) {
                @Override
                public View getView(FlowLayout parent, int position, String s) {
                    TextView tv = (TextView) mInflater.inflate(
                            R.layout.flow_city_tv, mFlowLayout, false);
                    LinearLayout.LayoutParams params = new LinearLayout.LayoutParams((getMetrics().widthPixels-dp2px(88))/3, LinearLayout.LayoutParams.WRAP_CONTENT);
                    params.leftMargin = dp2px(11);
                    params.rightMargin = dp2px(11);
                    params.topMargin = dp2px(10);
                    params.bottomMargin = dp2px(10);
                    tv.setPadding(0,dp2px(6),0,dp2px(6));
                    tv.setLayoutParams(params);
                    tv.setText(s);
                    return tv;
                }
            });
        }
    };

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
        mInflater = LayoutInflater.from(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.select_department_title));
        mComplete.setText(getString(R.string.complete));
        mVals = new ArrayList<>();
        adapter = new TagAdapter<String>(mVals) {
            @Override
            public View getView(FlowLayout parent, int position, String s) {
                TextView tv = (TextView) mInflater.inflate(
                        R.layout.flow_city_tv, mFlowLayout, false);
                LinearLayout.LayoutParams params = new LinearLayout.LayoutParams((getMetrics().widthPixels-dp2px(88))/3, LinearLayout.LayoutParams.WRAP_CONTENT);
                params.leftMargin = dp2px(11);
                params.rightMargin = dp2px(11);
                params.topMargin = dp2px(10);
                params.bottomMargin = dp2px(10);
                tv.setPadding(0,dp2px(6),0,dp2px(6));
                tv.setLayoutParams(params);
                tv.setText(s);
                return tv;
            }
        };
        mFlowLayout.setAdapter(adapter);
    }

    @Override
    protected void onResume() {
        super.onResume();
        getDepartmentList(AppConfig.getCurrentUseCompany());
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mComplete.setOnClickListener(this);
        mFlowLayout.setOnTagClickListener(new TagFlowLayoutOnTagClickListener());
    }

    class TagFlowLayoutOnTagClickListener implements TagFlowLayout.OnTagClickListener {

        @Override
        public boolean onTagClick(View view, int position, FlowLayout parent) {
//            saveHistory(mVals[position]);
            Intent intent = getIntent();
            intent.putExtra("department",mVals.get(position));
            setResult(RESULT_OK,intent);
            finish();
            return true;
        }
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
        switch (v.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_button_button:
                if (TextUtils.isEmpty(mInputDepartmentName.getText().toString().trim())){
                    ToastUtil.showInfo(getString(R.string.please_input_department_name));
                    return;
                }
                if (mInputDepartmentName.getText().toString().trim().length()>20){
                    ToastUtil.showInfo(getString(R.string.input_department_name_length_limit));
                    return;
                }
                Intent intent = getIntent();
                intent.putExtra("department",mInputDepartmentName.getText().toString().trim());
                setResult(RESULT_OK,intent);
                finish();
                break;
            default:
        }
    }

    protected void getDepartmentList(final long CompanyId) {// 提交用户信息
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<List<DepartmentEntity>>() {
            @Override
            protected List<DepartmentEntity> doInBackground(Void... params) {
                List<DepartmentEntity> departmentEntities = DepartmentRepository.getDepartmentList(CompanyId);
                return departmentEntities;
            }

            @Override
            protected void onPostExecute(List<DepartmentEntity> departmentEntities) {
                if (dialog != null)
                    dialog.dismiss();
                if (departmentEntities != null){
                    if (departmentEntities.size() != 0){
                        for (int i=0;i<departmentEntities.size();i++){
                            mVals.add(departmentEntities.get(i).DeptName);
                        }
                        adapter.notifyDataChanged();
                    } else {
//                        ToastUtil.showInfo("暂无部门，请添加");
                    }
                } else {
//                    ToastUtil.showInfo("获取失败");
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
            }

        }.execute();
    }
}
