package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.LinearLayout;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.repositories.ArchiveCommentRepository;
import com.juxian.bosscomments.widget.Button;
import com.juxian.bosscomments.widget.EditText;
import com.juxian.bosscomments.widget.TextView;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Tam on 2016/12/12.
 * 审核不通过页面
 */
public class AuditRejectReasonActivity extends BaseActivity {
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView mTitle;
    @BindView(R.id.feedback_content)
    EditText mReason;
    @BindView(R.id.include_button_button)
    Button mNotPassButton;
    @BindView(R.id.total_content_number)
    TextView mLeftCount;

    @Override
    public int getContentViewId() {
        return R.layout.activity_audit_reject_reason;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        initViewsData();
        initListener();
        setSystemBarTintManager(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        mTitle.setText(R.string.audit_notpass);
        mNotPassButton.setText(R.string.audit_notpass);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mNotPassButton.setOnClickListener(this);
        mReason.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                mLeftCount.setText((i + 1) + "");
            }

            @Override
            public void afterTextChanged(Editable editable) {
                if (editable.length() > 200) {
                    ToastUtil.showInfo("理由超过了200字");
                }
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
            case R.id.include_button_button:
                //审核不通过确定按钮
                ArchiveCommentEntity entity = new ArchiveCommentEntity();
                String reason = mReason.getText().toString().trim();
                if (TextUtils.isEmpty(reason)) {
                    ToastUtil.showInfo("请填写拒绝理由~");
                } else {
                    long bizId = getIntent().getLongExtra("CommentId", 0);
//                longvideo Mes_comment = getIntent().getLongExtra("Mes_comment", 0);
//                longvideo Mes_report = getIntent().getLongExtra("Mes_report", 0);
                    entity.CompanyId = getIntent().getLongExtra("CompanyId", 0);
                    entity.CommentId = bizId;
                    entity.RejectReason = reason;
                    reject(entity);
                }
                break;
        }
    }

    public void reject(final ArchiveCommentEntity entity) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean isReject = ArchiveCommentRepository.rejectArchiveComment(entity);
                return isReject;
            }

            @Override
            protected void onPostExecute(Boolean isReject) {
                if (dialog != null)
                    dialog.dismiss();
                if (isReject) {
                    ToastUtil.showInfo("拒绝成功");
                    finish();
                } else {
                    ToastUtil.showInfo("拒绝失败");
                }
            }

            protected void onPostError(Exception ex) {
//                ToastUtil.showError(getString(R.string.net_false_hint));
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }
}
