package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.models.FeedbackEntity;
import com.juxian.bosscomments.models.ResultEntity;
import com.juxian.bosscomments.repositories.FeedbackRepository;
import com.juxian.bosscomments.utils.DialogUtils;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/10/18.
 *
 * @ProjectName: [LaoBanDianPing]
 * @Package: [com.juxian.bosscomments.ui]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/18 15:12]
 * @Version: [v1.0]
 */
public class SuggestionFeedBackActivity extends RemoteDataActivity implements View.OnClickListener, DialogUtils.ArchiveDialogListener {

    private InputMethodManager manager;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_button_button)
    Button CommitFeedBack;
    @BindView(R.id.feedback_content)
    EditText feedback_content;
    @BindView(R.id.total_content_number)
    TextView feedback_content_now_num;
    @BindView(R.id.total_content_number_all)
    TextView feedback_content_all_num;
    @BindView(R.id.hot_phone_line)
    TextView hot_phone_line;
    @BindView(R.id.contact_us)
    TextView contact_us;
    private int numContent = 1000;
    private Dialog dialog;

    @Override
    public int getContentViewId() {
        return R.layout.activity_suggestion_feedback;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.suggestion_feedback_text));
        CommitFeedBack.setText(getString(R.string.submit));
        feedback_content_all_num.setText("/1000");
//        String hot_line = "<font color='#999999'>意见反馈热线：</font><font color='#50a7ff'>400-7054-8812</font>";
//        hot_phone_line.setText(Html.fromHtml(hot_line));
    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);
        manager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
        initViewsData();
        initListener();
        setSystemBarTintManager(this);
    }

    @Override
    public void loadPageData() {
        IsInitData = true;
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        contact_us.setOnClickListener(this);
        CommitFeedBack.setOnClickListener(this);
        feedback_content.addTextChangedListener(new TextWatcher() {

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
                feedback_content_now_num.setText("" + number);
                // editStart = content.getSelectionStart();
                // editEnd = content.getSelectionEnd();
                if (feedback_content.getText().toString().length() > numContent) {
                    // s.delete(editStart - 1, editEnd);
                    // int tempSelection = editEnd;
                    // content.setText(s);
                    // content.setSelection(tempSelection);//设置光标在最后
                    feedback_content_now_num.setTextColor(SuggestionFeedBackActivity.this
                            .getResources().getColor(
                                    R.color.above_proof));
                }
                if (feedback_content.getText().toString().length() <= numContent) {
                    feedback_content_now_num.setTextColor(SuggestionFeedBackActivity.this
                            .getResources()
                            .getColor(R.color.menu_color));
                }
            }
        });
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        // TODO Auto-generated method stub
        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            if (getCurrentFocus() != null
                    && getCurrentFocus().getWindowToken() != null) {
                manager.hideSoftInputFromWindow(getCurrentFocus()
                        .getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
            }
        }
        return super.onTouchEvent(event);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_button_button:
                if (TextUtils.isEmpty(feedback_content.getText().toString().trim())) {
                    ToastUtil.showInfo(getString(R.string.feedback_content_not_empty));
                    return;
                }
                if (feedback_content.getText().toString().length() > numContent) {
                    ToastUtil.showInfo(getString(R.string.feedback_content_length_limit));
                    return;
                }
                if (feedback_content.getText().toString().length() < 5) {
                    ToastUtil.showInfo(getString(R.string.feedback_content_length_limit1));
                    return;
                }
                FeedbackEntity entity = new FeedbackEntity();
                entity.CompanyId = AppConfig.getCurrentUseCompany();
                entity.Content = feedback_content.getText().toString();
                getFeedbackFrequency(entity);
                break;
            case R.id.contact_us:
                Intent intent = new Intent(this, AboutUsActivity.class);
                startActivity(intent);
                break;
            default:
                break;
        }
    }

    protected void postFeedback(final FeedbackEntity entity) {// 提交用户信息
        new AsyncRunnable<ResultEntity>() {
            @Override
            protected ResultEntity doInBackground(Void... params) {
                ResultEntity resultEntity = FeedbackRepository.postFeedback(entity);
                return resultEntity;
            }

            @Override
            protected void onPostExecute(ResultEntity resultEntity) {
                if (dialog != null)
                    dialog.dismiss();
                if (resultEntity != null) {
                    if (resultEntity.Success) {
                        DialogUtils.showArchiveDialog(SuggestionFeedBackActivity.this, false, "确定", "继续添加", "感谢您的建议！", "您的意见已经收到，将会有专业人员来处理您的反馈。这对我们来提升服务品质来说非常的重要！欢迎您再次提出建议！", null, SuggestionFeedBackActivity.this);
                    } else {
                        ToastUtil.showInfo(resultEntity.ErrorMessage);
                    }
                } else {
                    ToastUtil.showInfo("添加失败");
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
            }

        }.execute();
    }

    protected void getFeedbackFrequency(final FeedbackEntity entity) {// 提交用户信息
        dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Integer>() {
            @Override
            protected Integer doInBackground(Void... params) {
                Integer resultEntity = FeedbackRepository.getFeedbackFrequency();
                return resultEntity;
            }

            @Override
            protected void onPostExecute(Integer resultEntity) {
                if (resultEntity < 3 && resultEntity >= 0) {
                    postFeedback(entity);
                } else if (resultEntity >= 3) {
                    if (dialog != null)
                        dialog.dismiss();
                    ToastUtil.showInfo("很抱歉,每天最多只能提交3次");
                } else {
                    if (dialog != null)
                        dialog.dismiss();
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
            }

        }.execute();
    }

    @Override
    public void LeftBtMethod() {
        setResult(RESULT_OK);
        finish();
    }

    @Override
    public void RightBtMethod(ArchiveCommentEntity entity) {

    }
}
