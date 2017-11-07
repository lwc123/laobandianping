package com.juxian.bosscomments.ui;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.SelectCompanyAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.models.UserProfileEntity;
import com.juxian.bosscomments.repositories.CompanyMemberRepository;
import com.juxian.bosscomments.utils.DialogUtils;
import com.juxian.bosscomments.utils.SignInUtils;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.webapi.WebApiClient;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * Created by nene on 2017/3/6.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/3/6 13:33]
 * @Version: [v1.0]
 */
public class SelectOtherCompanyActivity extends RemoteDataActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView refreshListView;
    private View refreshListViewHeader;
    private View refreshListViewFooter;
    private SelectCompanyAdapter adapter;
    private List<MemberEntity> mCompanyEntities;
    private LinearLayout mBuildNewCompany;
    private List<String> memberEntities;

    @Override
    public int getContentViewId() {
        return R.layout.activity_select_other_company;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
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
        if ("LoginSelectCompany".equals(getIntent().getStringExtra("LoginSelectCompany"))) {
            mCompanyEntities.clear();
            for (int i = 0; i < memberEntities.size(); i++) {
                MemberEntity entity = JsonUtil.ToEntity(memberEntities.get(i), MemberEntity.class);
                mCompanyEntities.add(entity);
            }
            adapter.notifyDataSetChanged();
        } else {
            getMyRoles(this);
        }
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.select_company));
        mCompanyEntities = new ArrayList<>();
        refreshListViewHeader = LayoutInflater.from(getApplicationContext()).inflate(R.layout.include_other_company_header, null);
        refreshListView.getRefreshableView().addHeaderView(refreshListViewHeader, null, false);
        refreshListViewFooter = LayoutInflater.from(getApplicationContext()).inflate(R.layout.include_other_company_footer, null);
        refreshListView.getRefreshableView().addFooterView(refreshListViewFooter, null, false);
        mBuildNewCompany = (LinearLayout) refreshListViewFooter.findViewById(R.id.build_new_company);
        mBuildNewCompany.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent toOpenService = new Intent(getApplicationContext(), OpenServiceActivity.class);
                // change标签是为了判断是在开通服务页面是后退还是退出登录
                toOpenService.putExtra(Global.LISTVIEW_ITEM_TAG, "change");
                startActivityForResult(toOpenService, 100);
            }
        });
        if ("LoginSelectCompany".equals(getIntent().getStringExtra("LoginSelectCompany"))) {
            memberEntities = new ArrayList<>();
            memberEntities = getIntent().getStringArrayListExtra("AllCompany");
            adapter = new SelectCompanyAdapter(mCompanyEntities, getApplicationContext(), "login");
        } else {
            adapter = new SelectCompanyAdapter(mCompanyEntities, getApplicationContext(), "change");
        }
        refreshListView.setAdapter(adapter);
        if ("select".equals(getIntent().getStringExtra("BackStatus"))) {
            title.setText(getString(R.string.select_company));
            back.setVisibility(View.VISIBLE);
        } else {
            title.setText(getString(R.string.select_company));
            back.setVisibility(View.GONE);
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        refreshListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                if ("LoginSelectCompany".equals(getIntent().getStringExtra("LoginSelectCompany"))) {
                    if (mCompanyEntities.get(i - 2).myCompany.AuditStatus == CompanyEntity.AttestationStatus_Submited) {
                        DialogUtils.showMainRadiusDialog("企业认证信息审核中，请耐心等待。联系客服：400 815 9746", SelectOtherCompanyActivity.this);
                    } else {
                        SignInUtils.judgeStatus(SelectOtherCompanyActivity.this, mCompanyEntities.get(i - 2));
                    }
                } else {
                    // 个人切换企业
                    if ("personal".equals(getIntent().getStringExtra(Global.LISTVIEW_ITEM_TAG))) {
                        if (mCompanyEntities.get(i - 2).myCompany.AuditStatus == CompanyEntity.AttestationStatus_Passed) {
                            UserProfileEntity profileEntity = new UserProfileEntity();
                            profileEntity.CurrentOrganizationId = mCompanyEntities.get(i - 2).CompanyId;
                            changeUserIdentity(profileEntity,mCompanyEntities.get(i - 2));
                        } else if (mCompanyEntities.get(i - 2).myCompany.AuditStatus == CompanyEntity.AttestationStatus_Rejected) {
                            DialogUtils.showStandardTitleDialog(SelectOtherCompanyActivity.this,false,"我知道了","我知道了","企页认证审核不通过","请重新登录后，再次选择此企业提交认证信息");
                        } else if (mCompanyEntities.get(i - 2).myCompany.AuditStatus == CompanyEntity.AttestationStatus_None) {
                            DialogUtils.showStandardTitleDialog(SelectOtherCompanyActivity.this,false,"我知道了","我知道了","尚未提交认证","请重新登录后，再次选择此企业提交认证信息");
                        } else if (mCompanyEntities.get(i - 2).myCompany.AuditStatus == CompanyEntity.AttestationStatus_Submited) {
                            DialogUtils.showStandardTitleDialog(SelectOtherCompanyActivity.this,false,"我知道了","我知道了", "企业认证审核中","通过后将以短信形式告知企业法人，请耐心等待");
                        }
                    } else {
                        // 企业切换企业
                        if (AppConfig.getCurrentUseCompany() == mCompanyEntities.get(i - 2).CompanyId) {
                            return;
                        }
                        if (mCompanyEntities.get(i - 2).myCompany.AuditStatus == CompanyEntity.AttestationStatus_Passed) {
                            AppConfig.setCurrentProfileType(2);
                            AppConfig.setCurrentUseCompany(mCompanyEntities.get(i - 2).CompanyId);
                            Intent toHome = new Intent(getApplicationContext(), HomeActivity.class);
                            toHome.putExtra("CurrentMember",JsonUtil.ToJson(mCompanyEntities.get(i - 2)));
                            startActivity(toHome);
                            finish();
                        } else if (mCompanyEntities.get(i - 2).myCompany.AuditStatus == CompanyEntity.AttestationStatus_Rejected) {
                            DialogUtils.showStandardTitleDialog(SelectOtherCompanyActivity.this,false,"我知道了","我知道了","企页认证审核不通过","请重新登录后，再次选择此企业提交认证信息");
                        } else if (mCompanyEntities.get(i - 2).myCompany.AuditStatus == CompanyEntity.AttestationStatus_None) {
                            DialogUtils.showStandardTitleDialog(SelectOtherCompanyActivity.this,false,"我知道了","我知道了","尚未提交认证","请重新登录后，再次选择此企业提交认证信息");
                        } else if (mCompanyEntities.get(i - 2).myCompany.AuditStatus == CompanyEntity.AttestationStatus_Submited) {
                            DialogUtils.showStandardTitleDialog(SelectOtherCompanyActivity.this,false,"我知道了","我知道了", "企业认证审核中","通过后将以短信形式告知企业法人，请耐心等待");
                        }
                    }
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
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            default:
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

    public void getMyRoles(final Context context) {
        new AsyncRunnable<List<MemberEntity>>() {
            @Override
            protected List<MemberEntity> doInBackground(Void... params) {
                // 每次登录成功之后，保存token，并且返回登录信息
                List<MemberEntity> entities = CompanyMemberRepository.getMyRoles();
                return entities;
            }

            @Override
            protected void onPostExecute(List<MemberEntity> entities) {
                if (WebApiClient.getSingleton().LastError != null) {
                    ToastUtil.showInfo(context.getString(R.string.myroles_error_hint));
                } else {
                    IsInitData = true;
                    if (entities == null || entities.size() == 0) {

                    } else {
                        mCompanyEntities.clear();
                        mCompanyEntities.addAll(entities);
                        adapter.notifyDataSetChanged();
                    }
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                onRemoteError();
            }
        }.execute();
    }

    private final void changeUserIdentity(final UserProfileEntity profileEntity, final MemberEntity memberEntity) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                return AppContext.getCurrent().getUserAuthentication().ChangeCurrentToOrganizationProfile(profileEntity);
            }

            @Override
            protected void onPostExecute(Boolean result) {
                if (dialog != null)
                    dialog.dismiss();
                if (result == true) {
                    AppConfig.setCurrentUseCompany(AppContext.getCurrent().getCurrentAccount().getProfile().CurrentOrganizationId);
                    AppConfig.setCurrentProfileType(2);
                    SignInUtils.judgeStatus(SelectOtherCompanyActivity.this, memberEntity);
                } else {
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
}
