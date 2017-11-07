package com.juxian.bosscomments.adapter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.models.EmployeArchiveEntity;
import com.juxian.bosscomments.ui.WebViewDetailActivity;
import com.juxian.bosscomments.widget.RoundAngleImageView;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.utils.JsonUtil;

import java.text.SimpleDateFormat;
import java.util.List;

import de.hdodenhof.circleimageview.CircleImageView;

/**
 * Created by nene on 2016/11/28.
 * 阶段评价列表、离任报告列表adapter
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/28 14:34]
 * @Version: [v1.0]
 */
public class ArchiveCommentListAdapter extends MyBaseAdapter<ArchiveCommentEntity> {

    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_EMPLOYEE_AVATAR_OPTIONS;
    private static SimpleDateFormat sdfymdhms = new SimpleDateFormat("yyyy年MM月");
    private int mTag;

    public ArchiveCommentListAdapter(List<ArchiveCommentEntity> list, Context context,int mTag) {
        super(list, context);
        this.mTag = mTag;
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {

        ViewHolder viewHolder = null;
        if (convertView == null){
            viewHolder = new ViewHolder();

            convertView = inflater.inflate(R.layout.item_search_cr_result,null);
            viewHolder.mEmployeeItem = (RelativeLayout) convertView.findViewById(R.id.employee_record_item);
            viewHolder.mEmployeeAvatar = (CircleImageView) convertView.findViewById(R.id.activity_employee_photo);
            viewHolder.mEmployeeName = (TextView) convertView.findViewById(R.id.employee_name);
            viewHolder.mEmployeePosition = (TextView) convertView.findViewById(R.id.employee_position);
            viewHolder.mEvaluateNumber = (TextView) convertView.findViewById(R.id.evaluate_number);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        ArchiveCommentEntity entity = list.get(position);
        ImageLoader.getInstance().displayImage(entity.EmployeArchive.Picture,viewHolder.mEmployeeAvatar,options,animateFirstListener);
        viewHolder.mEmployeeName.setText(entity.EmployeArchive.RealName);
        if (entity.EmployeArchive.WorkItem != null) {
            viewHolder.mEmployeePosition.setText(entity.EmployeArchive.WorkItem.PostTitle);
        } else {
            viewHolder.mEmployeePosition.setText("");
        }
        if (mTag == 0) {
            viewHolder.mEvaluateNumber.setText(entity.StageYear + " " + entity.StageSectionText + " " + "评价");
        } else {
            viewHolder.mEvaluateNumber.setText("离任报告");
        }
        return convertView;
    }

    class ViewHolder{
        RelativeLayout mEmployeeItem;
        CircleImageView mEmployeeAvatar;
        TextView mEmployeeName;
        TextView mEmployeePosition;
        TextView mEvaluateNumber;
    }
}
