package com.juxian.bosscomments.adapter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.util.Log;
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
import com.juxian.bosscomments.ui.CompanyDetailActivity;
import com.juxian.bosscomments.widget.FlowLayout;
import com.juxian.bosscomments.widget.RoundAngleImageView;
import com.juxian.bosscomments.widget.TagFlowLayout;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.util.List;

/**
 * Created by nene on 2017/4/17.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/17 9:54]
 * @Version: [v1.0]
 */
public class CompanyListAdapter extends MyBaseAdapter<OpinionEntity> {

    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_LOGO_OPTIONS;
    private ClickLikedListener listener;
    private String mTag;

    public CompanyListAdapter(List<OpinionEntity> list, Context context, ClickLikedListener listener,String tag) {
        super(list, context);
        this.listener = listener;
        this.mTag = tag;
    }

    public void setCompanyListDatas(List<OpinionEntity> list){
        this.list = list;
        notifyDataSetChanged();
    }

    @Override
    public View createView(final int position, View convertView, ViewGroup parent) {
        ViewHolder vh = null;
        if (convertView == null){
            vh = new ViewHolder();

            convertView = inflater.inflate(R.layout.item_company_circle,null);
            vh.mCompanyInformation = (RelativeLayout) convertView.findViewById(R.id.company_information);
            vh.mCompanyLogo = (RoundAngleImageView) convertView.findViewById(R.id.company_logo);
            vh.mCompanyName = (TextView) convertView.findViewById(R.id.company_name);
            vh.mCommentInformation = (RelativeLayout) convertView.findViewById(R.id.comment_information);
            vh.mTagFlow = (TagFlowLayout) convertView.findViewById(R.id.tag_flow);
            vh.mCommentGrade = (TextView) convertView.findViewById(R.id.comment_grade);
            vh.mRatingBar = (RatingBar) convertView.findViewById(R.id.ratingBar);
            vh.mCommentTitle = (TextView) convertView.findViewById(R.id.comment_title);
            vh.mCommentContent = (TextView) convertView.findViewById(R.id.comment_content);
            vh.mEmployeeInformation = (TextView) convertView.findViewById(R.id.employee_information);
            vh.mReadCount = (TextView) convertView.findViewById(R.id.read_count);
            vh.mClickLove = (ImageView) convertView.findViewById(R.id.click_love);
            vh.mClickNum = (TextView) convertView.findViewById(R.id.click_number);
            vh.mView = convertView.findViewById(R.id.view);

            convertView.setTag(vh);
        } else {
            vh = (ViewHolder) convertView.getTag();
        }
        final OpinionEntity entity = list.get(position);
        vh.mCompanyInformation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(context, CompanyDetailActivity.class);
                intent.putExtra("CompanyId",entity.CompanyId);
                ((Activity)context).startActivity(intent);
            }
        });
        ImageLoader.getInstance().displayImage(entity.Company.CompanyLogo, vh.mCompanyLogo, options, animateFirstListener);
        vh.mCompanyName.setText(entity.Company.CompanyName);
        vh.mCommentInformation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(context, CompanyCircleWebViewActivity.class);
                intent.putExtra("OpinionEntity", JsonUtil.ToJson(entity));
                intent.putExtra("WebViewType","OpinionDetail");
                intent.putExtra("OpinionId",entity.OpinionId);
                ((Activity)context).startActivity(intent);
            }
        });
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
            if (TextUtils.isEmpty(entity.Region)){
                vh.mEmployeeInformation.setText("前员工-" + entity.WorkingYears + "年");
            } else {
                vh.mEmployeeInformation.setText("前员工-" + entity.WorkingYears + "年-" + entity.Region);
            }
        }
        vh.mReadCount.setText("阅读"+entity.ReadCount);
        if (entity.IsLiked){
            // 点赞过的，可以取消，这个时候应该是显示不喜欢按钮
            vh.mClickLove.setImageResource(R.drawable.ic_unlike);
        } else {
            vh.mClickLove.setImageResource(R.drawable.ic_like);
        }
        final long OpinionId = entity.OpinionId;
        vh.mClickLove.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                listener.clickLiked(OpinionId,position);
            }
        });
        if (entity.LikedCount >= 1000){
            vh.mClickNum.setText("999+");
        } else {
            vh.mClickNum.setText(entity.LikedCount + "");
        }
        if ("Mine".equals(mTag)){
            vh.mView.setVisibility(View.GONE);
        } else {
            vh.mView.setVisibility(View.VISIBLE);
        }

        return convertView;
    }

    class ViewHolder{
        RelativeLayout mCompanyInformation;
        RoundAngleImageView mCompanyLogo;
        TextView mCompanyName;
        RelativeLayout mCommentInformation;
        TagFlowLayout mTagFlow;
        TextView mCommentGrade;
        RatingBar mRatingBar;
        TextView mCommentTitle;
        TextView mCommentContent;
        TextView mEmployeeInformation;
        TextView mReadCount;
        ImageView mClickLove;
        TextView mClickNum;
        View mView;
    }
}
