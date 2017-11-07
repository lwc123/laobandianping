package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import handmark.pulltorefresh.library.PullToRefreshBase;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.SearchResultAdapter;
import com.juxian.bosscomments.adapter.TagAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.BossCommentEntity;
import com.juxian.bosscomments.models.TargetEmploye;
import com.juxian.bosscomments.repositories.BossCommentRepository;
import com.juxian.bosscomments.widget.FlowLayout;
import com.juxian.bosscomments.widget.TagFlowLayout;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/10/28.
 *
 * @ProjectName: [BossComment]
 * @Package: [com.juxian.bosscomments.ui]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/28 9:55]
 * @Version: [v1.0]
 */
public class SearchResultActivity extends BaseActivity implements PullToRefreshBase.OnRefreshListener2<ListView>,View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
//    @BindView(R.id.refresh_listView)
//    PullToRefreshListView refreshListView;
    @BindView(R.id.listView)
    ListView refreshListView;
    @BindView(R.id.search_result_employee_data)
    LinearLayout search_result_employee_data;
    @BindView(R.id.id_flowlayout)
    TagFlowLayout mFlowLayout;
    @BindView(R.id.edit_one_content)
    TextView search_name;
    @BindView(R.id.edit_two_content)
    TextView search_identity_number;
    @BindView(R.id.comments_number)
    TextView comments_number;
    @BindView(R.id.result_empty)
    LinearLayout result_empty;
    @BindView(R.id.include_button_button)
    Button add_boss_comments;
//    private View refreshListViewHeader;
//    private View refreshListViewFooter;
    private List<BossCommentEntity> entities;
    private SearchResultAdapter adapter;
    private LayoutInflater mInflater;
    private String[] mVals;
    private Intent mIntent;
    private int pageIndex = 1;
//     StopWatch

    @Override
    public int getContentViewId() {
        return R.layout.activity_search_result;
    }

    private Handler mHandler = new Handler() {
        public void handleMessage(android.os.Message msg) {
            mFlowLayout.setAdapter(new TagAdapter<String>((String[]) msg.obj) {
                @Override
                public View getView(FlowLayout parent, int position, String s) {
                    TextView tv = (TextView) mInflater.inflate(
                            R.layout.flow_tv, mFlowLayout, false);
                    Random rand = new Random();
                    int i = rand.nextInt(5);
                    switch (i){
                        case 0:
                            tv.setBackgroundDrawable(getResources().getDrawable(R.drawable.tag_flow_bg_one));
                            break;
                        case 1:
                            tv.setBackgroundDrawable(getResources().getDrawable(R.drawable.tag_flow_bg_two));
                            break;
                        case 2:
                            tv.setBackgroundDrawable(getResources().getDrawable(R.drawable.tag_flow_bg_three));
                            break;
                        case 3:
                            tv.setBackgroundDrawable(getResources().getDrawable(R.drawable.tag_flow_bg_four));
                            break;
                        case 4:
                            tv.setBackgroundDrawable(getResources().getDrawable(R.drawable.tag_flow_bg_five));
                            break;
                        default:
                            tv.setBackgroundDrawable(getResources().getDrawable(R.drawable.tag_flow_bg_one));
                    }
                    tv.setText(s);
                    return tv;
                }
            });
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        setSystemBarTintManager(this);
        mInflater = LayoutInflater.from(this);
        initViewsData();
        initListener();
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getIntent().getStringExtra("employee_name")+getString(R.string.employee_boss_comments));
//        refreshListView.setMode(PullToRefreshBase.Mode.DISABLED);
//        refreshListViewHeader = LayoutInflater.from(getApplicationContext()).inflate(R.layout.include_search_result_head,null);
//        refreshListView.getRefreshableView().addHeaderView(refreshListViewHeader);
//        refreshListViewFooter = LayoutInflater.from(getApplicationContext()).inflate(R.layout.include_search_result_footer,null);
//        Button include_button_button = (Button) refreshListViewFooter.findViewById(R.id.include_button_button);
//        include_button_button.setText(getString(R.string.add_comment));
//        include_button_button.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                Intent AddAccreditPerson = new Intent(getApplicationContext(), AddAccreditPersonActivity.class);
//                startActivity(AddAccreditPerson);
//            }
//        });
//        refreshListView.getRefreshableView().addFooterView(refreshListViewFooter);
        mIntent = getIntent();

        entities = new ArrayList<>();

        GetBossCommentSearch(mIntent.getStringExtra("employee_identity_number"),mIntent.getStringExtra("employee_name"),mIntent.getStringExtra("employee_company"),pageIndex);
        adapter = new SearchResultAdapter(entities,getApplicationContext());
        refreshListView.setAdapter(adapter);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        add_boss_comments.setOnClickListener(this);
//        refreshListView.setOnRefreshListener(this);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_button_button:
                ToastUtil.showInfo("添加一个");
                break;
            default:
        }
    }

    @Override
    public void onPullDownToRefresh(PullToRefreshBase<ListView> refreshView) {

    }

    @Override
    public void onPullUpToRefresh(PullToRefreshBase<ListView> refreshView) {

    }

    private void GetBossCommentSearch(final String idCard,final String employeeName,final String company,final int pageIndex) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<TargetEmploye>() {
            @Override
            protected TargetEmploye doInBackground(Void... params) {
                TargetEmploye targetEmploye = BossCommentRepository.GetBossCommentSearch(idCard,employeeName,company,pageIndex);
                return targetEmploye;
            }

            @Override
            protected void onPostExecute(TargetEmploye targetEmploye) {
                if (dialog != null)
                    dialog.dismiss();
                if (targetEmploye!=null) {
                    if (!TextUtils.isEmpty(targetEmploye.RealName)) {
                        search_name.setText(targetEmploye.RealName);
                        title.setText(targetEmploye.RealName+getString(R.string.employee_boss_comments));
                    } else {
                        search_name.setText("");
                    }
                    if (!TextUtils.isEmpty(targetEmploye.IDCard)){
                        search_identity_number.setText(targetEmploye.IDCard);
                    } else {
                        search_identity_number.setText("");
                    }
                    if (targetEmploye.Tags != null) {
                        mVals = new String[targetEmploye.Tags.length];
                        for (int i = 0; i < targetEmploye.Tags.length; i++) {
                            mVals[i] = targetEmploye.Tags[i];
                            Log.e(Global.LOG_TAG,targetEmploye.Tags[i]);
                        }
                        Message msg = mHandler.obtainMessage();
                        msg.obj = mVals;
                        mHandler.sendMessage(msg);
                    }
                    if (targetEmploye.Comments != null) {
                        comments_number.setText("截止目前该人才收到" + targetEmploye.Comments.size() + "条老板点评信息");
                        entities.addAll(targetEmploye.Comments);
                        result_empty.setVisibility(View.GONE);
                        refreshListView.setVisibility(View.VISIBLE);
                        adapter.notifyDataSetChanged();
                        search_result_employee_data.setFocusable(true);
                        search_result_employee_data.setFocusableInTouchMode(true);
                        search_result_employee_data.requestFocus();
                    } else {
                        comments_number.setText("截止目前该人才收到0条老板点评信息");
                        result_empty.setVisibility(View.VISIBLE);
                        refreshListView.setVisibility(View.GONE);
                    }
                } else {
                    comments_number.setText("截止目前该人才收到0条老板点评信息");
                    result_empty.setVisibility(View.VISIBLE);
                    refreshListView.setVisibility(View.GONE);
                }
            }

            protected void onPostError(Exception ex) {
                comments_number.setText("截止目前该人才收到0条老板点评信息");
                result_empty.setVisibility(View.VISIBLE);
                refreshListView.setVisibility(View.GONE);
//                ToastUtil.showError(getString(R.string.net_false_hint));
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

}
