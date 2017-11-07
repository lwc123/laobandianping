package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.PrivatenessArchiveSummaryEntity;
import com.juxian.bosscomments.models.PrivatenessServiceContractEntity;
import com.juxian.bosscomments.models.PrivatenessSummaryEntity;
import com.juxian.bosscomments.repositories.PrivatenessRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/12/16.
 * 个人端我的档案
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/16 18:11]
 * @Version: [v1.0]
 */
public class MyArchiveActivity extends RemoteDataActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.have_comment)
    LinearLayout mHaveComment;
    @BindView(R.id.comment_null)
    LinearLayout mCommentNull;
    @BindView(R.id.include_button_button)
    Button mGoToLook;
    @BindView(R.id.my_archive_summary_info)
    TextView mMyArchiveSummaryInfo;
    private PrivatenessServiceContractEntity mPrivatenessServiceContractEntity;

    @Override
    public int getContentViewId() {
        return R.layout.activity_my_archive;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.personal_my_archive));
        mGoToLook.setText(getString(R.string.personal_right_away_look));
        mCommentNull.setVisibility(View.GONE);
        mPrivatenessServiceContractEntity = JsonUtil.ToEntity(AppConfig.getPersonalServiceContract(),PrivatenessServiceContractEntity.class);
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
        GetPersonalArchiveSummary();
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mGoToLook.setOnClickListener(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        IsReloadDataOnResume = true;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_button_button:
                if (mPrivatenessServiceContractEntity != null){
                    Intent PersonalArchiveList = new Intent(getApplicationContext(),PersonalArchiveListActivity.class);
                    startActivity(PersonalArchiveList);
                } else {
                    Intent goToLookComment = new Intent(getApplicationContext(), LookMyArchiveActivity.class);
                    startActivity(goToLookComment);
                }
                break;
        }
    }

    /**
     * 我的档案摘要信息（根据这个判断当前账号是否有相应的阶段评价或离任报告）
     */
    private void GetPersonalArchiveSummary() {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<PrivatenessArchiveSummaryEntity>() {
            @Override
            protected PrivatenessArchiveSummaryEntity doInBackground(Void... params) {
                PrivatenessArchiveSummaryEntity entity = PrivatenessRepository.GetPersonalArchiveSummary();
                return entity;
            }

            @Override
            protected void onPostExecute(PrivatenessArchiveSummaryEntity entity) {
                if (dialog != null)
                    dialog.dismiss();
                if (entity != null){
                    IsInitData = true;
                    if (entity.DepartureReportNum ==0 && entity.StageEvaluationNum == 0){
                        mHaveComment.setVisibility(View.GONE);
                        mCommentNull.setVisibility(View.VISIBLE);
                    } else {
                        mHaveComment.setVisibility(View.VISIBLE);
                        mCommentNull.setVisibility(View.GONE);
                        if (entity.DepartureReportNum !=0 && entity.StageEvaluationNum != 0) {
                            mMyArchiveSummaryInfo.setText("通过手机号判定，发现您名下有来自" + entity.ArchiveNum + "位老板的"+entity.StageEvaluationNum+"条工作评价、"+entity.DepartureReportNum+"份离任报告。");
                        } else if (entity.DepartureReportNum ==0){
                            mMyArchiveSummaryInfo.setText("通过手机号判定，发现您名下有来自" + entity.ArchiveNum + "位老板的"+entity.StageEvaluationNum+"条工作评价.");
                        } else {
                            mMyArchiveSummaryInfo.setText("通过手机号判定，发现您名下有来自" + entity.ArchiveNum + "位老板的"+entity.DepartureReportNum+"份离任报告。");
                        }
                    }
                } else {
                    onRemoteError();
                    mHaveComment.setVisibility(View.GONE);
                    mCommentNull.setVisibility(View.VISIBLE);
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
