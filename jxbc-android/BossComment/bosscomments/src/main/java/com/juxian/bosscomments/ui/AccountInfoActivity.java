package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.repositories.CompanyRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Tam on 2017/2/1.
 */
public class AccountInfoActivity extends RemoteDataActivity implements View.OnClickListener {
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.account_info_name)
    TextView account_info_name;
    @BindView(R.id.account_info_phone)
    TextView account_info_phone;
    @BindView(R.id.account_info_position)
    TextView account_info_position;
    @BindView(R.id.account_info_role)
    TextView account_info_role;
    @BindView(R.id.account_info_change)
    TextView account_info_change;
    private CompanyEntity mCompanyEntity;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public int getContentViewId() {
        return R.layout.activity_account_info;
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText("账号信息");
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
        loadAccountSummary(AppConfig.getCurrentUseCompany());
    }

    @Override
    protected void onResume() {
        super.onResume();
        IsReloadDataOnResume = true;
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        account_info_change.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.account_info_change:
                Intent intent = new Intent(this, EditNameActivity.class);
                intent.putExtra(Global.LISTVIEW_ITEM_TAG, EditNameActivity.TYPE_EDIT_NAME);
                intent.putExtra("MemberEntity", JsonUtil.ToJson(mCompanyEntity.MyInformation));
                startActivity(intent);
                break;
            default:
                break;
        }
    }

    public void loadAccountSummary(final long CompanyId) {
        // 获取企业信息，根据之前保存的企业id查询
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<CompanyEntity>() {
            @Override
            protected CompanyEntity doInBackground(Void... params) {
                CompanyEntity entity = CompanyRepository.getMine(CompanyId);
                return entity;
            }

            @Override
            protected void onPostExecute(CompanyEntity entity) {
                if (dialog != null)
                    dialog.dismiss();
                if (entity != null) {
                    IsInitData = true;
                    mCompanyEntity = entity;
                    account_info_name.setText(entity.MyInformation.RealName);
                    account_info_phone.setText(entity.MyInformation.MobilePhone);
                    account_info_position.setText(entity.MyInformation.JobTitle);
                    if (entity.MyInformation.Role == MemberEntity.CompanyMember_Role_Boss) {
                        account_info_role.setText("老板");
                    } else if (entity.MyInformation.Role == MemberEntity.CompanyMember_Role_Admin) {
                        account_info_role.setText("管理员");
                    } else if (entity.MyInformation.Role == MemberEntity.CompanyMember_Role_Senior) {
                        account_info_role.setText("高管");
                    } else if (entity.MyInformation.Role == MemberEntity.CompanyMember_Role_XiaoMi) {
                        account_info_role.setText("建档员");
                    }
                    if (entity.MyInformation.Role == MemberEntity.CompanyMember_Role_Boss) {
                        account_info_change.setVisibility(View.GONE);
                    } else {
                        account_info_change.setVisibility(View.VISIBLE);
                    }
                } else {
                    onRemoteError();
                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }
}
