package com.juxian.bosscomments.fragment;

import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.MessageViewPagerAdapter;
import com.juxian.bosscomments.models.ConsoleEntity;
import com.juxian.bosscomments.repositories.CompanyReputationRepository;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2017/4/10.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/10 13:35]
 * @Version: [v1.0]
 */
public class CompanyCircleFragment extends BaseFragment implements View.OnClickListener,CompanyListFragment.onRefreshRedPointListener {

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
    @BindView(R.id.msg1)
    ImageView msg1;// 红点1
    @BindView(R.id.msg2)
    ImageView msg2;// 红点2
    @BindView(R.id.fragment_company_circle_viewpager)
    ViewPager mViewPager;
    private static final String PARAM = "param";
    private String mParam;
    private MessageViewPagerAdapter messageListAdapter;
    private ArrayList<BaseFragment> fragmentList;
    private CompanyListFragment mAllCompanyFragment;
    private AttentionCompanyFragment mAttentionCompanyFragment;

    public static CompanyCircleFragment newInstance(String param) {
        CompanyCircleFragment fragment = new CompanyCircleFragment();
        Bundle args = new Bundle();
        args.putString(PARAM, param);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            mParam = getArguments().getString(PARAM);
        }
    }

    @Override
    public View initViews() {
        View view = View.inflate(mActivity, R.layout.fragment_company_circle, null);
        //注入
        ButterKnife.bind(this, view);
        return view;
    }

    @Override
    public void onStart() {
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
    public void setData() {

    }

    @Override
    public void onResume() {
        super.onResume();
//        getConsole();
    }

    @Override
    public void initData() {
        super.initData();
        back.setVisibility(View.GONE);
        title.setText(getString(R.string.company_circle_title));
        fragmentList = new ArrayList<>();
        // 默认选中0
        mViewPager.setCurrentItem(0);
        line_one.setVisibility(View.VISIBLE);
        line_two.setVisibility(View.GONE);

        mAllCompanyFragment = CompanyListFragment.newInstance("AllCompanyFragment",this);//1

        mAttentionCompanyFragment = AttentionCompanyFragment.newInstance("AttentionCompanyFragment");//2
        fragmentList.add(mAllCompanyFragment);
        fragmentList.add(mAttentionCompanyFragment);
        messageListAdapter = new MessageViewPagerAdapter(getChildFragmentManager(), fragmentList);
        mViewPager.setAdapter(messageListAdapter);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        // 添加监听
        back.setOnClickListener(this);
        re_cc_service.setOnClickListener(this);
        re_work_height.setOnClickListener(this);
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
                    fragmentList.get(0).setData();
                } else if (position == 1) {
//                    mViewPager.setCurrentItem(1,false);
                    line_one.setVisibility(View.GONE);
                    line_two.setVisibility(View.VISIBLE);
                    mAllCompany.setTextColor(getResources().getColor(R.color.main_text_color));
                    mAttentionCompany.setTextColor(getResources().getColor(R.color.luxury_gold_color));
                    fragmentList.get(1).setData();
                }
            }

            @Override
            public void onPageScrollStateChanged(int state) {
            }
        });
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()){
            case R.id.include_head_title_lin:
                ToastUtil.showInfo("搜索");
                break;
            case R.id.re_cc_service:
                mViewPager.setCurrentItem(0,false);
                mAllCompany.setTextColor(getResources().getColor(R.color.luxury_gold_color));
                mAttentionCompany.setTextColor(getResources().getColor(R.color.main_text_color));
                line_one.setVisibility(View.VISIBLE);
                line_two.setVisibility(View.GONE);
//                fragmentList.get(0).setData();
                break;
            case R.id.re_work_height:
                mViewPager.setCurrentItem(1,false);
                mAllCompany.setTextColor(getResources().getColor(R.color.main_text_color));
                mAttentionCompany.setTextColor(getResources().getColor(R.color.luxury_gold_color));
                line_one.setVisibility(View.GONE);
                line_two.setVisibility(View.VISIBLE);
//                fragmentList.get(1).setData();
                break;
        }
    }
//
//    private void getConsole() {
//        // 获取企业信息，根据之前保存的企业id查询
//        new AsyncRunnable<ConsoleEntity>() {
//            @Override
//            protected ConsoleEntity doInBackground(Void... params) {
//                ConsoleEntity entity = CompanyReputationRepository.getConsole();
//                return entity;
//            }
//
//            @Override
//            protected void onPostExecute(ConsoleEntity entity) {
//                if (entity != null){
//                    AppConfig.setConsoleIndex(JsonUtil.ToJson(entity));
//                    if (entity.IsRedDot){
//                        msg2.setVisibility(View.VISIBLE);
//                    } else {
//                        msg2.setVisibility(View.GONE);
//                    }
//                }
//            }
//
//            protected void onPostError(Exception ex) {
//
//            }
//        }.execute();
//    }

    @Override
    public void onRefreshRedPoint(boolean IsRedDot) {
        if (IsRedDot){
            msg2.setVisibility(View.VISIBLE);
        } else {
            msg2.setVisibility(View.GONE);
        }
    }
}
