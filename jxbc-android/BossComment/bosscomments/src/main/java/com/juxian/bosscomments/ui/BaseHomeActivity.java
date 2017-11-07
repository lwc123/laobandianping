package com.juxian.bosscomments.ui;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.ComponentName;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.utils.SystemBarTintManager;
import com.umeng.analytics.MobclickAgent;

import net.juxian.appgenome.ActivityManager;
import net.juxian.appgenome.widget.ToastUtil;

/**
 * Created by nene on 2016/11/7.
 *
 * @ProjectName: [BossComment]
 * @Package: [com.juxian.bosscomments.ui]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/7 15:41]
 * @Version: [v1.0]
 */
public abstract class BaseHomeActivity extends AppCompatActivity {

    private long exitTime = 0;
    private AlertDialog networkDialog = null;
    public abstract int getContentViewId();

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ActivityManager.add(this);
        setContentView(getContentViewId());
    }

    @Override
    protected void onStart() {
        super.onStart();
        ActivityManager.setCurrent(this);
    }

    public void initListener(){

    }

    public void initViewsData(){

    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            if (System.currentTimeMillis() - exitTime > 2000) {
                ToastUtil.showInfo(this.getResources().getString(
                        R.string.app_exit_confirm));
                exitTime = System.currentTimeMillis();
            } else {
                ActivityManager.finishAll();
                this.finish();

            }
            return true;
        }
        return super.onKeyDown(keyCode, event);
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
    protected void setTranslucentStatus(boolean on) {
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

    @Override
    protected void onResume() {
        super.onResume();
//        checkNetworkStatus();
        MobclickAgent.onResume(this);
    }

    @Override
    protected void onPause() {
        super.onPause();
        MobclickAgent.onPause(this);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        ActivityManager.finish(this);
    }

    protected void checkNetworkStatus() {
        if (AppConfig.NETWORK_DISABLE != AppConfig.getNetworkStatus()) {
            if (null != networkDialog)
                networkDialog.dismiss();
            return;
        }
        AlertDialog.Builder b = new AlertDialog.Builder(this).setTitle("没有可用的网络")
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

    public void loadData(){
        loadPageData();
    }

    public void loadPageData(){

    }

    public void onRetry(){
        loadPageData();
    }
}
