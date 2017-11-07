package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.text.TextPaint;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.MessageEntity;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Created by nene on 2016/12/2.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/2 16:28]
 * @Version: [v1.0]
 */
public class CMessageListAdapter extends MyBaseAdapter<MessageEntity> {
    private DisplayImageOptions options = Global.Constants.DEFAULT_LOAD_PIC_OPTIONS;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    private SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public CMessageListAdapter(List<MessageEntity> list, Context context) {
        super(list, context);
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null) {
            viewHolder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_message_fragement, null);
            viewHolder.mess_frag_title = (TextView) convertView.findViewById(R.id.mess_frag_title);
            viewHolder.mess_frag_time = (TextView) convertView.findViewById(R.id.mess_frag_time);
            viewHolder.imageView_logo = (ImageView) convertView.findViewById(R.id.imageView_logo);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        MessageEntity messageEntity = list.get(position);

        viewHolder.mess_frag_title.setText(messageEntity.Content);

        ImageLoader.getInstance().displayImage(messageEntity.Picture, viewHolder.imageView_logo, options, animateFirstListener);
        FormatTime(viewHolder.mess_frag_time, position);
        TextPaint textPaint = viewHolder.mess_frag_title.getPaint();
        if (messageEntity.IsRead == 0) {//未读
            textPaint.setFakeBoldText(true);
        } else if (messageEntity.IsRead == 1) {
            textPaint.setFakeBoldText(false);
        }
        return convertView;
    }

    class ViewHolder {
        TextView mess_frag_title;
        TextView mess_frag_time;
        ImageView imageView_logo;
    }

    public void FormatTime(TextView view, int position) {
        try {
            String ItemDateStr = mSimpleDateFormat.format(list.get(position).CreatedTime);
            String NowDateStr = mSimpleDateFormat.format(new Date());
            long l = mSimpleDateFormat.parse(NowDateStr).getTime() - mSimpleDateFormat.parse(ItemDateStr).getTime();
            long day = l / (24 * 60 * 60 * 1000); //0
            long hour = (l / (60 * 60 * 1000) - day * 24); //7
            long min = ((l / (60 * 1000)) - day * 24 * 60 - hour * 60); //25
            long s = (l / 1000 - day * 24 * 60 * 60 - hour * 60 * 60 - min * 60); //27
            if (day > 1) {
                view.setText(ItemDateStr);
            } else if (hour >= 1) {
                view.setText(hour + "小时前");
            } else if (min >= 1) {
                view.setText(min + "分钟前");
            } else if (s >= 0) {
                view.setText("刚刚");
            } else {
                view.setText("未知时间");
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }
}
