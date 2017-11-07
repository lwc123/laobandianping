package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.widget.EditText;
import com.pl.wheelview.WheelView;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Tam on 2016/12/30.
 */
public class PersonalJobSearchActivity extends BaseActivity implements View.OnClickListener {
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_button_button)
    Button include_button_button;
    @BindView(R.id.company_info)
    EditText company_info;

    @BindView(R.id.company_field)
    TextView company_field;
    @BindView(R.id.company_city)
    TextView company_city;
    @BindView(R.id.company_salary)
    TextView company_salary;
    private ArrayList<String> mSalary;
    private String industry;
    private String city;

    @Override
    public int getContentViewId() {
        return R.layout.activity_personal_job_search;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        setSystemBarTintManager(this);
        initViewsData();
        initListener();
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.include_button_button:
                String Post_name = company_info.getText().toString().trim();
                String Post_field = company_field.getText().toString().trim();
                String Post_city = company_city.getText().toString().trim();
                String Post_salary = company_salary.getText().toString().trim();
                Intent intent = getIntent();
                intent.putExtra("JobName", Post_name);
                intent.putExtra("JobField", Post_field);
                intent.putExtra("JobCity", Post_city);
                intent.putExtra("JobSalaty", Post_salary);
                setResult(RESULT_OK, intent);
                finish();
                break;
            case R.id.company_field:
                Intent toSelectIndustry = new Intent(getApplicationContext(), EditIndustryLableActivity.class);
                startActivityForResult(toSelectIndustry, 200);
                break;
            case R.id.company_city:
                Intent SelectCity = new Intent(getApplicationContext(), SelectCityActivity.class);
                startActivityForResult(SelectCity, 100);
                break;
            case R.id.company_salary:
                showSelectOneDialog("薪资范围", mSalary, company_salary, 1);
                break;
        }
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText("搜索职位");
        include_button_button.setText("搜索");
        company_field.setOnClickListener(this);
        company_city.setOnClickListener(this);
        company_salary.setOnClickListener(this);
        mSalary = new ArrayList<>();
        mSalary.add("3k-5k");
        mSalary.add("5k-10k");
        mSalary.add("10k-20k");
        mSalary.add("20k-50k");
        mSalary.add("50k-100k");
        mSalary.add("100k-1000k");

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 100:
                if (resultCode == RESULT_OK) {
                    city = data.getStringExtra("city");
                    company_city.setText(city);
                }
                break;
            case 200:
                // 选择行业
                if (resultCode == RESULT_OK) {
                    industry = data.getStringExtra("industry");
                    company_field.setText(industry);
                }
                break;
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        company_field.setOnClickListener(this);
        company_city.setOnClickListener(this);
        company_salary.setOnClickListener(this);
        include_button_button.setOnClickListener(this);
    }

    public void showSelectOneDialog(String title, ArrayList<String> datas, final TextView content, int defaultSelect) {
        final Dialog dl = new Dialog(this);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(true);
        View dialog_view = View.inflate(getApplicationContext(), R.layout.advertise_one_wheelview, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        setWindowParams(dialogWindow);
        dl.show();
        final WheelView mExperienceRequired = (WheelView) dialog_view.findViewById(R.id.experience_required);
        TextView mBtnConfirm = (TextView) dialog_view.findViewById(R.id.btn_confirm);
        TextView cancel = (TextView) dialog_view.findViewById(R.id.cancel);
        TextView start_time = (TextView) dialog_view.findViewById(R.id.start_time);
        start_time.setText(title);
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
            }
        });
        mBtnConfirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                content.setText(mExperienceRequired.getSelectedText());
                dl.dismiss();
            }
        });
        mExperienceRequired.setCyclic(false);
        mExperienceRequired.setData(datas);
        mExperienceRequired.setDefault(defaultSelect);
    }
}
