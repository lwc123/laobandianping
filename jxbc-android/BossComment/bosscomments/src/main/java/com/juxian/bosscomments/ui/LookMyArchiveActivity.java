package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.PrivatenessServiceContractEntity;
import com.juxian.bosscomments.models.PrivatenessSummaryEntity;
import com.juxian.bosscomments.models.ResultEntity;
import com.juxian.bosscomments.repositories.PrivatenessRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/12/16.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/16 19:33]
 * @Version: [v1.0]
 */
public class LookMyArchiveActivity extends RemoteDataActivity implements View.OnClickListener {

    private InputMethodManager manager;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_button_button)
    Button mSave;
    @BindView(R.id.identity_card_number)
    EditText mInputIDCard;

    @Override
    public int getContentViewId() {
        return R.layout.activity_look_my_archive;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.personal_my_archive));
        mSave.setText("保存并查询");
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
        mSave.setOnClickListener(this);
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
        switch (v.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_button_button:
                Pattern idNumPattern = Pattern.compile("(\\d{14}[0-9a-zA-Z])|(\\d{17}[0-9a-zA-Z])");
                Matcher idNumMatcher = idNumPattern.matcher(mInputIDCard.getText().toString());
                if (TextUtils.isEmpty(mInputIDCard.getText().toString())){
                    ToastUtil.showInfo("请填写身份证号");
                    return;
                }
                if (!idNumMatcher.matches()){
                    ToastUtil.showInfo(getString(R.string.employee_identity_number_error));
                    mInputIDCard.requestFocus();
                    return;
                }
                bindingIDCard(mInputIDCard.getText().toString());
                break;
        }
    }

    private void bindingIDCard(final String IDCard) {
        // 获取企业信息，根据之前保存的企业id查询
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<ResultEntity>() {
            @Override
            protected ResultEntity doInBackground(Void... params) {
                ResultEntity entity = PrivatenessRepository.bindingIDCard(IDCard);
                return entity;
            }

            @Override
            protected void onPostExecute(ResultEntity entity) {
                if (dialog != null)
                    dialog.dismiss();
                if (entity != null) {
                    if (entity.Success){
                        AppConfig.setPersonalServiceContract(entity.JsonModel);
                        Intent intent = new Intent(getApplicationContext(),PersonalArchiveListActivity.class);
                        startActivity(intent);
                        finish();
                    } else {
                        ToastUtil.showInfo(entity.ErrorMessage);
                    }
                } else {
//                    ToastUtil.showInfo("网络错误");
                    onRemoteError();
                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
//                Log.e(Global.LOG_TAG, "net abnormal!");
            }
        }.execute();
    }
}
