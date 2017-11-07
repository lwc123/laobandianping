package com.juxian.bosscomments.utils;

import android.content.Context;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.youth.banner.loader.ImageLoader;

/**
 * Created by nene on 2017/4/17.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/17 10:23]
 * @Version: [v1.0]
 */
public class GlideImageLoader extends ImageLoader {
    @Override
    public void displayImage(Context context, Object path, ImageView imageView) {
        Glide.with(context).load(path).into(imageView);
    }

    @Override
    public ImageView createImageView(Context context) {
        return super.createImageView(context);
    }
}
