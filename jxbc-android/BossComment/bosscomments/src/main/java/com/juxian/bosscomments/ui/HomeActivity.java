package com.juxian.bosscomments.ui;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.widget.RadioButton;
import android.widget.RadioGroup;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.HomeViewPagerAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.fragment.BaseFragment;
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
public class HomeActivity extends BaseHomeActivity implements View.OnClickListener,DialogUtils.MainDialogListener {

    private static final String savedTab = "savedTab";

    //    @BindView(R.id.fragment_container)
//    FrameLayout fragmentContainer;
    @BindView(R.id.activity_home_viewpager)
    NoScrollViewPager mHomeViewPager;
    @BindView(R.id.rb_tab_main)
    RadioButton rbTabMain;
    @BindView(R.id.rb_tab_account)
    RadioButton rbTabAccount;
    @BindView(R.id.rb_tab_invite)
    RadioButton rbTabInvite;
    @BindView(R.id.main_radios)
    RadioGroup mainRadios;
    @BindView(R.id.headcolor)
    View view;
    private SystemBarTintManager tintManager;
    private int PageTag = 0;
    private ArrayList<BaseFragment> mFragmentList;
    private int mAuditStatus;
    private String mAuditInfo;
    private long oldTime;
    private long FirstClick;
    private Fragment inviteFragment;
//    private FragmentStatePagerAdapter mFragmentPagerAdapter = new FragmentStatePagerAdapter(getSupportFragmentManager()) {
//        @Override
//        public Fragment getItem(int position) {
//            if (position == R.id.rb_tab_main) {
//                return MainFragment.newInstance("MainFragment");
//            } else if (position == R.id.rb_tab_account) {
//                return InviteFragment.newInstance("InviteFragment");
//            } else {
//                return PersonalCenterFragment.newInstance("PersonalCenterFragment");
//            }
//        }
//
//        @Override
//        public int getCount() {
//            return 3;
//        }
//    };

    //这儿是3个大的 fragment
//    @OnCheckedChanged({R.id.rb_tab_main, R.id.rb_tab_account,R.id.rb_tab_invite})
//    public void onChecked(RadioButton rb) {
//        Boolean isChecked = rb.isChecked();
//        //检查是否选中
//        if (isChecked) {
//            int viewId = rb.getId();
////            if (viewId == R.id.rb_tab_main){
////                PageTag = 1;
////            } else {
////                PageTag = 2;
////            }
//            //instantiateItem从FragmentManager中查找Fragment，找不到就getItem新建一个
////            Fragment fragment = (Fragment) mFragmentPagerAdapter.instantiateItem(fragmentContainer, viewId);
////            mFragmentPagerAdapter.setPrimaryItem(fragmentContainer, viewId, fragment);
////            mFragmentPagerAdapter.finishUpdate(fragmentContainer);
//            switch (viewId){
//                case R.id.rb_tab_main:
//                    mHomeViewPager.setCurrentItem(0,false);
//                    break;
//                case R.id.rb_tab_account:
//                    mHomeViewPager.setCurrentItem(1,false);
//                    break;
//                case R.id.rb_tab_invite:
//                    mHomeViewPager.setCurrentItem(2,false);
//                    break;
//            }
//        }
//    }

    @Override
    public int getContentViewId() {
        return R.layout.activity_home;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        initViewsData();
        //onSaveInstanceState会保存已点击 tab 的 aid
        initShowView(savedInstanceState);
//        rbTabInvite.setOnClickListener(this);
        initPaySuccess();
//        initRecharge();
        initListener();

        /**
         * 改变状态栏颜色
         */
        showSystemBartint(view);
        tintManager = new SystemBarTintManager(this);
        tintManager.setStatusBarTintEnabled(true);
        tintManager.setStatusBarTintResource(R.color.main_color);
        tintManager.setStatusBarTintResource(R.color.transparency_color);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            view.setVisibility(View.GONE);
        } else {
            view.setVisibility(View.GONE);
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        rbTabMain.setOnClickListener(this);
        rbTabAccount.setOnClickListener(this);
        rbTabInvite.setOnClickListener(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
//        GetMineMessage(AppConfig.getCurrentUseCompany());
        mFragmentList = new ArrayList<>();
        mFragmentList.add(MainFragment.newInstance("MainFragment"));
        mFragmentList.add(InviteFragment.newInstance("InviteFragment"));
        mFragmentList.add(PersonalCenterFragment.newInstance("PersonalCenterFragment"));
        HomeViewPagerAdapter myPagerAdapter = new HomeViewPagerAdapter(getSupportFragmentManager(), mFragmentList);
        mHomeViewPager.setScrollble(true);
        mHomeViewPager.setAdapter(myPagerAdapter);
        mHomeViewPager.setOffscreenPageLimit(2);

        mHomeViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {

            @Override
            public void onPageSelected(int arg0) {
                // TODO Auto-generated method stub
                if (arg0 == 0) {
//                    tintManager.setStatusBarTintResource(R.color.main_color);
                    tintManager.setStatusBarTintResource(R.color.transparency_color);
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                        view.setVisibility(View.GONE);
                    } else {
                        view.setVisibility(View.GONE);
                    }

                    mFragmentList.get(arg0).setData();
                } else if (arg0 == 1) {
                    tintManager.setStatusBarTintResource(R.color.main_color);
//        tintManager.setStatusBarTintResource(R.color.transparency_color);
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                        view.setVisibility(View.VISIBLE);
                    } else {
                        view.setVisibility(View.GONE);
                    }

                    //每次刷新一个新时间，和上一次的时间对比，60s后就会刷新数据，不管时间够不够60s，时间都要重置。
                    long newTime = System.currentTimeMillis();

                    if (newTime - oldTime > 1000 * 120) {
                        mFragmentList.get(arg0).setData();
                    }
                    oldTime = newTime;
                } else if (arg0 == 2) {
//                    tintManager.setStatusBarTintResource(R.color.main_color);
                    tintManager.setStatusBarTintResource(R.color.transparency_color);
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                        view.setVisibility(View.GONE);
                    } else {
                        view.setVisibility(View.GONE);
                    }

                    mFragmentList.get(arg0).setData();
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
//        GetMineMessage(24);
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

    public void initPaySuccess() {
        if ("success".equals(getIntent().getStringExtra("PaySuccessTag"))) {
            rbTabMain.setChecked(false);
            rbTabAccount.setChecked(false);
            rbTabInvite.setChecked(false);
            mainRadios.clearCheck();
            rbTabAccount.performClick();
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 1:
                if (resultCode == RESULT_OK) {
                    rbTabMain.setChecked(false);
                    rbTabAccount.setChecked(false);
                    rbTabInvite.setChecked(false);
                    mainRadios.clearCheck();
                    if (PageTag == 1) {
                        rbTabMain.performClick();
                    } else {
                        rbTabAccount.performClick();
                    }
                }
                break;
            case 2:
                //我的动态
                if (resultCode == RESULT_OK) {
                    mFragmentList.get(1).setData();
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
                if (mFragmentList.get(0).getAuditStatus() != CompanyEntity.AttestationStatus_Passed) {
                    DialogUtils.showHomeDialog(mFragmentList.get(0).getAuditInfo(), this, mainRadios, rbTabMain, rbTabAccount, rbTabInvite,this);
                    return;
                }
                mHomeViewPager.setCurrentItem(0, false);
                break;
            case R.id.rb_tab_account:
                long newClick = System.currentTimeMillis();
                if (mFragmentList.get(0).getAuditStatus() != CompanyEntity.AttestationStatus_Passed) {
                    DialogUtils.showHomeDialog(mFragmentList.get(0).getAuditInfo(), this, mainRadios, rbTabMain, rbTabAccount, rbTabInvite,this);
                    return;
                }
                mHomeViewPager.setCurrentItem(1, false);
                //1s内双击老板圈刷新
                if (newClick - FirstClick < 1.0 * 1000) {
                    mFragmentList.get(1).setData();
                }
                FirstClick = newClick;
                break;
            case R.id.rb_tab_invite:
                if (mFragmentList.get(0).getAuditStatus() != CompanyEntity.AttestationStatus_Passed) {
                    DialogUtils.showHomeDialog(mFragmentList.get(0).getAuditInfo(), this, mainRadios, rbTabMain, rbTabAccount, rbTabInvite,this);
                    return;
                }
                mHomeViewPager.setCurrentItem(2, false);
                break;
        }
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
    }

    /**
     * 初始化退出登录返回情况
     */
    private void initRecharge() {
        rbTabMain.setChecked(false);
        rbTabAccount.setChecked(false);
        rbTabInvite.setChecked(false);
        mainRadios.clearCheck();
        rbTabAccount.performClick();
    }

    private void GetMineMessage(final int time) {
        // 获取企业信息，根据之前保存的企业id查询
        new AsyncRunnable<Integer>() {
            @Override
            protected Integer doInBackground(Void... params) {
                int entity = ApiTestRepository.getBossCircleHome(time);
                return entity;
            }

            @Override
            protected void onPostExecute(Integer entity) {
                if (entity > 0) {
                    ToastUtil.showInfo(entity + "");
                } else {
                    ToastUtil.showInfo(WebApiClient.getSingleton().LastError.toString() + "");
                }
            }

            protected void onPostError(Exception ex) {
                ToastUtil.showInfo("123");
                Log.e(Global.LOG_TAG, "net abnormal!");
            }
        }.execute();
    }

    public int dp2px(int dp) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp,
                getResources().getDisplayMetrics());
    }

    private final void signOut() {
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                return AppContext.getCurrent().getAuthentication().signOut();
            }

            @Override
            protected void onPostExecute(Boolean result) {

                if (result == true) {
//                    MobclickAgent.onProfileSignOff();
                    AppConfig.setCurrentUseCompany(0);
                    AppConfig.setCurrentProfileType(0);
                    Intent intent = new Intent(HomeActivity.this, SignInActivity.class);
                    startActivity(intent);
                    HomeActivity.this.finish();
                } else {

                }
            }

            @Override
            protected void onPostError(Exception ex) {

            }
        }.execute();
    }

    @Override
    public void MainLeftBtMethod() {
        signOut();
    }

    @Override
    public void MainRightBtMethod() {

    }
}
