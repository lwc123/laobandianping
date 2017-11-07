package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.ModifyRecordAdapter;
import com.juxian.bosscomments.models.ArchiveCommentLogEntity;
import com.juxian.bosscomments.repositories.ArchiveCommentRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import handmark.pulltorefresh.library.PullToRefreshListView;

/**
 * Created by Tam on 2017/2/8.
 */
public class ModifyRecordActivity extends RemoteDataActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView refreshListView;
    private List<ArchiveCommentLogEntity> entitis;
    private ModifyRecordAdapter mAdapter;

    @Override
    public int getContentViewId() {
        return R.layout.activity_modify_record;
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.modify_record));
        entitis = new ArrayList<>();
        mAdapter = new ModifyRecordAdapter(entitis, this);
        refreshListView.setAdapter(mAdapter);
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
        getLogList(AppConfig.getCurrentUseCompany(),Long.parseLong(getIntent().getStringExtra("CommentId")));
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
        }
    }

    private void getLogList(final long CompanyId, final long CommentId) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<List<ArchiveCommentLogEntity>>() {

            @Override
            protected List<ArchiveCommentLogEntity> doInBackground(Void... params) {
                List<ArchiveCommentLogEntity> logList = ArchiveCommentRepository.getLogList(CompanyId, CommentId);
                return logList;
            }

            @Override
            protected void onPostExecute(List<ArchiveCommentLogEntity> logList) {
                if (null != dialog)
                    dialog.dismiss();
                if (logList != null){
                    IsInitData = true;
                    if (logList.size()!=0) {
                        entitis.addAll(logList);
                        mAdapter.notifyDataSetChanged();
                    } else {
                        ToastUtil.showInfo("暂无修改记录");
                    }
                } else {
                    onRemoteError();
//                    ToastUtil.showInfo("暂无修改记录");
                }
            }

            protected void onPostError(Exception ex) {
                if (null != dialog)
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }
}
