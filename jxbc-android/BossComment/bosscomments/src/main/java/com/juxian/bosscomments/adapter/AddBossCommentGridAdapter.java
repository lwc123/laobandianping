package com.juxian.bosscomments.adapter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.ui.ShowBigImgActivity;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import org.xutils.image.ImageOptions;
import org.xutils.x;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by nene on 2016/10/31.
 *
 * @ProjectName: [BossComment]
 * @Package: [com.juxian.bosscomments.adapter]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/31 17:49]
 * @Version: [v1.0]
 */
public class AddBossCommentGridAdapter extends MyBaseAdapter<String> {

    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_LOAD_PIC_OPTIONS;
    private ImageDeleteListener listener;
    private ImageOptions xUtilsOptions = new ImageOptions.Builder().build();

    public AddBossCommentGridAdapter(List<String> list, Context context, ImageDeleteListener listener) {
        super(list, context);
        this.listener = listener;
    }

    @Override
    public View createView(final int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null) {
            viewHolder = new ViewHolder();

            convertView = inflater.inflate(R.layout.item_add_boss_comment_gridview, null);

            viewHolder.imageView = (ImageView) convertView.findViewById(R.id.image);
            viewHolder.delete = (ImageView) convertView.findViewById(R.id.delete);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        String url = list.get(position);
        if (url.startsWith("http://")) {
            ImageLoader.getInstance().displayImage(url, viewHolder.imageView, options, animateFirstListener);
        } else {
//            Bitmap bitmap = BitmapFactory.decodeFile(url);
//            viewHolder.imageView.setImageBitmap(bitmap);
            x.image().bind(viewHolder.imageView, url, xUtilsOptions);
        }
        viewHolder.imageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ArrayList ImageUrls = new ArrayList();
                ImageUrls.addAll(list);
                Intent ShowBigImg1 = new Intent(context, ShowBigImgActivity.class);
                ShowBigImg1.putExtra("ImageUrls", ImageUrls);
                ShowBigImg1.putExtra("index", (position));
                ((Activity) context).startActivity(ShowBigImg1);
            }
        });

        viewHolder.delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                listener.onDeleteImage(position);
            }
        });
        return convertView;
    }

    class ViewHolder {
        ImageView imageView;
        ImageView delete;
    }

    public interface ImageDeleteListener {
        void onDeleteImage(int position);
    }
}
