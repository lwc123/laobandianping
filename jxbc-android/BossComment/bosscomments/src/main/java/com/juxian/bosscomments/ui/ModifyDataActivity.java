package com.juxian.bosscomments.ui;

import android.Manifest;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppContext;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.AvatarEntity;
import com.juxian.bosscomments.models.ImageBucket;
import com.juxian.bosscomments.models.UserProfileEntity;
import com.juxian.bosscomments.utils.AlbumHelper;
import com.juxian.bosscomments.utils.PermissionUtils;
import com.juxian.bosscomments.utils.SystemBarTintManager;
import com.juxian.bosscomments.utils.checkSelfPermissionUtils;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import butterknife.BindView;
import butterknife.ButterKnife;
import de.hdodenhof.circleimageview.CircleImageView;
import me.nereo.multi_image_selector.MultiImageSelector;

/**
 * Created by nene on 2017/4/14.
 * 修改C端个人信息
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/14 14:58]
 * @Version: [v1.0]
 */
public class ModifyDataActivity extends RemoteDataActivity implements View.OnClickListener {

    private InputMethodManager manager;
    @BindView(R.id.back)
    ImageView back;
    @BindView(R.id.headcolor)
    View view;
    @BindView(R.id.profile_image_rl)
    RelativeLayout mModifyPersonalInformation;
    @BindView(R.id.profile_image)
    CircleImageView mProfileImage;
    @BindView(R.id.activity_modify_nickname_text)
    EditText mModifyNickNameText;
    @BindView(R.id.activity_modify_email_text)
    EditText mModifyEmailText;
    @BindView(R.id.activity_modify_phone_text)
    TextView mModifyPhoneText;
    @BindView(R.id.include_button_button)
    Button mSave;
    @BindView(R.id.personal_name)
    TextView mNickName;
    private SystemBarTintManager tintManager;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_PERSONAL_AVATAR_OPTIONS;
    private ArrayList<String> mSelectPath;
    private String mAvatar;

    @Override
    public int getContentViewId() {
        return R.layout.activity_modify_data;
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
        mSave.setText(getString(R.string.save));
        UserProfileEntity userProfileEntity = AppContext.getCurrent().getCurrentAccount().getProfile();
        ImageLoader.getInstance().displayImage(userProfileEntity.Avatar,mProfileImage,options,animateFirstListener);
        if (userProfileEntity != null){
            if (TextUtils.isEmpty(userProfileEntity.Email)){
                mModifyEmailText.setText("");
            } else {
                mModifyEmailText.setText(userProfileEntity.Email + "");
            }
            mModifyNickNameText.requestFocus();
            mModifyNickNameText.setFocusable(true);
            mModifyNickNameText.setFocusableInTouchMode(true);
            if (TextUtils.isEmpty(userProfileEntity.RealName)){
                mModifyNickNameText.setText("");
                mNickName.setText("");
            } else {
                mNickName.setText(userProfileEntity.RealName + "");
                mModifyNickNameText.setText(userProfileEntity.RealName + "");
                mModifyNickNameText.setSelection(userProfileEntity.RealName.length());
            }
        }
        if (userProfileEntity != null) {
            mModifyPhoneText.setText(userProfileEntity.MobilePhone+"");
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mModifyPersonalInformation.setOnClickListener(this);
        mSave.setOnClickListener(this);
    }

    @Override
    public void loadPageData() {

    }

    @Override
    public void onClick(View view) {

        switch (view.getId()) {
            case R.id.back:
                deleteImages();
                setResult(RESULT_OK);
                finish();
                break;
            case R.id.include_button_button:
                if (TextUtils.isEmpty(mModifyNickNameText.getText().toString().trim())){
                    ToastUtil.showInfo("请输入昵称");
                    return;
                }
                if (TextUtils.isEmpty(mModifyEmailText.getText().toString().trim())){
                    ToastUtil.showInfo("请输入邮箱");
                    return;
                }
                Matcher m = Pattern.compile("/^[a-z0-9._%-]+@([a-z0-9-]+\\.)+[a-z]{2,4}$/").matcher(mModifyEmailText.getText().toString().trim());
                if (!m.matches()){
                    ToastUtil.showInfo("邮箱格式错误，请重新输入");
                    return;
                }
                UserProfileEntity entity = new UserProfileEntity();
                entity.RealName = mModifyNickNameText.getText().toString().trim();
                entity.Email = mModifyEmailText.getText().toString().trim();
                ChangeProfile(entity);
                break;
            case R.id.profile_image_rl:
                if (Build.VERSION.SDK_INT < 23) {
                    try {
                        AlbumHelper helper = AlbumHelper.getHelper();
                        helper.init(getApplicationContext());
                        List<ImageBucket> dataList1 = helper.getImagesBucketList(false);
                    } catch (Exception e) {

                    } finally {
                        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                            checkSelfPermissionUtils.checkPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE);
                        }
                    }
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
                        MultiImageSelector selector = MultiImageSelector.create(ModifyDataActivity.this);
                        selector.showCamera(true);
                        selector.count(9);
                        selector.single();
                        selector.origin(mSelectPath);
                        selector.start(ModifyDataActivity.this, 520);
                    }
                } else {
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                        PermissionUtils.requestPermission(this, PermissionUtils.CODE_READ_EXTERNAL_STORAGE, mPermissionGrant);
                    } else {
                        MultiImageSelector selector = MultiImageSelector.create(ModifyDataActivity.this);
                        selector.showCamera(true);
                        selector.count(9);
                        selector.single();
                        selector.origin(mSelectPath);
                        selector.start(ModifyDataActivity.this, 520);
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
                    MultiImageSelector selector = MultiImageSelector.create(ModifyDataActivity.this);
                    selector.showCamera(true);
                    selector.count(9);
                    selector.single();
                    selector.origin(mSelectPath);
                    selector.start(ModifyDataActivity.this, 520);
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
//                    finish();
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

    protected void ChangeProfile(final UserProfileEntity entity) {// 提交用户信息
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean isSuccess = AppContext.getCurrent().getUserAuthentication().changeProfile(entity);
                return isSuccess;
            }

            @Override
            protected void onPostExecute(Boolean isSuccess) {
                dialog.dismiss();
                if (isSuccess) {
                    ToastUtil.showInfo("修改成功");
                    setResult(RESULT_OK);
                    finish();
                } else {
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
