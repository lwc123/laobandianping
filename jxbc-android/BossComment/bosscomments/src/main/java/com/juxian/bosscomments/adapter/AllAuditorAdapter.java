package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.MemberEntity;

import java.util.List;

/**
 * Created by nene on 2016/12/7.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/7 19:46]
 * @Version: [v1.0]
 */
public class AllAuditorAdapter extends MyBaseAdapter<MemberEntity> {

    private AuditorDeleteListener listener;

    public AllAuditorAdapter(List<MemberEntity> list, Context context, AuditorDeleteListener listener) {
        super(list, context);
        this.listener = listener;
    }

    @Override
    public View createView(final int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null){
            viewHolder = new ViewHolder();

            convertView = inflater.inflate(R.layout.item_auditor,null);

            viewHolder.mAuditorName = (TextView) convertView.findViewById(R.id.auditor_name);
            viewHolder.mDeleteAuditor = (ImageView) convertView.findViewById(R.id.delete_auditor);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        MemberEntity entity = list.get(position);
        viewHolder.mAuditorName.setText(entity.RealName+"（"+entity.JobTitle+"）");
        if (entity.Role != MemberEntity.CompanyMember_Role_Boss) {
            viewHolder.mDeleteAuditor.setVisibility(View.VISIBLE);
        } else {
            viewHolder.mDeleteAuditor.setVisibility(View.GONE);
        }
        viewHolder.mDeleteAuditor.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                list.remove(position);
                listener.onDeleteAuditor(position);
                notifyDataSetChanged();
            }
        });
        return convertView;
    }

    class ViewHolder{
        TextView mAuditorName;
        ImageView mDeleteAuditor;
    }

    public interface AuditorDeleteListener {
        void onDeleteAuditor(int position);
    }
}
