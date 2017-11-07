package com.juxian.bosscomments.ui;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.AccountSignResult;
import com.juxian.bosscomments.models.CompanyAuditEntity;
import com.juxian.bosscomments.models.ImageBucket;
import com.juxian.bosscomments.models.ResultEntity;
import com.juxian.bosscomments.presenter.CompanyAuthenticationPresenter;
import com.juxian.bosscomments.presenter.CompanyAuthenticationPresenterImpl;
import com.juxian.bosscomments.utils.AlbumHelper;
import com.juxian.bosscomments.utils.Bimp;
import com.juxian.bosscomments.utils.PermissionUtils;
import com.juxian.bosscomments.utils.checkSelfPermissionUtils;
import com.juxian.bosscomments.view.CompanyAuthenticationView;
import com.juxian.bosscomments.view.LoadValidationCodeView;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.utils.ImageUtil;
import net.juxian.appgenome.utils.ImageUtils;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import org.xutils.image.ImageOptions;
import org.xutils.x;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import butterknife.BindView;
import butterknife.ButterKnife;
import me.nereo.multi_image_selector.MultiImageSelector;

/**
 * Created by nene on 2016/10/17.
 *
 * @ProjectName: [LaoBanDianPing]
 * @Package: [com.juxian.bosscomments.ui]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/17 14:48]
 * @Version: [v1.0]
 */
@TargetApi(16)
public class LegalPersonInformationActivity extends RemoteDataActivity implements View.OnClickListener,CompanyAuthenticationView,LoadValidationCodeView {

    private InputMethodManager manager;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_button_button)
    Button btnSubmit;
    @BindView(R.id.add_positive_photo)
    ImageView add_positive_photo;
    @BindView(R.id.view)
    View view_line;
    @BindView(R.id.view1)
    View view_line1;
    @BindView(R.id.upload_legal_person)
    ImageView upload_legal_person;
    @BindView(R.id.upload_legal_person_picture_text)
    TextView upload_legal_person_picture_text;
    @BindView(R.id.input_leader_name)
    EditText input_leader_name;
    @BindView(R.id.input_your_phone)
    EditText input_your_phone;
    @BindView(R.id.input_validation_code)
    EditText input_validation_code;
    @BindView(R.id.setting_password_timers)
    TextView register_timers;// 获取验证码
    @BindView(R.id.legal_person_picture)
    RelativeLayout mLegalPersonPicture;
    @BindView(R.id.legal_person_picture1)
    RelativeLayout mLegalPersonPicture1;
    @BindView(R.id.company_business_license_picture)
    ImageView mLegalPersonPositive;
    @BindView(R.id.company_business_license_picture1)
    ImageView mLegalPersonContrary;
    @BindView(R.id.delete)
    ImageView mDeletePositive;
    @BindView(R.id.delete1)
    ImageView mDeleteContrary;
    @BindView(R.id.scrollview)
    ScrollView scrollview;
//    private String mImageUrl;
    private List<String> imgs;
    private ArrayList<String> changeImgs;
    private ValidationTimer validationTimer;
    private Dialog mValidationCodeDialog;
    private List<RelativeLayout> mLegalPersonPictures;
    private List<ImageView> mLegalPersons;
    private List<ImageView> mDeletePictures;
    private CompanyAuthenticationPresenter mCompanyAuthenticationPresenter;
    private Dialog mSignUpDialog;
    private CompanyAuditEntity entity;
    private String Licence;
    private int AuditStatus;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions optionsPhoto = Global.Constants.DEFAULT_LOAD_PIC_OPTIONS;
    private ArrayList<String> mSelectPath;
    private ImageOptions xUtilsOptions = new ImageOptions.Builder().build();

    @Override
    public int getContentViewId() {
        return R.layout.activity_legal_person_information;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        IsInitData = true;
        title.setText(getString(R.string.company_authentication));
        btnSubmit.setText(getString(R.string.submit_check));
        if (Bimp.drr.size() != 0) {
            Bimp.drr.clear();
        }
        if (ImageUtils.saveFilePaths.size()!=0) {
            ImageUtils.saveFilePaths.clear();
        }
        imgs = new ArrayList<>();
        changeImgs = new ArrayList<>();
//        back.setVisibility(View.GONE);
        validationTimer = new ValidationTimer(120, 1);
        mLegalPersonPictures = new ArrayList<>();
        mLegalPersonPictures.add(mLegalPersonPicture);
        mLegalPersonPictures.add(mLegalPersonPicture1);
        mLegalPersons = new ArrayList<>();
        mLegalPersons.add(mLegalPersonPositive);
        mLegalPersons.add(mLegalPersonContrary);
        mDeletePictures = new ArrayList<>();
        mDeletePictures.add(mDeletePositive);
        mDeletePictures.add(mDeleteContrary);
        mCompanyAuthenticationPresenter = new CompanyAuthenticationPresenterImpl(getApplicationContext(),this,this);
        entity = JsonUtil.ToEntity(getIntent().getStringExtra("CompanyAuditEntity"),CompanyAuditEntity.class);
        AuditStatus = entity.AuditStatus;
        if (AuditStatus == 9){
            input_leader_name.setText(entity.Company.LegalName);
            input_leader_name.setSelection(entity.Company.LegalName.length());
            input_your_phone.setText(entity.MobilePhone);
            if (entity.Images != null) {
                for (int i = 0; i < entity.Images.length; i++) {
                    imgs.add(entity.Images[i]);
                    changeImgs.add(entity.Images[i]);
                }
                setImageVisible(imgs);
            }
        }
        Licence = entity.Licence;
    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);
        manager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
        initViewsData();
        initListener();
        initLine();
        setSystemBarTintManager(this, R.color.main_color);
    }

    @Override
    public void loadPageData() {

    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        btnSubmit.setOnClickListener(this);
        register_timers.setOnClickListener(this);
        add_positive_photo.setOnClickListener(this);
        mDeletePositive.setOnClickListener(this);
        mDeleteContrary.setOnClickListener(this);
        mLegalPersonPositive.setOnClickListener(this);
        mLegalPersonContrary.setOnClickListener(this);
        scrollview.setOnTouchListener(new View.OnTouchListener() {

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                // TODO Auto-generated method stub
                Global.CloseKeyBoard(input_leader_name);
                return false;
            }
        });
    }

    public void initLine() {
        WindowManager manager = this.getWindowManager();
        DisplayMetrics outMetrics = new DisplayMetrics();
        manager.getDefaultDisplay().getMetrics(outMetrics);
        int width2 = outMetrics.widthPixels;
        int height2 = outMetrics.heightPixels;
        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, 2);
        params.leftMargin = (width2 - 2 * dp2px(22)) / 8 + dp2px(22);
        params.rightMargin = (width2 - 2 * dp2px(22)) / 8 + dp2px(22);
        params.topMargin = dp2px(11);
        view_line.setBackgroundColor(getResources().getColor(R.color.list_color));
        view_line.setLayoutParams(params);

        RelativeLayout.LayoutParams params1 = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, 2);
        params1.leftMargin = (width2 - 2 * dp2px(22)) / 8 + dp2px(22);
        params1.topMargin = dp2px(11);
        params1.rightMargin = ((width2 - 2 * dp2px(22)) / 8) * 3 + dp2px(22);
        view_line1.setVisibility(View.VISIBLE);
        view_line1.setBackgroundColor(getResources().getColor(R.color.luxury_gold_color));
        view_line1.setLayoutParams(params1);

        upload_legal_person.setImageResource(R.drawable.shape_become_cc_red);
        upload_legal_person_picture_text.setTextColor(getResources().getColor(R.color.luxury_gold_color));
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
    public void onClick(View v) {
        Matcher m1 = Pattern.compile("^1\\d{10}$").matcher(input_your_phone.getText().toString());
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                finish();
                break;
            case R.id.setting_password_timers:// 获取验证码
                if (TextUtils.isEmpty(input_your_phone.getText().toString())){
                    ToastUtil.showInfo(getString(R.string.mobile_phone_is_empty));
                    input_your_phone.requestFocus();
                    return;
                }
                if (!m1.matches() || input_your_phone.getText().toString().length() != 11) {
                    // txtRegisterPhone.requestFocus();
                    ToastUtil.showError(getString(R.string.phone_pattern_false));
                } else if (false == validationTimer.isRunning) {
//                    loadValidationCode();
                    mCompanyAuthenticationPresenter.loadValidationCode(input_your_phone.getText().toString().trim());
                    input_validation_code.setText("");
                    input_validation_code.setFocusable(true);
                } else {
                    break;
                }
                break;
            case R.id.include_button_button:
                if (TextUtils.isEmpty(input_leader_name.getText().toString())) {
                    ToastUtil.showInfo(getString(R.string.please_input_legal_person_name));
                    input_leader_name.requestFocus();
                    return;
                }
                if (input_leader_name.getText().toString().trim().length() > 5) {
                    ToastUtil.showInfo(getString(R.string.legal_person_name_length_limit));
                    input_leader_name.requestFocus();
                    return;
                }
                if (TextUtils.isEmpty(input_your_phone.getText().toString())) {
                    ToastUtil.showInfo(getString(R.string.mobile_phone_is_empty));
                    input_your_phone.requestFocus();
                    return;
                }
                if (!m1.matches() || input_your_phone.getText().toString().length() != 11) {
                    ToastUtil.showInfo(getString(R.string.phone_pattern_false));
                    input_your_phone.requestFocus();
                    return;
                }
                if (input_validation_code.getText().toString().length() == 0) {
                    ToastUtil.showInfo(getString(R.string.please_input_validation_code));
                    input_validation_code.requestFocus();
                    return;
                }
//                if (imgs.size() < 2) {
//                    ToastUtil.showInfo(getString(R.string.please_upload_identity_card_picture));
//                    return;
//                }
                entity.Company.LegalName = input_leader_name.getText().toString().trim();
                entity.MobilePhone = input_your_phone.getText().toString().trim();
                entity.ValidationCode = input_validation_code.getText().toString().trim();
//                Log.e(Global.LOG_TAG,entity.toString());
//                entity.Images = new String[imgs.size()];
//                if (Licence.startsWith("http://")){
//                    entity.Licence = Licence;
//                } else {
//                    entity.Licence = ImageUtil.toUploadBase64(Licence);
//                }
//                for (int i = 0; i < imgs.size(); i++) {
//                    if (imgs.get(i).startsWith("http://")){
//                        entity.Images[i] = imgs.get(i);
//                    } else {
//                        entity.Images[i] = ImageUtil.toUploadBase64(imgs.get(i));
//                    }
//                }
                mCompanyAuthenticationPresenter.submitAuthentication(Licence,changeImgs,mSelectPath,entity);
                break;
            case R.id.add_positive_photo:
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
//                        Intent add_photo = new Intent(getApplicationContext(), ImageGridActivity.class);
//                        if (AuditStatus == 9){
//                            add_photo.putExtra("NetPic", changeImgs.size());
//                        }
//                        add_photo.putExtra("Tag", "two");
//                        startActivityForResult(add_photo, 520);
                        MultiImageSelector selector = MultiImageSelector.create(LegalPersonInformationActivity.this);
                        selector.showCamera(true);
                        if (AuditStatus == 9){
                            selector.count(2-changeImgs.size());
                        } else {
                            selector.count(2);
                        }
                        selector.multi();
                        selector.origin(mSelectPath);
                        selector.start(LegalPersonInformationActivity.this, 520);
                    }
                } else {
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                        PermissionUtils.requestPermission(this, PermissionUtils.CODE_READ_EXTERNAL_STORAGE, mPermissionGrant);
                    } else {
//                        Intent add_photo = new Intent(getApplicationContext(), ImageGridActivity.class);
//                        if (AuditStatus == 9){
//                            add_photo.putExtra("NetPic", changeImgs.size());
//                        }
//                        add_photo.putExtra("Tag", "two");
//                        startActivityForResult(add_photo, 520);
                        MultiImageSelector selector = MultiImageSelector.create(LegalPersonInformationActivity.this);
                        selector.showCamera(true);
                        if (AuditStatus == 9){
                            selector.count(2-changeImgs.size());
                        } else {
                            selector.count(2);
                        }
                        selector.multi();
                        selector.origin(mSelectPath);
                        selector.start(LegalPersonInformationActivity.this, 520);
                    }
                }
                break;
            case R.id.delete:
                String deletePath = imgs.get(0);
                if (changeImgs.size() > 0) {
                    for (int i = 0; i < changeImgs.size(); i++) {
                        if (deletePath.equals(changeImgs.get(i))) {
                            changeImgs.remove(i);
                        }
                    }
                }
                if (mSelectPath != null) {
                    if (mSelectPath.size() > 0) {
                        for (int i = 0; i < mSelectPath.size(); i++) {
                            if (deletePath.equals(mSelectPath.get(i))) {
//                    Bimp.drr.remove(i);
                                mSelectPath.remove(i);
                            }
                        }
                    }
                }
                imgs.remove(0);
                add_positive_photo.setVisibility(View.VISIBLE);
                setImageVisible(imgs);
                break;
            case R.id.delete1:
                String deletePath1 = imgs.get(1);
                if (changeImgs.size() > 0) {
                    for (int i = 0; i < changeImgs.size(); i++) {
                        if (deletePath1.equals(changeImgs.get(i))) {
                            changeImgs.remove(i);
                        }
                    }
                }
                if (mSelectPath != null) {
                    if (mSelectPath.size() > 0) {
                        for (int i = 0; i < mSelectPath.size(); i++) {
                            if (deletePath1.equals(mSelectPath.get(i))) {
//                    Bimp.drr.remove(i);
                                mSelectPath.remove(i);
                            }
                        }
                    }
                }
                imgs.remove(1);
                add_positive_photo.setVisibility(View.VISIBLE);
                setImageVisible(imgs);
                break;
            case R.id.company_business_license_picture:
                Intent ShowBigImg = new Intent(getApplicationContext(),ShowBigImgActivity.class);
                ArrayList<String> Images = new ArrayList<>();
                Images.addAll(imgs);
                ShowBigImg.putExtra("ImageUrls",Images);
                ShowBigImg.putExtra("index",0);
                startActivity(ShowBigImg);
                break;
            case R.id.company_business_license_picture1:
                Intent ShowBigImg1 = new Intent(getApplicationContext(),ShowBigImgActivity.class);
                ArrayList<String> Images1 = new ArrayList<>();
                Images1.addAll(imgs);
                ShowBigImg1.putExtra("ImageUrls",Images1);
                ShowBigImg1.putExtra("index",1);
                startActivity(ShowBigImg1);
                break;
            default:
                break;
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
//                    Intent add_photo = new Intent(getApplicationContext(), ImageGridActivity.class);
//                    if (AuditStatus == 9){
//                        add_photo.putExtra("NetPic", changeImgs.size());
//                    }
//                    add_photo.putExtra("Tag", "two");
//                    startActivityForResult(add_photo, 520);
                    MultiImageSelector selector = MultiImageSelector.create(LegalPersonInformationActivity.this);
                    selector.showCamera(true);
                    if (AuditStatus == 9){
                        selector.count(2-changeImgs.size());
                    } else {
                        selector.count(2);
                    }
                    selector.multi();
                    selector.origin(mSelectPath);
                    selector.start(LegalPersonInformationActivity.this, 520);
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
                    mSelectPath = data.getStringArrayListExtra(MultiImageSelector.EXTRA_RESULT);
                    imgs.clear();
                    if (changeImgs.size() > 0) {
                        imgs.addAll(changeImgs);
                    }
                    imgs.addAll(mSelectPath);
//                    imgs.addAll(ImageUtils.saveFilePaths);
                    setImageVisible(imgs);
                }
                break;
            case 200:
                if (resultCode == RESULT_OK) {
                    setResult(RESULT_OK);
                    finish();
                }
                break;
        }
    }

    @Override
    public void onBackPressed() {
        for (int i=0;i<ImageUtils.saveFilePaths.size();i++){
            File imageFile = new File(ImageUtils.saveFilePaths.get(i));
            if (imageFile.exists()){
                imageFile.delete();
            }
        }
        ImageUtils.saveFilePaths.clear();
        super.onBackPressed();
    }

    @Override
    protected void onDestroy() {
        if (Bimp.drr.size() != 0) {
            Bimp.drr.clear();
        }
        super.onDestroy();
    }

    @Override
    public void returnLoadValidationCode(Integer result) {
        if (result == AccountSignResult.DUPLICATE_MOBILEPHONE) {
//            ToastUtil.showError(getString(R.string.the_phone_has_already_been_registered));
            // 在获取验证码的时候就可以知道该手机号是否已经注册
//            DialogUtils.showProgresbarDialog(LegalPersonInformationActivity.this);
//            validationTimer.reset();
        } else {
//            onRemoteError();
        }
    }

    @Override
    public void returnLoadValidationCodeFailure(String msg, Exception e) {
        onRemoteError();
    }

    @Override
    public void showLoadValidationCodeProgress() {
        mValidationCodeDialog = DialogUtil.showLoadingDialog();
        validationTimer.start();
    }

    @Override
    public void hideLoadValidationCodeProgress() {
        if (mValidationCodeDialog != null)
            mValidationCodeDialog.dismiss();
    }

    /**
     * @author 付晓龙
     * @ClassName: ValidationTimer
     * @说明:点击获取验证码计算时间
     * @date 2015-9-1 下午1:34:39
     */
    class ValidationTimer extends CountDownTimer {
        private boolean isRunning = false;

        public ValidationTimer(long millisInFuture, long countDownInterval) {
            super(millisInFuture * 1000, countDownInterval * 1000);
        }

        @Override
        public void onFinish() {
            register_timers.setBackground(getResources().getDrawable(
                    R.drawable.verification_code_bg));
            register_timers.setTextColor(getResources().getColor(R.color.luxury_gold_color));
            register_timers.setText(getString(R.string.again_get_validation_code));
            this.isRunning = false;
        }

        @Override
        public void onTick(long millisUntilFinished) {
            this.isRunning = true;
            register_timers.setText(String.format("获取%sS",
                    millisUntilFinished / 1000));
            register_timers.setBackground(getResources().getDrawable(
                    R.drawable.verification_code_gray_bg));
            register_timers.setTextColor(getResources().getColor(R.color.boss_circle_send));
        }

        public void reset() {
            this.cancel();
            this.onFinish();
        }
    }

    public void setImageVisible(List<String> saveFilePaths){
        for (int i=0;i<saveFilePaths.size();i++){
            mLegalPersonPictures.get(i).setVisibility(View.VISIBLE);
            mLegalPersons.get(i).setVisibility(View.VISIBLE);
            mDeletePictures.get(i).setVisibility(View.VISIBLE);
            if (saveFilePaths.get(i).startsWith("http://")){
                ImageLoader.getInstance().displayImage(saveFilePaths.get(i),mLegalPersons.get(i),optionsPhoto,animateFirstListener);
            } else {
                x.image().bind(mLegalPersons.get(i), saveFilePaths.get(i), xUtilsOptions);
//                Bitmap bitmap = BitmapFactory.decodeFile(saveFilePaths.get(i));
//                mLegalPersons.get(i).setImageBitmap(bitmap);
            }
        }
        for (int j=saveFilePaths.size();j<2;j++){
            mLegalPersonPictures.get(j).setVisibility(View.GONE);
            mLegalPersons.get(j).setVisibility(View.GONE);
            mDeletePictures.get(j).setVisibility(View.GONE);
        }
        if (saveFilePaths.size()<2){
            add_positive_photo.setVisibility(View.VISIBLE);
        } else {
            add_positive_photo.setVisibility(View.GONE);
        }
    }

    @Override
    public void CompanyAuthenticationSignResult(ResultEntity resultEntity) {
        if (resultEntity != null){
            if (resultEntity.Success) {
                for (int i = 0; i < imgs.size(); i++) {
                    File imageFile = new File(imgs.get(i));
                    if (imageFile.exists()) {
                        imageFile.delete();
                    }
                }
                File imageFile1 = new File(entity.Licence);
                if (imageFile1.exists()) {
                    imageFile1.delete();
                }
                AppConfig.setCurrentProfileType(2);
                AppConfig.setCurrentUseCompany(entity.Company.CompanyId);
                Intent toSubmited = new Intent(getApplicationContext(), ApplySubmittedActivity.class);
                setResult(RESULT_OK);
                startActivity(toSubmited);
                finish();
            } else {
                ToastUtil.showInfo(resultEntity.ErrorMessage);
            }
        } else {
//            ToastUtil.showInfo("申请失败");
            onRemoteError();
        }
    }

    @Override
    public void CompanyAuthenticationSignResultFailture(String msg, Exception e) {
        onRemoteError();
    }

    @Override
    public void showOpenAccountProgress() {
        mSignUpDialog = DialogUtil.showLoadingDialog();
    }

    @Override
    public void hideOpenAccountProgress() {
        if (mSignUpDialog != null)
            mSignUpDialog.dismiss();
    }
}
