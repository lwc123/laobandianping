package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.ArchiveCommentLogEntity;
import com.juxian.bosscomments.models.MemberEntity;

import java.text.SimpleDateFormat;
import java.util.List;

/**
 * Created by Tam on 2017/2/8.
 */
public class ModifyRecordAdapter extends MyBaseAdapter<ArchiveCommentLogEntity> {

    private SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat("yyyy年MM月dd日");

    public ModifyRecordAdapter(List<ArchiveCommentLogEntity> list, Context context) {
        super(list, context);
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null) {
            viewHolder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_modify_record, null);
            viewHolder.modify_record_role = (TextView) convertView.findViewById(R.id.modify_record_role);
            viewHolder.modify_record_time = (TextView) convertView.findViewById(R.id.modify_record_time);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        ArchiveCommentLogEntity entity = list.get(position);
        if (entity.CompanyMember.Role == MemberEntity.CompanyMember_Role_Boss) {
            viewHolder.modify_record_role.setText(entity.CompanyMember.RealName+"（老板）");
        } else if (entity.CompanyMember.Role == MemberEntity.CompanyMember_Role_Admin){
            viewHolder.modify_record_role.setText(entity.CompanyMember.RealName+"（管理员）");
        } else if (entity.CompanyMember.Role == MemberEntity.CompanyMember_Role_Senior){
            viewHolder.modify_record_role.setText(entity.CompanyMember.RealName+"（高管）");
        } else {
            viewHolder.modify_record_role.setText(entity.CompanyMember.RealName+"（建档员）");
        }
        viewHolder.modify_record_time.setText(mSimpleDateFormat.format(entity.ModifiedTime));
        return convertView;
    }

    class ViewHolder {
        TextView modify_record_role;
        TextView modify_record_time;
    }
}
