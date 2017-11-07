package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RatingBar;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.TagAdapter;
import com.juxian.bosscomments.models.OpinionEntity;
import com.juxian.bosscomments.models.ResultEntity;
import com.juxian.bosscomments.repositories.CompanyReputationRepository;
import com.juxian.bosscomments.widget.FlowLayout;
import com.juxian.bosscomments.widget.TagFlowLayout;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.DialogUtils;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2017/4/20.
 * 添加点评
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/20 16:34]
 * @Version: [v1.0]
 */
public class AddOpinionActivity extends RemoteDataActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.company_name)
    TextView mCompanyName;
    @BindView(R.id.ratingBar)
    RatingBar mRatingBar;
    @BindView(R.id.groups)
    LinearLayout mGroups;
    @BindView(R.id.tag_flow)
    TagFlowLayout mTagFlow;
    @BindView(R.id.total_content_number_all)
    TextView mCommentContentTotalNum;
    @BindView(R.id.feedback_content)
    EditText mCommentContent;
    @BindView(R.id.total_content_number)
    TextView mCommentContentNowNum;
    @BindView(R.id.include_button_button)
    Button mAnonymityOpinion;
    private int numContent = 500;
    private TagAdapter<String> adapter;
    private List<String> lables;
    private LayoutInflater mInflater;

    @Override
    public int getContentViewId() {
        return R.layout.activity_add_opinion;
    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);
        initViewsData();
        initListener();
        setSystemBarTintManager(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText("添加点评");
        mCompanyName.setText(getIntent().getStringExtra("CompanyName"));
        mRatingBar.setStepSize(1);
        mInflater = LayoutInflater.from(this);
        lables = new ArrayList<>();
        lables.add("1234");
        lables.add("1234");
        lables.add("1234");
        lables.add("1234");
        lables.add("1234");
        lables.add("1234");
        lables.add("1234");
        adapter = new TagAdapter<String>(lables) {
            @Override
            public View getView(FlowLayout parent, int position, String s) {
                TextView tv = (TextView) mInflater.inflate(
                        R.layout.item_opinion_lable, mTagFlow, false);
//                LinearLayout.LayoutParams params = new LinearLayout.LayoutParams((getMetrics().widthPixels - dp2px(88)) / 3, LinearLayout.LayoutParams.WRAP_CONTENT);
//                params.leftMargin = dp2px(11);
//                params.rightMargin = dp2px(11);
//                params.bottomMargin = dp2px(10);
//                tv.setPadding(0, dp2px(6), 0, dp2px(6));
//                tv.setLayoutParams(params);
                tv.setText(s);

                return tv;
            }
        };
        mTagFlow.setAdapter(adapter);

        mCommentContent.setHint("说说您对这家公司的评价吧，10个字以上");
        mAnonymityOpinion.setText("匿名点评");
        mCommentContent.setTextColor(getResources().getColor(R.color.main_text_color));
        mCommentContentTotalNum.setText("/500");
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mAnonymityOpinion.setOnClickListener(this);
        mRatingBar.setOnRatingBarChangeListener(new RatingBar.OnRatingBarChangeListener() {
            @Override
            public void onRatingChanged(RatingBar ratingBar, float v, boolean b) {
                mGroups.setVisibility(View.VISIBLE);

            }
        });
        mCommentContent.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before,
                                      int count) {
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count,
                                          int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
                // TODO Auto-generated method stub
                int number = s.length();
                mCommentContentNowNum.setText("" + number);
                if (mCommentContent.getText().toString().length() > numContent) {
                    mCommentContentNowNum.setTextColor(AddOpinionActivity.this
                            .getResources().getColor(
                                    R.color.above_proof));
                }
                if (mCommentContent.getText().toString().length() <= numContent) {
                    mCommentContentNowNum.setTextColor(AddOpinionActivity.this
                            .getResources()
                            .getColor(R.color.menu_color));
                }
            }
        });
        // 选择多个标签时的回调
        mTagFlow.setOnSelectListener(new TagFlowLayout.OnSelectListener() {
            @Override
            public void onSelected(Set<Integer> selectPosSet) {
                ToastUtil.showInfo("5678");
            }
        });
        mTagFlow.setOnTagClickListener(new TagFlowLayout.OnTagClickListener()
        {
            @Override
            public boolean onTagClick(View view, int position, FlowLayout parent)
            {
                ToastUtil.showInfo("1234");
                return true;
            }
        });
    }

    @Override
    public void loadPageData() {

    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_button_button:
                ToastUtil.showInfo("发布");
                break;
        }
    }

    private void createCompanyComment(final OpinionEntity entity) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<ResultEntity>() {
            @Override
            protected ResultEntity doInBackground(Void... params) {
                ResultEntity resultEntity = CompanyReputationRepository.createCompanyComment(entity);
                return resultEntity;
            }

            @Override
            protected void onPostExecute(ResultEntity resultEntity) {
                if (dialog != null)
                    dialog.dismiss();
                if (resultEntity != null) {
                    if (resultEntity.Success) {
                        ToastUtil.showInfo("添加成功");
                    } else {
                        ToastUtil.showInfo("添加失败");
                    }
                } else {
                    onRemoteError();
                }
            }

            protected void onPostError(Exception ex) {
                onRemoteError();
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

}
