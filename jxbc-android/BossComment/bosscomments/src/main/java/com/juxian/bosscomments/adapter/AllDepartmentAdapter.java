package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.DepartmentEntity;

import java.util.List;

/**
 * Created by nene on 2016/12/21.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/21 13:37]
 * @Version: [v1.0]
 */
public class AllDepartmentAdapter extends MyBaseAdapter<DepartmentEntity> {

    private DepartmentManageListener listener;

    public AllDepartmentAdapter(List<DepartmentEntity> list, Context context,DepartmentManageListener listener) {
        super(list, context);
        this.listener = listener;
    }

    @Override
    public View createView(final int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null){
            viewHolder = new ViewHolder();

            convertView = inflater.inflate(R.layout.item_all_department,null);

            viewHolder.mDepartmentName = (TextView) convertView.findViewById(R.id.item_all_department_name);
            viewHolder.mChange = (TextView) convertView.findViewById(R.id.item_all_department_change);
            viewHolder.mDelete = (TextView) convertView.findViewById(R.id.item_all_department_delete);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        DepartmentEntity entity = list.get(position);
        viewHolder.mDepartmentName.setText(entity.DeptName);
        final DepartmentEntity entity1 = entity;
        viewHolder.mChange.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                listener.ChangeDepartment(entity1);
            }
        });
        viewHolder.mDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                listener.DeleteDepartment(position);
            }
        });
        return convertView;
    }

    class ViewHolder{
        TextView mDepartmentName;
        TextView mChange;
        TextView mDelete;
    }

    public interface DepartmentManageListener{
        void ChangeDepartment(DepartmentEntity entity);
        void DeleteDepartment(int position);
    }
}
