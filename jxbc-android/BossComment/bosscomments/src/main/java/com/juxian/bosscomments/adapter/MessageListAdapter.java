package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.text.TextPaint;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.MessageEntity;

import java.text.SimpleDateFormat;
import java.util.List;

/**
 * Created by nene on 2016/12/2.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/2 16:28]
 * @Version: [v1.0]
 */
public class MessageListAdapter extends MyBaseAdapter<MessageEntity> {

    private SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    public MessageListAdapter(List<MessageEntity> list, Context context) {
        super(list, context);
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null) {
            viewHolder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_message, null);
            viewHolder.workComment_title = (TextView) convertView.findViewById(R.id.workComment_title);
            viewHolder.message_submittime = (TextView) convertView.findViewById(R.id.message_submittime);
            viewHolder.invite_company = (TextView) convertView.findViewById(R.id.invite_company);
            viewHolder.goToCheck = (ImageView) convertView.findViewById(R.id.goToCheck);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        MessageEntity messageEntity = list.get(position);
        if (messageEntity.BizType == 3 || messageEntity.BizType == 2) {    //工作评价,离任报告，可点击item
            viewHolder.goToCheck.setVisibility(View.VISIBLE);
            viewHolder.invite_company.setVisibility(View.GONE);
        } else {      //邀请注册，普通条目，不可点击item
            viewHolder.goToCheck.setVisibility(View.GONE);
            viewHolder.invite_company.setVisibility(View.GONE);
        }
//        if ("personal".equals(tag)){
//            viewHolder.goToCheck.setVisibility(View.GONE);
//        }

        viewHolder.workComment_title.setText(messageEntity.Content);
        viewHolder.message_submittime.setText(mSimpleDateFormat.format(messageEntity.CreatedTime));
        TextPaint textPaint = viewHolder.workComment_title.getPaint();
        if (messageEntity.IsRead == 0) {//未读
            textPaint.setFakeBoldText(true);
        } else if (messageEntity.IsRead == 1) {
            textPaint.setFakeBoldText(false);
        }
        return convertView;
    }

    class ViewHolder {
        TextView workComment_title;
        TextView message_submittime;
        ImageView goToCheck;
        TextView invite_company;
    }
}
