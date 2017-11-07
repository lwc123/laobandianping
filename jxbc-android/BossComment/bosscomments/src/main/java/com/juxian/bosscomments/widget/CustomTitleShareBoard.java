package com.juxian.bosscomments.widget;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.*;

import com.juxian.bosscomments.R;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.bean.SocializeEntity;
import com.umeng.socialize.controller.UMServiceFactory;
import com.umeng.socialize.controller.UMSocialService;
import com.umeng.socialize.controller.listener.SocializeListeners;

import net.juxian.appgenome.modules.ShareMessageBuilder;
import net.juxian.appgenome.socialize.ShareMessage;
import net.juxian.appgenome.socialize.ShareUtil;
import net.juxian.appgenome.socialize.SocialManager;
import net.juxian.appgenome.utils.Constants;

/**
 * Created by nene on 2017/4/22.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/22 17:14]
 * @Version: [v1.0]
 */
public class CustomTitleShareBoard extends PopupWindow implements View.OnClickListener {

    private UMSocialService mController = UMServiceFactory
            .getUMSocialService(Constants.DESCRIPTOR);
    private Activity mActivity;
    private Context context;
    private String title;
    private String content;
    private String imgUrl;
    private String shareUrl;
    private RelativeLayout linWeiXin;
    private RelativeLayout linPengyouquan;

    public CustomTitleShareBoard(Activity activity, Context context, String title,
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
        View rootView = LayoutInflater.from(context).inflate(R.layout.popupwindow_select_consume_type, null);

        linWeiXin = (RelativeLayout) rootView.findViewById(R.id.re_income_record);
        android.widget.TextView select_income_record = (android.widget.TextView) rootView.findViewById(R.id.select_income_record);
        select_income_record.setText("分享给微信好友");
        linPengyouquan = (RelativeLayout) rootView.findViewById(R.id.re_expense_record);
        android.widget.TextView select_expense_record = (android.widget.TextView) rootView.findViewById(R.id.select_expense_record);
        select_expense_record.setText("发送至朋友圈");
        RelativeLayout reWithdrawDepositRecord = (RelativeLayout) rootView.findViewById(R.id.re_withdraw_deposit_record);
        reWithdrawDepositRecord.setVisibility(View.GONE);

        linWeiXin.setOnClickListener(this);
        linPengyouquan.setOnClickListener(this);

        setContentView(rootView);
        setWidth(ViewGroup.LayoutParams.WRAP_CONTENT);
        setHeight(ViewGroup.LayoutParams.WRAP_CONTENT);
        setTouchable(true);
        setBackgroundDrawable(mActivity.getResources().getDrawable(R.drawable.mask_icon_7));
        setTouchable(true);
        setOutsideTouchable(true);
//        showAsDropDown(mBelowView, 0, 12);
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.re_income_record){
            linWeiXin.setOnClickListener(null);
            linPengyouquan.setOnClickListener(null);
            shareTest(SHARE_MEDIA.WEIXIN);
        } else if (id == R.id.re_expense_record){
            linWeiXin.setOnClickListener(null);
            linPengyouquan.setOnClickListener(null);
            shareTest(SHARE_MEDIA.WEIXIN_CIRCLE);
        } else {
            dismiss();
        }
    }

    private UMSocialService shareService = null;

    public void shareTest(SHARE_MEDIA media) {
        if (null == shareService)
            shareService = SocialManager.getShareService(mActivity);
        ShareMessage message = ShareMessageBuilder.BuildByTrends(title,
                content, shareUrl, imgUrl);
        ShareUtil.resetShareMedia(shareService, message);
        shareService.postShare(context, media, new SocializeListeners.SnsPostListener() {

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
}
