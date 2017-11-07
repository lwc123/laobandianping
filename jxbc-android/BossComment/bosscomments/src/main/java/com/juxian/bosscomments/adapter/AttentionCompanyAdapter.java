package com.juxian.bosscomments.adapter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.CCompanyEntity;
import com.juxian.bosscomments.models.ConsoleEntity;
import com.juxian.bosscomments.ui.CompanyDetailActivity;
import com.juxian.bosscomments.widget.FlowLayout;
import com.juxian.bosscomments.widget.RoundAngleImageView;
import com.juxian.bosscomments.widget.TagFlowLayout;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.utils.JsonUtil;

import java.util.List;

/**
 * Created by nene on 2017/4/17.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/17 17:55]
 * @Version: [v1.0]
 */
public class AttentionCompanyAdapter extends MyBaseAdapter<CCompanyEntity> {

    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_LOGO_OPTIONS;
    private int ConcernedTotal;

    public AttentionCompanyAdapter(List<CCompanyEntity> list, Context context) {
        super(list, context);
    }

    public void setAttentionCompanyData(List<CCompanyEntity> list,int ConcernedTotal){
        this.list = list;
        this.ConcernedTotal = ConcernedTotal;
        notifyDataSetChanged();
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null){
            viewHolder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_attention_company,null);

            viewHolder.mAttentionCause = (TextView) convertView.findViewById(R.id.attention_cause);
            viewHolder.mCompanyInformation = (RelativeLayout) convertView.findViewById(R.id.company_information);
            viewHolder.mCompanyLogo = (RoundAngleImageView) convertView.findViewById(R.id.company_logo);
            viewHolder.mCompanyName = (TextView) convertView.findViewById(R.id.company_name);
            viewHolder.mRatingBar = (RatingBar) convertView.findViewById(R.id.ratingBar);
            viewHolder.mNewAttention = (ImageView) convertView.findViewById(R.id.msg);
            viewHolder.mTagFlow = (TagFlowLayout) convertView.findViewById(R.id.tag_flow);
            viewHolder.mBasicInformation = (TextView) convertView.findViewById(R.id.basic_information);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        CCompanyEntity entity = list.get(position);
        if (position == 0) {
            viewHolder.mAttentionCause.setVisibility(View.VISIBLE);
        } else {
            if (entity.IsFormerClub == list.get(position-1).IsFormerClub){
                viewHolder.mAttentionCause.setVisibility(View.GONE);
            } else {
                viewHolder.mAttentionCause.setVisibility(View.VISIBLE);
            }
        }
        if (entity.IsFormerClub){
            viewHolder.mAttentionCause.setText("老东家");
        } else {
//            ConsoleEntity consoleEntity = JsonUtil.ToEntity(AppConfig.getConsoleIndex(),ConsoleEntity.class);
            viewHolder.mAttentionCause.setText("共有关注"+ ConcernedTotal + "家");
        }
        final long CompanyId = entity.CompanyId;
        viewHolder.mCompanyInformation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(context, CompanyDetailActivity.class);
                intent.putExtra("CompanyId",CompanyId);
                ((Activity)context).startActivity(intent);
            }
        });
        ImageLoader.getInstance().displayImage(entity.CompanyLogo, viewHolder.mCompanyLogo, options, animateFirstListener);
        viewHolder.mCompanyName.setText(entity.CompanyName);
        viewHolder.mRatingBar.setRating((float) entity.Score);
//        if (entity.)
        viewHolder.mNewAttention.setVisibility(View.GONE);
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
        viewHolder.mBasicInformation.setText("总阅读"+entity.ReadCount+"   共"+entity.CommentCount+"条点评   来自"+entity.StaffCount+"位员工");
        if (entity.IsRedDot){
            viewHolder.mNewAttention.setVisibility(View.VISIBLE);
        } else {
            viewHolder.mNewAttention.setVisibility(View.GONE);
        }
        return convertView;
    }

    class ViewHolder{
        TextView mAttentionCause;
        RelativeLayout mCompanyInformation;
        RoundAngleImageView mCompanyLogo;
        TextView mCompanyName;
        RatingBar mRatingBar;
        ImageView mNewAttention;
        TagFlowLayout mTagFlow;
        TextView mBasicInformation;
    }
}
