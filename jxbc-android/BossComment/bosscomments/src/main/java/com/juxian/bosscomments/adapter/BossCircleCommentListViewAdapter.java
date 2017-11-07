package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.BossDynamicCommentEntity;

import java.util.List;

/**
 * Created by Tam on 2016/12/27.
 */
public class BossCircleCommentListViewAdapter extends MyBaseAdapter<BossDynamicCommentEntity> implements View.OnClickListener {
    private ReplyOnClickListener replyOnClickListener;
//    private String CompanyAbbr;

    public BossCircleCommentListViewAdapter(List<BossDynamicCommentEntity> list, Context context, ReplyOnClickListener replyOnClickListener) {
        super(list, context);
        this.replyOnClickListener = replyOnClickListener;
//        CompanyAbbr = AppConfig.getCompanyAbbr();
    }

    @Override
    public View createView(final int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null) {
            viewHolder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_boss_circle_comment_listview, null);
            viewHolder.CompanyAbbr = (TextView) convertView.findViewById(R.id.boss_name);
            viewHolder.comment_ll = (LinearLayout) convertView.findViewById(R.id.comment_ll);
            viewHolder.bossComment = (TextView) convertView.findViewById(R.id.boss_comment);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        //做条目类型的判断


        viewHolder.CompanyAbbr.setText(list.get(position).CompanyAbbr + " : ");
        viewHolder.bossComment.setText(list.get(position).Content);
        viewHolder.comment_ll.setTag(position);
        viewHolder.comment_ll.setOnClickListener(this);
        return convertView;
    }


    /**
     * 回复评论
     *
     * @param pos
     * @param bossDynamicCommentEntity
     * @param tag                      1为对评论进行回复，非1为对动态进行的回复
     */
    public void RefreshCommentList(int pos, BossDynamicCommentEntity bossDynamicCommentEntity, int tag) {
        list.add(pos + 1, bossDynamicCommentEntity);
        notifyDataSetChanged();
    }

    @Override
    public void onClick(View v) {
        int pos = (int) v.getTag();
        replyOnClickListener.ToReply(v, list.get(pos).CompanyAbbr, pos, 1);
    }

    class ViewHolder {
        TextView CompanyAbbr;
        TextView bossComment;
        LinearLayout comment_ll;
    }

    public interface ReplyOnClickListener {
        void ToReply(View view, String CompanyAbbr, int position, int Tag);
    }
}
