package com.juxian.bosscomments.fragment;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.CMessageListAdapter;
import com.juxian.bosscomments.models.MessageEntity;
import com.juxian.bosscomments.repositories.MessageRepository;
import com.juxian.bosscomments.ui.AuditWebViewActivity;
import com.juxian.bosscomments.ui.MessageDetailActivity;

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
 * Created by Tam on 2017/2/8.
 */
public class MessageFragment extends BaseFragment implements PullToRefreshBase.OnRefreshListener2 {

    @BindView(R.id.refresh_listView)
    PullToRefreshListView mRefreshListView;
    private CMessageListAdapter messageListAdapter;
    List<MessageEntity> mEntities;
    private static final String PARAM = "param";
    private String mParam;
    private int messageType;
    private int pageIndex;
    public boolean HaveSuspendingMsg;
    public boolean HaveNotifyMsg;
    @BindView(R.id.show_or_not)
    RelativeLayout show_or_not;
    @BindView(R.id.content_is_null)
    LinearLayout content_is_null;
    private Dialog dialog;

    public static MessageFragment newInstance(String param, DateLoadDown DateLoadDown) {
        mDateLoadDown = DateLoadDown;
        MessageFragment fragment = new MessageFragment();
        Bundle args = new Bundle();
        args.putString(PARAM, param);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mParam = getArguments().getString(PARAM);
        }
    }

    @Override
    public View initViews() {
        View view = View.inflate(mActivity, R.layout.fragment_message, null);
        //注入
        ButterKnife.bind(this, view);
        return view;
    }

    @Override
    public void setData() {
        pageIndex = 1;
        if ("notify".equals(mParam)) {
            messageType = 1;
            getUnreadNum(0, pageIndex,messageType,true);
//            getMessageList(0, pageIndex, messageType);
        } else if ("suspending".equals(mParam)) {
            messageType = 2;
            getUnreadNum(0, pageIndex,messageType,true);
//            getMessageList(0, pageIndex, messageType);
        }
    }

    @Override
    public void initData() {
        super.initData();
        mEntities = new ArrayList<>();
        mRefreshListView.setOnRefreshListener(this);
        mRefreshListView.setMode(PullToRefreshBase.Mode.BOTH);
        messageListAdapter = new CMessageListAdapter(mEntities, getContext());
        mRefreshListView.setAdapter(messageListAdapter);
        setData();
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        mRefreshListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                MessageEntity messageEntity = null;
                messageEntity = mEntities.get(i - 1);
                if (messageEntity.BizType == 3) {     //工作评价
                    Intent intent = new Intent(getActivity(), AuditWebViewActivity.class);
                    intent.putExtra("CommentType", "audit");
                    intent.putExtra("CompanyId", messageEntity.ToCompanyId);
                    intent.putExtra("BizId", messageEntity.BizId);
                    intent.putExtra("MsgID", messageEntity.MessageId);
                    startActivityForResult(intent, 110);
                } else if (messageEntity.BizType == 2) {  //离任报告
                    Intent intent = new Intent(getActivity(), AuditWebViewActivity.class);
                    intent.putExtra("CommentType", "leaving_report");
                    intent.putExtra("CompanyId", messageEntity.ToCompanyId);
                    intent.putExtra("BizId", messageEntity.BizId);
                    intent.putExtra("MsgID", messageEntity.MessageId);
                    startActivityForResult(intent, 110);
                } else {
                    Intent intent = new Intent(getActivity(), MessageDetailActivity.class);
                    intent.putExtra("messageEntity", JsonUtil.ToJson(messageEntity));
                    startActivityForResult(intent, 110);
                }
            }
        });
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 110) {
            if (resultCode == getActivity().RESULT_OK) {
//                Log.e(Global.LOG_TAG, "123");
                setData();
            }
        }
    }

    public void getMessageList(final int tag, final int Page, final int messageType,boolean isShowDialog) {
        if (isShowDialog) {
            dialog = DialogUtil.showLoadingDialog();
        }
        new AsyncRunnable<List<MessageEntity>>() {
            @Override
            protected List<MessageEntity> doInBackground(Void... params) {
                // 每次登录成功之后，保存token，并且返回登录信息
                List<MessageEntity> messageEntities = MessageRepository.getList(Page, messageType);
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
            }
        }.execute();
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase refreshView) {
        pageIndex = 1;
        getUnreadNum(0, pageIndex,messageType,false);
//        getMessageList(0, pageIndex, messageType);
    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase refreshView) {
        pageIndex++;
        getUnreadNum(1, pageIndex,messageType,false);
//        getMessageList(1, pageIndex, messageType);
    }

    public static DateLoadDown mDateLoadDown;

    public interface DateLoadDown {
        void initMsgPoint();
    }

    public void getUnreadNum(final int tag, final int Page, final int MessageType,final boolean isShowDialog) {

        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean success = MessageRepository.getUnreadNum(MessageType);
                return success;
            }

            @Override
            protected void onPostExecute(Boolean model) {
                if (model) {
                    if (messageType == 1) {//notify
                        HaveNotifyMsg = true;
                    }
                    if (messageType == 2) {//suspending
                        HaveSuspendingMsg = true;
                    }
                    mDateLoadDown.initMsgPoint();
                } else {
                    if (messageType == 1) {//notify
                        HaveNotifyMsg = false;
                    }
                    if (messageType == 2) {//suspending
                        HaveSuspendingMsg = false;
                    }
                    mDateLoadDown.initMsgPoint();
                }
                getMessageList(tag, Page, MessageType,isShowDialog);
            }

            protected void onPostError(Exception ex) {

            }
        }.execute();
    }
}
