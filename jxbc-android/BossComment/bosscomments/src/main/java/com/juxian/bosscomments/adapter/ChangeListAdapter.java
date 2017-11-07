package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.ArchiveCommentEntity;

import java.util.List;

/**
 * Created by nene on 2016/12/1.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/1 16:29]
 * @Version: [v1.0]
 */
public class ChangeListAdapter extends MyBaseAdapter<ArchiveCommentEntity> {

    public ChangeListAdapter(List<ArchiveCommentEntity> list, Context context) {
        super(list, context);
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null){
            viewHolder = new ViewHolder();

            convertView = inflater.inflate(R.layout.item_change_list,null);

            viewHolder.mChangeItemText = (TextView) convertView.findViewById(R.id.item_change_text);
            viewHolder.view = convertView.findViewById(R.id.view);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
//        String str = list.get(position);
//        viewHolder.mChangeItemText.setText(str+"");
        ArchiveCommentEntity entity = list.get(position);
        if (entity.CommentType == 0) {
            viewHolder.view.setVisibility(View.GONE);
            viewHolder.mChangeItemText.setText(entity.StageYear+" "+entity.StageSectionText+" 评价");
        } else {
            viewHolder.view.setVisibility(View.VISIBLE);
            viewHolder.mChangeItemText.setText("离任报告");
        }
        return convertView;
    }

    class ViewHolder{
        TextView mChangeItemText;
        View view;
    }
}
