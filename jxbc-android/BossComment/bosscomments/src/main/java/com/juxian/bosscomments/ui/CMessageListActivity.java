package com.juxian.bosscomments.ui;

import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.MessageViewPagerAdapter;
import com.juxian.bosscomments.fragment.BaseFragment;
import com.juxian.bosscomments.fragment.MessageFragment;
import com.juxian.bosscomments.utils.SystemBarTintManager;

import net.juxian.appgenome.ActivityManager;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/12/2.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/2 16:09]
 * @Version: [v1.0]
 */
public class CMessageListActivity extends FragmentActivity implements View.OnClickListener, MessageFragment.DateLoadDown {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.re_cc_service)
    RelativeLayout re_cc_service;
    @BindView(R.id.re_work_height)
    RelativeLayout re_work_height;
    @BindView(R.id.content_is_null)
    LinearLayout content_is_null;
    @BindView(R.id.activity_my_order_viewpager)
    ViewPager viewpager;
    @BindView(R.id.one)
    View line_one;
    @BindView(R.id.two)
    View line_two;
    @BindView(R.id.msg1)
    ImageView msg1;
    @BindView(R.id.msg2)
    ImageView msg2;
    private MessageViewPagerAdapter messageListAdapter;
    private ArrayList<BaseFragment> fragmentList;
//    private int pageIndex;
    MessageFragment fragment_Notify;
    MessageFragment fragment_suspending;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_cp_message);
        ActivityManager.add(this);
        ButterKnife.bind(this);
        initViewsData();
        initListener();
//        setSystemBarTintManager(this);
        SystemBarTintManager tintManager = new SystemBarTintManager(this);
        tintManager.setStatusBarTintEnabled(true);
        tintManager.setStatusBarTintResource(R.color.main_color);
    }

    @Override
    protected void onStart() {
        super.onStart();
        ActivityManager.setCurrent(this);
    }

    public void initViewsData() {
        title.setText(getString(R.string.main_message));
        fragmentList = new ArrayList<>();
        viewpager.setCurrentItem(0);
        line_one.setVisibility(View.VISIBLE);
        line_two.setVisibility(View.GONE);

        fragment_Notify = MessageFragment.newInstance("notify", this);//1

        fragment_suspending = MessageFragment.newInstance("suspending", this);//2
        fragmentList.add(fragment_suspending);
        fragmentList.add(fragment_Notify);
        messageListAdapter = new MessageViewPagerAdapter(getSupportFragmentManager(), fragmentList);
        viewpager.setAdapter(messageListAdapter);


    }

    public void initRedMsgPoint() {
        if (fragment_Notify.HaveNotifyMsg) {
            msg2.setVisibility(View.VISIBLE);
        } else {
            msg2.setVisibility(View.GONE);
        }
        if (fragment_suspending.HaveSuspendingMsg) {
            msg1.setVisibility(View.VISIBLE);
        } else {
            msg1.setVisibility(View.GONE);
        }
    }

    public void initListener() {
        re_cc_service.setOnClickListener(this);
        re_work_height.setOnClickListener(this);
        back.setOnClickListener(this);
        viewpager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                if (position == 0) {
                    viewpager.setCurrentItem(0);
                    line_one.setVisibility(View.VISIBLE);
                    line_two.setVisibility(View.GONE);
                    fragmentList.get(0).setData();
//                    pageIndex = 0;
                } else if (position == 1) {
                    viewpager.setCurrentItem(1);
                    line_one.setVisibility(View.GONE);
                    line_two.setVisibility(View.VISIBLE);
                    fragmentList.get(1).setData();
//                    pageIndex = 1;
                }
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });

    }

    @Override
    protected void onRestart() {
        super.onRestart();
//        if (pageIndex == 0){
//            viewpager.setCurrentItem(0);
//            line_one.setVisibility(View.VISIBLE);
//            line_two.setVisibility(View.GONE);
//            fragmentList.get(0).setData();
//        } else {
//            viewpager.setCurrentItem(1);
//            line_one.setVisibility(View.GONE);
//            line_two.setVisibility(View.VISIBLE);
//            fragmentList.get(1).setData();
//        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.re_cc_service:
                viewpager.setCurrentItem(0);
                line_one.setVisibility(View.VISIBLE);
                line_two.setVisibility(View.GONE);
                break;
            case R.id.re_work_height:
                viewpager.setCurrentItem(1);
                line_one.setVisibility(View.GONE);
                line_two.setVisibility(View.VISIBLE);
                break;
        }
    }

    @Override
    public void initMsgPoint() {
        initRedMsgPoint();
    }
}
