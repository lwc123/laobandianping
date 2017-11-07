package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.graphics.drawable.AnimationDrawable;
import android.text.Html;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.example.xlhratingbar_lib.XLHRatingBar;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.BossCommentEntity;
import com.juxian.bosscomments.utils.Player;
import com.juxian.bosscomments.utils.TimeUtil;
import com.juxian.bosscomments.widget.NoScrollGridView;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by nene on 2016/10/28.
 *
 * @ProjectName: [BossComment]
 * @Package: [com.juxian.bosscomments.adapter]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/28 13:53]
 * @Version: [v1.0]
 */
public class SearchResultAdapter extends MyBaseAdapter<BossCommentEntity> {

    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_AVATAR_OPTIONS;
    private Player player;
    private AnimationDrawable voiceAnimation = null;

    public SearchResultAdapter(List<BossCommentEntity> list, Context context) {
        super(list, context);
        player = new Player(context);
    }

    public void setDatas(List<BossCommentEntity> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null) {
            viewHolder = new ViewHolder();

            convertView = inflater.inflate(R.layout.item_search_result, null);

            viewHolder.add_comment_time = (TextView) convertView.findViewById(R.id.add_comment_time);
            viewHolder.comment_person_name = (TextView) convertView.findViewById(R.id.comment_person_name);
            viewHolder.been_commented_person_position = (TextView) convertView.findViewById(R.id.been_commented_person_position);
            viewHolder.company_name = (TextView) convertView.findViewById(R.id.company_name);
            viewHolder.capacityRatingBar = (XLHRatingBar) convertView.findViewById(R.id.ratingBar);
            viewHolder.attitudeRatingBar = (XLHRatingBar) convertView.findViewById(R.id.ratingBar1);
            viewHolder.performanceRatingBar = (XLHRatingBar) convertView.findViewById(R.id.ratingBar2);
            viewHolder.comment_text_content = (TextView) convertView.findViewById(R.id.comment_text_content);
            viewHolder.voice = (LinearLayout) convertView.findViewById(R.id.voice);
            viewHolder.playing_ani = (ImageView) convertView.findViewById(R.id.playing_ani);
            viewHolder.gridView = (NoScrollGridView) convertView.findViewById(R.id.gridview);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        BossCommentEntity entity = list.get(position);
        viewHolder.add_comment_time.setText(TimeUtil.parserTime3(entity.ModifiedTime.getTime() + ""));
        if (!TextUtils.isEmpty(entity.CommentatorName)) {
            viewHolder.comment_person_name.setText(entity.CommentatorName);
        } else {
            viewHolder.comment_person_name.setText("");
        }
        if (!TextUtils.isEmpty(entity.TargetJobTitle)) {
            viewHolder.been_commented_person_position.setText(entity.TargetJobTitle);
        } else {
            viewHolder.been_commented_person_position.setText("");
        }
        if (!TextUtils.isEmpty(entity.EntName)) {
            viewHolder.company_name.setText(entity.EntName);
        } else {
            viewHolder.company_name.setText("");
        }
        viewHolder.capacityRatingBar.setCountSelected(entity.WorkAbility);
        viewHolder.attitudeRatingBar.setCountSelected(entity.WorkManner);
        viewHolder.performanceRatingBar.setCountSelected(entity.WorkAchievement);
        if (!TextUtils.isEmpty(entity.Text)) {
            String comment_content = "<font color='#4a4a4a'>评语：</font><font color='#999999'>" + entity.Text + "</font>";
            viewHolder.comment_text_content.setText(Html.fromHtml(comment_content));
        } else {
            viewHolder.comment_text_content.setText("该评论没有文本评语");
        }
        if (!TextUtils.isEmpty(entity.Voice)) {
            viewHolder.voice.setVisibility(View.VISIBLE);
            viewHolder.voice.setTag(position);
            final int site = position;
            final ViewHolder finalViewHolder = viewHolder;
            viewHolder.voice.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if (!player.isPlaying) {
                        player.setImageView(finalViewHolder.playing_ani);
                        player.playUrl(list.get(site).Voice);
//                        Log.e(Global.LOG_TAG,"播放");
//                        showAnimation(finalViewHolder.playing_ani);
                    }
                    else {
                        player.stop();
//                        Log.e(Global.LOG_TAG,"ting");
//                        voiceAnimation.stop();
//                        finalViewHolder.playing_ani.setImageResource(R.drawable.yuyin);
                    }
                }
            });
        } else {
            viewHolder.voice.setVisibility(View.GONE);
        }
//        Log.e(Global.LOG_TAG, position + "         " + entity.toString());

        if (entity.Images != null) {
            viewHolder.gridView.setVisibility(View.VISIBLE);
            List<String> ImagesList = new ArrayList<>();
            for (int i=0;i<entity.Images.length;i++){
                ImagesList.add(entity.Images[i]);
            }
            viewHolder.gridView.setAdapter(new SearchResultGridAdapter(ImagesList,context));
        } else {
            viewHolder.gridView.setVisibility(View.GONE);
        }
        return convertView;
    }

    private void showAnimation(ImageView imageView) {
        // play voice, and start animation
        imageView.setImageResource(R.drawable.voice_from_icon);
        voiceAnimation = (AnimationDrawable) imageView.getDrawable();
        voiceAnimation.start();
    }

    class ViewHolder {
        TextView add_comment_time;
        TextView comment_person_name;
        TextView been_commented_person_position;
        TextView company_name;
        XLHRatingBar capacityRatingBar;
        XLHRatingBar attitudeRatingBar;
        XLHRatingBar performanceRatingBar;
        TextView comment_text_content;
        LinearLayout voice;
        ImageView playing_ani;
        NoScrollGridView gridView;
    }
}
