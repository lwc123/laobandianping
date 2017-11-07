package com.juxian.bosscomments.adapter;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Build;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.BossDynamicCommentEntity;
import com.juxian.bosscomments.models.BossDynamicEntity;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.ui.ShowBigImgActivity;
import com.juxian.bosscomments.widget.NoScrollGridView;
import com.juxian.bosscomments.widget.ResultListView;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.FailReason;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.utils.JsonUtil;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

/**
 * Created by Tam on 2016/12/23.
 */
public class BossCircleAdapter extends MyBaseAdapter<BossDynamicEntity> implements View.OnClickListener, BossCircleCommentListViewAdapter.ReplyOnClickListener {
    private DisplayImageOptions options = Global.Constants.DEFAULT_LOAD_PIC_OPTIONS;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    public CircleOperationListener mCircleOperationListener;
    private SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    public int SCwidth = ((Activity) context).getWindowManager().getDefaultDisplay().getWidth();
    public double standardscale;
    public double standWidth = (int) (SCwidth * 0.5);
    public double standHight = 480;
    private ReplyAction replyAction;
    private BossCircleCommentListViewAdapter bossCircleCommentListViewAdapter;

    public BossCircleAdapter(List<BossDynamicEntity> list, Context context, CircleOperationListener circleOperationListener, ReplyAction replyAction) {
        super(list, context);
        this.mCircleOperationListener = circleOperationListener;
        this.replyAction = replyAction;
        standardscale = (standHight / standWidth);
    }

    @Override
    public View createView(final int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null) {
            viewHolder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_circle, null);
            viewHolder.itemCircleCpHeadImg = (ImageView) convertView.findViewById(R.id.item_circle_cp_head_img);
            viewHolder.itemCircleCpName = (TextView) convertView.findViewById(R.id.item_circle_cp_name);
//            viewHolder.itemCircleCpBossLin = (LinearLayout) convertView.findViewById(R.id.item_circle_cp_boss_lin);
//            viewHolder.itemCircleCpBoss = (TextView) convertView.findViewById(R.id.item_circle_cp_boss);
            viewHolder.itemCircleCpBossName = (TextView) convertView.findViewById(R.id.item_circle_cp_boss_name);
            viewHolder.itemCircleCpComment = (TextView) convertView.findViewById(R.id.item_circle_cp_comment);
            viewHolder.itemCirclePicGv = (NoScrollGridView) convertView.findViewById(R.id.item_circle_pic_gv);
//            viewHolder.itemCircleLikeComment = (LinearLayout) convertView.findViewById(R.id.item_circle_like_comment);
            viewHolder.itemCircleTime = (TextView) convertView.findViewById(R.id.item_circle_time);
            viewHolder.itemCircleDelete = (TextView) convertView.findViewById(R.id.item_circle_delete);
            viewHolder.itemCircleLike = (ImageView) convertView.findViewById(R.id.item_circle_like);
            viewHolder.item_circle_img_one = (ImageView) convertView.findViewById(R.id.item_circle_img_one);
            viewHolder.itemCircleLikeCount = (TextView) convertView.findViewById(R.id.item_circle_like_count);
            viewHolder.itemCircleCommentCount = (TextView) convertView.findViewById(R.id.item_circle_comment_count);
            viewHolder.itemCircleCommentImg = (ImageView) convertView.findViewById(R.id.item_circle_comment_img);
            viewHolder.itemCircleCommentLine = (View) convertView.findViewById(R.id.item_circle_comment_line);
            viewHolder.commentAll = (ResultListView) convertView.findViewById(R.id.comment_all);
            viewHolder.item_circle_img_ll = (LinearLayout) convertView.findViewById(R.id.item_circle_img_ll);
            viewHolder.boss_circle_item_line = convertView.findViewById(R.id.boss_circle_item_line);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }

        if (position == list.size() - 1) {
            viewHolder.boss_circle_item_line.setVisibility(View.GONE);
        } else {
            viewHolder.boss_circle_item_line.setVisibility(View.VISIBLE);
        }
        ImageLoader.getInstance().displayImage(list.get(position).Company.CompanyLogo, viewHolder.itemCircleCpHeadImg, options, animateFirstListener);
        viewHolder.itemCircleCpName.setText(list.get(position).Company.CompanyName);
        viewHolder.itemCircleCpBossName.setText(list.get(position).Company.LegalName);
        if (list.get(position).Content == null) {
            viewHolder.itemCircleCpComment.setVisibility(View.GONE);
        } else {
            viewHolder.itemCircleCpComment.setText(list.get(position).Content);
        }

//        viewHolder.itemCircleTime.setText(mSimpleDateFormat.format(list.get(position).CreatedTime));
        FormatTime(viewHolder.itemCircleTime, position);
        viewHolder.itemCircleLikeCount.setText(list.get(position).LikedNum + "");
        viewHolder.itemCircleCommentCount.setText(list.get(position).CommentCount + "");
        MemberEntity memberEntity = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);

        if (list.get(position).PassportId == memberEntity.PassportId) {
            viewHolder.itemCircleDelete.setVisibility(View.VISIBLE);
            viewHolder.itemCircleDelete.setTag(position);
            viewHolder.itemCircleDelete.setOnClickListener(this);
        } else {
            viewHolder.itemCircleDelete.setVisibility(View.GONE);

        }

//    // 图片列表
        if (list.get(position).Img == null || list.get(position).Img.length == 0) {
            viewHolder.itemCirclePicGv.setVisibility(View.GONE);
            viewHolder.item_circle_img_ll.setVisibility(View.GONE);
        } else if (list.get(position).Img.length == 1) {
            viewHolder.itemCirclePicGv.setVisibility(View.GONE);
            viewHolder.item_circle_img_ll.setVisibility(View.VISIBLE);
            viewHolder.item_circle_img_one.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    //查看大图
                    Intent ShowBigImg = new Intent(context, ShowBigImgActivity.class);
                    ArrayList<String> Images = new ArrayList<>();
                    Images.add(list.get(position).Img[0]);
                    ShowBigImg.putExtra("ImageUrls", Images);
                    ShowBigImg.putExtra("index", 0);
                    ((Activity) context).startActivityForResult(ShowBigImg, 111);
                }
            });
            final ImageView imageView = viewHolder.item_circle_img_one;
            final ViewHolder finalViewHolder = viewHolder;
            ImageLoader.getInstance().displayImage(list.get(position).Img[0], viewHolder.item_circle_img_one, options, new ImageLoadingListener() {
                @Override
                public void onLoadingStarted(String imageUri, View view) {

                }

                @Override
                public void onLoadingFailed(String imageUri, View view, FailReason failReason) {

                }

                @Override
                public void onLoadingComplete(String imageUri, View view, Bitmap bitmap) {
                    double w = bitmap.getWidth();
                    double h = bitmap.getHeight();
                    int newW = 0;
                    int newH = 0;
                    double oriScale = h / w;
                    if (oriScale > standardscale) {
                        newW = (int) (w / (h / standHight));
                        newH = (int) standHight;
//                        Log.e("qq", "原图为更瘦高" + "w-->" + w + "  h-->" + h + "  newH-->" + newH + "  newW-->" + newW);
                        if (newW < 100) {
                            newW = 100;
                        }
                    } else if (oriScale < standardscale) {
                        newH = (int) (h / (w / standWidth));
                        newW = (int) standWidth;
                        if (newH < 350) {
                            newH = 350;
                        }
//                        Log.e("qq", "原图为更矮胖" + "w-->" + w + "  h-->" + h + "  newH-->" + newH + "  newW-->" + newW);
                    } else {
                        newH = (int) standHight;
                        newW = (int) standWidth;
//                        Log.e("qq", "原图为标准比例" + "w-->" + w + "  h-->" + h + "  newH-->" + newH + "  newW-->" + newW);
                    }
                    LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(newW, newH);
                    finalViewHolder.item_circle_img_ll.setLayoutParams(params);
                    imageView.setImageBitmap(bitmap);

                }

                @Override
                public void onLoadingCancelled(String imageUri, View view) {

                }
            });

        } else {
            viewHolder.itemCirclePicGv.setVisibility(View.VISIBLE);
            viewHolder.item_circle_img_ll.setVisibility(View.GONE);
            final List<String> imglist = new ArrayList<>(Arrays.asList(list.get(position).Img));
            ItemCircleImageGVAdapter imageAdapter = (ItemCircleImageGVAdapter) viewHolder.itemCirclePicGv.getTag();
            if (imageAdapter == null) {
                imageAdapter = new ItemCircleImageGVAdapter(imglist, context);
                viewHolder.itemCirclePicGv.setAdapter(imageAdapter);
                viewHolder.itemCirclePicGv.setTag(imageAdapter);
            } else {
                imageAdapter.setList(imglist);
                viewHolder.itemCirclePicGv.setAdapter(imageAdapter);
            }
            viewHolder.itemCirclePicGv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
                    //查看大图
                    Intent ShowBigImg = new Intent(context, ShowBigImgActivity.class);
                    ArrayList<String> Images = new ArrayList<>();
                    Images.addAll(imglist);
                    ShowBigImg.putExtra("ImageUrls", Images);
                    ShowBigImg.putExtra("index", position);
                    ((Activity) context).startActivityForResult(ShowBigImg, 111);
                }
            });
        }

        //评论列表
        if (list.get(position).Comment.size() > 0) {
            viewHolder.commentAll.setVisibility(View.VISIBLE);
            viewHolder.itemCircleCommentLine.setVisibility(View.VISIBLE);
            bossCircleCommentListViewAdapter = (BossCircleCommentListViewAdapter) viewHolder.commentAll.getTag();
            if (bossCircleCommentListViewAdapter == null) {
                bossCircleCommentListViewAdapter = new BossCircleCommentListViewAdapter(list.get(position).Comment, context, this);
                viewHolder.commentAll.setTag(bossCircleCommentListViewAdapter);
                viewHolder.commentAll.setAdapter(bossCircleCommentListViewAdapter);
            }
            bossCircleCommentListViewAdapter.setList(list.get(position).Comment);
            viewHolder.commentAll.setAdapter(bossCircleCommentListViewAdapter);
        } else {
            viewHolder.itemCircleCommentLine.setVisibility(View.GONE);
            viewHolder.commentAll.setVisibility(View.GONE);
        }

        if (list.get(position).IsLiked == true) {
            viewHolder.itemCircleLike.setImageResource(R.drawable.red_like);
        } else {
            viewHolder.itemCircleLike.setImageResource(R.drawable.black_like);
        }
        viewHolder.itemCircleLike.setTag(position);
        viewHolder.itemCircleCommentImg.setTag(position);
        viewHolder.itemCircleLike.setOnClickListener(this);
        viewHolder.itemCircleCommentImg.setOnClickListener(this);
        return convertView;
    }

    //回复评论 后刷新评论列表
    public void refresh(int pos, BossDynamicCommentEntity bossDynamicCommentEntity) {
        bossCircleCommentListViewAdapter.RefreshCommentList(pos, bossDynamicCommentEntity, 1);
    }


    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public void onClick(View view) {
        int pos = (int) view.getTag();

        switch (view.getId()) {
            case R.id.item_circle_delete://删除动态
                mCircleOperationListener.deleteCircleDynamic(list.get(pos).Company.CompanyId, list.get(pos).DynamicId, pos);
                break;
            case R.id.item_circle_like: //点赞
                if (list.get(pos).IsLiked == true) {
                    mCircleOperationListener.likeCircleDynamic(AppConfig.getCurrentUseCompany(), list.get(pos).DynamicId, pos, true, view);
                } else {
                    mCircleOperationListener.likeCircleDynamic(AppConfig.getCurrentUseCompany(), list.get(pos).DynamicId, pos, false, view);
                }
                break;
            case R.id.item_circle_comment_img://评论
                BossDynamicCommentEntity entity = new BossDynamicCommentEntity();
                mCircleOperationListener.commentCircleDynamic(pos, view);
                break;
        }
    }

    class ViewHolder {
        ImageView itemCircleCpHeadImg;
        LinearLayout item_circle_img_ll;
        TextView itemCircleCpName;
        //        LinearLayout itemCircleCpBossLin;
//        TextView itemCircleCpBoss;
        TextView itemCircleCpBossName;
        TextView itemCircleCpComment;
        NoScrollGridView itemCirclePicGv;
        //        LinearLayout itemCircleLikeComment;
        TextView itemCircleTime;
        TextView itemCircleDelete;
        ImageView itemCircleLike;
        ImageView item_circle_img_one;
        TextView itemCircleLikeCount;
        TextView itemCircleCommentCount;
        ImageView itemCircleCommentImg;
        View itemCircleCommentLine;
        ResultListView commentAll;
        View boss_circle_item_line;
    }

    @Override
    public void ToReply(View view, String CompanyAbbr, int position, int Tag) {
        replyAction.replayAction(view, CompanyAbbr, position, Tag);
    }

    public interface ReplyAction {
        void replayAction(View view, String CompanyAbbr, int position, int Tag);
    }

    public interface CircleOperationListener {
        void deleteCircleDynamic(long CompanyId, long DynamicId, int pos);

        void likeCircleDynamic(long CompanyId, long DynamicId, int pos, boolean b, View view);

        void commentCircleDynamic(int pos, View view);
    }

    public void FormatTime(TextView view, int position) {
        try {
            String ItemDateStr = mSimpleDateFormat.format(list.get(position).CreatedTime);
            String NowDateStr = mSimpleDateFormat.format(new Date());
            long l = mSimpleDateFormat.parse(NowDateStr).getTime() - mSimpleDateFormat.parse(ItemDateStr).getTime();
            long day = l / (24 * 60 * 60 * 1000); //0
            long hour = (l / (60 * 60 * 1000) - day * 24); //7
            long min = ((l / (60 * 1000)) - day * 24 * 60 - hour * 60); //25
            long s = (l / 1000 - day * 24 * 60 * 60 - hour * 60 * 60 - min * 60); //27
            if (day > 1) {
                view.setText(ItemDateStr);
            } else if (hour >= 1) {
                view.setText(hour + "小时前");
            } else if (min >= 1) {
                view.setText(min + "分钟前");
            } else if (s >= 0) {
                view.setText("刚刚");
            } else {
                view.setText("未知时间");
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }
}
