package com.juxian.bosscomments.ui;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.RadioGroup;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.HomeViewPagerAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.fragment.BaseFragment;
import com.juxian.bosscomments.fragment.CPersonalCenterFragment;
import com.juxian.bosscomments.fragment.CompanyCircleFragment;
import com.juxian.bosscomments.fragment.InviteFragment;
import com.juxian.bosscomments.fragment.MainFragment;
import com.juxian.bosscomments.fragment.PersonalCenterFragment;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.repositories.ApiTestRepository;
import com.juxian.bosscomments.utils.DialogUtils;
import com.juxian.bosscomments.utils.SystemBarTintManager;
import com.juxian.bosscomments.widget.NoScrollViewPager;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.webapi.WebApiClient;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/10/17.
 *
 * @Description: 主页
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/17 9:19]
 * @Version: [v1.0]
 */
public class CHomeActivity extends BaseHomeActivity implements View.OnClickListener {

    private static final String savedTab = "savedTab";

    //    @BindView(R.id.fragment_container)
//    FrameLayout fragmentContainer;
    @BindView(R.id.activity_home_viewpager)
    NoScrollViewPager mHomeViewPager;
    @BindView(R.id.rb_tab_main)
    RadioButton rbTabMain;
    @BindView(R.id.rb_tab_person)
    RadioButton rbTabPerson;
    @BindView(R.id.main_radios)
    RadioGroup mainRadios;
    @BindView(R.id.go_to_search)
    ImageView mGoToSearch;
    private SystemBarTintManager tintManager;
    private int PageTag = 0;
    private ArrayList<BaseFragment> mFragmentList;
    private int mAuditStatus;
    private String mAuditInfo;
    private long oldTime;
    private long FirstClick;

    @Override
    public int getContentViewId() {
        return R.layout.activity_chome;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        initViewsData();
        //onSaveInstanceState会保存已点击 tab 的 aid
        initShowView(savedInstanceState);

//        initPaySuccess();

        initListener();
        setSystemBarTintManager(this);
    }

    @Override
    public void initListener() {
        super.initListener();
        rbTabMain.setOnClickListener(this);
        rbTabPerson.setOnClickListener(this);
        mGoToSearch.setOnClickListener(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
//        GetMineMessage(AppConfig.getCurrentUseCompany());
        mFragmentList = new ArrayList<>();
        mFragmentList.add(CompanyCircleFragment.newInstance("CompanyOpinion"));
        mFragmentList.add(CPersonalCenterFragment.newInstance("CPersonalCenter"));
        HomeViewPagerAdapter myPagerAdapter = new HomeViewPagerAdapter(getSupportFragmentManager(), mFragmentList);
        mHomeViewPager.setScrollble(true);
        mHomeViewPager.setAdapter(myPagerAdapter);
        mHomeViewPager.setOffscreenPageLimit(2);

        mHomeViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {

            @Override
            public void onPageSelected(int arg0) {
                // TODO Auto-generated method stub
                if (arg0 == 0) {
                    mFragmentList.get(arg0).setData();
                } else if (arg0 == 1) {

                    //每次刷新一个新时间，和上一次的时间对比，60s后就会刷新数据，不管时间够不够60s，时间都要重置。
//                    long newTime = System.currentTimeMillis();
//
//                    if (newTime - oldTime > 1000 * 120) {
                    mFragmentList.get(arg0).setData();
//                    }
//                    oldTime = newTime;
                }
            }

            @Override
            public void onPageScrolled(int arg0, float arg1, int arg2) {
                // TODO Auto-generated method stub

            }

            @Override
            public void onPageScrollStateChanged(int arg0) {
                // TODO Auto-generated method stub

            }
        });
        mHomeViewPager.setCurrentItem(0, false);
        mFragmentList.get(0).setData();
    }

    /**
     * 初始化最初显示页面
     *
     * @param savedInstanceState
     */
    public void initShowView(Bundle savedInstanceState) {
        if (savedInstanceState == null) {
            //默认将第一个RadioButton设为选中
            Log.i(Global.LOG_TAG, "savedInstanceState  null");
            rbTabMain.performClick();
        } else {
            Log.i(Global.LOG_TAG, "savedInstanceState not null");

            RadioButton radioButton = (RadioButton) findViewById(savedInstanceState.getInt(savedTab));
            Log.i(Global.LOG_TAG, radioButton.getText() + "");

            radioButton.performClick();
        }
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        outState.putInt(savedTab, mainRadios.getCheckedRadioButtonId());
        RadioButton radioButton = (RadioButton) findViewById(mainRadios.getCheckedRadioButtonId());
        //删除下面这行，不然容易发生重影
//        super.onSaveInstanceState(outState);
    }

    @Override
    protected void onResume() {
        super.onResume();
//        GetMineMessage(AppConfig.getCurrentUseCompany());
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 1:
                if (resultCode == RESULT_OK) {
                    rbTabMain.setChecked(false);
                    rbTabPerson.setChecked(false);
                    mainRadios.clearCheck();
                    if (PageTag == 1) {
                        rbTabMain.performClick();
                    } else {
                        rbTabPerson.performClick();
                    }
                }
                break;
            case 2:
                //我的动态
                if (resultCode == RESULT_OK) {
                    mFragmentList.get(1).setData();
                }
                break;
            case 100:
                if (resultCode == RESULT_OK){
                    finish();
                }
                break;
            default:
                break;
        }
        switch (resultCode) {
            //直接从发布返回；我的动态-->发布-->返回
            case 10086:
                //发布
                mFragmentList.get(1).setData();
                break;
        }
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.rb_tab_main:
                mHomeViewPager.setCurrentItem(0, false);
                break;
            case R.id.rb_tab_person:
//                long newClick = System.currentTimeMillis();
                mHomeViewPager.setCurrentItem(1, false);
//                //1s内双击老板圈刷新
//                if (newClick - FirstClick < 1.0 * 1000) {
//                    mFragmentList.get(1).setData();
//                }
//                FirstClick = newClick;
                break;
            case R.id.go_to_search:
                Intent intent = new Intent(getApplicationContext(),SearchCompanyActivity.class);
                startActivityForResult(intent,100);
                break;
        }
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
    }

    public int dp2px(int dp) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp,
                getResources().getDisplayMetrics());
    }
}
