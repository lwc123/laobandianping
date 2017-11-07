package com.juxian.bosscomments.adapter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.listener.ClickLikedListener;
import com.juxian.bosscomments.models.OpinionEntity;
import com.juxian.bosscomments.ui.CompanyCircleWebViewActivity;
import com.juxian.bosscomments.widget.FlowLayout;
import com.juxian.bosscomments.widget.TagFlowLayout;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.utils.JsonUtil;

import java.util.List;

import de.hdodenhof.circleimageview.CircleImageView;

/**
 * Created by nene on 2017/4/19.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/19 13:27]
 * @Version: [v1.0]
 */
public class CompanyDetailAdapter extends MyBaseAdapter<OpinionEntity> {

    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_PERSONAL_AVATAR_OPTIONS;
    private ClickLikedListener listener;
    private String mFromResource;

    public CompanyDetailAdapter(List<OpinionEntity> list, Context context, ClickLikedListener listener,String mFromResource) {
        super(list, context);
        this.listener = listener;
        this.mFromResource = mFromResource;
    }

    public void setCompanyDetailDatas(List<OpinionEntity> list){
        this.list = list;
        notifyDataSetChanged();
    }

    @Override
    public View createView(final int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null){
            viewHolder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_company_detail,null);

            viewHolder.mProfileAvatar = (CircleImageView) convertView.findViewById(R.id.profile_image);
            viewHolder.mUserInformation = (RelativeLayout) convertView.findViewById(R.id.company_information);
            viewHolder.mCommentInformation = (RelativeLayout) convertView.findViewById(R.id.comment_information);
            viewHolder.mNickName = (TextView) convertView.findViewById(R.id.company_name);
            viewHolder.mCommentGrade = (TextView) convertView.findViewById(R.id.comment_grade);
            viewHolder.mRatingBar = (RatingBar) convertView.findViewById(R.id.ratingBar);
            viewHolder.mTagFlow = (TagFlowLayout) convertView.findViewById(R.id.tag_flow);
            viewHolder.mCommentTitle = (TextView) convertView.findViewById(R.id.comment_title);
            viewHolder.mCommentContent = (TextView) convertView.findViewById(R.id.comment_content);
            viewHolder.mEmployeeInformation = (TextView) convertView.findViewById(R.id.employee_information);
            viewHolder.mReadCount = (TextView) convertView.findViewById(R.id.read_count);
            viewHolder.mClickLove = (ImageView) convertView.findViewById(R.id.click_love);
            viewHolder.mLikedNumber = (TextView) convertView.findViewById(R.id.click_number);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        OpinionEntity entity = list.get(position);
        ImageLoader.getInstance().displayImage(entity.Avatar,viewHolder.mProfileAvatar,options,animateFirstListener);
//        final long OpinionId = entity.OpinionId;
        final OpinionEntity opinionEntity = entity;
        viewHolder.mUserInformation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(context, CompanyCircleWebViewActivity.class);
                if (!TextUtils.isEmpty(mFromResource)){
                    intent.putExtra("FromResource",mFromResource);
                }
                intent.putExtra("OpinionEntity", JsonUtil.ToJson(opinionEntity));
                intent.putExtra("WebViewType","OpinionDetail");
                intent.putExtra("OpinionId",opinionEntity.OpinionId);
                ((Activity)context).startActivity(intent);
            }
        });
        viewHolder.mCommentInformation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(context, CompanyCircleWebViewActivity.class);
                if (!TextUtils.isEmpty(mFromResource)){
                    intent.putExtra("FromResource",mFromResource);
                }
                intent.putExtra("OpinionEntity", JsonUtil.ToJson(opinionEntity));
                intent.putExtra("WebViewType","OpinionDetail");
                intent.putExtra("OpinionId",opinionEntity.OpinionId);
                ((Activity)context).startActivity(intent);
            }
        });
        viewHolder.mNickName.setText("匿名用户");
        viewHolder.mCommentGrade.setText(entity.Scoring+"分");
        viewHolder.mRatingBar.setRating(entity.Scoring);

        TagAdapter<String> adapter;
        final TagFlowLayout mTagFlow = viewHolder.mTagFlow;
        adapter = new TagAdapter<String>(entity.Labels) {
            @Override
            public View getView(FlowLayout parent, int position, String s) {
                TextView tv = (TextView) inflater.inflate(
                        R.layout.company_reputation_lable, mTagFlow, false);
                tv.setText(s);
                return tv;
            }
        };
        viewHolder.mTagFlow.setAdapter(adapter);
        viewHolder.mTagFlow.setTag(position);

        viewHolder.mCommentTitle.setText(entity.Title);
        viewHolder.mCommentContent.setText(entity.Content);
        if (entity.WorkingYears<0){
            viewHolder.mEmployeeInformation.setText("员工-"+Math.abs(entity.WorkingYears)+"年-"+entity.Region);
        } else {
            viewHolder.mEmployeeInformation.setText("前员工-"+entity.WorkingYears+"年-"+entity.Region);
        }

        if (entity.ReadCount >99999){
            viewHolder.mReadCount.setText("阅读 99999+");
        } else {
            viewHolder.mReadCount.setText("阅读 " + entity.ReadCount);
        }
        if (entity.IsLiked) {
            viewHolder.mClickLove.setImageResource(R.drawable.ic_unlike);
        } else {
            viewHolder.mClickLove.setImageResource(R.drawable.ic_like);
        }
        viewHolder.mClickLove.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                listener.clickLiked(opinionEntity.OpinionId,position);
            }
        });
        if (entity.LikedCount == 0){
            viewHolder.mLikedNumber.setVisibility(View.INVISIBLE);
        } else {
            if (entity.LikedCount > 999){
                viewHolder.mLikedNumber.setText("999+");
            } else {
                viewHolder.mLikedNumber.setText(entity.LikedCount+"");
            }
            viewHolder.mLikedNumber.setVisibility(View.VISIBLE);
        }

        return convertView;
    }

    class ViewHolder{
        CircleImageView mProfileAvatar;
        RelativeLayout mUserInformation;
        RelativeLayout mCommentInformation;
        TextView mNickName;
        TextView mCommentGrade;
        RatingBar mRatingBar;
        TagFlowLayout mTagFlow;
        TextView mCommentTitle;
        TextView mCommentContent;
        TextView mEmployeeInformation;
        TextView mReadCount;
        ImageView mClickLove;
        TextView mLikedNumber;
    }
}
