package net.juxian.appgenome.widget;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.BitmapDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.LinearLayout;
import android.widget.PopupWindow;

import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.bean.SocializeEntity;
import com.umeng.socialize.controller.UMServiceFactory;
import com.umeng.socialize.controller.UMSocialService;
import com.umeng.socialize.controller.listener.SocializeListeners.SnsPostListener;

import net.juxian.appgenome.R;
import net.juxian.appgenome.modules.ShareMessageBuilder;
import net.juxian.appgenome.socialize.ShareMessage;
import net.juxian.appgenome.socialize.ShareUtil;
import net.juxian.appgenome.socialize.SocialManager;
import net.juxian.appgenome.utils.Constants;

/**
 *
 */
public class CustomShareBoard extends PopupWindow implements OnClickListener {

    private UMSocialService mController = UMServiceFactory
            .getUMSocialService(Constants.DESCRIPTOR);
    private Activity mActivity;
    private Context context;
    private String title;
    private String content;
    private String imgUrl;
    private String shareUrl;
    private LinearLayout linWeiXin;
    private LinearLayout linPengyouquan;

    public CustomShareBoard(Activity activity, Context context, String title,
                            String content, String imgUrl, String shareUrl) {
        super(activity);
        this.mActivity = activity;
        this.context = context;
        this.title = title;
        this.content = content;
        this.imgUrl = imgUrl;
        this.shareUrl = shareUrl;
        initView(activity);
    }

    @SuppressWarnings("deprecation")
    private void initView(Context context) {
        View rootView = LayoutInflater.from(context).inflate(
                R.layout.custom_board, null);
        // rootView.findViewById(R.id.custom_board_weibo_lin).setOnClickListener(//
        // 微博
        // this);
        linWeiXin = (LinearLayout) rootView.findViewById(R.id.custom_board_weixin_lin);
        linPengyouquan = (LinearLayout) rootView.findViewById(R.id.custom_board_pengyouquan_lin);
        linWeiXin.setOnClickListener(this);
        linPengyouquan.setOnClickListener(this);
//		rootView.findViewById(R.id.custom_board_weixin_lin).setOnClickListener(// 微信好友
//				this);
//		rootView.findViewById(R.id.custom_board_pengyouquan_lin)
//				.setOnClickListener(this);// 微信朋友圈
        rootView.findViewById(R.id.details_job_center_cancel_text)
                .setOnClickListener(this);
        setContentView(rootView);
        setWidth(LayoutParams.MATCH_PARENT);
        setHeight(LayoutParams.WRAP_CONTENT);
        setFocusable(true);
        setBackgroundDrawable(new BitmapDrawable());
        setTouchable(true);
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.custom_board_weixin_lin){
            linWeiXin.setOnClickListener(null);
            linPengyouquan.setOnClickListener(null);
            shareTest(SHARE_MEDIA.WEIXIN);
        } else if (id == R.id.custom_board_pengyouquan_lin){
            linWeiXin.setOnClickListener(null);
            linPengyouquan.setOnClickListener(null);
            shareTest(SHARE_MEDIA.WEIXIN_CIRCLE);
        } else {
            dismiss();
        }
//        switch (id) {
//            // case R.id.custom_board_weibo_lin:
//            // shareTest(SHARE_MEDIA.SINA);
//            // // performShare(SHARE_MEDIA.SINA);
//            // break;
//            case R.id.custom_board_weixin_lin:
//                linWeiXin.setOnClickListener(null);
//                linPengyouquan.setOnClickListener(null);
//                shareTest(SHARE_MEDIA.WEIXIN);
//                // performShare(SHARE_MEDIA.WEIXIN);
//
//                break;
//            case R.id.custom_board_pengyouquan_lin:
//                linWeiXin.setOnClickListener(null);
//                linPengyouquan.setOnClickListener(null);
//                shareTest(SHARE_MEDIA.WEIXIN_CIRCLE);
//                // performShare(SHARE_MEDIA.WEIXIN_CIRCLE);
//                // performShare(SHARE_MEDIA.QQ);
//                break;
//            // case R.id.qzone:
//            // performShare(SHARE_MEDIA.QZONE);
//            // break;
//            case R.id.details_job_center_cancel_text:
//                dismiss();
//                break;
//            default:
//                break;
//        }
    }

    private UMSocialService shareService = null;

    public void shareTest(SHARE_MEDIA media) {
        if (null == shareService)
            shareService = SocialManager.getShareService(mActivity);
        ShareMessage message = ShareMessageBuilder.BuildByTrends(title,
                content, shareUrl, imgUrl);
        ShareUtil.resetShareMedia(shareService, message);
        shareService.postShare(context, media, new SnsPostListener() {

            @Override
            public void onStart() {
            }

            @Override
            public void onComplete(SHARE_MEDIA platform, int eCode,
                                   SocializeEntity entity) {
                // if (eCode == StatusCode.ST_CODE_SUCCESSED) {
                // } else {
                // }
                dismiss();
            }
        });
    }

    /**
     * 分享监听器
     */
    // SnsPostListener mShareListener = new SnsPostListener() {
    //
    // @Override
    // public void onStart() {
    //
    // }
    //
    // @Override
    // public void onComplete(SHARE_MEDIA platform, int stCode,
    // SocializeEntity entity) {
    // if (stCode == StatusCode.ST_CODE_SUCCESSED) {
    // // loadShare(sharedChannel);
    // // Toast.makeText(JobCenterDetailsTestActivity.this, "分享成功",
    // // Toast.LENGTH_SHORT).show();
    // } else {
    // // Toast.makeText(context, "分享失败 : error code : " + stCode,
    // // Toast.LENGTH_SHORT).show();
    // }
    // }
    // };

    // private void performShare(SHARE_MEDIA platform) {
    // mController.postShare(mActivity, platform, new SnsPostListener() {
    //
    // @Override
    // public void onStart() {
    //
    // }
    //
    // @Override
    // public void onComplete(SHARE_MEDIA platform, int eCode,
    // SocializeEntity entity) {
    // String showText = platform.toString();
    // if (eCode == StatusCode.ST_CODE_SUCCESSED) {
    // // showText += "平台分享成功";
    // } else {
    // // showText += "平台分享失败";
    // }
    // Toast.makeText(mActivity, showText, Toast.LENGTH_SHORT).show();
    // dismiss();
    // }
    // });
    // }

}
