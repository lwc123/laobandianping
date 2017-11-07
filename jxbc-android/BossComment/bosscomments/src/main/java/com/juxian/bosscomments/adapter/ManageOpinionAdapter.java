package com.juxian.bosscomments.adapter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.listener.ClickLikedListener;
import com.juxian.bosscomments.models.OpinionEntity;
import com.juxian.bosscomments.ui.CompanyCircleWebViewActivity;
import com.juxian.bosscomments.ui.CompanyDetailActivity;
import com.juxian.bosscomments.widget.FlowLayout;
import com.juxian.bosscomments.widget.RoundAngleImageView;
import com.juxian.bosscomments.widget.TagFlowLayout;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import java.util.List;

import de.hdodenhof.circleimageview.CircleImageView;

/**
 * Created by nene on 2017/4/17.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/17 9:54]
 * @Version: [v1.0]
 */
public class ManageOpinionAdapter extends MyBaseAdapter<OpinionEntity> implements CompoundButton.OnCheckedChangeListener {

    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_PERSONAL_AVATAR_OPTIONS;
    private TextView mHideButton;

    public ManageOpinionAdapter(List<OpinionEntity> list, Context context,TextView mHideButton) {
        super(list, context);
        this.mHideButton = mHideButton;
    }

    public void setOpinionListDatas(List<OpinionEntity> list){
        this.list = list;
        notifyDataSetChanged();
    }

    @Override
    public View createView(final int position, View convertView, ViewGroup parent) {
        ViewHolder vh = null;
        if (convertView == null){
            vh = new ViewHolder();

            convertView = inflater.inflate(R.layout.item_manage_opinion,null);
            vh.mSelectOpinion = (CheckBox) convertView.findViewById(R.id.select_opinion);
            vh.mCompanyLogo = (CircleImageView) convertView.findViewById(R.id.profile_image);
            vh.mCompanyName = (TextView) convertView.findViewById(R.id.company_name);
            vh.mTagFlow = (TagFlowLayout) convertView.findViewById(R.id.tag_flow);
            vh.mCommentGrade = (TextView) convertView.findViewById(R.id.comment_grade);
            vh.mRatingBar = (RatingBar) convertView.findViewById(R.id.ratingBar);
            vh.mCommentTitle = (TextView) convertView.findViewById(R.id.comment_title);
            vh.mCommentContent = (TextView) convertView.findViewById(R.id.comment_content);
            vh.mEmployeeInformation = (TextView) convertView.findViewById(R.id.employee_information);
            vh.mReadCount = (TextView) convertView.findViewById(R.id.read_count);

            convertView.setTag(vh);
        } else {
            vh = (ViewHolder) convertView.getTag();
        }
        final OpinionEntity entity = list.get(position);
        vh.mSelectOpinion.setTag(position);
        vh.mSelectOpinion.setOnCheckedChangeListener(this);
        // 必须放置在监听器后面，否则在滑动过程中CheckBox的选中状态会丢失
        vh.mSelectOpinion.setChecked(entity.isSelectOpinion);

        ImageLoader.getInstance().displayImage(entity.Avatar, vh.mCompanyLogo, options, animateFirstListener);
        vh.mCompanyName.setText("匿名用户");
//        vh.mCompanyName.setText(entity.Company.CompanyName);
        TagAdapter<String> adapter;
        final TagFlowLayout mTagFlow = vh.mTagFlow;
        adapter = new TagAdapter<String>(entity.Labels) {
            @Override
            public View getView(FlowLayout parent, int position, String s) {
                TextView tv = (TextView) inflater.inflate(
                        R.layout.company_reputation_lable, mTagFlow, false);
                tv.setText(s);
                return tv;
            }
        };
        vh.mTagFlow.setAdapter(adapter);
        vh.mTagFlow.setTag(position);
        vh.mCommentGrade.setText(entity.Scoring+"分");
//        float commentGrade = entity.Scoring;
        vh.mRatingBar.setRating(entity.Scoring);
        if (!TextUtils.isEmpty(entity.Title)) {
            if (entity.Title.length() > 18) {
                String sTitle = entity.Title.substring(0, 18);
                vh.mCommentTitle.setText(sTitle);
            } else {
                vh.mCommentTitle.setText(entity.Title);
            }
        } else {
            vh.mCommentTitle.setText("");
        }
        if (entity.Content.length() > 200){
            vh.mCommentContent.setText(entity.Content.substring(0,200)+"...");
        } else {
            vh.mCommentContent.setText(entity.Content);
        }

        if (entity.WorkingYears<0){
            vh.mEmployeeInformation.setText("员工-"+Math.abs(entity.WorkingYears)+"年-"+entity.Region);
        } else {
            vh.mEmployeeInformation.setText("前员工-"+entity.WorkingYears+"年-"+entity.Region);
        }
        vh.mReadCount.setText("阅读"+entity.ReadCount);
        return convertView;
    }

    @Override
    public void onCheckedChanged(CompoundButton compoundButton, boolean isChecked) {
        int position = (Integer) compoundButton.getTag();
        list.get(position).isSelectOpinion = isChecked;
        int n=0;
        for (int i=0;i<list.size();i++){
            if (list.get(i).isSelectOpinion){
                n++;
            }
        }
        if (n>0) {
            mHideButton.setEnabled(true);
        } else {
            mHideButton.setEnabled(false);
        }
    }

    class ViewHolder{
        CheckBox mSelectOpinion;
        CircleImageView mCompanyLogo;
        TextView mCompanyName;
        TagFlowLayout mTagFlow;
        TextView mCommentGrade;
        RatingBar mRatingBar;
        TextView mCommentTitle;
        TextView mCommentContent;
        TextView mEmployeeInformation;
        TextView mReadCount;
    }
}
