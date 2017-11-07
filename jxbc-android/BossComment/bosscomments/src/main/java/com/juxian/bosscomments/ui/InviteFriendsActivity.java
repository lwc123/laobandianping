package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.InvitedRegisterEntity;
import com.juxian.bosscomments.models.UserProfileEntity;
import com.juxian.bosscomments.models.UserSummaryEntity;
import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.repositories.CompanyRepository;
import com.juxian.bosscomments.repositories.UserRepository;
import com.juxian.bosscomments.utils.SystemBarTintManager;
import com.juxian.bosscomments.widget.RoundAngleImageView;
import com.juxian.bosscomments.widget.RoundImageView;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.CustomShareBoard;
import net.juxian.appgenome.widget.DialogUtil;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

import butterknife.BindView;
import butterknife.ButterKnife;
import de.hdodenhof.circleimageview.CircleImageView;

/**
 * Created by nene on 2016/10/19.
 *
 * @ProjectName: [LaoBanDianPing]
 * @Package: [com.juxian.bosscomments.ui]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/19 9:50]
 * @Version: [v1.0]
 */
public class InviteFriendsActivity extends RemoteDataActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_back)
    ImageView back;
    @BindView(R.id.share)
    Button right_now_share;
    @BindView(R.id.profile_image)
    CircleImageView me_photo;
    @BindView(R.id.boss_brief)
    TextView boss_brief;
    @BindView(R.id.headcolor)
    View view;
    @BindView(R.id.invite_qrcode)
    ImageView mInviteQrcode;
    @BindView(R.id.personal_name)
    TextView mPersonalName;
    @BindView(R.id.personal_company)
    TextView mPersonalCompany;
    private SystemBarTintManager tintManager;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions optionsPhoto = Global.Constants.DEFAULT_PERSONAL_AVATAR_OPTIONS;
    DisplayImageOptions center_background = Global.Constants.DEFAULT_MY_CENTER_AVATAR_OPTIONS;
    private InvitedRegisterEntity mInvitedRegisterEntity;
    private CompanyEntity companyEntity;
    private String InviteRegisterUrl;

    @Override
    public int getContentViewId() {
        return R.layout.activity_invite_friends;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        companyEntity = JsonUtil.ToEntity(getIntent().getStringExtra("CompanyEntity"),CompanyEntity.class);
        ImageLoader.getInstance().displayImage(AppContext.getCurrent().getCurrentAccount().getProfile().Avatar,me_photo,optionsPhoto,animateFirstListener);
        mPersonalName.setText(companyEntity.MyInformation.RealName);
        mPersonalCompany.setText(companyEntity.CompanyName);
    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);
        initViewsData();
        initListener();
        /**
         * 改变状态栏颜色
         */
        showSystemBartint(view);
        tintManager = new SystemBarTintManager(this);
        tintManager.setStatusBarTintEnabled(true);
        tintManager.setStatusBarTintResource(R.color.main_color);
        tintManager.setStatusBarTintResource(R.color.transparency_color);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            view.setVisibility(View.GONE);
        } else {
            view.setVisibility(View.GONE);
        }
    }

    @Override
    public void loadPageData() {
        getInviteInfo(AppConfig.getCurrentUseCompany());
    }

    @Override
    public void initListener() {
        super.initListener();
        right_now_share.setOnClickListener(this);
        back.setOnClickListener(this);
    }

    @Override
    protected void onResume() {
        super.onResume();

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.include_head_title_back:
                setResult(RESULT_OK);
                finish();
                break;
            case R.id.share:
                // 还未在微信平台上添加这个应用
                String shareUrl = InviteRegisterUrl;
                String ShareTitle = "嗨，再也不怕捣蛋的员工了，这个神器大赞!";
                String Content = "老板点评，让员工对职业保持敬畏，让离任员工继续创造价值。";
//                InputStream abpath=getClass().getResourceAsStream("/assets/logo.png");
//                String UserAvatar = null;
//                try {
//                    UserAvatar = new String(InputStreamToByte(abpath));
//                } catch (IOException e) {
//                    e.printStackTrace();
//                }
                String UserAvatar = "http://res.laobandianping.com/images/app_icon.png";
                CustomShareBoard shareBoard = new CustomShareBoard(
                        InviteFriendsActivity.this, getApplicationContext(), ShareTitle, Content,
                        UserAvatar, shareUrl);
                shareBoard.showAtLocation(InviteFriendsActivity.this.getWindow()
                        .getDecorView(), Gravity.BOTTOM, 0, 0);
                break;
            default:
                break;
        }
    }

    private byte[] InputStreamToByte(InputStream is) throws IOException {
        ByteArrayOutputStream bytestream = new ByteArrayOutputStream();
        int ch;
        while ((ch = is.read()) != -1) {
            bytestream.write(ch);
        }
        byte imgdata[] = bytestream.toByteArray();
        bytestream.close();
        return imgdata;
    }

    @Override
    public void onBackPressed() {
        setResult(RESULT_OK);
        super.onBackPressed();
    }

    public void getInviteInfo(final long CompanyId){
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<InvitedRegisterEntity>() {
            @Override
            protected InvitedRegisterEntity doInBackground(Void... params) {
                InvitedRegisterEntity resultEntity = CompanyRepository.getInviteRegister(CompanyId);
                return resultEntity;
            }

            @Override
            protected void onPostExecute(InvitedRegisterEntity result) {
                if (dialog != null)
                    dialog.dismiss();
                if (result != null){
                    mInvitedRegisterEntity = result;
                    boss_brief.setText("3.每邀请一位老板开户，公司将获得"+result.InvitePremium+"金币");
                    InviteRegisterUrl = result.InviteRegisterUrl;
                    ImageLoader.getInstance().displayImage(result.InviteRegisterQrcode,mInviteQrcode,optionsPhoto,animateFirstListener);
                } else {
                    onRemoteError();
                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
            }
        }.execute();
    }
}
