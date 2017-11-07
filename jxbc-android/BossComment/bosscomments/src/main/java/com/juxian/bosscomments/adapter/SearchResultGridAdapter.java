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
 * Created by nene on 2016/10/31.
 *
 * @ProjectName: [BossComment]
 * @Package: [com.juxian.bosscomments.adapter]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/31 17:49]
 * @Version: [v1.0]
 */
public class SearchResultGridAdapter extends MyBaseAdapter<String> {

    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_LOAD_PIC_OPTIONS;

    public SearchResultGridAdapter(List<String> list, Context context) {
        super(list, context);
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null){
            viewHolder = new ViewHolder();

            convertView = inflater.inflate(R.layout.item_search_result_grid,null);

            viewHolder.imageView = (ImageView) convertView.findViewById(R.id.imageView);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        String url = list.get(position);
//        viewHolder.imageView.setTag(url);
//        if(viewHolder.imageView.getTag()!=null&&viewHolder.imageView.getTag().equals(url)){
            ImageLoader.getInstance().displayImage(url, viewHolder.imageView,options,animateFirstListener);
//        }
        return convertView;
    }

    class ViewHolder{
        ImageView imageView;
    }
}
