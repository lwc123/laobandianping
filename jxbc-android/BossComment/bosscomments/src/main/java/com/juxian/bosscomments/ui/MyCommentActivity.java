package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.MyCommentsAdapter;
import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.repositories.ArchiveCommentRepository;

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
 * Created by Tam on 2016/12/10.
 * 我的评价
 */
public class MyCommentActivity extends RemoteDataActivity implements PullToRefreshBase.OnRefreshListener2<ListView>, View.OnClickListener, AdapterView.OnItemClickListener {

    private PopupWindow popupWindow;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_back)
    ImageView mBack;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView refreshListView;
    @BindView(R.id.include_head_title_re)
    RelativeLayout mSelectCommentType;
    @BindView(R.id.include_head_title_tab)
    ImageView mSelectCommentImage;
    @BindView(R.id.show_or_not)
    RelativeLayout show_or_not;
    @BindView(R.id.content_is_null)
    LinearLayout mContentIsNull;
    private List<ArchiveCommentEntity> entities;
    private MyCommentsAdapter adapter;
    private int pageIndex;
    private int mAuditStatus = 0;
    private MemberEntity currentMemberEntity;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


    }

    @Override
    public int getContentViewId() {
        return R.layout.activity_mycomment;
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.mycomment_title));
        pageIndex = 1;
        refreshListView.setMode(PullToRefreshBase.Mode.BOTH);
        refreshListView.setOnItemClickListener(this);
        entities = new ArrayList<>();
        adapter = new MyCommentsAdapter(entities, this);
        refreshListView.setAdapter(adapter);
        mSelectCommentImage.setImageResource(R.drawable.list_select);
        mSelectCommentImage.setVisibility(View.VISIBLE);
        currentMemberEntity = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);//自己的信息
//        pageIndex = 1;
//        getMyComments(AppConfig.getCurrentUseCompany(), mAuditStatus, pageIndex, 0);
    }

    @Override
    public void initListener() {
        super.initListener();
        mBack.setOnClickListener(this);
        refreshListView.setOnRefreshListener(this);
        mSelectCommentType.setOnClickListener(this);
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
        pageIndex = 1;
        getMyComments(AppConfig.getCurrentUseCompany(), mAuditStatus, pageIndex, 0);
    }

    @Override
    protected void onResume() {
        super.onResume();
        IsReloadDataOnResume = true;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.include_head_title_re:
                showPopupWindow(v);
                break;
            case R.id.include_head_title_back:
                finish();
                break;
        }
    }

//    public void moveToTop() {
//        if (refreshListView != null) {
//            refreshListView.getRefreshableView().smoothScrollToPosition(0);
//        }
//    }

    private void getMyComments(final long companyId, final int AuditStatus, final int pageIndex, final int tag) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<List<ArchiveCommentEntity>>() {
            @Override
            protected List<ArchiveCommentEntity> doInBackground(Void... params) {
                List<ArchiveCommentEntity> commentList = ArchiveCommentRepository.getMyComments(companyId, AuditStatus, pageIndex);
                return commentList;
            }

            @Override
            protected void onPostExecute(List<ArchiveCommentEntity> commentList) {
                if (dialog != null)
                    dialog.dismiss();
                refreshListView.onRefreshComplete();
                IsInitData = true;
                if (commentList != null) {
                    if (commentList.size() != 0) {
                        if (tag == 0) {
                            entities.clear();
                        }
                        entities.addAll(commentList);
                        show_or_not.setVisibility(View.VISIBLE);
                        mContentIsNull.setVisibility(View.GONE);
                        adapter.notifyDataSetChanged();
                    } else {
                        if (tag == 0) {
                            entities.clear();
                            entities.addAll(commentList);
                            adapter.notifyDataSetChanged();
                        } else {
                            ToastUtil.showInfo("暂无更多评价");
                        }
                        if (entities.size() == 0) {
                            show_or_not.setVisibility(View.GONE);
                            mContentIsNull.setVisibility(View.VISIBLE);
                        }
                    }
                } else {
                    if (tag == 0) {
                        show_or_not.setVisibility(View.GONE);
                        mContentIsNull.setVisibility(View.VISIBLE);
                    } else {
                        ToastUtil.showInfo("暂无更多评价");
                    }
                }
            }

            protected void onPostError(Exception ex) {
//                ToastUtil.showError(getString(R.string.net_false_hint));
                refreshListView.onRefreshComplete();
                onRemoteError();
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    private void showPopupWindow(View v) {
        final View contentView = LayoutInflater.from(getApplicationContext()).inflate(R.layout.popupwindow_select_audit_all, null);
        TextView all_audit = (TextView) contentView.findViewById(R.id.select_all_audit);
        TextView waiting_audit = (TextView) contentView.findViewById(R.id.select_waiting_audit);
        TextView passed_audit = (TextView) contentView.findViewById(R.id.select_passed_audit);
        TextView not_passed_audit = (TextView) contentView.findViewById(R.id.select_not_passed_audit);
        all_audit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mAuditStatus = 0;
                pageIndex = 1;
                getMyComments(AppConfig.getCurrentUseCompany(), mAuditStatus, pageIndex, 0);
                popupWindow.dismiss();
            }
        });
        waiting_audit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mAuditStatus = 1;
                pageIndex = 1;
                getMyComments(AppConfig.getCurrentUseCompany(), mAuditStatus, pageIndex, 0);
                popupWindow.dismiss();
            }
        });
        passed_audit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mAuditStatus = 2;
                pageIndex = 1;
                getMyComments(AppConfig.getCurrentUseCompany(), mAuditStatus, pageIndex, 0);
                popupWindow.dismiss();
            }
        });
        not_passed_audit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mAuditStatus = 9;
                pageIndex = 1;
                getMyComments(AppConfig.getCurrentUseCompany(), mAuditStatus, pageIndex, 0);
                popupWindow.dismiss();
            }
        });
        popupWindow = new PopupWindow(contentView, LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT, true);
        popupWindow.setTouchable(true);
        popupWindow.setBackgroundDrawable(getResources().getDrawable(R.drawable.mask_icon_7));
        popupWindow.showAsDropDown(mSelectCommentType, 0, 12);

    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex = 1;
        getMyComments(AppConfig.getCurrentUseCompany(), mAuditStatus, pageIndex, 0);
    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {
        pageIndex++;
        getMyComments(AppConfig.getCurrentUseCompany(), mAuditStatus, pageIndex, 1);
    }

    @Override
    public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
        ArchiveCommentEntity archiveCommentEntity = entities.get(position - 1);
        //如果是提交人
        if (archiveCommentEntity.PresenterId == currentMemberEntity.PassportId) {
            if (archiveCommentEntity.AuditStatus == 1 || archiveCommentEntity.AuditStatus == 2) { //审核中,通过
                Intent intent = new Intent(this, AuditWebViewActivity.class);
                if (archiveCommentEntity.CommentType == 1) { //是离任报告
                    intent.putExtra("CommentType", "leaving_report");

                } else { //工作评价
                    intent.putExtra("CommentType", "audit");

                }
                intent.putExtra("CompanyId",entities.get(position - 1).CompanyId);
                intent.putExtra("BizId", entities.get(position - 1).CommentId);
                startActivity(intent);

            } else if (archiveCommentEntity.AuditStatus == 9) { //未通过

                // 跳转到重新提交页面
                if (archiveCommentEntity.CommentType == 0) {
                    Intent Change = new Intent(this, AddBossCommentActivity.class);
                    Change.putExtra("Tag", "Have");
                    Change.putExtra("Operation", "Change");
                    Change.putExtra("CommentId", archiveCommentEntity.CommentId);
                    startActivityForResult(Change,100);
                } else {
                    Intent Change = new Intent(this, AddDepartureReportActivity.class);
                    Change.putExtra("Tag", "Have");
                    Change.putExtra("Operation", "Change");
                    Change.putExtra("CommentId", archiveCommentEntity.CommentId);
                    startActivityForResult(Change,200);
                }
            }
        } else {
            //审核人
            Intent intent = new Intent(this, AuditWebViewActivity.class);
            if (archiveCommentEntity.CommentType == 1) { //是离任报告
                intent.putExtra("CommentType", "leaving_report");
            } else { //工作评价
                intent.putExtra("CommentType", "audit");
            }
            intent.putExtra("CompanyId",entities.get(position - 1).CompanyId);
            intent.putExtra("BizId", entities.get(position - 1).CommentId);
            startActivity(intent);
        }

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode){
            case 100:
                pageIndex = 1;
                getMyComments(AppConfig.getCurrentUseCompany(), mAuditStatus, pageIndex, 0);
                break;
            case 200:
                pageIndex = 1;
                getMyComments(AppConfig.getCurrentUseCompany(), mAuditStatus, pageIndex, 0);
                break;
        }
    }
}
