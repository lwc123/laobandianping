package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.AllEmployeeRecordAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.DepartmentEntity;
import com.juxian.bosscomments.models.DepartmentGroupEntity;
import com.juxian.bosscomments.models.EmployeArchiveEntity;
import com.juxian.bosscomments.models.EmployeArchiveListEntity;
import com.juxian.bosscomments.repositories.CompanyRepository;
import com.juxian.bosscomments.repositories.EmployeArchiveRepository;
import com.juxian.bosscomments.widget.RoundAngleImageView;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.DialogUtils;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import handmark.pulltorefresh.library.PullToRefreshBase;
import handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * Created by nene on 2016/11/26.
 * 员工档案列表
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/26 12:47]
 * @Version: [v1.0]
 */
public class AllEmployeeRecordActivity extends RemoteDataActivity implements View.OnClickListener, PullToRefreshBase.OnRefreshListener2<ListView> {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    //    @BindView(R.id.include_head_title_tab)
//    ImageView mAddRecordImg;
//    @BindView(R.id.include_head_title_re)
//    RelativeLayout mAddRecord;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView mRefreshListView;
    @BindView(R.id.activity_search)
    RelativeLayout mSearchBox;
    @BindView(R.id.activity_search_text)
    TextView mSearchText;
    @BindView(R.id.include_head_title_tab2)
    TextView mNewBuildText;
    @BindView(R.id.include_head_title_re1)
    RelativeLayout mNewBuild;
    @BindView(R.id.null_hint)
    TextView mNullHint;
    @BindView(R.id.content_is_null)
    LinearLayout mContentIsNull;
    @BindView(R.id.add)
    Button mNewBuildBt;
    @BindView(R.id.re_listview)
    RelativeLayout re_listview;
    @BindView(R.id.build_staff_on_active_duty_record)
    LinearLayout mBuildActiveRecord;
    @BindView(R.id.build_separated_employees_record)
    LinearLayout mBuildSeparatedRecord;
    @BindView(R.id.activity_cc_page_error_rela)
    RelativeLayout mSearchView;
    @BindView(R.id.data_list)
    LinearLayout mDataList;
    @BindView(R.id.data_null)
    LinearLayout mDataNull;
    private AllEmployeeRecordAdapter mAdapter;
    private View refreshListViewHeader;
    private List<DepartmentGroupEntity> entities;
    private String mTag;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_LOGO_OPTIONS;
    private Dialog dialog;
    private int dialogIndex = 0;

    @Override
    public int getContentViewId() {
        return R.layout.activity_all_employee_record;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.all_employee_record));
        mNewBuildText.setText(getString(R.string.new_build));
        mSearchView.setVisibility(View.GONE);
        mNewBuild.setVisibility(View.VISIBLE);
        mNewBuildText.setVisibility(View.VISIBLE);
//        mAddRecordImg.setImageResource(R.drawable.add_position);
//        mAddRecordImg.setVisibility(View.VISIBLE);
        mRefreshListView.setMode(PullToRefreshBase.Mode.DISABLED);
        mTag = getIntent().getStringExtra("ArchiveList");
        entities = new ArrayList<>();
        mAdapter = new AllEmployeeRecordAdapter(entities, this, mTag, getIntent().getStringExtra("CommentType"));
        mRefreshListView.setAdapter(mAdapter);
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
//        mAddRecord.setOnClickListener(this);
        mNewBuild.setOnClickListener(this);
        mRefreshListView.setOnRefreshListener(this);
        mSearchBox.setOnClickListener(this);
        mSearchText.setOnClickListener(this);
        mNewBuildBt.setOnClickListener(this);
        mBuildActiveRecord.setOnClickListener(this);
        mBuildSeparatedRecord.setOnClickListener(this);
        mRefreshListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {

            }
        });
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_head_title_re1:
                Intent AddEmployeeRecord = new Intent(getApplicationContext(), AddEmployeeRecordActivity.class);
                AddEmployeeRecord.putExtra(AddEmployeeRecordActivity.EMPLOYEE_RECORD_TYPE, "All");
                AddEmployeeRecord.putExtra(AddEmployeeRecordActivity.OPERATION_TYPE, "Build");
                if ("SelectArchive".equals(mTag)) {
                    AddEmployeeRecord.putExtra("ArchiveList", "SelectArchive");
                }
                startActivityForResult(AddEmployeeRecord, 100);
                break;
            case R.id.activity_search:
                Intent SearchEmployee = new Intent(getApplicationContext(), SearchEmployeeActivity.class);
                SearchEmployee.putExtra(SearchEmployeeActivity.SEARCH_TYPE, "SearchEmployee");
                if ("SelectArchive".equals(mTag)) {
                    SearchEmployee.putExtra("CommentType", getIntent().getStringExtra("CommentType"));
                    SearchEmployee.putExtra("ArchiveList", "SelectArchive");
                }
                startActivity(SearchEmployee);
                break;
            case R.id.activity_search_text:
                Intent SearchEmployee1 = new Intent(getApplicationContext(), SearchEmployeeActivity.class);
                SearchEmployee1.putExtra(SearchEmployeeActivity.SEARCH_TYPE, "SearchEmployee");
                if ("SelectArchive".equals(mTag)) {
                    SearchEmployee1.putExtra("CommentType", getIntent().getStringExtra("CommentType"));
                    SearchEmployee1.putExtra("ArchiveList", "SelectArchive");
                }
                startActivity(SearchEmployee1);
                break;
            case R.id.add:
                Intent AddEmployeeRecord1 = new Intent(getApplicationContext(), AddEmployeeRecordActivity.class);
                AddEmployeeRecord1.putExtra(AddEmployeeRecordActivity.EMPLOYEE_RECORD_TYPE, "All");
                AddEmployeeRecord1.putExtra(AddEmployeeRecordActivity.OPERATION_TYPE, "Build");
                if ("SelectArchive".equals(mTag)) {
                    AddEmployeeRecord1.putExtra("ArchiveList", "SelectArchive");
                }
                startActivityForResult(AddEmployeeRecord1, 100);
                break;
            case R.id.build_staff_on_active_duty_record:
                Intent AddOnActiveRecord = new Intent(getApplicationContext(),AddEmployeeRecordActivity.class);
                AddOnActiveRecord.putExtra(AddEmployeeRecordActivity.EMPLOYEE_RECORD_TYPE,"OnActive");
                AddOnActiveRecord.putExtra(AddEmployeeRecordActivity.OPERATION_TYPE,"Build");
                startActivity(AddOnActiveRecord);
                break;
            case R.id.build_separated_employees_record:
                Intent AddSeparatedEmployeeRecord = new Intent(getApplicationContext(),AddEmployeeRecordActivity.class);
                AddSeparatedEmployeeRecord.putExtra(AddEmployeeRecordActivity.EMPLOYEE_RECORD_TYPE,"Departure");
                AddSeparatedEmployeeRecord.putExtra(AddEmployeeRecordActivity.OPERATION_TYPE,"Build");
                startActivity(AddSeparatedEmployeeRecord);
                break;
            default:
        }
    }

    private BroadcastReceiver ArchiveBroadcastReceiver = new BroadcastReceiver() {

        @Override
        public void onReceive(Context context, Intent intent) {
            Intent intent1 = getIntent();
            intent1.putExtra("ArchiveInformation", intent.getStringExtra("ArchiveInformation"));
            AllEmployeeRecordActivity.this.setResult(AllEmployeeRecordActivity.RESULT_OK, intent1);
            finish();
        }
    };

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 100:
                if (resultCode == RESULT_OK) {
                    Intent intent = new Intent();
                    intent.putExtra("ArchiveInformation", data.getStringExtra("ArchiveInformation"));
                    setResult(RESULT_OK, intent);
                    finish();
                }
                break;
        }
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {

    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {

    }

    @Override
    protected void onResume() {
        super.onResume();
        IsReloadDataOnResume = true;
//        checkNetStatus();
//        GetMineMessage(AppConfig.getCurrentUseCompany());
//        entities.clear();
//        GetEmployeeList(AppConfig.getCurrentUseCompany());
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction("AllEmployeeRecordActivity");
        registerReceiver(ArchiveBroadcastReceiver, intentFilter);
    }

    @Override
    public void loadPageData() {
        GetMineMessage(AppConfig.getCurrentUseCompany());
    }

    @Override
    protected void onDestroy() {
        // TODO Auto-generated method stub
        super.onDestroy();
        try {
            unregisterReceiver(ArchiveBroadcastReceiver);
        } catch (Exception e1) {
            e1.printStackTrace();
        }
    }

    private void GetEmployeeList(final long CompanyId) {
        // 获取企业信息，根据之前保存的企业id查询
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<EmployeArchiveListEntity>() {
            @Override
            protected EmployeArchiveListEntity doInBackground(Void... params) {
                EmployeArchiveListEntity entity = EmployeArchiveRepository.getEmployeeList(CompanyId);
                return entity;
            }

            @Override
            protected void onPostExecute(EmployeArchiveListEntity entity) {
//                DialogUtils.hideLoadingDialog();
                if (dialog != null)
                    dialog.dismiss();
                IsInitData = true;
                if (entity != null) {

                    re_listview.setVisibility(View.VISIBLE);
                    mContentIsNull.setVisibility(View.GONE);
                    DepartmentGroupEntity departmentGroupEntity = new DepartmentGroupEntity();
                    departmentGroupEntity.employeArchiveEntities = new ArrayList<EmployeArchiveEntity>();
                    departmentGroupEntity.departmentEntity = new DepartmentEntity();
                    departmentGroupEntity.departmentEntity.DeptName = "已离任";
                    departmentGroupEntity.departmentEntity.DeptId = 0;
                    for (int i = 0; i < entity.ArchiveLists.size(); i++) {
                        if (entity.ArchiveLists.get(i).IsDimission == 1) {
                            departmentGroupEntity.employeArchiveEntities.add(entity.ArchiveLists.get(i));
                        }
                    }
                    departmentGroupEntity.departmentEntity.StaffNumber = departmentGroupEntity.employeArchiveEntities.size();
                    for (int i = 0; i < entity.Departments.size(); i++) {
                        DepartmentGroupEntity departmentGroupEntity1 = new DepartmentGroupEntity();
                        departmentGroupEntity1.employeArchiveEntities = new ArrayList<EmployeArchiveEntity>();
                        departmentGroupEntity1.departmentEntity = entity.Departments.get(i);
                        for (int j = 0; j < entity.ArchiveLists.size(); j++) {
                            if (entity.Departments.get(i).DeptId == entity.ArchiveLists.get(j).DeptId) {
                                if (entity.ArchiveLists.get(j).IsDimission == 0)
                                    departmentGroupEntity1.employeArchiveEntities.add(entity.ArchiveLists.get(j));
                            }
                        }
                        entities.add(departmentGroupEntity1);
                    }
                    entities.add(departmentGroupEntity);
                    mAdapter.notifyDataSetChanged();
                } else {
                    re_listview.setVisibility(View.GONE);
                    mContentIsNull.setVisibility(View.VISIBLE);
                    mNullHint.setText("公司还未建立员工档案");
                }
            }

            protected void onPostError(Exception ex) {
                onRemoteError();
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    private void GetMineMessage(final long CompanyId) {
        // 获取企业信息，根据之前保存的企业id查询
        new AsyncRunnable<CompanyEntity>() {
            @Override
            protected CompanyEntity doInBackground(Void... params) {
                CompanyEntity entity = CompanyRepository.getSummary(CompanyId);
                return entity;
            }

            @Override
            protected void onPostExecute(CompanyEntity entity) {
                if (entity != null) {
                    if (entity.EmployedNum + entity.DimissionNum == 0){
                        mDataList.setVisibility(View.GONE);
                        mSearchView.setVisibility(View.GONE);
                        mDataNull.setVisibility(View.VISIBLE);
                        IsInitData = true;
                    } else {
                        mDataList.setVisibility(View.VISIBLE);
                        mSearchView.setVisibility(View.VISIBLE);
                        mDataNull.setVisibility(View.GONE);
                        entities.clear();
                        GetEmployeeList(AppConfig.getCurrentUseCompany());
                    }

                } else {
                    Log.e(Global.LOG_TAG, "NULL");
                }
            }

            protected void onPostError(Exception ex) {
                onRemoteError();
            }
        }.execute();
    }
}
