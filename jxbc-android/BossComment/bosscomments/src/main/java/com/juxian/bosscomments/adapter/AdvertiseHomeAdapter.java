package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.JobEntity;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * Created by Tam on 2016/12/19.
 */
public class AdvertiseHomeAdapter extends MyBaseAdapter<JobEntity> {

    private static SimpleDateFormat sdfymdhms = new SimpleDateFormat("yyyy-MM-dd");
    private DecimalFormat df1 = new DecimalFormat("0.00");

    public AdvertiseHomeAdapter(List<JobEntity> list, Context context) {
        super(list, context);
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null) {
            viewHolder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_activity_advertise_home, null);
            viewHolder.position = (TextView) convertView.findViewById(R.id.advertise_home_position);
            viewHolder.issue = (TextView) convertView.findViewById(R.id.advertise_home_issue);
            viewHolder.real_time = (TextView) convertView.findViewById(R.id.advertise_home_post_real_time);
            viewHolder.salary = (TextView) convertView.findViewById(R.id.advertise_home_salary);
            viewHolder.positionStatus = (TextView) convertView.findViewById(R.id.position_status);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        JobEntity entity = list.get(position);
        viewHolder.position.setText(entity.JobName);
        if (TextUtils.isEmpty(entity.CompanyMember.RealName)){
            viewHolder.issue.setText("");
        } else {
            viewHolder.issue.setText("由"+entity.CompanyMember.RealName+"发布");
        }
        String str = df1.format(entity.SalaryRangeMin/1000);
        String[] SalaryMinArray = str.split("\\.");
        String SalaryMin = null;
        if ("00".equals(SalaryMinArray[1])){
            SalaryMin = SalaryMinArray[0];
        } else {
            SalaryMin = str;
        }
        String str1 = df1.format(entity.SalaryRangeMax/1000);
        String[] SalaryMaxArray = str1.split("\\.");
        String SalaryMax = null;
        if ("00".equals(SalaryMaxArray[1])){
            SalaryMax = SalaryMaxArray[0];
        } else {
            SalaryMax = str1;
        }
        viewHolder.salary.setText(SalaryMin+"k-"+SalaryMax+"k");
        if (entity.DisplayState == 0){
            viewHolder.positionStatus.setVisibility(View.GONE);
        } else {
            viewHolder.positionStatus.setVisibility(View.VISIBLE);
        }
        viewHolder.real_time.setText("发布于"+sdfymdhms.format(entity.ModifiedTime));
        return convertView;
    }

    class ViewHolder {

        TextView position;
        TextView issue;
        TextView real_time;
        TextView salary;
        TextView positionStatus;
    }
}
