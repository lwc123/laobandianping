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
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.view.Display;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.utils.Dp2pxUtil;
import com.juxian.bosscomments.utils.SystemBarTintManager;
import com.umeng.analytics.MobclickAgent;
import com.umeng.socialize.controller.UMSocialService;

import net.juxian.appgenome.socialize.ShareMessage;
import net.juxian.appgenome.socialize.ShareUtil;
import net.juxian.appgenome.socialize.SocialManager;
import net.juxian.appgenome.widget.ActivityBase;
import net.juxian.appgenome.widget.DoubleClickExitHandler;
import net.juxian.appgenome.widget.ToastUtil;

public abstract class BaseActivity extends ActivityBase implements
        OnClickListener {

    private AlertDialog networkDialog = null;
    private boolean firstNoNet;

    public BaseActivity currentActivity = null;
    public boolean isRefresh;
    public boolean isCheckNet = false;
//    public View errorView;

    public abstract int getContentViewId();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(getContentViewId());
        currentActivity = this;
//        errorView = LayoutInflater.from(getApplicationContext()).inflate(
//                R.layout.activity_load_fail, null);
        // UmengUpdateAgent.update(this);
//        Class<?> clazz = this.getClass();
//        if (clazz == CcPage.class || clazz == FindActivityActivity.class) {// 暂时取消这里的更新
//            UpgradeManager.checkUpgrades();
//        }
        initPage();
        if (isCheckNet) {
            if (!isRefresh) {
                checkNetStatus();
            }
        }
    }

    public void initListener(){

    }

    public void initViewsData(){

    }

//    public void isAuthenticated() {
//        Class<?> clazz = this.getClass();
//        if (clazz == Welcome_Acitivity.class || clazz == GuideActivity.class) {
//
//        } else {
//            if (!AppContext.getCurrent().getUserAuthentication().isAuthenticated()) {
//                startActivity(new Intent(this, ShortCutSignInActivity.class));
//                finish();
//            }
//        }
//    }
    public DisplayMetrics getMetrics(){
        WindowManager manager = this.getWindowManager();
        DisplayMetrics outMetrics = new DisplayMetrics();
        manager.getDefaultDisplay().getMetrics(outMetrics);
        return outMetrics;
    }

    public int dp2px(int dp) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp,
                getResources().getDisplayMetrics());
    }

    @Override
    public void onClick(View v) {
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (isCheckNet) {
            // 如果第一次是没网的，后面回来之后有网了，则这个if不走
            if (isRefresh&&!firstNoNet) {
                loadData();
            }
        }
//        checkNetworkStatus();
        if (firstNoNet&&AppConfig.NETWORK_DISABLE != AppConfig.getNetworkStatus()){
            if (dl != null){
                dl.dismiss();
            }
            firstNoNet = false;
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

    protected void checkNetworkStatus() {
        if (AppConfig.NETWORK_DISABLE != AppConfig.getNetworkStatus()) {
            if (null != networkDialog)
                networkDialog.dismiss();
            return;
        }
        Builder b = new Builder(this).setTitle("没有可用的网络")
                .setMessage("使用移动网络或开启Wifi？");
        networkDialog = b
                .setPositiveButton("使用移动网络",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog,
                                                int whichButton) {
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
                        })
                .setNeutralButton("开启Wifi",
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog,
                                                int whichButton) {
                                Intent intent = null;
                                if (Build.VERSION.SDK_INT > 10) {
                                    intent = new Intent(
                                            android.provider.Settings.ACTION_WIFI_SETTINGS);
                                } else {
                                    intent = new Intent();
                                    ComponentName component = new ComponentName(
                                            "com.android.settings",
                                            "com.android.settings.wifi.WifiSettings");
                                    intent.setComponent(component);
                                    intent.setAction("android.intent.action.VIEW");
                                }
                                startActivity(intent);
                            }
                        }).show();
    }

//    protected void checkAuthenticateStatus(IResultListener listener) {
//        if (AppContext.getCurrent().getAuthentication().isAuthenticated()) {
//            listener.onReturn(RESULT_OK, null);
//        } else {
//            this.signIn(listener);
//        }
//    }

//    protected void signIn(IResultListener listener) {
//        super.startActivityForResult(SignInActivity.class, null, listener);
//    }

    private DoubleClickExitHandler exitHandler = null;


    protected void initStateBar() {
        SystemBarTintManager tintManager = new SystemBarTintManager(this);
        tintManager.setStatusBarTintEnabled(true);
        tintManager.setStatusBarTintResource(R.color.main_color);
    }

    private UMSocialService shareService = null;

    protected  void showSystemBartint(View view){
        setSystemBartint(view);
    }

    protected void setSystemBartint(View view) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            setTranslucentStatus(true);
        } else {
            view.setVisibility(View.GONE);
        }
    }

    protected void setSystemBarTintManager(Activity activity){
        SystemBarTint(activity);
    }

    private void SystemBarTint(Activity activity){
        SystemBarTintManager tintManager = new SystemBarTintManager(activity);
        tintManager.setStatusBarTintEnabled(true);
        tintManager.setStatusBarTintResource(R.color.main_color);
    }

    protected void setSystemBarTintManager(Activity activity, int res){
        SystemBarTint(activity,res);
    }

    private void SystemBarTint(Activity activity, int res){
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

    /**
     * @return Boolean 返回类型
     * @throws
     * @Title: checkPhone
     * @说 明:校验手机号
     * @参 数: @return
     */
    public Boolean checkPhone(EditText input_your_phone) {
        if (input_your_phone.getText().toString().trim().length() == 0) {
            ToastUtil.showError(getString(R.string.mobile_phone_is_empty));
            return false;
        }
        return true;
    }

    public void setWindowParams(Window dialogWindow){
        WindowManager m = getWindowManager();
        Display d = m.getDefaultDisplay();  //为获取屏幕宽、高

        WindowManager.LayoutParams p = dialogWindow.getAttributes();  //获取对话框当前的参数值
        p.width = (int) (d.getWidth() * 1.0);    //宽度设置为屏幕的0.8

        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dialogWindow.setAttributes(p);     //设置生效
        dialogWindow.getAttributes().windowAnimations = R.style.default_dialog_animation;
        dialogWindow.setWindowAnimations(R.style.default_dialog_animation);
        dialogWindow.setGravity(Gravity.BOTTOM);
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

    public void resultCheckNetStatus(){
        if (AppConfig.NETWORK_DISABLE != AppConfig.getNetworkStatus()) {
            // 网络可用
            if (null != dl)
                dl.dismiss();
            ToastUtil.showInfo("网络超时");
        } else {
            // 网络不可用
            if (null != dl)
                dl.dismiss();
            showDialog(false,"重试","开启网络","未开启移动网络或Wifi？");
        }
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
