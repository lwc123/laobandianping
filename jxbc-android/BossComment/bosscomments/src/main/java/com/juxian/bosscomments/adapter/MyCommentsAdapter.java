package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.models.MemberEntity;

import net.juxian.appgenome.utils.JsonUtil;

import java.text.SimpleDateFormat;
import java.util.List;

/**
 * Created by Tam on 2016/12/12.
 */
public class MyCommentsAdapter extends MyBaseAdapter<ArchiveCommentEntity> {

    private MemberEntity currentMemberEntity;
    private ViewHolder viewHolder;
    private static SimpleDateFormat sdfymdhms = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public MyCommentsAdapter(List<ArchiveCommentEntity> list, Context applicationContext) {
        super(list, applicationContext);
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        viewHolder = null;
        if (convertView == null) {
            viewHolder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_mycomment, null);
            viewHolder.name = (TextView) convertView.findViewById(R.id.item_mycomment_auditor_employee_name_real);
            viewHolder.workState = (TextView) convertView.findViewById(R.id.item_mycomment_auditor_employee_workState);
            viewHolder.time = (TextView) convertView.findViewById(R.id.item_mycomment_auditor_employee_time);
//            viewHolder.timeAndComment = (View) convertView.findViewById(R.id.item_mycomment_auditor_employee_time_comment);
            viewHolder.line = (View) convertView.findViewById(R.id.line);

            viewHolder.submitTime = (TextView) convertView.findViewById(R.id.item_mycomment_auditor_employee_submittedTime);
            viewHolder.auditState = (TextView) convertView.findViewById(R.id.item_mycomment_auditor_audited_stated);
            viewHolder.seeAuditLogger = (TextView) convertView.findViewById(R.id.item_mycomment_auditor_employee_check);
            viewHolder.reason = (TextView) convertView.findViewById(R.id.item_mycomment_auditor_employee_reason);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }

        ArchiveCommentEntity archiveCommentEntity = list.get(position); //列表中的实体
        currentMemberEntity = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);//自己的信息
        //如果是提交人
        if (archiveCommentEntity.PresenterId == currentMemberEntity.PassportId) {    //条目是我提交的

            if (archiveCommentEntity.AuditStatus == 1) { //审核中
                viewHolder.auditState.setText("审核中");
                viewHolder.auditState.setTextColor(context.getResources().getColor(R.color.menu_color));
                viewHolder.seeAuditLogger.setText("查看");
                viewHolder.seeAuditLogger.setTextColor(context.getResources().getColor(R.color.luxury_gold_color));
                viewHolder.reason.setVisibility(View.GONE);
                viewHolder.line.setVisibility(View.GONE);
            } else if (archiveCommentEntity.AuditStatus == 2) { //审核通过
                viewHolder.auditState.setText("审核通过");
                viewHolder.seeAuditLogger.setText("查看");
                viewHolder.seeAuditLogger.setTextColor(context.getResources().getColor(R.color.luxury_gold_color));
                viewHolder.auditState.setTextColor(context.getResources().getColor(R.color.menu_color));
                viewHolder.line.setVisibility(View.GONE);
                viewHolder.reason.setVisibility(View.GONE);
            } else if (archiveCommentEntity.AuditStatus == 9) { //未通过
                viewHolder.auditState.setText("审核未通过");
                viewHolder.seeAuditLogger.setText("重新提交");
                viewHolder.seeAuditLogger.setTextColor(context.getResources().getColor(R.color.luxury_gold_color));
                viewHolder.auditState.setTextColor(context.getResources().getColor(R.color.juxian_red));
                if (archiveCommentEntity.RejectReason == null) {
                    viewHolder.reason.setText("未通过原因：" + archiveCommentEntity.RejectReason);
                } else {
                    viewHolder.reason.setText("未通过原因：" + archiveCommentEntity.RejectReason + "(" + archiveCommentEntity.OperateRealName + ")");
                }

                viewHolder.line.setVisibility(View.VISIBLE);
                viewHolder.reason.setVisibility(View.VISIBLE);
            }
        } else {
            //审核人
            if (archiveCommentEntity.AuditStatus == 1) { //需要审核
                viewHolder.auditState.setText("待我审核");
                viewHolder.seeAuditLogger.setText("去审核");
                viewHolder.seeAuditLogger.setTextColor(context.getResources().getColor(R.color.luxury_gold_color));
                viewHolder.auditState.setTextColor(context.getResources().getColor(R.color.menu_color));
                viewHolder.line.setVisibility(View.GONE);
                viewHolder.reason.setVisibility(View.GONE);
            } else if (archiveCommentEntity.AuditStatus == 2) { //审核通过
                viewHolder.auditState.setText("审核通过");
                viewHolder.seeAuditLogger.setText("查看");
                viewHolder.seeAuditLogger.setTextColor(context.getResources().getColor(R.color.luxury_gold_color));
                viewHolder.auditState.setTextColor(context.getResources().getColor(R.color.menu_color));
                viewHolder.line.setVisibility(View.GONE);
                viewHolder.reason.setVisibility(View.GONE);
            } else if (archiveCommentEntity.AuditStatus == 9) { //未通过
                viewHolder.auditState.setText("审核未通过");
                viewHolder.seeAuditLogger.setText("查看");
                viewHolder.auditState.setTextColor(context.getResources().getColor(R.color.juxian_red));
                viewHolder.seeAuditLogger.setTextColor(context.getResources().getColor(R.color.luxury_gold_color));
                viewHolder.line.setVisibility(View.VISIBLE);
                if (TextUtils.isEmpty(archiveCommentEntity.OperateRealName)) {
                    viewHolder.reason.setText("未通过原因：" + archiveCommentEntity.RejectReason);
                } else {
                    viewHolder.reason.setText("未通过原因：" + archiveCommentEntity.RejectReason + "(" + archiveCommentEntity.OperateRealName + ")");
                }
                viewHolder.reason.setVisibility(View.VISIBLE);
            }
        }

        //离任
        if (archiveCommentEntity.EmployeArchive.IsDimission == 1) {
            viewHolder.workState.setText("离任");
            if (archiveCommentEntity.CommentType == 1) {//离任报告
                viewHolder.time.setText("离任报告");
            } else { //工作评价
                viewHolder.time.setText(archiveCommentEntity.StageYear + archiveCommentEntity.StageSection + "工作评价");
            }

        } else {
            viewHolder.workState.setText("在职");
//            viewHolder.timeAndComment.setVisibility(View.VISIBLE);
            viewHolder.time.setText(archiveCommentEntity.StageYear + archiveCommentEntity.StageSection + "工作评价");
        }
        viewHolder.name.setText(archiveCommentEntity.EmployeArchive.RealName);
        viewHolder.submitTime.setText(sdfymdhms.format(archiveCommentEntity.CreatedTime));
        viewHolder.seeAuditLogger.setTag(position);
//        viewHolder.seeAuditLogger.setOnClickListener(this);
        return convertView;
    }

//    @Override
//    public void onClick(View view) {
//        int position = (int) view.getTag();
//        ArchiveCommentEntity archiveCommentEntity = list.get(position);
//
//        //如果是提交人
//        if (archiveCommentEntity.PresenterId == currentMemberEntity.PassportId) {
//            if (archiveCommentEntity.AuditStatus == 1 || archiveCommentEntity.AuditStatus == 2) { //审核中,通过
//                Log.e(Global.LOG_TAG, "onClick: " + "我是提交人---》审核中和通过");
//                Intent intent = new Intent(context, AuditWebViewActivity.class);
//                if (archiveCommentEntity.CommentType == 1) { //是离任报告
//                    intent.putExtra("CommentType", "leaving_report");
//
//                } else { //工作评价
//                    intent.putExtra("CommentType", "audit");
//
//                }
//                intent.putExtra("BizId", list.get(position).CommentId);
//                ((Activity) context).startActivity(intent);
//
//            } else if (archiveCommentEntity.AuditStatus == 9) { //未通过
//                Log.e(Global.LOG_TAG, "onClick: " + "我是提交人---》审核未通过");
//
//                // 跳转到重新提交页面
//                if (archiveCommentEntity.CommentType == 0) {
//                    Intent Change = new Intent(context, AddBossCommentActivity.class);
//                    Change.putExtra("Tag", "Have");
//                    Change.putExtra("Operation", "Change");
//                    Change.putExtra("CommentId", archiveCommentEntity.CommentId);
//                    ((Activity) context).startActivity(Change);
//                } else {
//                    Intent Change = new Intent(context, AddDepartureReportActivity.class);
//                    Change.putExtra("Tag", "Have");
//                    Change.putExtra("Operation", "Change");
//                    Change.putExtra("CommentId", archiveCommentEntity.CommentId);
//                    ((Activity) context).startActivity(Change);
//                }
//            }
//        } else {
//            //审核人
//            Intent intent = new Intent(context, AuditWebViewActivity.class);
//            if (archiveCommentEntity.CommentType == 1) { //是离任报告
//                intent.putExtra("CommentType", "leaving_report");
//            } else { //工作评价
//                intent.putExtra("CommentType", "audit");
//            }
//            intent.putExtra("BizId", list.get(position).CommentId);
//            ((Activity) context).startActivity(intent);
//        }
//
//    }

    class ViewHolder {
        TextView name;
        TextView workState;
        TextView time;
        TextView submitTime;
        TextView auditState;
        TextView seeAuditLogger;
        TextView reason;
        View timeAndComment;
        View line;
    }
}
