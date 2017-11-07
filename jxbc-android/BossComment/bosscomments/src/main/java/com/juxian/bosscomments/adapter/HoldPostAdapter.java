package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.WorkItemEntity;

import java.text.SimpleDateFormat;
import java.util.List;

/**
 * Created by nene on 2016/11/29.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/29 13:49]
 * @Version: [v1.0]
 */
public class HoldPostAdapter extends MyBaseAdapter<WorkItemEntity> {

    private static SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat("yyyy年MM月dd日");

    public HoldPostAdapter(List<WorkItemEntity> list, Context context) {
        super(list, context);
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null) {
            viewHolder = new ViewHolder();

            convertView = inflater.inflate(R.layout.item_position_listview, null);

            viewHolder.position_time = (TextView) convertView.findViewById(R.id.position_time);
            viewHolder.position = (TextView) convertView.findViewById(R.id.position);
            viewHolder.department = (TextView) convertView.findViewById(R.id.department);
            viewHolder.wageIncome = (TextView) convertView.findViewById(R.id.wage_income);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        WorkItemEntity entity = list.get(position);
        if ("3000年01月01日".equals(mSimpleDateFormat.format(entity.PostEndTime))) {
            viewHolder.position_time.setText(mSimpleDateFormat.format(entity.PostStartTime) + "-至今");
        } else {
            viewHolder.position_time.setText(mSimpleDateFormat.format(entity.PostStartTime) + "-" + mSimpleDateFormat.format(entity.PostEndTime));
        }
        viewHolder.position.setText(entity.PostTitle);
        viewHolder.department.setText(entity.Department);
        if (!TextUtils.isEmpty(entity.Salary)) {
            viewHolder.wageIncome.setVisibility(View.VISIBLE);
            viewHolder.wageIncome.setText("年薪" + entity.Salary + "万元");
        } else {
            viewHolder.wageIncome.setVisibility(View.GONE);
        }
        return convertView;
    }

    class ViewHolder {
        TextView position_time;
        TextView position;
        TextView department;
        TextView wageIncome;
    }
}
