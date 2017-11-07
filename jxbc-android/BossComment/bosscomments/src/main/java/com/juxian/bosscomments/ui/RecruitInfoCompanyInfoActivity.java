package com.juxian.bosscomments.ui;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.BizDictEntity;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.modules.DictionaryPool;
import com.juxian.bosscomments.repositories.CompanyRepository;

import net.juxian.appgenome.utils.AsyncRunnable;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Tam on 2016/12/28.
 */
public class RecruitInfoCompanyInfoActivity extends BaseActivity {
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.activity_company_info_modify)
    LinearLayout activity_company_info_modify;
    @BindView(R.id.company_info_text_field)
    TextView company_info_text_field;
    @BindView(R.id.company_info_text_abbr)
    TextView company_info_text_abbr;
    @BindView(R.id.company_info_text_size)
    TextView company_info_text_size;
    @BindView(R.id.company_info_text_city)
    TextView company_info_text_city;
    private List<BizDictEntity> Citys;
    private List<BizDictEntity> Industrys;

    @Override
    public int getContentViewId() {
        return R.layout.activity_recruit_conpany_info;
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
        title.setText("发布职位");
        Citys = new ArrayList<>();
        Industrys = new ArrayList<>();
        GetDictonary();
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
//        activity_company_info_modify.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.activity_company_info_modify://跳去我的进行修改
                Intent ChangeData = new Intent(this, ModifyCpInfoActivity.class);
                startActivity(ChangeData);
                break;
        }
    }

    private void GetCompanyMessage(final long CompanyId) {
        // 获取企业信息，根据之前保存的企业id查询
        new AsyncRunnable<CompanyEntity>() {
            @Override
            protected CompanyEntity doInBackground(Void... params) {
                CompanyEntity entity = CompanyRepository.getSummary(CompanyId);
                return entity;
            }

            @Override
            protected void onPostExecute(CompanyEntity entity) {
                if (entity != null){
//                    for (int i=0;i<Industrys.size();i++) {
//                        if (entity.Industry.equals(Industrys.get(i).Code)) {
//                            company_info_text_field.setText(Industrys.get(i).Name);
//                        }
//                    }
                    company_info_text_field.setText(entity.Industry);
                    company_info_text_abbr.setText(entity.CompanyAbbr);
                    company_info_text_size.setText(entity.CompanySizeText);
//                    for (int i=0;i<Citys.size();i++) {
//                        if (entity.Region.equals(Citys.get(i).Code)) {
//                            company_info_text_city.setText(Citys.get(i).Name);
//                        }
//                    }
                    company_info_text_city.setText(entity.RegionText);
                }
            }

            protected void onPostError(Exception ex) {
                Log.e(Global.LOG_TAG, "net abnormal!");
            }
        }.execute();
    }

    private void GetDictonary() {
        // 获取企业信息，根据之前保存的企业id查询
        new AsyncRunnable<HashMap<String, List<BizDictEntity>>>() {
            @Override
            protected HashMap<String, List<BizDictEntity>> doInBackground(Void... params) {
                HashMap<String, List<BizDictEntity>> entities = DictionaryPool.loadCityIndustryDictionaries();
                return entities;
            }

            @Override
            protected void onPostExecute(HashMap<String, List<BizDictEntity>> entities) {
                if (entities != null){
                    if (entities.size()>0) {
                        Citys = entities.get(DictionaryPool.Code_City);
                        Industrys = entities.get(DictionaryPool.Code_Industry);
                        GetCompanyMessage(AppConfig.getCurrentUseCompany());
                    }
                }
            }

            protected void onPostError(Exception ex) {
                Log.e(Global.LOG_TAG, "net abnormal!");
            }
        }.execute();
    }
}
