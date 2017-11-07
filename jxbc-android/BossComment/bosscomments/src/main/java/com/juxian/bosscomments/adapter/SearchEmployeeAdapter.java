package com.juxian.bosscomments.adapter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.EmployeArchiveEntity;
import com.juxian.bosscomments.models.EmployeeRecordEntity;
import com.juxian.bosscomments.ui.WebViewDetailActivity;
import com.juxian.bosscomments.widget.RoundAngleImageView;
import com.juxian.bosscomments.widget.RoundImageView;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.text.SimpleDateFormat;
import java.util.List;

import de.hdodenhof.circleimageview.CircleImageView;

/**
 * Created by nene on 2016/11/28.
 * 档案列表（子adapter）
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/28 14:34]
 * @Version: [v1.0]
 */
public class SearchEmployeeAdapter extends MyBaseAdapter<EmployeArchiveEntity> {

    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_AVATAR_OPTIONS;
    private static SimpleDateFormat sdfymdhms = new SimpleDateFormat("yyyy年MM月");
    private String Tag;
    private String Type;

    public SearchEmployeeAdapter(List<EmployeArchiveEntity> list, Context context,String Tag,String Type) {
        super(list, context);
        this.Tag = Tag;
        this.Type = Type;
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {

        ViewHolder viewHolder = null;
        if (convertView == null){
            viewHolder = new ViewHolder();

            convertView = inflater.inflate(R.layout.item_search_employee,null);
            viewHolder.mEmployeeItem = (RelativeLayout) convertView.findViewById(R.id.employee_record_item);
            viewHolder.mEmployeeAvatar = (CircleImageView) convertView.findViewById(R.id.activity_employee_photo);
            viewHolder.mEmployeeName = (TextView) convertView.findViewById(R.id.employee_name);
            viewHolder.mEmployeePosition = (TextView) convertView.findViewById(R.id.employee_position);
            viewHolder.mEmployeeEntryTime = (TextView) convertView.findViewById(R.id.employee_entry_time);
            viewHolder.mEvaluateNumber = (TextView) convertView.findViewById(R.id.evaluate_number);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        EmployeArchiveEntity entity = list.get(position);
        ImageLoader.getInstance().displayImage(entity.Picture,viewHolder.mEmployeeAvatar,options,animateFirstListener);
        viewHolder.mEmployeeName.setText(entity.RealName);
        if (entity.WorkItem!=null) {
            if (!TextUtils.isEmpty(entity.WorkItem.Department)) {
                viewHolder.mEmployeePosition.setText(entity.WorkItem.Department);
            } else {
                viewHolder.mEmployeePosition.setText("");
            }
        } else {
            viewHolder.mEmployeePosition.setText("");
        }
        if (entity.IsDimission == 0){
            viewHolder.mEmployeeEntryTime.setText(sdfymdhms.format(entity.EntryTime)+"加入公司");
        } else {
            viewHolder.mEmployeeEntryTime.setText(sdfymdhms.format(entity.EntryTime)+"加入公司，"+sdfymdhms.format(entity.DimissionTime)+"离任");
        }
        viewHolder.mEvaluateNumber.setText("已评价（"+entity.CommentsNum+"）条");
        viewHolder.mEmployeeItem.setTag(position);
        final EmployeArchiveEntity entity1 = entity;
        viewHolder.mEmployeeItem.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if ("SelectArchive".equals(Tag)){
                    Intent intent = new Intent();
                    intent.putExtra("ArchiveInformation", JsonUtil.ToJson(entity1));
                    ((Activity)context).setResult(((Activity)context).RESULT_OK,intent);
                    ((Activity)context).finish();
                } else if ("ReturnArchive".equals(Tag)){
                    if ("DeportReport".equals(Type)&&entity1.DepartureReportNum>0){
                        ToastUtil.showInfo("该员工已有离任报告");
                    } else {
                        Intent intent = new Intent("AllEmployeeRecordActivity");
                        intent.putExtra("ArchiveInformation", JsonUtil.ToJson(entity1));
                        ((Activity) context).sendBroadcast(intent);
                        ((Activity) context).finish();
                    }
                } else {
                    Intent GoArchiveDetail = new Intent(context, WebViewDetailActivity.class);
                    GoArchiveDetail.putExtra("DetailType","Archive");
                    GoArchiveDetail.putExtra("ArchiveId",entity1.ArchiveId);
                    ((Activity)context).startActivity(GoArchiveDetail);
                }
            }
        });
        return convertView;
    }

    class ViewHolder{
        RelativeLayout mEmployeeItem;
        CircleImageView mEmployeeAvatar;
        TextView mEmployeeName;
        TextView mEmployeePosition;
        TextView mEmployeeEntryTime;
        TextView mEvaluateNumber;
    }
}
