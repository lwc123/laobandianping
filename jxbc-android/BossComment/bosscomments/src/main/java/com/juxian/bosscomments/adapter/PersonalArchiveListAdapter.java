package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.EmployeArchiveEntity;

import java.util.List;

/**
 * Created by nene on 2016/12/19.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/19 19:45]
 * @Version: [v1.0]
 */
public class PersonalArchiveListAdapter extends MyBaseAdapter<EmployeArchiveEntity> {

    public PersonalArchiveListAdapter(List<EmployeArchiveEntity> list, Context context) {
        super(list, context);
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null){
            viewHolder = new ViewHolder();

            convertView = inflater.inflate(R.layout.item_personal_archive_list,null);
            viewHolder.mCompanyName = (TextView) convertView.findViewById(R.id.company_name);
            viewHolder.mArchiveNumber = (TextView) convertView.findViewById(R.id.archive_number);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        EmployeArchiveEntity entity = list.get(position);
        if (TextUtils.isEmpty(entity.CompanyName)){
            viewHolder.mCompanyName.setText("");
        } else {
            viewHolder.mCompanyName.setText(entity.CompanyName);
        }
        if (entity.StageEvaluationNum != 0 && entity.DepartureReportNum != 0){
            viewHolder.mArchiveNumber.setText("有"+entity.StageEvaluationNum+"份工作评价，"+entity.DepartureReportNum+"份离任报告");
        } else {
            if (entity.StageEvaluationNum != 0 && entity.DepartureReportNum == 0){
                viewHolder.mArchiveNumber.setText("有"+entity.StageEvaluationNum+"份工作评价");
            } else if (entity.StageEvaluationNum == 0 && entity.DepartureReportNum != 0){
                viewHolder.mArchiveNumber.setText("有"+entity.DepartureReportNum+"份离任报告");
            } else {
                viewHolder.mArchiveNumber.setText("暂无工作评价、离任报告");
            }
        }
        return convertView;
    }

    class ViewHolder{
        TextView mCompanyName;
        TextView mArchiveNumber;
    }
}
