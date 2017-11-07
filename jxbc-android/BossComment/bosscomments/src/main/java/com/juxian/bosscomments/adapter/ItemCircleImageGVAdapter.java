package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import java.util.List;

/**
 * Created by Tam on 2016/12/23.
 */
public class ItemCircleImageGVAdapter<String> extends MyBaseAdapter {
    private DisplayImageOptions options = Global.Constants.DEFAULT_LOAD_PIC_OPTIONS;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();

    public ItemCircleImageGVAdapter(List<String> list, Context context) {
        super(list, context);
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null) {
            viewHolder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_circle_image, null);
            viewHolder.itemCircleImg = (ImageView) convertView.findViewById(R.id.item_circle_img);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        ImageLoader.getInstance().displayImage((java.lang.String) list.get(position), viewHolder.itemCircleImg, options, animateFirstListener);

        return convertView;
    }

    class ViewHolder {
        ImageView itemCircleImg;
    }
}
