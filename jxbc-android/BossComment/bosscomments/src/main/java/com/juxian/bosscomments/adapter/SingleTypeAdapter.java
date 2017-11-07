package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RatingBar;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.CCompanyEntity;
import com.juxian.bosscomments.widget.FlowLayout;
import com.juxian.bosscomments.widget.RoundAngleImageView;
import com.juxian.bosscomments.widget.TagFlowLayout;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import java.util.List;

/**
 * Created by nene on 2017/4/20.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/20 13:42]
 * @Version: [v1.0]
 */
public class SingleTypeAdapter extends MyBaseAdapter<CCompanyEntity> {

    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_LOGO_OPTIONS;

    public SingleTypeAdapter(List<CCompanyEntity> list, Context context) {
        super(list, context);
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null){
            viewHolder = new ViewHolder();

            convertView = inflater.inflate(R.layout.item_company_single,null);

            viewHolder.mCompanyLogo = (RoundAngleImageView) convertView.findViewById(R.id.company_logo);
            viewHolder.mCompanyName = (TextView) convertView.findViewById(R.id.company_name);
            viewHolder.mRatingBar = (RatingBar) convertView.findViewById(R.id.ratingBar);
            viewHolder.mCompanyIndustry = (TextView) convertView.findViewById(R.id.company_industry);
            viewHolder.mCompanyAddress = (TextView) convertView.findViewById(R.id.company_address);
            viewHolder.mCompanyScale = (TextView) convertView.findViewById(R.id.company_scale);
            viewHolder.mTagFlow = (TagFlowLayout) convertView.findViewById(R.id.tag_flow);
            viewHolder.mCompanyContentInformation = (TextView) convertView.findViewById(R.id.company_content_information);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        CCompanyEntity entity = list.get(position);
        ImageLoader.getInstance().displayImage(entity.CompanyLogo, viewHolder.mCompanyLogo, options, animateFirstListener);
        viewHolder.mCompanyName.setText(entity.CompanyName);
        viewHolder.mRatingBar.setRating((float) entity.Score);
        viewHolder.mCompanyIndustry.setText(entity.Industry);
        viewHolder.mCompanyAddress.setText(entity.Address);
        viewHolder.mCompanyScale.setText(entity.CompanySize);
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
        viewHolder.mCompanyContentInformation.setText("总阅读 "+entity.ReadCount+"   共"+entity.CommentCount+"条点评   "+"来自"+entity.StaffCount+"位员工");
        return convertView;
    }

    class ViewHolder{
        RoundAngleImageView mCompanyLogo;
        TextView mCompanyName;
        RatingBar mRatingBar;
        TextView mCompanyIndustry;
        TextView mCompanyAddress;
        TextView mCompanyScale;
        TagFlowLayout mTagFlow;
        TextView mCompanyContentInformation;
    }
}
