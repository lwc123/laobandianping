package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.MessageListAdapter;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.models.MessageEntity;
import com.juxian.bosscomments.repositories.MessageRepository;
import com.juxian.bosscomments.repositories.PrivatenessRepository;

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
 * Created by nene on 2016/12/2.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/2 16:09]
 * @Version: [v1.0]
 */
public class MessageListActivity extends RemoteDataActivity implements View.OnClickListener, PullToRefreshBase.OnRefreshListener2, AdapterView.OnItemClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.refresh_listView)
    PullToRefreshListView mRefreshListView;
    @BindView(R.id.show_or_not)
    RelativeLayout show_or_not;
    @BindView(R.id.content_is_null)
    LinearLayout content_is_null;
    private MessageListAdapter messageListAdapter;

    private List<MessageEntity> mEntities;
    private int pageIndex;

    @Override
    public int getContentViewId() {
        return R.layout.activity_message;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.main_message));
        mEntities = new ArrayList<>();
        mRefreshListView.setMode(PullToRefreshBase.Mode.BOTH);
        messageListAdapter = new MessageListAdapter(mEntities, this);
        mRefreshListView.setAdapter(messageListAdapter);
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
        pageIndex = 1;
        getMessageList(0, pageIndex);
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
//        if ("company".equals(mUserType)) {
        mRefreshListView.setOnItemClickListener(this);
//        }
        mRefreshListView.setOnRefreshListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
        }
    }

    public void getMessageList(final int tag, final int Page) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<List<MessageEntity>>() {
            @Override
            protected List<MessageEntity> doInBackground(Void... params) {
                // 每次登录成功之后，保存token，并且返回登录信息
                List<MessageEntity> messageEntities = MessageRepository.getList(Page, 1);
                return messageEntities;
            }

            @Override
            protected void onPostExecute(List<MessageEntity> messageEntities) {
                if (dialog != null)
                    dialog.dismiss();
                if (messageEntities == null) {
                    show_or_not.setVisibility(View.GONE);
                    content_is_null.setVisibility(View.VISIBLE);
                } else {
                    if (messageEntities.size() > 0) {
                        if (tag == 0) { //下拉
                            mEntities.clear();
                        }
                        show_or_not.setVisibility(View.VISIBLE);//列表
                        content_is_null.setVisibility(View.GONE);
                        mEntities.addAll(messageEntities);
                        messageListAdapter.notifyDataSetChanged();
                        //检测是否有未读消息

                    } else {
                        if (tag == 0) { //下拉无获取数据
                            mEntities.clear();
                            mEntities.addAll(messageEntities);
                            messageListAdapter.notifyDataSetChanged();
                            show_or_not.setVisibility(View.GONE);
                            content_is_null.setVisibility(View.VISIBLE);
                        } else {
                            ToastUtil.showInfo("暂无更多消息");
                        }
                    }
                }

                mRefreshListView.onRefreshComplete();
            }

            @Override
            protected void onPostError(Exception ex) {
                mRefreshListView.onRefreshComplete();
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase refreshView) {
        pageIndex = 1;
        getMessageList(0, pageIndex);
    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase refreshView) {
        pageIndex++;
        getMessageList(1, pageIndex);
    }

    @Override
    public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
        MessageEntity messageEntity = null;
        messageEntity = mEntities.get(i - 1);

        Intent intent = new Intent(getApplicationContext(), MessageDetailActivity.class);
        intent.putExtra("messageEntity", JsonUtil.ToJson(messageEntity));
        startActivityForResult(intent, 110);

//        if (messageEntity.BizType == 3) {     //工作评价
//            Intent intent = new Intent(this, AuditWebViewActivity.class);
//            intent.putExtra("CommentType", "audit");
//            intent.putExtra("CompanyId",messageEntity.ToCompanyId);
//            intent.putExtra("BizId", messageEntity.BizId);
//            startActivity(intent);
//        } else if (messageEntity.BizType == 2) {  //离职报告
//            Intent intent = new Intent(this, AuditWebViewActivity.class);
//            intent.putExtra("CommentType", "leaving_report");
//            intent.putExtra("CompanyId",messageEntity.ToCompanyId);
//            intent.putExtra("BizId", messageEntity.BizId);
//            startActivity(intent);
//        }
    }
}
