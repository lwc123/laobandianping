package com.juxian.bosscomments.ui;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.VideoView;

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
 * Created by Tam on 2017/2/10.
 */
public class StartUpHomePageActivity extends BaseWelcomeActivity {

    @BindView(R.id.vv)
    VideoView mVideoView;
    @BindView(R.id.headcolor)
    View viewHead;
    private SystemBarTintManager tintManager;
    private static final String SHAREDPREFERENCES_NAME = "first_pref";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initViewsData();
        setContentView(R.layout.activity_startup_homepage);
        ButterKnife.bind(this);
        initListener();
        start();
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

    private void start() {
        mVideoView.setVideoURI(Uri.parse(getPath()));
//        mVv.setMediaController(new MediaController(this));
//        mVv.requestFocus();
        mVideoView.start();
    }

    private void setGuided() {
        SharedPreferences preferences = StartUpHomePageActivity.this
                .getSharedPreferences(SHAREDPREFERENCES_NAME,
                        Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = preferences.edit();

        editor.putBoolean("isFirstIn", false);

        editor.commit();
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
    }

    @Override
    public void loadPageData() {
        super.loadPageData();
        goActivity();
    }

    @Override
    public void initListener() {
        super.initListener();
        mVideoView.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
            @Override
            public void onCompletion(MediaPlayer mediaPlayer) {
//                setGuided();
                AppConfig.set(GuideActivity.First_Start, "false");
                checkNetStatus();
            }
        });
//        mVideoView.setOnErrorListener(new MediaPlayer.OnErrorListener() {
//            @Override
//            public boolean onError(MediaPlayer mediaPlayer, int i, int i1) {
//                Toast.makeText(StartUpHomePageActivity.this, "出错", Toast.LENGTH_SHORT).show();
//
//                return true;
//            }
//        });
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    private void goActivity() {
        // 判断是否是第一次打开app
//        if (null == AppConfig.get(GuideActivity.First_Start)) {
//            Intent intent1 = new Intent(Welcome_Acitivity.this, GuideActivity.class);
//            startActivity(intent1);
//            finish();
//            return;
//        }

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
                if (authentication.getCurrentAccount() != null) {
                    if ("18700000000".equals(authentication.getCurrentAccount().getProfile().MobilePhone)) {
                        signOut();
                    } else {
                        signInByToken(this);
                    }
                } else {
                    Activity current = ActivityManager.getCurrent();
                    Intent intent = new Intent(current, SignInActivity.class);
                    current.startActivity(intent);
                    current.finish();
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

    public String getPath() {
        if (null == AppConfig.get(GuideActivity.First_Start)){
            return "android.resource://" + getPackageName() + "/" + R.raw.longvideo;
        } else {
            return "android.resource://" + getPackageName() + "/" + R.raw.shortvideo;
        }
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
