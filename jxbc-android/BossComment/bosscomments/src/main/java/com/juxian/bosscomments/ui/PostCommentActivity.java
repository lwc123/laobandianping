package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.OpinionEntity;
import com.juxian.bosscomments.models.OpinionReplyEntity;
import com.juxian.bosscomments.models.ResultEntity;
import com.juxian.bosscomments.repositories.CompanyReputationRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2017/4/12.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/12 14:51]
 * @Version: [v1.0]
 */
public class PostCommentActivity extends RemoteDataActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_button_button)
    Button mPostComment;
    @BindView(R.id.total_content_number_all)
    TextView mCommentContentTotalNum;
    @BindView(R.id.feedback_content)
    EditText mCommentContent;
    @BindView(R.id.total_content_number)
    TextView mCommentContentNowNum;
    private int numContent = 140;
    private String mFromResource;

    @Override
    public int getContentViewId() {
        return R.layout.activity_post_comment;
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
        title.setText(getString(R.string.post_comment_title));
        mPostComment.setText(getString(R.string.personal_on_anonymous_comments));
        mCommentContent.setHint("发表评论");
        mCommentContent.setTextColor(getResources().getColor(R.color.main_text_color));
        mCommentContentTotalNum.setText("/140");
        mFromResource = getIntent().getStringExtra("FromResource");
        if ("FromB".equals(mFromResource)){
            title.setText("回复点评");
            mPostComment.setText("回复");
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mPostComment.setOnClickListener(this);
        mCommentContent.addTextChangedListener(new TextWatcher() {

            @Override
            public void onTextChanged(CharSequence s, int start, int before,
                                      int count) {
                // TODO Auto-generated method stub
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count,
                                          int after) {
                // TODO Auto-generated method stub
            }

            @Override
            public void afterTextChanged(Editable s) {
                // TODO Auto-generated method stub
                int number = s.length();
                mCommentContentNowNum.setText("" + number);
                if (mCommentContent.getText().toString().length() > numContent) {
                    mCommentContentNowNum.setTextColor(PostCommentActivity.this
                            .getResources().getColor(
                                    R.color.above_proof));
                }
                if (mCommentContent.getText().toString().length() <= numContent) {
                    mCommentContentNowNum.setTextColor(PostCommentActivity.this
                            .getResources()
                            .getColor(R.color.menu_color));
                }
            }
        });
    }

    @Override
    public void loadPageData() {
        IsInitData = true;
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_button_button:
                mPostComment.setEnabled(false);
                if (TextUtils.isEmpty(mCommentContent.getText().toString().trim())){
                    ToastUtil.showInfo("评论不能为空");
                    mPostComment.setEnabled(true);
                    return;
                }
                if (mCommentContent.getText().toString().trim().length()>140){
                    ToastUtil.showInfo("评论最多140字哦~");
                    mPostComment.setEnabled(true);
                    return;
                }
                OpinionReplyEntity opinionReplyEntity = new OpinionReplyEntity();
                opinionReplyEntity.OpinionId = getIntent().getLongExtra("OpinionId",0);
                // 这个公司ID是口碑公司ID，不要与B端的公司ID混淆
                opinionReplyEntity.OpinionCompanyId = getIntent().getLongExtra("CompanyId",0);
                opinionReplyEntity.Content = mCommentContent.getText().toString().trim();
                if ("FromB".equals(mFromResource)){
                    // B端回复评论
                    CompanyEntity companyEntity = JsonUtil.ToEntity(AppConfig.getAccountCompany(),CompanyEntity.class);
                    opinionReplyEntity.CompanyId = AppConfig.getCurrentUseCompany();
                    opinionReplyEntity.Avatar = companyEntity.CompanyLogo;
                    opinionReplyEntity.NickName = companyEntity.CompanyAbbr;
                    opinionReplyEntity.ReplyType = 1;
                    enterpriseReply(opinionReplyEntity);
                } else {
                    opinionReplyEntity.ReplyType = 0;
                    getCompanyReputationList(opinionReplyEntity);
                }
                break;
        }
    }

    private void getCompanyReputationList(final OpinionReplyEntity opinionReplyEntity) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<ResultEntity>() {
            @Override
            protected ResultEntity doInBackground(Void... params) {
                ResultEntity resultEntity = CompanyReputationRepository.createCompanyCommentReply(opinionReplyEntity);
                return resultEntity;
            }

            @Override
            protected void onPostExecute(ResultEntity resultEntity) {
                if (dialog!=null)
                    dialog.dismiss();
                mPostComment.setEnabled(true);
                if (resultEntity != null) {
                    if (resultEntity.Success){
                        ToastUtil.showInfo("评论成功");
                        finish();
                    } else {
                        ToastUtil.showInfo("评论失败");
                    }
                } else {
                    onRemoteError();
                }
            }

            protected void onPostError(Exception ex) {
                if (dialog!=null)
                    dialog.dismiss();
                mPostComment.setEnabled(true);
                onRemoteError();
            }
        }.execute();
    }

    private void enterpriseReply(final OpinionReplyEntity opinionReplyEntity) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<ResultEntity>() {
            @Override
            protected ResultEntity doInBackground(Void... params) {
                ResultEntity resultEntity = CompanyReputationRepository.enterpriseReply(opinionReplyEntity);
                return resultEntity;
            }

            @Override
            protected void onPostExecute(ResultEntity resultEntity) {
                if (dialog!=null)
                    dialog.dismiss();
                mPostComment.setEnabled(true);
                if (resultEntity != null) {
                    if (resultEntity.Success){
                        ToastUtil.showInfo("回复成功");
                        finish();
                    } else {
                        ToastUtil.showInfo("回复失败");
                    }
                } else {
                    onRemoteError();
                }
            }

            protected void onPostError(Exception ex) {
                if (dialog!=null)
                    dialog.dismiss();
                mPostComment.setEnabled(true);
                onRemoteError();
            }
        }.execute();
    }
}
