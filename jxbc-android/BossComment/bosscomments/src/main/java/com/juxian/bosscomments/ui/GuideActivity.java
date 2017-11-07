package com.juxian.bosscomments.ui;

import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.TextView;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.GuideViewPagerAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.utils.SystemBarTintManager;
import com.umeng.socialize.controller.UMSocialService;
import com.umeng.socialize.sso.UMSsoHandler;
import net.juxian.appgenome.LogManager;
import net.juxian.appgenome.socialize.SocialManager;
import java.util.ArrayList;
import java.util.List;
import butterknife.BindView;
import butterknife.ButterKnife;

public class GuideActivity extends BaseActivity {
    private Context context;

    private UMSocialService socialService = null;
    public static final String First_Start = "firstStart";
    public static final String IS_RESET = "Is_Reset";

    private ViewPager vp;
    private GuideViewPagerAdapter vpAdapter;
    private List<View> views;
    private boolean isReload = false;
    @BindView(R.id.circle1)
    ImageView radioButton1;
    @BindView(R.id.circle2)
    ImageView radioButton2;
    @BindView(R.id.circle3)
    ImageView radioButton3;
    View lastView;
    @BindView(R.id.headcolor)
    View view;
    private SystemBarTintManager tintManager;

    public int getContentViewId(){
        return R.layout.guide_activity;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        //        setContentView(R.layout.guide_activity);
        ButterKnife.bind(this);
        context = GuideActivity.this;

        radioButton1.setImageResource(R.drawable.shape_guide_oval_red);
        Global.uiInit(GuideActivity.this);

        if (null != this.getIntent())
            isReload = this.getIntent().getBooleanExtra(IS_RESET, false);
        socialService = SocialManager.getLoginService(this);
        initViews();
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

    private void initViews() {
        LayoutInflater inflater = LayoutInflater.from(this);
        views = new ArrayList<View>();
        views.add(inflater.inflate(R.layout.guide_one, null));
        views.add(inflater.inflate(R.layout.guide_two, null));
        lastView = inflater.inflate(R.layout.guide_four, null);
        TextView open = (TextView) lastView.findViewById(R.id.open_juxianling);
        open.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
//                startActivity(new Intent(context, LoginOrNewAccountActivity.class));
                startActivity(new Intent(context, SignInActivity.class));
                finish();
            }
        });
        views.add(lastView);

        vpAdapter = new GuideViewPagerAdapter(views, this);
        vp = (ViewPager) findViewById(R.id.viewpager);

        vp.addOnPageChangeListener(new OnPageChangeListener() {

            @Override
            public void onPageSelected(int arg0) {
                switch (arg0) {
                    case 0:
                        initCircle();
                        showCircle();
                        radioButton1.setImageResource(R.drawable.shape_guide_oval_red);
                        break;
                    case 1:
                        initCircle();
                        showCircle();
                        radioButton2.setImageResource(R.drawable.shape_guide_oval_red);
                        break;
                    case 2:
                        initCircle();
                        showCircle();
                        radioButton3.setImageResource(R.drawable.shape_guide_oval_red);
                        break;
                    default:
                        radioButton1.setVisibility(View.INVISIBLE);
                        radioButton2.setVisibility(View.INVISIBLE);
                        radioButton3.setVisibility(View.INVISIBLE);
                        break;
                }
            }

            @Override
            public void onPageScrolled(int arg0, float arg1, int arg2) {
            }

            @Override
            public void onPageScrollStateChanged(int arg0) {
            }
        });
        vp.setAdapter(vpAdapter);
        if (isReload) {
            LogManager.getLogger().i("isReload:%s", isReload);
            vp.setCurrentItem(views.size() - 1);
        }
    }// 返回退出程序

    // 判断用户登录是否为手机号
    public static boolean isNumeric(String str) {
        for (int i = str.length(); --i >= 0; ) {
            if (!Character.isDigit(str.charAt(i))) {
                return false;
            }
        }
        return true;
    }

    public void showCircle() {
        radioButton1.setVisibility(View.VISIBLE);
        radioButton2.setVisibility(View.VISIBLE);
        radioButton3.setVisibility(View.VISIBLE);
    }

    public void initCircle() {
        radioButton1.setImageResource(R.drawable.shape_guide_oval_black);
        radioButton2.setImageResource(R.drawable.shape_guide_oval_black);
        radioButton3.setImageResource(R.drawable.shape_guide_oval_black);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        UMSsoHandler ssoHandler = socialService.getConfig().getSsoHandler(
                requestCode);
        if (ssoHandler != null) {
            ssoHandler.authorizeCallBack(requestCode, resultCode, data);
        }
    }
}
