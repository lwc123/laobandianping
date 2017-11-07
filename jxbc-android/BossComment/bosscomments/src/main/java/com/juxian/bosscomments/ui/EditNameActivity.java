package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Environment;
import android.text.TextUtils;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.DepartmentEntity;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.models.ResultEntity;
import com.juxian.bosscomments.repositories.CompanyMemberRepository;
import com.juxian.bosscomments.repositories.DepartmentRepository;
import com.juxian.bosscomments.utils.FileHelper;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * @version 1.0
 * @author: 付晓龙
 * @类 说 明:修改姓名
 * @创建时间：2016-3-16 下午1:46:17
 */
public class EditNameActivity extends BaseActivity implements OnClickListener {

    private InputMethodManager manager;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    //    @BindView(R.id.include_head_title_register)
//    TextView save;
//    @BindView(R.id.include_head_title_register_re)
//    RelativeLayout saveRe;
    private Context context;
    @BindView(R.id.activity_edit_name)
    EditText name;
    @BindView(R.id.include_button_button)
    Button save;
    @BindView(R.id.type_text)
    TextView mTypeText;
    @BindView(R.id.type_hint)
    TextView mTypeHint;
    public static final String TYPE_INDUSTRY = "type_industry", TYPE_ADD_DEPARTMENT = "type_add_department", TYPE_UPDATE_DEPARTMENT = "type_update_department", TYPE_EDIT_NAME = "type_edit_name";
    private Intent mIntent;
    private String mTypeTag;
    private ArrayList<String> histsoft;
    private static FileHelper helper;
    private DepartmentEntity mDepartmentEntity;
    private MemberEntity mMemberEntity;

    @Override
    public int getContentViewId() {
        return R.layout.activity_change_name;
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
        manager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
        initViewsData();
        back.setOnClickListener(this);

        save.setOnClickListener(this);
//        saveRe.setOnClickListener(this);
//        save.setVisibility(View.VISIBLE);
        setSystemBarTintManager(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.company_industry));

        save.setText(getString(R.string.save));
        mIntent = getIntent();
        mTypeTag = mIntent.getStringExtra(Global.LISTVIEW_ITEM_TAG);
        if (TYPE_INDUSTRY.equals(mTypeTag)) {
            mTypeText.setVisibility(View.GONE);
            mTypeHint.setVisibility(View.GONE);
            name.setHint(getString(R.string.industry_name));
        } else if (TYPE_ADD_DEPARTMENT.equals(mTypeTag)) {
            mTypeText.setVisibility(View.GONE);
            mTypeHint.setVisibility(View.GONE);
            name.setHint(getString(R.string.please_write_department_name));
            title.setText("添加部门");
        } else if (TYPE_UPDATE_DEPARTMENT.equals(mTypeTag)) {
            mTypeText.setVisibility(View.GONE);
            mTypeHint.setVisibility(View.GONE);
            mDepartmentEntity = JsonUtil.ToEntity(getIntent().getStringExtra("DepartmentEntity"), DepartmentEntity.class);
            name.setHint(getString(R.string.please_write_department_name));
            name.setText(mDepartmentEntity.DeptName);
            name.setSelection(mDepartmentEntity.DeptName.length());
            title.setText("修改部门");
        } else if (TYPE_EDIT_NAME.equals(mTypeTag)) {
            mTypeText.setVisibility(View.GONE);
            mTypeHint.setVisibility(View.GONE);
            mMemberEntity = JsonUtil.ToEntity(getIntent().getStringExtra("MemberEntity"), MemberEntity.class);
            name.setHint(getString(R.string.please_input_name));
            name.setText(mMemberEntity.RealName);
            name.setSelection(mMemberEntity.RealName.length());
            title.setText("修改姓名");
        }
        histsoft = new ArrayList<>();
        helper = new FileHelper(getApplicationContext());
        try {
            readFile02();
        } catch (IOException e) {
            e.printStackTrace();
        }
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
        super.onClick(v);
        Pattern idNumPattern = Pattern.compile("(\\d{14}[0-9a-zA-Z])|(\\d{17}[0-9a-zA-Z])");
        Matcher m1 = Pattern.compile("^1\\d{10}$").matcher(name.getText().toString());
        switch (v.getId()) {
            case R.id.include_button_button:// 保存
                if (TYPE_INDUSTRY.equals(mTypeTag)) {
                    if (TextUtils.isEmpty(name.getText().toString().trim())) {
                        ToastUtil.showInfo(getString(R.string.not_input_industry_content));
                        return;
                    }
                    if (name.getText().toString().trim().length() > 10) {
                        ToastUtil.showInfo(getString(R.string.industry_length_limit));
                        return;
                    }
                    saveHistory(name.getText().toString());
                    Intent intent = getIntent();
                    intent.putExtra("lable", name.getText().toString());
                    setResult(RESULT_OK, intent);
                    finish();
                } else if (TYPE_ADD_DEPARTMENT.equals(mTypeTag)) {
                    DepartmentEntity departmentEntity = new DepartmentEntity();
                    departmentEntity.CompanyId = AppConfig.getCurrentUseCompany();
                    departmentEntity.DeptName = name.getText().toString().trim();
                    addDepartment(departmentEntity);
                } else if (TYPE_UPDATE_DEPARTMENT.equals(mTypeTag)) {
                    if (mDepartmentEntity.DeptName.equals(name.getText().toString().trim())) {
                        finish();
                        return;
                    }
                    if (TextUtils.isEmpty(name.getText().toString().trim())) {
                        ToastUtil.showInfo("请输入部门名称");
                        return;
                    }
                    if (name.getText().toString().trim().length() > 20) {
                        ToastUtil.showInfo("部门名称超出了20个字");
                        return;
                    }
                    mDepartmentEntity.DeptName = name.getText().toString().trim();
                    updateDepartment(mDepartmentEntity);
                } else if (TYPE_EDIT_NAME.equals(mTypeTag)) {
                    if (TextUtils.isEmpty(name.getText().toString().trim())) {
                        ToastUtil.showInfo(getString(R.string.please_input_name));
                        return;
                    }
                    if (name.getText().toString().trim().length() > 5) {
                        ToastUtil.showInfo(getString(R.string.employee_record_name_limit));
                        return;
                    }
                    MemberEntity entity = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);
                    entity.RealName = name.getText().toString().trim();
                    entity.MobilePhone = mMemberEntity.MobilePhone;
                    PostUpdateCompanyMember(entity);
                }
                break;
            case R.id.include_head_title_lin:
                InputMethodManager imm = (InputMethodManager) getApplicationContext().getSystemService(Context.INPUT_METHOD_SERVICE);
                imm.hideSoftInputFromWindow(name.getWindowToken(), 0); //强制隐藏键盘
                finish();
                break;

            default:
                break;
        }
    }

    private void PostUpdateCompanyMember(final MemberEntity entity) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean success = CompanyMemberRepository.updateCompanyMember(entity);
                return success;
            }

            @Override
            protected void onPostExecute(Boolean success) {
                if (dialog != null)
                    dialog.dismiss();
                if (success == true) {
                    ToastUtil.showInfo("修改成功");
                    finish();
                } else {
                    ToastUtil.showInfo("修改失败");
                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    /**
     * 保存输入的标记到历史标签中，并且跳转到搜索结果界面
     *
     * @param search
     */
    public void saveHistory(String search) {
        for (int i = 0; i < histsoft.size(); i++) {
            if (search
                    .equals(histsoft.get(i))) {// 如果有重复的删除
                histsoft.remove(i);
            }
        }
//        if (histsoft.size() >= 3) {// 已经有10个
//            histsoft.remove(0);
//            histsoft.add(search);// 搜索内容加载到搜索历史中
//            helper.deleteSDFile("JuXianBossComments.txt");
//            try {
//                helper.writeSDFile(histsoft,
//                        "JuXianBossComments.txt");
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
//            ToastUtil.showInfo("您已添加过三个行业");
//            return;
//        } else {// 搜索记录不足3个
        histsoft.add(search);// 搜索内容加载到搜索历史中
        helper.deleteSDFile("JuXianBossComments.txt");
        try {
            helper.writeSDFile(histsoft,
                    "JuXianBossComments.txt");
        } catch (Exception e) {
            e.printStackTrace();
        }
//        }
    }


    public void readFile02() throws IOException {
        FileInputStream fis = new FileInputStream(Environment
                .getExternalStorageDirectory().getPath()
                + "//"
                + "JuXianBossComments.txt");
        InputStreamReader isr = new InputStreamReader(fis, "UTF-8");
        BufferedReader br = new BufferedReader(isr);
        // 简写如下
        // BufferedReader br = new BufferedReader(new InputStreamReader(
        // new FileInputStream("E:/phsftp/evdokey/evdokey_201103221556.txt"),
        // "UTF-8"));
        String line = "";
        String[] arrs = null;
        histsoft.clear();
        while ((line = br.readLine()) != null) {
            // arrs = line.split(",");
            // ToastUtil.showInfo(line);
            histsoft.add(line);
            Log.i("JuXian", "测试" + line);
            // System.out.println(arrs[0] + " : " + arrs[1] + " : " + arrs[2]);
        }

        br.close();
        isr.close();
        fis.close();
    }

    protected void addDepartment(final DepartmentEntity entity) {// 提交用户信息
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<ResultEntity>() {
            @Override
            protected ResultEntity doInBackground(Void... params) {
                ResultEntity resultEntity = DepartmentRepository.addDepartment(entity);
                return resultEntity;
            }

            @Override
            protected void onPostExecute(ResultEntity resultEntity) {
                dialog.dismiss();
                if (resultEntity != null) {
                    if (resultEntity.Success) {
                        ToastUtil.showInfo("添加成功");
                        finish();
                    } else {
                        ToastUtil.showInfo(resultEntity.ErrorMessage);
                    }
                } else {
                    ToastUtil.showInfo("添加失败");
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                dialog.dismiss();
            }

        }.execute();
    }

    protected void updateDepartment(final DepartmentEntity entity) {// 提交用户信息
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<ResultEntity>() {
            @Override
            protected ResultEntity doInBackground(Void... params) {
                ResultEntity resultEntity = DepartmentRepository.updateDepartment(entity);
                return resultEntity;
            }

            @Override
            protected void onPostExecute(ResultEntity resultEntity) {
                dialog.dismiss();
                if (resultEntity != null) {
                    if (resultEntity.Success) {
                        ToastUtil.showInfo("修改成功");
                        finish();
                    } else {
                        ToastUtil.showInfo(resultEntity.ErrorMessage);
                    }
                } else {
                    ToastUtil.showInfo("网络错误");
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                ToastUtil.showInfo("网络错误");
                dialog.dismiss();
            }

        }.execute();
    }
}
