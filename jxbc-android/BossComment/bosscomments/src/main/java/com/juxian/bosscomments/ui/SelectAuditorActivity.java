package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.TagAdapter;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.repositories.CompanyMemberRepository;
import com.juxian.bosscomments.widget.FlowLayout;
import com.juxian.bosscomments.widget.TagFlowLayout;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * @version 1.0
 * @author: 付晓龙
 * @类 说 明:
 * @创建时间：2016-3-10 下午3:55:26
 */
public class SelectAuditorActivity extends BaseActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    private Context context;
    private List<MemberEntity> Lable;
    private List<MemberEntity> mSelectAuditors;
    private List<String> lables;
    @BindView(R.id.lable_flowlayout)
    TagFlowLayout mFlowLayout;
    private LayoutInflater mInflater;
    @BindView(R.id.hint)
    TextView mHint;
    @BindView(R.id.include_button_button)
    Button mSure;
    private TagAdapter<String> adapter;

    @Override
    public int getContentViewId() {
        return R.layout.activity_edit_auditor_lable;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        context = this;
        initViewsData();
        initListener();

        setSystemBarTintManager(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        Lable = new ArrayList<MemberEntity>();
        mSelectAuditors = new ArrayList<>();
        lables = new ArrayList<>();
        adapter = new TagAdapter<String>(lables) {
            @Override
            public View getView(FlowLayout parent, int position, String s) {
                TextView tv = (TextView) mInflater.inflate(
                        R.layout.item_edit_lable, mFlowLayout, false);
                LinearLayout.LayoutParams params = new LinearLayout.LayoutParams((getMetrics().widthPixels - dp2px(88)) / 3, LinearLayout.LayoutParams.WRAP_CONTENT);
                params.leftMargin = dp2px(11);
                params.rightMargin = dp2px(11);
                params.bottomMargin = dp2px(10);
                tv.setPadding(0, dp2px(6), 0, dp2px(6));
                tv.setLayoutParams(params);
                tv.setText(s);

                return tv;
            }
        };
        mFlowLayout.setAdapter(adapter);
        title.setText(getString(R.string.select_auditor_title));
        mHint.setText(getString(R.string.select_auditor_is_empty));
        mSure.setText(getString(R.string.ok));
        mSure.setVisibility(View.GONE);
        mInflater = LayoutInflater.from(this);
        getCompanyMemberList(AppConfig.getCurrentUseCompany());
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mSure.setOnClickListener(this);
        mFlowLayout.setOnTagClickListener(new TagFlowLayout.OnTagClickListener() {
            @Override
            public boolean onTagClick(View view, int position,
                                      FlowLayout parent) {
                if (position == lables.size() - 1) {
                    MemberEntity entity = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);
                    if (entity.Role == MemberEntity.CompanyMember_Role_Boss || entity.Role == MemberEntity.CompanyMember_Role_Admin) {
                        mFlowLayout.setSelectStatus(position);
                        Intent intent = new Intent(context, AddAccreditPersonActivity.class);
                        intent.putExtra("FromSelectAuditor", "FromSelectAuditor");
                        startActivityForResult(intent, 100);
                    } else {
                        ToastUtil.showInfo("您没有添加审核人的权限");
                        mFlowLayout.setSelectStatus(position);
                        return false;
//                        ((TagView)view).setChecked(false);
                    }
                } else {

                }
                return true;
            }
        });
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_button_button:// 保存标签
                if (mFlowLayout.getSelectedView().size() > 0) {
                    List<MemberEntity> SelectAuditors = new ArrayList<>();
                    SelectAuditors.addAll(getSelectAuditors());
                    Intent intent = new Intent();
                    ArrayList<String> AuditorStrings = new ArrayList<String>();
                    for (int i = 0; i < SelectAuditors.size(); i++) {
                        AuditorStrings.add(JsonUtil.ToJson(SelectAuditors.get(i)));
                    }
                    intent.putStringArrayListExtra("AuditorStrings", AuditorStrings);
                    setResult(RESULT_OK, intent);
                    finish();
                } else {
                    finish();
                }
                break;
            default:
                break;
        }
    }

//    @Override
//    protected void onResume() {
//        super.onResume();
//        getCompanyMemberList(AppConfig.getCurrentUseCompany());
//    }

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
                if (memberEntities == null) {

                } else {
                    mHint.setText("选择授权的审核人（可以多选）");
                    Lable.clear();
                    lables.clear();
                    for (int i = 0; i < memberEntities.size(); i++) {
                        if (memberEntities.get(i).Role == MemberEntity.CompanyMember_Role_Senior) {
                            Lable.add(memberEntities.get(i));
                        }
                    }
                    for (int i = 0; i < Lable.size(); i++) {
                        lables.add(Lable.get(i).RealName);
                    }
//                    MemberEntity memberEntity = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);
//                    if (memberEntity.Role == MemberEntity.CompanyMember_Role_Boss || memberEntity.Role == MemberEntity.CompanyMember_Role_Admin) {
                    lables.add("+添加审核人");
//                    }
                    if (Lable.size() == 0) {
                        mSure.setVisibility(View.GONE);
                    } else {
                        mSure.setVisibility(View.VISIBLE);
                    }
                    adapter.notifyDataChanged();
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    // 选中的行业的keys
    public List<MemberEntity> getSelectAuditors() {
        if (mFlowLayout.getSelectedView().size() > 0) {
            Iterator<Integer> it = mFlowLayout.getSelectedView().iterator();
            while (it.hasNext()) {
                mSelectAuditors.add(Lable.get(it.next()));
            }
            return mSelectAuditors;
        } else {
            return null;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 100:
                if (resultCode == RESULT_OK) {
                    getCompanyMemberList(AppConfig.getCurrentUseCompany());
                }
                break;
        }
    }
}
