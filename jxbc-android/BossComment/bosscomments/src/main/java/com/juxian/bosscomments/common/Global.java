package com.juxian.bosscomments.common;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Typeface;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ImageView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.ImageItem;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;
import com.nostra13.universalimageloader.core.listener.SimpleImageLoadingListener;

import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by nene on 2016/10/13.
 *
 * @ProjectName: [LaoBanDianPing]
 * @Package: [com.juxian.bosscomments.common]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/13 13:19]
 * @Version: [v1.0]
 */
public class Global {
    private static boolean uiInitialed = false;
    public static Typeface APP_TYPEFACE;
    public static final String LOG_TAG = "JuXian";
    public static final String LISTVIEW_ITEM_TAG = "tag";
    public static String SMCODE = "FRUIT1204";
    public static ImageItem single;

    static {
        APP_TYPEFACE = null;
    }

    public static void uiInit(Context context) {
        if (uiInitialed)
            return;
        uiInitialed = true;
        APP_TYPEFACE = Typeface.createFromAsset(context.getAssets(),
                "fonts/mini.ttf");
    }

    public static void CloseKeyBoard(EditText edit) {
        InputMethodManager imm = (InputMethodManager) edit.getContext()
                .getSystemService(Context.INPUT_METHOD_SERVICE);
        if (imm.isActive()) {
            imm.hideSoftInputFromWindow(edit.getApplicationWindowToken(), 0);

        }
    }

    public static class AnimateFirstDisplayListener extends
            SimpleImageLoadingListener {

        static final List<String> displayedImages = Collections
                .synchronizedList(new LinkedList<String>());

        @Override
        public void onLoadingComplete(String imageUri, View view,
                                      Bitmap loadedImage) {
            if (loadedImage != null) {
                ImageView imageView = (ImageView) view;
                boolean firstDisplay = !displayedImages.contains(imageUri);
                if (firstDisplay) {
                    // FadeInBitmapDisplayer.animate(imageView, 5000);
                    // displayedImages.add(imageUri);

                }
            }
        }
    }

    public static class Constants {
        public static final DisplayImageOptions DEFAULT_AVATAR_OPTIONS;// 默认头像
        public static final DisplayImageOptions DEFAULT_MY_CENTER_AVATAR_OPTIONS;
        public static final DisplayImageOptions DEFAULT_PERSONAL_AVATAR_OPTIONS;
        public static final DisplayImageOptions DEFAULT_EMPLOYEE_AVATAR_OPTIONS;
        public static final DisplayImageOptions DEFAULT_LOAD_PIC_OPTIONS;
        public static final DisplayImageOptions DEFAULT_COMPANY_LOGO_OPTIONS;
        public static final DisplayImageOptions DEFAULT_LOGO_OPTIONS;
        public static final DisplayImageOptions DEFAULT_OPEN_SERVICE_OPTIONS;
        public static final DisplayImageOptions DEFAULT_OPEN_SERVICE_ICON_OPTIONS;

        static {
            DEFAULT_AVATAR_OPTIONS = new DisplayImageOptions.Builder()
                    // 默认用户头像
                    .cacheInMemory(true).cacheOnDisc(true)
                    .considerExifParams(true)
                    .bitmapConfig(Bitmap.Config.ARGB_8888)
                    .imageScaleType(ImageScaleType.EXACTLY)
//                    .showImageOnLoading(R.drawable.default_head)
                    .showImageForEmptyUri(R.drawable.default_head)
                    .showImageOnFail(R.drawable.default_head).
                    // displayer(new RoundedBitmapDisplayer(20)).// 设置圆角图片，弧度为20
                            build();
            DEFAULT_MY_CENTER_AVATAR_OPTIONS = new DisplayImageOptions.Builder()
                    // 默认用户头像
                    .cacheInMemory(true).cacheOnDisc(true)
                    .considerExifParams(true)
                    .bitmapConfig(Bitmap.Config.ARGB_8888)
                    .imageScaleType(ImageScaleType.EXACTLY)
                    .showImageForEmptyUri(R.drawable.user_head)
                    .showImageOnFail(R.drawable.user_head).
                    // displayer(new RoundedBitmapDisplayer(20)).// 设置圆角图片，弧度为20
                            build();
            DEFAULT_PERSONAL_AVATAR_OPTIONS = new DisplayImageOptions.Builder()
                    // 默认个人头像
                    .cacheInMemory(true).cacheOnDisc(true)
                    .considerExifParams(true)
                    .bitmapConfig(Bitmap.Config.ARGB_8888)
                    .imageScaleType(ImageScaleType.EXACTLY)
                    .showImageForEmptyUri(R.drawable.personal_default_avatar)
                    .showImageOnFail(R.drawable.personal_default_avatar).
                    // displayer(new RoundedBitmapDisplayer(20)).// 设置圆角图片，弧度为20
                            build();
            DEFAULT_EMPLOYEE_AVATAR_OPTIONS = new DisplayImageOptions.Builder()
                    // 默认个人头像
                    .cacheInMemory(true).cacheOnDisc(true)
                    .considerExifParams(true)
                    .bitmapConfig(Bitmap.Config.ARGB_8888)
                    .imageScaleType(ImageScaleType.EXACTLY)
                    .showImageForEmptyUri(R.drawable.employee_avatar)
                    .showImageOnFail(R.drawable.employee_avatar).
                    // displayer(new RoundedBitmapDisplayer(20)).// 设置圆角图片，弧度为20
                            build();
            DEFAULT_LOAD_PIC_OPTIONS = new DisplayImageOptions.Builder()
                    // 默认用户头像
                    .cacheInMemory(true).cacheOnDisc(true)
                    .considerExifParams(true)
                    .bitmapConfig(Bitmap.Config.RGB_565)
                    .imageScaleType(ImageScaleType.EXACTLY)
//                    .showImageOnLoading(R.drawable.default_pic)
                    .showImageForEmptyUri(R.drawable.default_pic)
                    .showImageOnFail(R.drawable.default_pic)
                    // displayer(new RoundedBitmapDisplayer(20)).// 设置圆角图片，弧度为20
                            .build();
            DEFAULT_COMPANY_LOGO_OPTIONS = new DisplayImageOptions.Builder()
                    // 默认用户头像
                    .cacheInMemory(true).cacheOnDisc(true)
                    .considerExifParams(true)
                    .bitmapConfig(Bitmap.Config.ARGB_8888)
                    .imageScaleType(ImageScaleType.EXACTLY)
//                    .showImageOnLoading(R.drawable.company_default_logo)
                    .showImageForEmptyUri(R.drawable.company_default_logo)
                    .showImageOnFail(R.drawable.company_default_logo).
                    // displayer(new RoundedBitmapDisplayer(20)).// 设置圆角图片，弧度为20
                            build();
            DEFAULT_LOGO_OPTIONS = new DisplayImageOptions.Builder()
                    // 默认用户头像
                    .cacheInMemory(true).cacheOnDisc(true)
                    .considerExifParams(true)
                    .bitmapConfig(Bitmap.Config.ARGB_8888)
                    .imageScaleType(ImageScaleType.EXACTLY)
//                    .showImageOnLoading(R.drawable.company_logo)
                    .showImageForEmptyUri(R.drawable.company_logo)
                    .showImageOnFail(R.drawable.company_logo).
                    // displayer(new RoundedBitmapDisplayer(20)).// 设置圆角图片，弧度为20
                            build();
            DEFAULT_OPEN_SERVICE_OPTIONS = new DisplayImageOptions.Builder()
                    // 默认用户头像
                    .cacheInMemory(true).cacheOnDisc(true)
                    .considerExifParams(true)
                    .bitmapConfig(Bitmap.Config.ARGB_8888)
                    .imageScaleType(ImageScaleType.EXACTLY)
//                    .showImageOnLoading(R.drawable.the_god_of_wealth)
                    .showImageForEmptyUri(R.drawable.the_god_of_wealth)
                    .showImageOnFail(R.drawable.the_god_of_wealth).
                    // displayer(new RoundedBitmapDisplayer(20)).// 设置圆角图片，弧度为20
                            build();
            DEFAULT_OPEN_SERVICE_ICON_OPTIONS = new DisplayImageOptions.Builder()
                    // 默认用户头像
                    .cacheInMemory(true).cacheOnDisc(true)
                    .considerExifParams(true)
                    .bitmapConfig(Bitmap.Config.ARGB_8888)
                    .imageScaleType(ImageScaleType.EXACTLY)
//                    .showImageOnLoading(R.drawable.lantern)
                    .showImageForEmptyUri(R.drawable.lantern)
                    .showImageOnFail(R.drawable.lantern).
                    // displayer(new RoundedBitmapDisplayer(20)).// 设置圆角图片，弧度为20
                            build();
        }
    }
}
