package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.AllDepartmentAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.BaseEntity;
import com.juxian.bosscomments.models.DepartmentEntity;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.models.ResultEntity;
import com.juxian.bosscomments.repositories.DepartmentRepository;
import com.juxian.bosscomments.utils.DialogUtils;

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
 * @CreateDate: [2016/12/20 14:32]
 * @Version: [v1.0]
 */
public class AllDepartmentActivity extends RemoteDataActivity implements View.OnClickListener,PullToRefreshBase.OnRefreshListener2<ListView>,AllDepartmentAdapter.DepartmentManageListener,DialogUtils.DepartmentDialogListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView refreshListView;
    @BindView(R.id.include_head_title_tab2)
    TextView mAddCommentText;
    @BindView(R.id.include_head_title_re1)
    RelativeLayout mAddComment;
    private List<DepartmentEntity> entities;
    private AllDepartmentAdapter adapter;

    @Override
    public int getContentViewId() {
        return R.layout.activity_all_department;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.all_department_title));
        mAddCommentText.setText(getString(R.string.add));
        mAddComment.setVisibility(View.VISIBLE);
        mAddCommentText.setVisibility(View.VISIBLE);
        refreshListView.setMode(PullToRefreshBase.Mode.DISABLED);
        entities = new ArrayList<>();
        adapter = new AllDepartmentAdapter(entities,getApplicationContext(),this);
        refreshListView.setAdapter(adapter);
    }

    @Override
    protected void onResume() {
        super.onResume();
        IsReloadDataOnResume = true;
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
        refreshListView.setOnRefreshListener(this);
        mAddComment.setOnClickListener(this);
    }

    @Override
    public void loadPageData() {
        getDepartmentList(AppConfig.getCurrentUseCompany());
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_head_title_re1:
                Intent intent = new Intent(getApplicationContext(), EditNameActivity.class);
                intent.putExtra(Global.LISTVIEW_ITEM_TAG, EditNameActivity.TYPE_ADD_DEPARTMENT);
                startActivity(intent);
                break;
        }
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {

    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {

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
                IsInitData = true;
                if (departmentEntities != null){
                    firstLoadData = false;
                    if (departmentEntities.size() != 0){
                        entities.clear();
                        entities.addAll(departmentEntities);
                        adapter.notifyDataSetChanged();
                    } else {
                        ToastUtil.showInfo("暂无部门，请添加");
                    }
                } else {
//                    ToastUtil.showInfo("获取失败");
                    onRemoteError();
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }

        }.execute();
    }

    protected void deleteDepartment(final DepartmentEntity entity,final int position) {// 提交用户信息
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<ResultEntity>() {
            @Override
            protected ResultEntity doInBackground(Void... params) {
                ResultEntity resultEntity = DepartmentRepository.deleteDepartment(entity);
                return resultEntity;
            }

            @Override
            protected void onPostExecute(ResultEntity resultEntity) {
                if (dialog != null)
                    dialog.dismiss();
                if (resultEntity != null){
                    if (resultEntity.Success){
                        ToastUtil.showInfo("删除成功");
                        entities.remove(position);
                        adapter.notifyDataSetChanged();
                    } else {
                        ToastUtil.showInfo(resultEntity.ErrorMessage);
                    }
                } else {
//                    ToastUtil.showInfo("网络错误");
                    onRemoteError();
                }
            }

            @Override
            protected void onPostError(Exception ex) {
//                ToastUtil.showInfo("网络错误");
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }

        }.execute();
    }

    @Override
    public void ChangeDepartment(DepartmentEntity entity) {
        Intent intent = new Intent(getApplicationContext(),EditNameActivity.class);
        intent.putExtra(Global.LISTVIEW_ITEM_TAG,EditNameActivity.TYPE_UPDATE_DEPARTMENT);
        intent.putExtra("DepartmentEntity", JsonUtil.ToJson(entity));
        startActivity(intent);
    }

    @Override
    public void DeleteDepartment(int position) {
        if (entities.get(position).StaffNumber>0){
            ToastUtil.showInfo("该部门下有员工档案，暂不能删除");
            return;
        }
        DialogUtils.showDialog(this,entities.get(position),position,this);

    }

    @Override
    public void LeftBtMethod() {

    }

    @Override
    public void RightBtMethod(DepartmentEntity entity, int pos) {
        deleteDepartment(entity,pos);
    }
}
