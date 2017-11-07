package com.juxian.bosscomments.utils;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.CheckBox;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.models.DepartmentEntity;
import com.juxian.bosscomments.models.EmployeArchiveEntity;
import com.juxian.bosscomments.ui.SignInActivity;

import net.juxian.appgenome.utils.JsonUtil;

/**
 * Created by nene on 2016/12/5.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/5 11:09]
 * @Version: [v1.0]
 */
public class DialogUtils {
    /**
     * 点击注册的时候，用于判断该手机号是否已经注册，要是注册，则提示用户去登录
     */
    public static void showProgresbarDialog(final Context context, final String mobilePhone) {
        final Dialog dl = new Dialog(context);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(true);
        View dialog_view = View.inflate(context, R.layout.dialog_tips, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = Dp2pxUtil.dp2px(300, context);
        dialogWindow.setAttributes(lp);
        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dl.show();
        TextView close = (TextView) dialog_view.findViewById(R.id.dialog_tips_cancel);
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
            }
        });
        TextView login = (TextView) dialog_view.findViewById(R.id.dialog_tips_ok);
        login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent SignIn = new Intent(context, SignInActivity.class);
                SignIn.putExtra("phone", mobilePhone);
                context.startActivity(SignIn);
                dl.dismiss();
                ((Activity) context).finish();
            }
        });
    }

    /**
     * 工作台提示Dialog，用于提示正在审核的用户
     *
     * @param hintText
     */
    public static void showMainDialog(String hintText, Context context,final MainDialogListener listener) {
        final Dialog dl = new Dialog(context);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(false);
        View dialog_view = View.inflate(context, R.layout.dialog_main_tips, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = Dp2pxUtil.dp2px(300, context);
        dialogWindow.setAttributes(lp);
        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dl.show();
        TextView hint = (TextView) dialog_view.findViewById(R.id.dialog_tips_content);
        if (TextUtils.isEmpty(hintText)) {
            hint.setText("数据访问超时，请退出重试！");
        } else {
            hint.setText(hintText);
        }

        TextView cancel = (TextView) dialog_view.findViewById(R.id.dialog_tips_cancel);
        TextView ok = (TextView) dialog_view.findViewById(R.id.dialog_tips_ok);
        ok.setText("我知道了");
        cancel.setText("退出登录");
//        cancel.setVisibility(View.GONE);
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
                listener.MainLeftBtMethod();
            }
        });
        ok.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
                listener.MainRightBtMethod();
            }
        });
    }

    public interface MainDialogListener {
        void MainLeftBtMethod();

        void MainRightBtMethod();
    }

    /**
     * 工作台提示Dialog，用于提示正在审核的用户
     *
     * @param hintText
     */
    public static void showHomeDialog(String hintText, Context context, final RadioGroup mainRadios, final RadioButton rbTabMain, final RadioButton rbTabAccount, final RadioButton rbTabInvite,final MainDialogListener listener) {
        final Dialog dl = new Dialog(context);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(false);
        View dialog_view = View.inflate(context, R.layout.dialog_main_tips, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = Dp2pxUtil.dp2px(300, context);
        dialogWindow.setAttributes(lp);
        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dl.show();
        TextView hint = (TextView) dialog_view.findViewById(R.id.dialog_tips_content);
        if (TextUtils.isEmpty(hintText)) {
            hint.setText("数据访问超时，请退出重试！");
        } else {
            hint.setText(hintText);
        }
        TextView cancel = (TextView) dialog_view.findViewById(R.id.dialog_tips_cancel);
        TextView ok = (TextView) dialog_view.findViewById(R.id.dialog_tips_ok);
        ok.setText("我知道了");
        cancel.setText("退出登录");
//        cancel.setVisibility(View.GONE);
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
                rbTabMain.setChecked(false);
                rbTabAccount.setChecked(false);
                rbTabInvite.setChecked(false);
                mainRadios.clearCheck();
                rbTabMain.setChecked(true);
                listener.MainLeftBtMethod();
            }
        });
        ok.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
                rbTabMain.setChecked(false);
                rbTabAccount.setChecked(false);
                rbTabInvite.setChecked(false);
                mainRadios.clearCheck();
                rbTabMain.setChecked(true);
                listener.MainRightBtMethod();
            }
        });
    }

    /**
     * 点击注册的时候，用于判断该手机号是否已经注册，要是注册，则提示用户去登录
     */
    public static void showAlreadyRegisterDialog(final Context context) {
        final Dialog dl = new Dialog(context);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(true);
        View dialog_view = View.inflate(context, R.layout.dialog_tips, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = Dp2pxUtil.dp2px(300, context);
        dialogWindow.setAttributes(lp);
        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dl.show();
        TextView close = (TextView) dialog_view.findViewById(R.id.dialog_tips_cancel);
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
            }
        });
        TextView login = (TextView) dialog_view.findViewById(R.id.dialog_tips_ok);
        login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent SignIn = new Intent(context, SignInActivity.class);
                context.startActivity(SignIn);
                dl.dismiss();
                ((Activity) context).finish();
            }
        });
    }

    public static void showDialog(final Context context, final DepartmentEntity entity, final int pos, final DepartmentDialogListener listener) {
        final Dialog dl = new Dialog(context);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(false);
        View dialog_view = View.inflate(context, R.layout.dialog_accredit, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = Dp2pxUtil.dp2px(300, context);
        dialogWindow.setAttributes(lp);
        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dl.show();
        TextView close = (TextView) dialog_view.findViewById(R.id.dialog_tips_cancel);
        TextView ok = (TextView) dialog_view.findViewById(R.id.dialog_tips_ok);
        TextView content = (TextView) dialog_view.findViewById(R.id.dialog_tips_content);
        content.setText("确定要删除？");
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
                listener.LeftBtMethod();
            }
        });
        ok.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // 判断是否是继续建立档案，是，则继续建立，否则执行其他操作
                dl.dismiss();
                listener.RightBtMethod(entity, pos);
            }
        });
    }

    public interface DepartmentDialogListener {
        void LeftBtMethod();

        void RightBtMethod(DepartmentEntity entity, int pos);
    }


    public static void showArchiveDialog(final Context context, boolean isShow, String leftText, String rightText, String titleText, final String contentText, final ArchiveCommentEntity entity, final ArchiveDialogListener listener) {
        final Dialog dl = new Dialog(context);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(false);
        View dialog_view = View.inflate(context, R.layout.dialog_comment, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = Dp2pxUtil.dp2px(300, context);
        dialogWindow.setAttributes(lp);
        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dl.show();
        TextView close = (TextView) dialog_view.findViewById(R.id.dialog_tips_cancel);
        close.setText(leftText);
        TextView ok = (TextView) dialog_view.findViewById(R.id.dialog_tips_ok);
        if (isShow) {
            ok.setVisibility(View.VISIBLE);
        } else {
            ok.setVisibility(View.GONE);
        }
        ok.setText(rightText);
        TextView content = (TextView) dialog_view.findViewById(R.id.dialog_tips_content);
        TextView title = (TextView) dialog_view.findViewById(R.id.dialog_tips_title);
        title.setText(titleText);
        content.setText(contentText);
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
                listener.LeftBtMethod();
            }
        });
        ok.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // 判断是否是继续建立档案，是，则继续建立，否则执行其他操作
                dl.dismiss();
                listener.RightBtMethod(entity);
            }
        });
    }

    public interface ArchiveDialogListener {
        void LeftBtMethod();

        void RightBtMethod(ArchiveCommentEntity entity);
    }

    public static void showEmployeeRecordDialog(final Context context, String ContentText, String Button2, final Class<?> GoalIntentClass, final EmployeArchiveEntity entity) {
        final Dialog dl = new Dialog(context);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(false);
        View dialog_view = View.inflate(context, R.layout.dialog_tips, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = Dp2pxUtil.dp2px(300, context);
        dialogWindow.setAttributes(lp);
        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dl.show();
        TextView content = (TextView) dialog_view.findViewById(R.id.dialog_tips_content);
        content.setText(ContentText);
        TextView close = (TextView) dialog_view.findViewById(R.id.dialog_tips_cancel);
        close.setText("关闭");
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
                ((Activity) context).finish();
            }
        });
        TextView login = (TextView) dialog_view.findViewById(R.id.dialog_tips_ok);
        login.setText(Button2);
        login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // 判断是否是继续建立档案，是，则继续建立，否则执行其他操作
                dl.dismiss();
                Intent intent = new Intent(context, GoalIntentClass);
                intent.putExtra("Tag", "Have");
                intent.putExtra("isContinue", "continue");
                intent.putExtra("EmployeArchiveEntity", JsonUtil.ToJson(entity));
                ((Activity) context).startActivity(intent);
                ((Activity) context).finish();
            }
        });
    }

    public interface DialogListener {
        void LeftBtMethod();

        void RightBtMethod();
    }

    public static void showStandardDialog(final Context context, final String Button1, final String Button2, final String contentText, final DialogListener listener) {
        final Dialog dl = new Dialog(context);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(false);
        View dialog_view = View.inflate(context, R.layout.dialog_accredit, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = Dp2pxUtil.dp2px(300, context);
        dialogWindow.setAttributes(lp);
        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dl.show();
        TextView close = (TextView) dialog_view.findViewById(R.id.dialog_tips_cancel);
        TextView ok = (TextView) dialog_view.findViewById(R.id.dialog_tips_ok);
        TextView content = (TextView) dialog_view.findViewById(R.id.dialog_tips_content);
        close.setText(Button1);
        ok.setText(Button2);
        content.setText(contentText);
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
                listener.LeftBtMethod();
            }
        });
        ok.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // 判断是否是继续建立档案，是，则继续建立，否则执行其他操作
                dl.dismiss();
                listener.RightBtMethod();
            }
        });
    }

    public static void showStandardCheckDialog(final Context context, final String Button1, final String Button2, final String contentText, final CheckDialogListener listener) {
        final Dialog dl = new Dialog(context);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(false);
        View dialog_view = View.inflate(context, R.layout.dialog_accredit, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = Dp2pxUtil.dp2px(300, context);
        dialogWindow.setAttributes(lp);
        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dl.show();
        TextView close = (TextView) dialog_view.findViewById(R.id.dialog_tips_cancel);
        TextView ok = (TextView) dialog_view.findViewById(R.id.dialog_tips_ok);
        TextView content = (TextView) dialog_view.findViewById(R.id.dialog_tips_content);
        LinearLayout select_send_sms = (LinearLayout) dialog_view.findViewById(R.id.select_send_sms);
        select_send_sms.setVisibility(View.VISIBLE);
        final CheckBox send_sms_check = (CheckBox) dialog_view.findViewById(R.id.send_sms_check);
        close.setText(Button1);
        ok.setText(Button2);
        content.setText(contentText);
        select_send_sms.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (send_sms_check.isChecked()) {
                    send_sms_check.setChecked(false);
                } else {
                    send_sms_check.setChecked(true);
                }
            }
        });
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
                listener.LeftBtMethod();
            }
        });
        ok.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // 判断是否是继续建立档案，是，则继续建立，否则执行其他操作
                dl.dismiss();
                listener.RightBtMethod(send_sms_check.isChecked());
            }
        });
    }

    public interface CheckDialogListener {
        void LeftBtMethod();

        void RightBtMethod(boolean isSendSms);
    }

    public static void showRadiusDialog(final Context context, boolean isShowBt, final String Button1, final String Button2, final String contentText, final DialogListener listener) {
        final Dialog dl = new Dialog(context);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(false);
        View dialog_view = View.inflate(context, R.layout.dialog_hint_title, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = Dp2pxUtil.dp2px(300, context);
        dialogWindow.setAttributes(lp);
        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dl.show();
        TextView close = (TextView) dialog_view.findViewById(R.id.dialog_tips_cancel);
        View line = dialog_view.findViewById(R.id.line);
        TextView ok = (TextView) dialog_view.findViewById(R.id.dialog_tips_ok);
        TextView content = (TextView) dialog_view.findViewById(R.id.dialog_tips_content);
        if (isShowBt) {
            close.setVisibility(View.VISIBLE);
            line.setVisibility(View.VISIBLE);
        } else {
            close.setVisibility(View.GONE);
            line.setVisibility(View.GONE);
        }
        close.setText(Button1);
        close.setTextColor(context.getResources().getColor(R.color.menu_color));
        ok.setTextColor(context.getResources().getColor(R.color.main_gold_color));
        ok.setText(Button2);
        content.setText(contentText);
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
                listener.LeftBtMethod();
            }
        });
        ok.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // 判断是否是继续建立档案，是，则继续建立，否则执行其他操作
                dl.dismiss();
                listener.RightBtMethod();
            }
        });
    }

    public static void showMainRadiusDialog(String hintText, Context context) {
        final Dialog dl = new Dialog(context);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(false);
        View dialog_view = View.inflate(context, R.layout.dialog_hint_title, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = Dp2pxUtil.dp2px(300, context);
        dialogWindow.setAttributes(lp);
        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dl.show();
        TextView hint = (TextView) dialog_view.findViewById(R.id.dialog_tips_content);
        if (TextUtils.isEmpty(hintText)) {
            hint.setText("数据访问超时，请退出重试！");
        } else {
            hint.setText(hintText);
        }

        TextView cancel = (TextView) dialog_view.findViewById(R.id.dialog_tips_cancel);
        TextView ok = (TextView) dialog_view.findViewById(R.id.dialog_tips_ok);
        View line = dialog_view.findViewById(R.id.line);
        ok.setText("我知道了");
        cancel.setVisibility(View.GONE);
        line.setVisibility(View.GONE);
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
            }
        });
        ok.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
            }
        });
    }

    public static void showStandardTitleDialog(final Context context, boolean isShow, String leftText, String rightText, String titleText, final String contentText) {
        final Dialog dl = new Dialog(context);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(false);
        View dialog_view = View.inflate(context, R.layout.dialog_comment, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = Dp2pxUtil.dp2px(300, context);
        dialogWindow.setAttributes(lp);
        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dl.show();
        TextView close = (TextView) dialog_view.findViewById(R.id.dialog_tips_cancel);
        close.setText(leftText);
        TextView ok = (TextView) dialog_view.findViewById(R.id.dialog_tips_ok);
        View line = dialog_view.findViewById(R.id.line);
        if (isShow) {
            line.setVisibility(View.VISIBLE);
            ok.setVisibility(View.VISIBLE);
        } else {
            line.setVisibility(View.GONE);
            ok.setVisibility(View.GONE);
        }
        ok.setText(rightText);
        TextView content = (TextView) dialog_view.findViewById(R.id.dialog_tips_content);
        TextView title = (TextView) dialog_view.findViewById(R.id.dialog_tips_title);
        title.setText(titleText);
        content.setText(contentText);
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
            }
        });
        ok.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // 判断是否是继续建立档案，是，则继续建立，否则执行其他操作
                dl.dismiss();
            }
        });
    }

    public static void showStandardTitleDialog(final Context context, String leftText, String rightText, String titleText, final String contentText,final StandardTitleDialogListener listener) {
        final Dialog dl = new Dialog(context);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(false);
        View dialog_view = View.inflate(context, R.layout.dialog_comment, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = Dp2pxUtil.dp2px(300, context);
        dialogWindow.setAttributes(lp);
        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dl.show();
        TextView close = (TextView) dialog_view.findViewById(R.id.dialog_tips_cancel);
        close.setText(leftText);
        TextView ok = (TextView) dialog_view.findViewById(R.id.dialog_tips_ok);
        ok.setText(rightText);
        TextView content = (TextView) dialog_view.findViewById(R.id.dialog_tips_content);
        TextView title = (TextView) dialog_view.findViewById(R.id.dialog_tips_title);
        title.setText(titleText);
        content.setText(contentText);
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
                listener.LeftBtMethod();
            }
        });
        ok.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // 判断是否是继续建立档案，是，则继续建立，否则执行其他操作
                dl.dismiss();
                listener.RightBtMethod();
            }
        });
    }

    public interface StandardTitleDialogListener {
        void LeftBtMethod();

        void RightBtMethod();
    }
}
