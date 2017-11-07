package com.juxian.bosscomments.utils;

import android.Manifest;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.provider.Settings;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.EmployeArchiveEntity;

/**
 * Created by nene on 2016/12/12.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/12 13:44]
 * @Version: [v1.0]
 */
public class checkSelfPermissionUtils {
    public static void checkPermission(Context context,String permission){

            if (permission.equals(Manifest.permission.RECORD_AUDIO))
                showDialog(context, "在设置-应用管理-老板点评-权限中开启麦克风权限，以正常使用麦克风功能", "确定");
            else if (permission.equals(Manifest.permission.READ_EXTERNAL_STORAGE))
                showDialog(context, "在设置-应用-老板点评-权限中开启存储权限，以正常使用相册功能", "确定");
            else if (permission.equals(Manifest.permission.CAMERA)){
                showDialog(context, "在设置-应用-老板点评-权限中开启相机权限，以正常使用拍照功能", "确定");
            }
//            ActivityCompat.requestPermissions(this,new String[] {Manifest.permission.CAMERA,Manifest.permission.READ_EXTERNAL_STORAGE,Manifest.permission.WRITE_EXTERNAL_STORAGE}, 100);

    }

    public static void showDialog(final Context context, String ContentText, String Button2) {
        final Dialog dl = new Dialog(context);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(false);
        View dialog_view = View.inflate(context, R.layout.dialog_tips, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = Dp2pxUtil.dp2px(260,context);
        dialogWindow.setAttributes(lp);
        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dl.show();
        TextView content = (TextView) dialog_view.findViewById(R.id.dialog_tips_content);
        content.setText(ContentText);
        content.setTextSize(12);
        TextView close = (TextView) dialog_view.findViewById(R.id.dialog_tips_cancel);
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
            }
        });
        TextView login = (TextView) dialog_view.findViewById(R.id.dialog_tips_ok);
        login.setText(Button2);
        login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // 判断是否是继续建立档案，是，则继续建立，否则执行其他操作
                Intent intent =  new Intent(Settings.ACTION_SETTINGS);
                ((Activity)context).startActivity(intent);
                dl.dismiss();
            }
        });
    }
}
