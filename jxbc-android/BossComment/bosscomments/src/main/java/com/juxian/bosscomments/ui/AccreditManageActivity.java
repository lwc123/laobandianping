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
import com.juxian.bosscomments.adapter.AccreditManageAdapter;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.repositories.CompanyMemberRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import handmark.pulltorefresh.library.PullToRefreshBase;
import handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener2;
import handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * Created by nene on 2016/10/25.
 * 授权管理
 *
 * @ProjectName: [LaoBanDianPing]
 * @Package: [com.juxian.bosscomments.ui]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/25 11:11]
 * @Version: [v1.0]
 */
public class AccreditManageActivity extends RemoteDataActivity implements OnRefreshListener2<ListView>, View.OnClickListener, AccreditManageAdapter.AccreditOperationListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView refreshListView;
    @BindView(R.id.include_head_title_tab2)
    TextView mNewBuildText;
    @BindView(R.id.include_head_title_re1)
    RelativeLayout mNewBuild;
    //    private View refreshListViewHeader;
    private List<MemberEntity> entities;
    private AccreditManageAdapter adapter;

    @Override
    public int getContentViewId() {
        return R.layout.activity_accredit_manage;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.authorization_management));
        refreshListView.setMode(Mode.DISABLED);
        mNewBuildText.setText(getString(R.string.add));
        mNewBuild.setVisibility(View.VISIBLE);
        mNewBuildText.setVisibility(View.VISIBLE);
        entities = new ArrayList<>();
        adapter = new AccreditManageAdapter(entities, this, this);
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
        setSystemBarTintManager(this);
        initViewsData();
        initListener();
    }

    @Override
    public void loadPageData() {
        getCompanyMemberList(AppConfig.getCurrentUseCompany());
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        refreshListView.setOnRefreshListener(this);
        mNewBuild.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_head_title_re1:
                Intent AddAccreditPerson = new Intent(getApplicationContext(), AddAccreditPersonActivity.class);
                startActivity(AddAccreditPerson);
                break;
            default:
        }
    }

    public void getCompanyMemberList(final long CompanyId) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<List<MemberEntity>>() {
            @Override
            protected List<MemberEntity> doInBackground(Void... params) {
                // 每次登录成功之后，保存token，并且返回登录信息
                List<MemberEntity> memberEntities = CompanyMemberRepository.getCompanyMemberList(CompanyId);
                return memberEntities;
            }

            @Override
            protected void onPostExecute(List<MemberEntity> memberEntities) {
                if (dialog != null)
                    dialog.dismiss();
                IsInitData = true;
                if (memberEntities == null) {
                    onRemoteError();
                } else {
                    entities.clear();
                    entities.addAll(memberEntities);
                    adapter.notifyDataSetChanged();
//                    adapter.setList(entities);
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

    private void PostDeleteCompanyMember(final MemberEntity entity, final int pos) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean success = CompanyMemberRepository.deleteCompanyMember(entity);
                return success;
            }

            @Override
            protected void onPostExecute(Boolean model) {
                if (dialog != null)
                    dialog.dismiss();
                if (model) {
                    ToastUtil.showInfo("删除成功");
                    entities.remove(pos);
                    adapter.notifyDataSetChanged();
                } else {
                    ToastUtil.showInfo("删除失败");
                }
            }

            protected void onPostError(Exception ex) {
//                ToastUtil.showError(getString(R.string.net_false_hint));
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {

    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {

    }

    @Override
    public void deleteClick(MemberEntity entity, int pos) {
//        PostDeleteCompanyMember(entity, pos);
        showDialog(entity, pos);
    }

    public void showDialog(final MemberEntity entity, final int pos) {
        final Dialog dl = new Dialog(this);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(false);
        View dialog_view = View.inflate(getApplicationContext(), R.layout.dialog_accredit, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = dp2px(260);
        dialogWindow.setAttributes(lp);
        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dl.show();
        TextView close = (TextView) dialog_view.findViewById(R.id.dialog_tips_cancel);
        TextView ok = (TextView) dialog_view.findViewById(R.id.dialog_tips_ok);
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
            }
        });
        ok.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // 判断是否是继续建立档案，是，则继续建立，否则执行其他操作
                dl.dismiss();
                PostDeleteCompanyMember(entity, pos);
            }
        });
    }
}
