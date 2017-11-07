package com.juxian.bosscomments.adapter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.juxian.bosscomments.models.ImageBucket;
import com.juxian.bosscomments.ui.ImageGridActivity;
import com.juxian.bosscomments.ui.PicActivity;
import com.juxian.bosscomments.utils.BitmapCache;
import com.juxian.bosscomments.R;

import java.io.Serializable;
import java.util.List;

public class PicCustomsListAdapter extends BaseAdapter {
    private Context context;
    private List<ImageBucket> dataList;
    BitmapCache cache;
    BitmapCache.ImageCallback callback = new BitmapCache.ImageCallback() {
        @Override
        public void imageLoad(ImageView imageView, Bitmap bitmap,
                              Object... params) {
            if (imageView != null && bitmap != null) {
                String url = (String) params[0];
                if (url != null && url.equals((String) imageView.getTag())) {
                    ((ImageView) imageView).setImageBitmap(bitmap);
                } else {
                }
            } else {
            }
        }
    };

    public PicCustomsListAdapter(Context content, List<ImageBucket> dataList) {
        this.context = content;
        this.dataList = dataList;
        cache = new BitmapCache();
    }

    @Override
    public int getCount() {

        if (dataList != null) {
            return dataList.size();
        } else
            return 0;
    }

    @Override
    public Object getItem(int position) {

        return null;
    }

    @Override
    public long getItemId(int position) {

        return 0;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {

        HolderView holder = null;
        if (convertView == null) {
            holder = new HolderView();
            convertView = LayoutInflater.from(context).inflate(
                    R.layout.pic_customslist_item, null);
            holder.pic_customslist_imgs = (ImageView) convertView
                    .findViewById(R.id.pic_customslist_imgs);
            holder.pic_customslist_imgname = (TextView) convertView
                    .findViewById(R.id.pic_customslist_imgname);
            holder.pic_customslist_imgcount = (TextView) convertView
                    .findViewById(R.id.pic_customslist_imgcount);
            convertView.setTag(holder);
        } else {
            holder = (HolderView) convertView.getTag();
        }
        ImageBucket item = dataList.get(position);
        holder.pic_customslist_imgcount.setText("" + item.count);
        holder.pic_customslist_imgname.setText(item.bucketName);
        if (item.imageList != null && item.imageList.size() > 0) {
            String thumbPath = item.imageList.get(0).thumbnailPath;
            String sourcePath = item.imageList.get(0).imagePath;
            holder.pic_customslist_imgs.setTag(sourcePath);
            cache.displayBmp(holder.pic_customslist_imgs, thumbPath,
                    sourcePath, callback);
        } else {
            holder.pic_customslist_imgs.setImageBitmap(null);
        }
        convertView.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {

                Intent intent = new Intent(context, ImageGridActivity.class);
                intent.putExtra(PicActivity.EXTRA_IMAGE_LIST,
                        (Serializable) dataList.get(position).imageList);
                context.startActivity(intent);
                ((Activity) context).overridePendingTransition(
                        R.anim.push_left_in, R.anim.push_left_out);
                ((Activity) context).finish();
            }
        });
        return convertView;
    }

    public class HolderView {
        public ImageView pic_customslist_imgs;
        public TextView pic_customslist_imgname;
        public TextView pic_customslist_imgcount;

    }
}
