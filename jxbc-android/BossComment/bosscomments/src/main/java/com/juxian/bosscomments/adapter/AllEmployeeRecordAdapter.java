package com.juxian.bosscomments.adapter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.DepartmentGroupEntity;
import com.juxian.bosscomments.models.EmployeArchiveEntity;
import com.juxian.bosscomments.ui.WebViewDetailActivity;
import com.juxian.bosscomments.widget.RoundAngleImageView;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.text.SimpleDateFormat;
import java.util.List;

import de.hdodenhof.circleimageview.CircleImageView;

/**
 * Created by nene on 2016/11/26.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/26 13:52]
 * @Version: [v1.0]
 */
public class AllEmployeeRecordAdapter extends MyBaseAdapter<DepartmentGroupEntity> {

    private String Tag;
    private String Type;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_EMPLOYEE_AVATAR_OPTIONS;
    private static SimpleDateFormat sdfymdhms = new SimpleDateFormat("yyyy年MM月");

    public AllEmployeeRecordAdapter(List<DepartmentGroupEntity> list, Context context, String Tag, String Type) {
        super(list, context);
        this.Tag = Tag;
        this.Type = Type;
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null) {
            viewHolder = new ViewHolder();

            convertView = inflater.inflate(R.layout.item_all_employee_record, null);

            viewHolder.mCompanyDepartment = (RelativeLayout) convertView.findViewById(R.id.company_department);
            viewHolder.mEmployeeList = (LinearLayout) convertView.findViewById(R.id.listView);
            viewHolder.mDepartment = (TextView) convertView.findViewById(R.id.department);
            viewHolder.mPeopleNumber = (TextView) convertView.findViewById(R.id.number_of_people);
            viewHolder.mWhiteItem = convertView.findViewById(R.id.white_item);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        DepartmentGroupEntity entity = list.get(position);
//        viewHolder.mEmployeeList.setAdapter(new SearchEmployeeAdapter(entity.employeArchiveEntities,context,Tag));
        viewHolder.mEmployeeList.removeAllViews();
        for (int i = 0; i < entity.employeArchiveEntities.size(); i++) {
            View childView = LayoutInflater.from(context).inflate(R.layout.item_search_employee, null);
            CircleImageView mEmployeeAvatar = (CircleImageView) childView.findViewById(R.id.activity_employee_photo);
            TextView mEmployeeName = (TextView) childView.findViewById(R.id.employee_name);
            TextView mEmployeePosition = (TextView) childView.findViewById(R.id.employee_position);
            TextView mEmployeeEntryTime = (TextView) childView.findViewById(R.id.employee_entry_time);
            TextView mEvaluateNumber = (TextView) childView.findViewById(R.id.evaluate_number);

            ImageLoader.getInstance().displayImage(entity.employeArchiveEntities.get(i).Picture, mEmployeeAvatar, options, animateFirstListener);
            mEmployeeName.setText(entity.employeArchiveEntities.get(i).RealName);
            if (entity.employeArchiveEntities.get(i).WorkItem != null) {
                if (!TextUtils.isEmpty(entity.employeArchiveEntities.get(i).WorkItem.Department)) {
                    mEmployeePosition.setText(entity.employeArchiveEntities.get(i).WorkItem.PostTitle);
                } else {
                    mEmployeePosition.setText("");
                }
            } else {
                mEmployeePosition.setText("");
            }
            if (entity.employeArchiveEntities.get(i).IsDimission == 0) {
                mEmployeeEntryTime.setText(sdfymdhms.format(entity.employeArchiveEntities.get(i).EntryTime) + "加入公司");
            } else {
                mEmployeeEntryTime.setText(sdfymdhms.format(entity.employeArchiveEntities.get(i).EntryTime) + "加入公司，" + sdfymdhms.format(entity.employeArchiveEntities.get(i).DimissionTime) + "离任");
            }
            if (entity.employeArchiveEntities.get(i).CommentsNum > 0) {
                mEvaluateNumber.setText("已评价(" + entity.employeArchiveEntities.get(i).CommentsNum + ")条");
            } else {
                mEvaluateNumber.setText("未评价");
                mEvaluateNumber.setTextColor(context.getResources().getColor(R.color.juxian_red));
            }

            final EmployeArchiveEntity entity1 = entity.employeArchiveEntities.get(i);
            childView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if ("SelectArchive".equals(Tag)) {
                        if ("DeportReport".equals(Type) && entity1.DepartureReportNum > 0) {
                            ToastUtil.showInfo("该员工已有离任报告");
                        } else {
                            Intent intent = new Intent();
                            intent.putExtra("ArchiveInformation", JsonUtil.ToJson(entity1));
                            ((Activity) context).setResult(((Activity) context).RESULT_OK, intent);
                            ((Activity) context).finish();
                        }
                    } else {
                        Intent GoArchiveDetail = new Intent(context, WebViewDetailActivity.class);
                        GoArchiveDetail.putExtra("DetailType", "Archive");
                        GoArchiveDetail.putExtra("CommentsNum", entity1.CommentsNum);
                        GoArchiveDetail.putExtra("ArchiveId", entity1.ArchiveId);
                        ((Activity) context).startActivity(GoArchiveDetail);
                    }
                }
            });
            viewHolder.mEmployeeList.addView(childView);
            if (i < entity.employeArchiveEntities.size()) {
                View lineView = LayoutInflater.from(context).inflate(R.layout.include_line, null);
                viewHolder.mEmployeeList.addView(lineView);
            }
        }
        viewHolder.mDepartment.setText(entity.departmentEntity.DeptName);
        viewHolder.mPeopleNumber.setText(entity.departmentEntity.StaffNumber + "人");
        return convertView;
    }

    class ViewHolder {
        RelativeLayout mCompanyDepartment;
        LinearLayout mEmployeeList;
        TextView mDepartment;
        TextView mPeopleNumber;
        View mWhiteItem;
    }
}
