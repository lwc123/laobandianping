package com.juxian.bosscomments.ui;

import android.app.Dialog;
import android.os.Build;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.InvitedRegisterEntity;
import com.juxian.bosscomments.repositories.CompanyRepository;
import com.juxian.bosscomments.repositories.PrivatenessRepository;
import com.juxian.bosscomments.utils.SystemBarTintManager;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.CustomShareBoard;
import net.juxian.appgenome.widget.DialogUtil;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/12/30.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/30 14:34]
 * @Version: [v1.0]
 */
public class PersonalInviteActivity extends RemoteDataActivity implements View.OnClickListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.share)
    Button right_now_share;
    @BindView(R.id.copy_link)
    Button copy_link;
    @BindView(R.id.boss_brief)
    TextView boss_brief;
    @BindView(R.id.invite_qrcode)
    ImageView mInviteQrcode;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions optionsPhoto = Global.Constants.DEFAULT_LOAD_PIC_OPTIONS;
    private InvitedRegisterEntity mInvitedRegisterEntity;
    private String InviteRegisterUrl;

    @Override
    public int getContentViewId() {
        return R.layout.activity_personal_invite;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText("邀请注册");
    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);
        initViewsData();
        initListener();
        setSystemBarTintManager(this);
    }

    @Override
    public void loadPageData() {
        getInviteInfo();
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
        IsReloadDataOnResume = true;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.share:
                // 还未在微信平台上添加这个应用
                String shareUrl = InviteRegisterUrl;
                String ShareTitle = "嗨，提升现有员工工作效率，改善员工风貌，有这个就够了！";
                String Content = "老板点评，为职业诚信者点赞背书，让职业失信者受到约束。";
//                InputStream abpath=getClass().getResourceAsStream("/assets/logo.png");
//                String UserAvatar = null;
//                try {
//                    UserAvatar = new String(InputStreamToByte(abpath));
//                } catch (IOException e) {
//                    e.printStackTrace();
//                }
                String UserAvatar = "http://res.laobandianping.com/images/app_icon.png";
                CustomShareBoard shareBoard = new CustomShareBoard(
                        PersonalInviteActivity.this, getApplicationContext(), ShareTitle, Content,
                        UserAvatar, shareUrl);
                shareBoard.showAtLocation(PersonalInviteActivity.this.getWindow()
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

    public void getInviteInfo(){
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<InvitedRegisterEntity>() {
            @Override
            protected InvitedRegisterEntity doInBackground(Void... params) {
                InvitedRegisterEntity resultEntity = PrivatenessRepository.getInviteRegister();
                return resultEntity;
            }

            @Override
            protected void onPostExecute(InvitedRegisterEntity result) {
                if (dialog != null)
                    dialog.dismiss();
                if (result != null){
                    IsInitData = true;
                    mInvitedRegisterEntity = result;
                    boss_brief.setText("每邀请一位老板开户，您将获得"+result.InvitePremium+"元奖金（税后）");
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