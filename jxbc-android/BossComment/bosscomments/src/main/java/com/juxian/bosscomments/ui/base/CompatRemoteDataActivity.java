package com.juxian.bosscomments.ui.base;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.content.ComponentName;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.view.Display;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.utils.Dp2pxUtil;
import com.juxian.bosscomments.utils.SystemBarTintManager;

import net.juxian.appgenome.widget.CompatActivityBase;
import net.juxian.appgenome.widget.ToastUtil;

/**
 * Created by nene on 2017/4/25.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/25 10:49]
 * @Version: [v1.0]
 */
public abstract class CompatRemoteDataActivity extends CompatActivityBase {

    public boolean IsReloadDataOnResume;// 是否在OnResume重新加载数据
    public boolean IsDelayLoadData;// 是否要延迟加载数据
    public boolean IsInitData;// 第一次是否加载数据成功
    public boolean ShowNetworkErrorDialog;
    public boolean ShowServerErrorDialog;
    public Dialog dl = null;
    public CompatRemoteDataActivity currentActivity = null;

    public abstract int getContentViewId();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(getContentViewId());
        currentActivity = this;
        IsInitData = false;
        IsReloadDataOnResume = false;
        // 初始化子页面
        initPageView();
        // 初始化页面数据
        if (!IsDelayLoadData)
            initPageData();
    }

    @Override
    protected void onResume() {
        super.onResume();
        if ((AppConfig.NETWORK_DISABLE != AppConfig.getNetworkStatus()) && (ShowNetworkErrorDialog || IsReloadDataOnResume)) {
            // IsReloadDataOnResume在子Activity中的onCreate设置为true   ShowNetworkErrorDialog默认是为false的
            initPageData();
        }
    }

    public void initListener(){

    }

    public void initViewsData(){

    }

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

    public void initPageData() {
        if (ShowNetworkErrorDialog || ShowServerErrorDialog) {
            dl.dismiss();
        }
        ShowNetworkErrorDialog = false;
        ShowServerErrorDialog = false;
        // 检查网络状态
        checkNetworkStatus();
    }

    public abstract void initPageView();

    public abstract void loadPageData();

    public void onRemoteError() {
        if (AppConfig.NETWORK_DISABLE != AppConfig.getNetworkStatus()) {
            // 网络可用，是服务错误
            onServerError();
        } else {
            onNetworkError();
        }
    }

    public void onNetworkError() {
        ProcessNetworkError();
    }

    public void onServerError() {
        ProcessServerError();
    }

    public void checkNetworkStatus() {
        if (AppConfig.NETWORK_DISABLE != AppConfig.getNetworkStatus()) {
            // 网络可用
            if (null != dl)
                dl.dismiss();
            loadPageData();
        } else {
            onNetworkError();
        }
    }

    /**
     * 网络未开启时的错误提示
     */
    public void ProcessNetworkError() {
        if (!IsInitData) {
            showNetworkDialog(false, "重试", "开启网络", "未开启移动网络或Wifi？");
            ShowNetworkErrorDialog = true;
        } else {
            ToastUtil.showInfo("网络未开启");
        }
    }

    /**
     * 网络开启时的错误提示
     */
    public void ProcessServerError() {
        if (!IsInitData) {
            showServerDialog(true, "重试", "开启网络", "网络超时");
            ShowServerErrorDialog = true;
        } else {
            ToastUtil.showInfo("网络超时");
        }
    }

    public void showNetworkDialog(boolean isNetDisable, String Button1, String Button2, String contentText) {
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
        if (isNetDisable) {
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
                initPageData();
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

    public void showServerDialog(boolean isNetDisable, String Button1, String Button2, String contentText) {
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
        if (isNetDisable) {
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
                initPageData();
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
