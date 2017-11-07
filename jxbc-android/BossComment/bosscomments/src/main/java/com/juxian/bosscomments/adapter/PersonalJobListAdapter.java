package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.juxian.bosscomments.R;

import java.util.List;

/**
 * Created by nene on 2016/12/19.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/19 19:45]
 * @Version: [v1.0]
 */
public class PersonalJobListAdapter extends MyBaseAdapter<String> {

    public PersonalJobListAdapter(List<String> list, Context context) {
        super(list, context);
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null){
            viewHolder = new ViewHolder();

            convertView = inflater.inflate(R.layout.item_personal_job_list,null);

            viewHolder.mJobTitle = (TextView) convertView.findViewById(R.id.job_title);
            viewHolder.mSalaryRange = (TextView) convertView.findViewById(R.id.salary_range);
            viewHolder.mCompanyName = (TextView) convertView.findViewById(R.id.company_name);
            viewHolder.mPostTime = (TextView) convertView.findViewById(R.id.post_time);
            viewHolder.mRequireExperience = (TextView) convertView.findViewById(R.id.require_experience);
            viewHolder.mRequireEducational = (TextView) convertView.findViewById(R.id.require_educational);
            viewHolder.mCompanyAddress = (TextView) convertView.findViewById(R.id.company_address);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        return convertView;
    }

    class ViewHolder{
        TextView mJobTitle;
        TextView mSalaryRange;
        TextView mCompanyName;
        TextView mPostTime;
        TextView mRequireExperience;
        TextView mRequireEducational;
        TextView mCompanyAddress;
    }
}
