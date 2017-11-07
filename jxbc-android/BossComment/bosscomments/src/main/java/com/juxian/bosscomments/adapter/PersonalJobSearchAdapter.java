package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.JobEntity;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * Created by Tam on 2016/12/29.
 */
public class PersonalJobSearchAdapter extends MyBaseAdapter<JobEntity> {
    private SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
    private DecimalFormat df1 = new DecimalFormat("0.00");

    public PersonalJobSearchAdapter(List<JobEntity> list, Context context) {
        super(list, context);
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null) {
            viewHolder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_personal_job_search, null);
            viewHolder.position_name = (TextView) convertView.findViewById(R.id.personal_job_search_position_name);
            viewHolder.position_cp_name = (TextView) convertView.findViewById(R.id.personal_job_search_position_cp_name);
            viewHolder.position_time = (TextView) convertView.findViewById(R.id.personal_job_search_position_submit_time);
            viewHolder.position_experience = (TextView) convertView.findViewById(R.id.personal_job_search_position_experience);
            viewHolder.position_edu = (TextView) convertView.findViewById(R.id.personal_job_search_position_education);
            viewHolder.position_salary = (TextView) convertView.findViewById(R.id.personal_job_search_position_salary);
            viewHolder.position_address = (TextView) convertView.findViewById(R.id.personal_job_search_position_workaddress);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        JobEntity jobEntity = list.get(position);
        viewHolder.position_name.setText(jobEntity.JobName);
        viewHolder.position_cp_name.setText(jobEntity.Company.CompanyAbbr);
        viewHolder.position_time.setText(mSimpleDateFormat.format(jobEntity.ModifiedTime));
        if (!TextUtils.isEmpty(jobEntity.ExperienceRequireText)) {
            viewHolder.position_experience.setText(jobEntity.ExperienceRequireText);
        } else {
            viewHolder.position_experience.setText("");
        }
        if (!TextUtils.isEmpty(jobEntity.EducationRequireText)) {
            viewHolder.position_edu.setText(jobEntity.EducationRequireText);
        } else {
            viewHolder.position_edu.setText("");
        }
        if (!TextUtils.isEmpty(jobEntity.JobCityText)) {
            viewHolder.position_address.setText(jobEntity.JobCityText + jobEntity.JobLocation);
        } else {
            viewHolder.position_address.setText("" + jobEntity.JobLocation);
        }


        String str = df1.format(list.get(position).SalaryRangeMin / 1000);
        String[] SalaryMinArray = str.split("\\.");
        String SalaryMin = null;
        if ("00".equals(SalaryMinArray[1])) {
            SalaryMin = SalaryMinArray[0];
        } else {
            SalaryMin = str;
        }
        String str1 = df1.format(list.get(position).SalaryRangeMax / 1000);
        String[] SalaryMaxArray = str1.split("\\.");
        String SalaryMax = null;
        if ("00".equals(SalaryMaxArray[1])) {
            SalaryMax = SalaryMaxArray[0];
        } else {
            SalaryMax = str1;
        }
        viewHolder.position_salary.setText(SalaryMin + "k-" + SalaryMax + "k");
        return convertView;
    }

    class ViewHolder {
        TextView position_name;
        TextView position_cp_name;
        TextView position_time;
        TextView position_experience;
        TextView position_edu;
        TextView position_salary;
        TextView position_address;

    }
}
