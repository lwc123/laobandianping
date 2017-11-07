package com.juxian.bosscomments.ui;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.modules.UserAuthentication;
import com.juxian.bosscomments.utils.SignInUtils;
import com.juxian.bosscomments.utils.SystemBarTintManager;

import net.juxian.appgenome.ActivityManager;
import net.juxian.appgenome.utils.AsyncRunnable;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * @author 付晓龙
 * @ClassName: Welcome_Acitivity
 * @说明:首界面
 * @date 2015-8-12 上午10:37:16
 */

public class Welcome_Acitivity extends BaseWelcomeActivity {

    private TextView updateText;
    @BindView(R.id.headcolor)
    View viewHead;
    private static final String SHAREDPREFERENCES_NAME = "first_pref";
    private SystemBarTintManager tintManager;

    private void goActivity() {
        // 判断是否是第一次打开app
        if (null == AppConfig.get(GuideActivity.First_Start)) {
            Intent intent1 = new Intent(Welcome_Acitivity.this, GuideActivity.class);
            startActivity(intent1);
            finish();
            return;
        }

        UserAuthentication authentication = AppContext.getCurrent().getUserAuthentication();
        boolean isAuthenticated = authentication.isAuthenticated();
        if (false == isAuthenticated) {
//            startActivity(new Intent(this, LoginOrNewAccountActivity.class));
            startActivity(new Intent(this, SignInActivity.class));
            finish();
            return;
        }
        // 初始化数据成功
        if (authentication.isInitializedIdentity()) {
            // 判断是否登录
            if (AppContext.getCurrent().isAuthenticated()) {
                // 线下高管账号：18700000000   密码：974539
                if ("18700000000".equals(authentication.getCurrentAccount().getProfile().MobilePhone)){
                    signOut();
                } else {
                    signInByToken(this);
                }
//                SignInUtils.SignInSuccess(this,authentication);
            } else {
                Activity current = ActivityManager.getCurrent();
//                Intent intent = new Intent(current, LoginOrNewAccountActivity.class);
                Intent intent = new Intent(current, SignInActivity.class);
                current.startActivity(intent);
                current.finish();

            }
        } else {
            Activity current = ActivityManager.getCurrent();
//            Intent intent = new Intent(current, LoginOrNewAccountActivity.class);
            Intent intent = new Intent(current, SignInActivity.class);
            current.startActivity(intent);
            current.finish();
        }
    }

    private void setGuided() {
        SharedPreferences preferences = Welcome_Acitivity.this
                .getSharedPreferences(SHAREDPREFERENCES_NAME,
                        Context.MODE_PRIVATE);
        Editor editor = preferences.edit();

        editor.putBoolean("isFirstIn", false);

        editor.commit();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        final View view = View.inflate(this, R.layout.welcome_activity, null);
        setContentView(view);
        ButterKnife.bind(this);
        initViews();
        showSystemBartint(viewHead);
        AlphaAnimation aa = new AlphaAnimation(0.3f, 1.0f);
        aa.setDuration(678);
        view.startAnimation(aa);
        aa.setAnimationListener(new AnimationListener() {
            @Override
            public void onAnimationEnd(Animation arg0) {
//                goActivity();
                checkNetStatus();
                setGuided();
            }

            @Override
            public void onAnimationRepeat(Animation animation) {
            }

            @Override
            public void onAnimationStart(Animation animation) {
            }
        });

        /**
         * 改变状态栏颜色
         */
        showSystemBartint(viewHead);
        tintManager = new SystemBarTintManager(this);
        tintManager.setStatusBarTintEnabled(true);
        tintManager.setStatusBarTintResource(R.color.main_color);
        tintManager.setStatusBarTintResource(R.color.transparency_color);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            viewHead.setVisibility(View.GONE);
        } else {
            viewHead.setVisibility(View.GONE);
        }
    }

    @Override
    public void loadPageData() {
        super.loadPageData();
        goActivity();
    }

    private void initViews() {
        updateText = (TextView) findViewById(R.id.updateText);
        updateText.setText("当前版本 : " + AppConfig.getCurrentVersion().VersionName);
    }

    // 登录
    public void signInByToken(final Context context) {
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                // 每次登录成功之后，保存token，并且返回登录信息
                Boolean isSuccess = AppContext.getCurrent().getUserAuthentication().signInByToken();
                return isSuccess;
            }

            @Override
            protected void onPostExecute(Boolean isSuccess) {
                if (isSuccess) {
                    UserAuthentication authentication = AppContext.getCurrent().getUserAuthentication();
                    SignInUtils.SignInSuccess(context, authentication);
                } else {
                    secondCheckNetStatus();
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                secondCheckNetStatus();
            }
        }.execute();
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
                    Activity current = ActivityManager.getCurrent();
//                    Intent intent = new Intent(current, LoginOrNewAccountActivity.class);
                    Intent intent = new Intent(current, SignInActivity.class);
                    current.startActivity(intent);
                    current.finish();
                } else {
                    secondCheckNetStatus();
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                secondCheckNetStatus();
            }
        }.execute();
    }
}
