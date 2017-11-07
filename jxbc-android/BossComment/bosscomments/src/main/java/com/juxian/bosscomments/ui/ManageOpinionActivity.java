package com.juxian.bosscomments.ui;

import android.support.v4.view.ViewPager;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.MessageViewPagerAdapter;
import com.juxian.bosscomments.fragment.BaseFragment;
import com.juxian.bosscomments.fragment.ManageOpinionFragment;
import com.juxian.bosscomments.ui.base.CompatRemoteDataActivity;

import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2017/4/25.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/25 10:29]
 * @Version: [v1.0]
 */
public class ManageOpinionActivity extends CompatRemoteDataActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.re_cc_service)
    RelativeLayout re_cc_service;
    @BindView(R.id.re_work_height)
    RelativeLayout re_work_height;
    @BindView(R.id.my_collect_service)
    TextView mAllCompany;
    @BindView(R.id.my_collect_work_height)
    TextView mAttentionCompany;
    @BindView(R.id.one)
    View line_one;// 红线1
    @BindView(R.id.two)
    View line_two;// 红线2
    @BindView(R.id.fragment_company_circle_viewpager)
    ViewPager mViewPager;
    @BindView(R.id.company_detail_bts)
    LinearLayout mOptionsBts;
    @BindView(R.id.company_detail_left_bt)
    TextView mManageOpinionLeftBt;
    @BindView(R.id.company_detail_right_bt)
    TextView mManageOpinionRightBt;
    private ArrayList<BaseFragment> fragmentList;
    private MessageViewPagerAdapter messageListAdapter;
    private ManageOpinionFragment mOwnOpinionList,mHideOpinionList;

    @Override
    public int getContentViewId() {
        return R.layout.fragment_company_circle;
    }

    @Override
    protected void onStart() {
        super.onStart();
        mAllCompany.post(new Runnable() {
            @Override
            public void run() {
                ViewGroup.LayoutParams layoutParams = line_one.getLayoutParams();
                layoutParams.width = mAllCompany.getMeasuredWidth();
                line_one.setLayoutParams(layoutParams);
            }
        });
        mAttentionCompany.post(new Runnable() {
            @Override
            public void run() {
                ViewGroup.LayoutParams layoutParams = line_two.getLayoutParams();
                layoutParams.width = mAttentionCompany.getMeasuredWidth();
                line_two.setLayoutParams(layoutParams);
            }
        });
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
        title.setText(getString(R.string.company_opinion_manage_opinion));
        fragmentList = new ArrayList<>();
        mViewPager.setCurrentItem(0);
        line_one.setVisibility(View.VISIBLE);
        line_two.setVisibility(View.GONE);
        mAllCompany.setText("已有点评");
        mAttentionCompany.setText("已隐藏点评");
        mOptionsBts.setVisibility(View.VISIBLE);
        mManageOpinionLeftBt.setText("全选");
        mManageOpinionRightBt.setText("隐藏");

        mOwnOpinionList = ManageOpinionFragment.newInstance("OwnOpinion",mManageOpinionLeftBt,mManageOpinionRightBt,getIntent().getLongExtra("OpinionCompanyId",0));
        mHideOpinionList = ManageOpinionFragment.newInstance("HideOpinion",mManageOpinionLeftBt,mManageOpinionRightBt,getIntent().getLongExtra("OpinionCompanyId",0));
        fragmentList.add(mOwnOpinionList);
        fragmentList.add(mHideOpinionList);

        messageListAdapter = new MessageViewPagerAdapter(getSupportFragmentManager(), fragmentList);
        mViewPager.setAdapter(messageListAdapter);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        re_cc_service.setOnClickListener(this);
        re_work_height.setOnClickListener(this);
        mManageOpinionLeftBt.setOnClickListener(this);
        mManageOpinionRightBt.setOnClickListener(this);
        mViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
            }

            @Override
            public void onPageSelected(int position) {
                if (position == 0) {
//                    mViewPager.setCurrentItem(0,false);
                    mAllCompany.setTextColor(getResources().getColor(R.color.luxury_gold_color));
                    mAttentionCompany.setTextColor(getResources().getColor(R.color.main_text_color));
                    line_one.setVisibility(View.VISIBLE);
                    line_two.setVisibility(View.GONE);
                    mManageOpinionLeftBt.setText("全选");
                    mManageOpinionRightBt.setText("隐藏");
                    fragmentList.get(0).setData();
                } else if (position == 1) {
//                    mViewPager.setCurrentItem(1,false);
                    line_one.setVisibility(View.GONE);
                    line_two.setVisibility(View.VISIBLE);
                    mAllCompany.setTextColor(getResources().getColor(R.color.main_text_color));
                    mAttentionCompany.setTextColor(getResources().getColor(R.color.luxury_gold_color));
                    mManageOpinionLeftBt.setText("全选");
                    mManageOpinionRightBt.setText("恢复显示");
                    fragmentList.get(1).setData();
                }
            }

            @Override
            public void onPageScrollStateChanged(int state) {
            }
        });
    }

    @Override
    public void loadPageData() {

    }

    @Override
    public void onClick(View view) {
        switch (view.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.re_cc_service:
                mViewPager.setCurrentItem(0,false);
                mAllCompany.setTextColor(getResources().getColor(R.color.luxury_gold_color));
                mAttentionCompany.setTextColor(getResources().getColor(R.color.main_text_color));
                line_one.setVisibility(View.VISIBLE);
                line_two.setVisibility(View.GONE);
                mManageOpinionLeftBt.setText("全选");
                mManageOpinionRightBt.setText("隐藏");
//                fragmentList.get(0).setData();
                break;
            case R.id.re_work_height:
                mViewPager.setCurrentItem(1,false);
                line_one.setVisibility(View.GONE);
                line_two.setVisibility(View.VISIBLE);
                mAllCompany.setTextColor(getResources().getColor(R.color.main_text_color));
                mAttentionCompany.setTextColor(getResources().getColor(R.color.luxury_gold_color));
                mManageOpinionLeftBt.setText("全选");
                mManageOpinionRightBt.setText("恢复显示");
//                fragmentList.get(1).setData();
                break;
            case R.id.company_detail_left_bt:
                fragmentList.get(mViewPager.getCurrentItem()).setAllSelect();
                break;
            case R.id.company_detail_right_bt:
//                ToastUtil.showInfo("可用");
                fragmentList.get(mViewPager.getCurrentItem()).netWork();
                break;
        }
    }
}
