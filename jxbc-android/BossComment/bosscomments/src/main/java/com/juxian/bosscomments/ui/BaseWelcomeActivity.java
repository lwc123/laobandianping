package com.juxian.bosscomments.ui;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.app.Dialog;
import android.content.ComponentName;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.utils.Dp2pxUtil;
import com.juxian.bosscomments.utils.SystemBarTintManager;
import com.umeng.analytics.MobclickAgent;
import com.umeng.socialize.controller.UMSocialService;

import net.juxian.appgenome.socialize.ShareMessage;
import net.juxian.appgenome.socialize.ShareUtil;
import net.juxian.appgenome.socialize.SocialManager;
import net.juxian.appgenome.upgrade.UpgradeManager;
import net.juxian.appgenome.widget.ActivityBase;
import net.juxian.appgenome.widget.DoubleClickExitHandler;
import net.juxian.appgenome.widget.IResultListener;

public abstract class BaseWelcomeActivity extends ActivityBase implements
        OnClickListener {

    private AlertDialog networkDialog = null;
    private Dialog dl = null;

    public BaseWelcomeActivity currentActivity = null;
    public View errorView;
    private long exitTime = 0;
    private boolean firstNoNet;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        currentActivity = this;
        // UmengUpdateAgent.update(this);

        // PushAgent mPushAgent = PushAgent.getInstance(this);
        // mPushAgent.enable();
        // PushAgent.getInstance(this).onAppStart();
        // // 查看是否有新的反馈通知
        // FeedbackAgent agent = new FeedbackAgent(currentActivity);
        // agent.sync();
        /**
         * 改变状态栏颜色
         */
        // if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
        // setTranslucentStatus(true);
        // } else {
        // // view.setVisibility(View.GONE);
        // }
        //
        // SystemBarTintManager tintManager = new SystemBarTintManager(this);
        // tintManager.setStatusBarTintEnabled(true);
        // tintManager.setStatusBarTintResource(R.color.main_color);
        // 改变结束
    }

    public void initListener(){

    }

    public void initViewsData(){

    }
//	/**
//	 * 点击空白区域去除软键盘
//	 */
//	@Override
//	public boolean onTouchEvent(MotionEvent event) {
//		// TODO Auto-generated method stub
//		if (event.getAction() == MotionEvent.ACTION_DOWN) {
//			if (getCurrentFocus() != null
//					&& getCurrentFocus().getWindowToken() != null) {
//				manager.hideSoftInputFromWindow(getCurrentFocus()
//						.getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
//			}
//		}
//		return super.onTouchEvent(event);
//	}

    @Override
    public void onClick(View v) {
    }

    @Override
    protected void onResume() {
        super.onResume();
//        checkNetworkStatus();
        if (firstNoNet&&AppConfig.NETWORK_DISABLE != AppConfig.getNetworkStatus()){
            if (dl != null){
                dl.dismiss();
            }
            onRetry();
        }
        MobclickAgent.onResume(this);
    }

    protected void onPause() {
        super.onPause();
        MobclickAgent.onPause(this);
    }

    public void startActivity(Class<?> clazz) {
        startActivity(new Intent(this, clazz));
    }

    @Override
    public void startActivity(Intent intent) {
        super.startActivity(intent);
        // overridePendingTransition(android.R.anim.fade_in,
        // android.R.anim.fade_out);
    }

    public void startActivityWithFinish(Class<?> clazz) {
        startActivity(clazz);
        finish();
        // overridePendingTransition(android.R.anim.fade_in,
        // android.R.anim.fade_out);
    }

    @Override
    public void finish() {
        super.finish();
        // overridePendingTransition(android.R.anim.fade_out,
        // android.R.anim.fade_in);
    }

    @Override
    public void setTitle(CharSequence title) {
        super.setTitle(title);
        // this.navBar.setTitle(title);
    }

    protected void checkAuthenticateStatus(IResultListener listener) {
        if (AppContext.getCurrent().getAuthentication().isAuthenticated()) {
            listener.onReturn(RESULT_OK, null);
        } else {
            this.signIn(listener);
        }
    }

    protected void signIn(IResultListener listener) {
        super.startActivityForResult(SignInActivity.class, null, listener);
    }

    private DoubleClickExitHandler exitHandler = null;


    protected void initStateBar() {
        SystemBarTintManager tintManager = new SystemBarTintManager(this);
        tintManager.setStatusBarTintEnabled(true);
        tintManager.setStatusBarTintResource(R.color.main_color);
    }

    private UMSocialService shareService = null;

    protected void showSystemBartint(View view) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            setTranslucentStatus(true);
        } else {
            view.setVisibility(View.GONE);
        }
    }

    protected void setSystemBarTintManager(Activity activity){
        SystemBarTintManager tintManager = new SystemBarTintManager(activity);
        tintManager.setStatusBarTintEnabled(true);
        tintManager.setStatusBarTintResource(R.color.main_color);
    }

    protected void setSystemBarTintManager(Activity activity, int res){
        SystemBarTintManager tintManager = new SystemBarTintManager(activity);
        tintManager.setStatusBarTintEnabled(true);
        tintManager.setStatusBarTintResource(res);
    }

    @TargetApi(19)
    private void setTranslucentStatus(boolean on) {
        Window win = getWindow();
        WindowManager.LayoutParams winParams = win.getAttributes();
        final int bits = WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS;
        if (on) {
            winParams.flags |= bits;
        } else {
            winParams.flags &= ~bits;
        }
        win.setAttributes(winParams);
    }

    public void share(ShareMessage message) {
        if (null == shareService)
            shareService = SocialManager.getShareService(this);
        ShareUtil.resetShareMedia(shareService, message);
        shareService.openShare(this, false);
    }

    public void checkNetStatus(){
        if (AppConfig.NETWORK_DISABLE != AppConfig.getNetworkStatus()) {
            // 网络可用
            if (null != dl)
                dl.dismiss();
            loadData();
        } else {
            // 网络不可用
            firstNoNet = true;
            if (null != dl){
                dl.dismiss();
            }
            showDialog(false,"重试","开启网络","未开启移动网络或Wifi？");
        }
    }

    public void secondCheckNetStatus(){
        if (AppConfig.NETWORK_DISABLE != AppConfig.getNetworkStatus()) {
            // 网络可用
            if (null != dl)
                dl.dismiss();
            showDialog(true,"重试","开启网络","网络超时，请稍等片刻重试？");
        } else {
            // 网络不可用
            if (null != dl)
                dl.dismiss();
            showDialog(false,"重试","开启网络","未开启移动网络或Wifi？");
        }
    }

    public void loadData(){
        loadPageData();
    }

    public void loadPageData(){

    }

    public void onRetry(){
        loadPageData();
    }

    public void showDialog(boolean isNetDisable,String Button1,String Button2,String contentText) {
        dl = new Dialog(this);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(false);
        View dialog_view = View.inflate(this, R.layout.dialog_accredit, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = Dp2pxUtil.dp2px(270, this);
        dialogWindow.setAttributes(lp);
        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dl.show();
        TextView close = (TextView) dialog_view.findViewById(R.id.dialog_tips_cancel);
        TextView ok = (TextView) dialog_view.findViewById(R.id.dialog_tips_ok);
        TextView content = (TextView) dialog_view.findViewById(R.id.dialog_tips_content);
        if (isNetDisable){
            // 网络可用的时候，只要一个重试按钮
            ok.setVisibility(View.GONE);
        } else {
            ok.setVisibility(View.VISIBLE);
        }
        close.setText(Button1);
        ok.setText(Button2);
        content.setText(contentText);
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
                onRetry();
            }
        });
        ok.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // 判断是否是继续建立档案，是，则继续建立，否则执行其他操作
                dl.dismiss();
                Intent intent = null;
                if (Build.VERSION.SDK_INT > 10) {
                    intent = new Intent(
                            android.provider.Settings.ACTION_WIRELESS_SETTINGS);
                } else {
                    intent = new Intent();
                    ComponentName component = new ComponentName(
                            "com.android.settings",
                            "com.android.settings.WirelessSettings");
                    intent.setComponent(component);
                    intent.setAction("android.intent.action.VIEW");
                }
                startActivity(intent);
            }
        });
    }
}
