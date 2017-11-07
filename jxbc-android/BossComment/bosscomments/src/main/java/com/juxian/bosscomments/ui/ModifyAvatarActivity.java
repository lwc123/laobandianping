package com.juxian.bosscomments.ui;

import android.Manifest;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.AvatarEntity;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.ImageBucket;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.utils.AlbumHelper;
import com.juxian.bosscomments.utils.PermissionUtils;
import com.juxian.bosscomments.utils.SystemBarTintManager;
import com.juxian.bosscomments.utils.checkSelfPermissionUtils;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.ImageUtil;
import net.juxian.appgenome.utils.ImageUtils;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import de.hdodenhof.circleimageview.CircleImageView;
import me.nereo.multi_image_selector.MultiImageSelector;

/**
 * Created by nene on 2017/3/28.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/3/28 10:13]
 * @Version: [v1.0]
 */
public class ModifyAvatarActivity extends RemoteDataActivity implements View.OnClickListener {

    private InputMethodManager manager;
    @BindView(R.id.back)
    ImageView back;
    @BindView(R.id.headcolor)
    View view;
//    @BindView(R.id.include_button_button)
//    Button mSaveCompanyInfo;
    @BindView(R.id.profile_image_rl)
    RelativeLayout mModifyPersonalInformation;
    @BindView(R.id.profile_image)
    CircleImageView mProfileImage;
    @BindView(R.id.personal_name)
    TextView mPersonalName;
    @BindView(R.id.activity_modify_name)
    TextView mModifyName;
    @BindView(R.id.activity_modify_field_real)
    TextView mModifyPosition;
    @BindView(R.id.activity_modify_role)
    TextView mModifyRole;
    @BindView(R.id.activity_modify_phone)
    TextView mModifyPhone;
    private SystemBarTintManager tintManager;
    private CompanyEntity mCompanyEntity;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_PERSONAL_AVATAR_OPTIONS;
    private ArrayList<String> mSelectPath;
    private String mAvatar;

    @Override
    public int getContentViewId() {
        return R.layout.activity_modify_avatar;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);
        manager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
        initViewsData();
        initListener();
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
        IsInitData = true;
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        // TODO Auto-generated method stub
        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            if (getCurrentFocus() != null
                    && getCurrentFocus().getWindowToken() != null) {
                manager.hideSoftInputFromWindow(getCurrentFocus()
                        .getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
            }
        }
        return super.onTouchEvent(event);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
//        mSaveCompanyInfo.setText("保存");
        mCompanyEntity = JsonUtil.ToEntity(getIntent().getStringExtra("CompanyEntity"),CompanyEntity.class);
        if (mCompanyEntity!=null){
            ImageLoader.getInstance().displayImage(AppContext.getCurrent().getCurrentAccount().getProfile().Avatar, mProfileImage, options, animateFirstListener);
            mPersonalName.setText(mCompanyEntity.MyInformation.RealName);
            mModifyName.setText(mCompanyEntity.CompanyName);
            mModifyPosition.setText(mCompanyEntity.MyInformation.JobTitle);
            if (mCompanyEntity.MyInformation.Role == MemberEntity.CompanyMember_Role_Boss){
                mModifyRole.setText("老板");
            } else if (mCompanyEntity.MyInformation.Role == MemberEntity.CompanyMember_Role_Admin){
                mModifyRole.setText("管理员");
            } else if (mCompanyEntity.MyInformation.Role == MemberEntity.CompanyMember_Role_Senior){
                mModifyRole.setText("高管");
            } else if (mCompanyEntity.MyInformation.Role == MemberEntity.CompanyMember_Role_XiaoMi){
                mModifyRole.setText("建档员");
            }
            mModifyPhone.setText(AppContext.getCurrent().getCurrentAccount().MobilePhone);
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
//        mSaveCompanyInfo.setOnClickListener(this);
        mModifyPersonalInformation.setOnClickListener(this);
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()){
            case R.id.back:
                deleteImages();
                finish();
                break;
//            case R.id.include_button_button:
//                if (TextUtils.isEmpty(mAvatar)) {
//                    ToastUtil.showInfo("请选择头像");
//                    return;
//                }
//                ChangeAvatar(mAvatar);
//                break;
            case R.id.profile_image_rl:
                if (Build.VERSION.SDK_INT < 23) {
                    try {
                        AlbumHelper helper = AlbumHelper.getHelper();
                        helper.init(getApplicationContext());
                        List<ImageBucket> dataList1 = helper.getImagesBucketList(false);
                    } catch (Exception e){

                    } finally {
                        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                            checkSelfPermissionUtils.checkPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE);
                        }
                    }
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
                        MultiImageSelector selector = MultiImageSelector.create(ModifyAvatarActivity.this);
                        selector.showCamera(true);
                        selector.count(9);
                        selector.single();
                        selector.origin(mSelectPath);
                        selector.start(ModifyAvatarActivity.this, 520);
                    }
                } else {
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                        PermissionUtils.requestPermission(this, PermissionUtils.CODE_READ_EXTERNAL_STORAGE, mPermissionGrant);
                    } else {
                        MultiImageSelector selector = MultiImageSelector.create(ModifyAvatarActivity.this);
                        selector.showCamera(true);
                        selector.count(9);
                        selector.single();
                        selector.origin(mSelectPath);
                        selector.start(ModifyAvatarActivity.this, 520);
                    }
                }
                break;
            default:
                break;
        }
    }

    @Override
    public void onBackPressed() {
        deleteImages();
        super.onBackPressed();
    }

    private void deleteImages(){
        if (mSelectPath != null) {
            for (int i = 0; i < mSelectPath.size(); i++) {
                File imageFile = new File(mSelectPath.get(i));
                if (imageFile.exists()) {
                    imageFile.delete();
                }
            }
        }
    }

    private PermissionUtils.PermissionGrant mPermissionGrant = new PermissionUtils.PermissionGrant() {
        @Override
        public void onPermissionGranted(int requestCode) {
            switch (requestCode) {
                case PermissionUtils.CODE_RECORD_AUDIO:
                    break;
                case PermissionUtils.CODE_GET_ACCOUNTS:
                    break;
                case PermissionUtils.CODE_READ_PHONE_STATE:
                    break;
                case PermissionUtils.CODE_CALL_PHONE:
                    break;
                case PermissionUtils.CODE_CAMERA:
                    break;
                case PermissionUtils.CODE_ACCESS_FINE_LOCATION:
                    break;
                case PermissionUtils.CODE_ACCESS_COARSE_LOCATION:
                    break;
                case PermissionUtils.CODE_READ_EXTERNAL_STORAGE:
                    MultiImageSelector selector = MultiImageSelector.create(ModifyAvatarActivity.this);
                    selector.showCamera(true);
                    selector.count(9);
                    selector.single();
                    selector.origin(mSelectPath);
                    selector.start(ModifyAvatarActivity.this, 520);
                    break;
                case PermissionUtils.CODE_WRITE_EXTERNAL_STORAGE:
                    break;
                default:
                    break;
            }
        }
    };

    @Override
    public void onRequestPermissionsResult(final int requestCode, @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        PermissionUtils.requestPermissionsResult(this, requestCode, permissions, grantResults, mPermissionGrant);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 520:
                if (resultCode == RESULT_OK) {
                    if (resultCode == RESULT_OK) {
                        mSelectPath = data.getStringArrayListExtra(MultiImageSelector.EXTRA_RESULT);

                        mAvatar = mSelectPath.get(0);
                        Bitmap bitmap = BitmapFactory.decodeFile(mAvatar);
                        mProfileImage.setImageBitmap(bitmap);
                        ChangeAvatar(mAvatar);
                    }
                }
                break;
        }
    }

    protected void ChangeAvatar(final String imgFile) {// 提交用户信息
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<String>() {
            @Override
            protected String doInBackground(Void... params) {
                final AvatarEntity avatar = new AvatarEntity();
                avatar.setAvatar(imgFile);

                String url = AppContext.getCurrent().getUserAuthentication().changeAvatar(avatar);
                return url;
            }

            @Override
            protected void onPostExecute(String result) {
                dialog.dismiss();
                if (result.startsWith("http://")) {
                    deleteImages();
                    ToastUtil.showInfo(getString(R.string.photo_uploading_success));
                    finish();
                } else {
//                    ToastUtil.showError(getString(R.string.photo_uploading_fail));
                    onRemoteError();
                }
            }

            @Override
            protected void onPostError(Exception ex) {
                dialog.dismiss();
                onRemoteError();
            }

        }.execute();
    }
}
