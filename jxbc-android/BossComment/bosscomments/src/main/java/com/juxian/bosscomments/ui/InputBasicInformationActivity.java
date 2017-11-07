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
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.BizDictEntity;
import com.juxian.bosscomments.models.CompanyAuditEntity;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.ImageBucket;
import com.juxian.bosscomments.modules.DictionaryPool;
import com.juxian.bosscomments.repositories.CompanyRepository;
import com.juxian.bosscomments.repositories.UserRepository;
import com.juxian.bosscomments.utils.AlbumHelper;
import com.juxian.bosscomments.utils.Bimp;
import com.juxian.bosscomments.utils.PermissionUtils;
import com.juxian.bosscomments.utils.checkSelfPermissionUtils;
import com.juxian.bosscomments.widget.VoicePopupWindow;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;
import com.pl.wheelview.WheelView;

import net.juxian.appgenome.ActivityManager;
import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.ImageUtils;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import org.xutils.image.ImageOptions;
import org.xutils.x;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Timer;

import butterknife.BindView;
import butterknife.ButterKnife;
import me.nereo.multi_image_selector.MultiImageSelector;

/**
 * @version 1.0
 * @author: 张振清
 * @类 说 明:填写企业信息
 * @创建时间：2015-8-31 下午1:55:35
 */
@TargetApi(16)
public class InputBasicInformationActivity extends BaseActivity implements OnClickListener {

    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.input_company_abbreviation_name)
    EditText mInputCompanyShortName;//
    @BindView(R.id.select_company_industry)
    TextView mCompanyIndustry;
    @BindView(R.id.select_company_scale)
    TextView mCompanyScale;
    @BindView(R.id.select_company_city)
    TextView mCompanyCity;
    @BindView(R.id.company_name_text)
    EditText mCompanyName;
    @BindView(R.id.include_button_button)
    Button btnSubmit;
    @BindView(R.id.phone_number)
    RelativeLayout mSelectCompanyScale;
    @BindView(R.id.leader_name)
    RelativeLayout mSelectCompanyIndestry;
    @BindView(R.id.company_in_city)
    RelativeLayout mSelectCompanyCity;

    final int MIN_LENGTH = 6;
    @BindView(R.id.view)
    View view_line;
    @BindView(R.id.view1)
    View view_line1;
    @BindView(R.id.scrollview)
    ScrollView scrollview;
    @BindView(R.id.company_business_license_picture)
    ImageView mShowPicture;
    @BindView(R.id.add_company_business_license_picture)
    ImageView mAddPicture;
    @BindView(R.id.delete)
    ImageView mDelete;
    @BindView(R.id.need_help)
    TextView need_help;
    @BindView(R.id.add_hint)
    RelativeLayout mAddHint;
    @BindView(R.id.reject_hint_text)
    TextView mRejectHintText;
    private InputMethodManager manager;
    private String path;
    private long CompanyId;
    private String mCompanyCityCode;

    private ArrayList<String> mAllScaleTagText;
    private ArrayList<String> mAllScaleTagCode;

    private String mDefaultScaleCode;
    private String mOldCompanyName;
    private String mCompanyAuditStatus;
    private CompanyAuditEntity mCompanyAuditEntity;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions optionsPhoto = Global.Constants.DEFAULT_LOAD_PIC_OPTIONS;
    private ArrayList<String> mSelectPath;
    private ImageOptions xUtilsOptions = new ImageOptions.Builder().build();


    public int getContentViewId() {
        return R.layout.activity_input_basic_information;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        getWindow().setSoftInputMode(
                WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
        ButterKnife.bind(this);

        manager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
        initViewsData();

        initListener();
        initLine();
        setSystemBarTintManager(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.company_authentication));
        btnSubmit.setText(getString(R.string.next_step));

        back.setVisibility(View.GONE);

        mAllScaleTagText = new ArrayList<>();
        mAllScaleTagCode = new ArrayList<>();
//        OpenEnterpriseRequestEntity entity = JsonUtil.ToEntity(getIntent().getStringExtra("OpenEnterpriseRequestEntity"), OpenEnterpriseRequestEntity.class);
        mOldCompanyName = getIntent().getStringExtra("Company");
        mCompanyName.setText(mOldCompanyName);
        mCompanyName.setSelection(mOldCompanyName.length());
        CompanyId = Long.parseLong(getIntent().getStringExtra("CompanyId"));
        mCompanyAuditStatus = getIntent().getStringExtra("AuditStatus");
        getTags();
        if ("9".equals(mCompanyAuditStatus)) {
            mAddHint.setVisibility(View.VISIBLE);
            getRejectCompanyInfo(CompanyId);
        }
        if (ImageUtils.saveFilePaths.size() != 0) {
            ImageUtils.saveFilePaths.clear();
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        btnSubmit.setOnClickListener(this);
        mSelectCompanyScale.setOnClickListener(this);
        mSelectCompanyIndestry.setOnClickListener(this);
        mSelectCompanyCity.setOnClickListener(this);
        mAddPicture.setOnClickListener(this);
        mShowPicture.setOnClickListener(this);
        mDelete.setOnClickListener(this);
        need_help.setOnClickListener(this);
        scrollview.setOnTouchListener(new View.OnTouchListener() {

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                // TODO Auto-generated method stub
                Global.CloseKeyBoard(mInputCompanyShortName);
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
        params1.rightMargin = ((width2 - 2 * dp2px(22)) / 8) * 5 + dp2px(22);
        view_line1.setVisibility(View.VISIBLE);
        view_line1.setBackgroundColor(getResources().getColor(R.color.luxury_gold_color));
        view_line1.setLayoutParams(params1);
    }

    /**
     * 点击空白区域去除软键盘
     */
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
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
//            if (System.currentTimeMillis() - exitTime > 2000) {
//                ToastUtil.showInfo(this.getResources().getString(
//                        R.string.app_exit_confirm));
//                exitTime = System.currentTimeMillis();
//            } else {
                ActivityManager.finishAll();
                this.finish();

//            }
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:// 返回
                finish();
                break;
            case R.id.include_button_button:// 注册完成
                if (TextUtils.isEmpty(mCompanyName.getText().toString().trim())) {
                    ToastUtil.showInfo(getString(R.string.please_company_full_name));
                    mCompanyName.requestFocus();
                    return;
                }
                if (mCompanyName.getText().toString().trim().length() > 30) {
                    ToastUtil.showInfo(getString(R.string.full_company_name_length_limit));
                    mCompanyName.requestFocus();
                    return;
                }
                if (TextUtils.isEmpty(mInputCompanyShortName.getText().toString().trim())) {
                    ToastUtil.showInfo(getString(R.string.company_abbreviation));
                    mInputCompanyShortName.requestFocus();
                    return;
                }
                if (mInputCompanyShortName.getText().toString().trim().length() > 10) {
                    ToastUtil.showInfo(getString(R.string.company_name_length_below_ten));
                    mInputCompanyShortName.requestFocus();
                    return;
                }
                if (TextUtils.isEmpty(mCompanyIndustry.getText().toString())) {
                    ToastUtil.showInfo(getString(R.string.please_select_company_industry));
                    return;
                }
                if (TextUtils.isEmpty(mCompanyScale.getText().toString())) {
                    ToastUtil.showInfo(getString(R.string.company_scale_not_empty));
                    return;
                }
                if (TextUtils.isEmpty(mCompanyCity.getText().toString())) {
                    ToastUtil.showInfo(getString(R.string.company_in_city_not_empty));
                    return;
                }
                if (TextUtils.isEmpty(path)) {
                    ToastUtil.showInfo(getString(R.string.please_upload_business_license_picture));
                    return;
                }
                if (mOldCompanyName.equals(mCompanyName.getText().toString().trim())) {
                    CompanyAuditEntity entity = null;
                    if ("9".equals(mCompanyAuditStatus)) {
                        entity = mCompanyAuditEntity;
                    } else {
                        entity = new CompanyAuditEntity();
                        entity.CompanyId = CompanyId;
                        entity.Company = new CompanyEntity();
                    }
                    entity.Company.CompanyName = mCompanyName.getText().toString().trim();
                    entity.Company.CompanyAbbr = mInputCompanyShortName.getText().toString().trim();
                    entity.Company.Industry = mCompanyIndustry.getText().toString();
                    entity.Company.CompanySize = mDefaultScaleCode;
                    entity.Company.Region = mCompanyCityCode;
                    entity.Company.CompanyId = CompanyId;
                    entity.Licence = path;
                    Intent toRequest = new Intent(getApplicationContext(), LegalPersonInformationActivity.class);
                    toRequest.putExtra("CompanyAuditEntity", JsonUtil.ToJson(entity));
                    startActivityForResult(toRequest, 100);
                } else {
                    showDialog();
                }
                break;
            case R.id.leader_name:
                Intent toSelectIndustry = new Intent(getApplicationContext(), EditIndustryLableActivity.class);
                startActivityForResult(toSelectIndustry, 200);
                break;
            case R.id.phone_number:
                if (mAllScaleTagText.size()>0){
                    int defaultSelect = 0;
                    if (TextUtils.isEmpty(mCompanyScale.getText().toString())){
                        defaultSelect = 0;
                    } else {
                        for (int i=0;i<mAllScaleTagText.size();i++){
                            if (mCompanyScale.getText().toString().equals(mAllScaleTagText.get(i))){
                                defaultSelect = i;
                            }
                        }
                    }
                    showSelectScaleDialog(mAllScaleTagText,defaultSelect);
                }
                break;
            case R.id.company_in_city:
                Intent toSelectCity = new Intent(getApplicationContext(), SelectCityActivity.class);
                startActivityForResult(toSelectCity, 400);
                break;
            case R.id.company_business_license_picture:
                // 点击查看大图
                Intent ShowBigImg = new Intent(getApplicationContext(), ShowBigImgActivity.class);
                ArrayList<String> Images = new ArrayList<>();
                Images.add(path);
                ShowBigImg.putExtra("ImageUrls", Images);
                ShowBigImg.putExtra("index", 0);
                startActivity(ShowBigImg);
                break;
            case R.id.add_company_business_license_picture:
                // 添加营业执照图片
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
//                        Intent ChangeAvatar1 = new Intent(getApplicationContext(), ImageGridActivity.class);
//                        ChangeAvatar1.putExtra("NetPic", 0);
//                        ChangeAvatar1.putExtra("Tag", "shortvideo");
//                        startActivityForResult(ChangeAvatar1, 520);
                        MultiImageSelector selector = MultiImageSelector.create(InputBasicInformationActivity.this);
                        selector.showCamera(true);
                        selector.count(1);
//                        if (mChoiceMode.getCheckedRadioButtonId() == R.id.single) {
//                        selector.single();
//                        } else {
                        selector.multi();
//                        }
                        selector.origin(mSelectPath);
                        selector.start(InputBasicInformationActivity.this, 520);
                    }
                } else {
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                        PermissionUtils.requestPermission(this, PermissionUtils.CODE_READ_EXTERNAL_STORAGE, mPermissionGrant);
                    } else {
//                        Intent ChangeAvatar1 = new Intent(getApplicationContext(), ImageGridActivity.class);
//                        ChangeAvatar1.putExtra("NetPic", 0);
//                        ChangeAvatar1.putExtra("Tag", "shortvideo");
//                        startActivityForResult(ChangeAvatar1, 520);
                        MultiImageSelector selector = MultiImageSelector.create(InputBasicInformationActivity.this);
                        selector.showCamera(true);
                        selector.count(1);
//                        if (mChoiceMode.getCheckedRadioButtonId() == R.id.single) {
//                        selector.single();
//                        } else {
                        selector.multi();
//                        }
                        selector.origin(mSelectPath);
                        selector.start(InputBasicInformationActivity.this, 520);
                    }
                }
                break;
            case R.id.delete:
                path = null;
//                if (Bimp.drr.size() != 0) {
//                    Bimp.drr.clear();
//                }
                if (mSelectPath != null) {
                    if (mSelectPath.size() != 0) {
                        mSelectPath.clear();
                    }
                }
                mShowPicture.setVisibility(View.GONE);
                mDelete.setVisibility(View.GONE);
                mAddPicture.setVisibility(View.VISIBLE);
                break;
            case R.id.need_help:
                Intent intent = new Intent(getApplicationContext(),AboutUsActivity.class);
                intent.putExtra("ShowType","NeedHelp");
                startActivity(intent);
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
//                    Intent ChangeAvatar1 = new Intent(getApplicationContext(), ImageGridActivity.class);
//                    ChangeAvatar1.putExtra("NetPic", 0);
//                    ChangeAvatar1.putExtra("Tag", "shortvideo");
//                    startActivityForResult(ChangeAvatar1, 520);
                    MultiImageSelector selector = MultiImageSelector.create(InputBasicInformationActivity.this);
                    selector.showCamera(true);
                    selector.count(1);
//                        if (mChoiceMode.getCheckedRadioButtonId() == R.id.single) {
//                        selector.single();
//                        } else {
                    selector.multi();
//                        }
                    selector.origin(mSelectPath);
                    selector.start(InputBasicInformationActivity.this, 520);
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
    public void onBackPressed() {
        for (int i = 0; i < ImageUtils.saveFilePaths.size(); i++) {
            File imageFile = new File(ImageUtils.saveFilePaths.get(i));
            if (imageFile.exists()) {
                imageFile.delete();
            }
        }
        ImageUtils.saveFilePaths.clear();
        super.onBackPressed();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 100:
                if (resultCode == RESULT_OK) {
//                    setResult(RESULT_OK);
                    finish();
                }
                break;
            case 200:
                // 选择行业
                if (resultCode == RESULT_OK) {
                    mCompanyIndustry.setText(data.getStringExtra("industry"));
                }
                break;
            case 300:
                if (resultCode == RESULT_OK) {
                    mCompanyScale.setText(data.getStringExtra("CompanyScale"));
                }
                break;
            case 400:
                // 选择城市
                if (resultCode == RESULT_OK) {
                    mCompanyCity.setText(data.getStringExtra("city"));
                    mCompanyCityCode = data.getStringExtra("CityCode");
                }
                break;
            case 520:
                if (requestCode == 520 && resultCode == RESULT_OK) {
                    mSelectPath = data.getStringArrayListExtra(MultiImageSelector.EXTRA_RESULT);
//                    if (ImageUtils.saveFilePaths.size() > 0) {
//                        path = ImageUtils.saveFilePaths.get(0);
                        path = mSelectPath.get(0);
//                        Bitmap bitmap = BitmapFactory.decodeFile(ImageUtils.saveFilePaths.get(0));
//                        Bitmap bitmap = BitmapFactory.decodeFile(path);
                        x.image().bind(mShowPicture, path, xUtilsOptions);
                        mShowPicture.setVisibility(View.VISIBLE);
                        mDelete.setVisibility(View.VISIBLE);
//                        mShowPicture.setImageBitmap(bitmap);
                        mAddPicture.setVisibility(View.GONE);
//                    }
                }
                break;
            default:
                break;
        }
    }

    @Override
    protected void onResume() {
        // TODO Auto-generated method stub
        super.onResume();
    }

    public void showSelectScaleDialog(ArrayList<String> datas, int defaultSelect) {
        final Dialog dl = new Dialog(this);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(true);
        View dialog_view = View.inflate(getApplicationContext(), R.layout.advertise_one_wheelview, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        setWindowParams(dialogWindow);
        dl.show();
        final WheelView mScaleWheelView = (WheelView) dialog_view.findViewById(R.id.experience_required);
        TextView mBtnConfirm = (TextView) dialog_view.findViewById(R.id.btn_confirm);
        TextView cancel = (TextView) dialog_view.findViewById(R.id.cancel);
        TextView start_time = (TextView) dialog_view.findViewById(R.id.start_time);
        start_time.setText("选择规模");
        cancel.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
            }
        });
        mBtnConfirm.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                mCompanyScale.setText(mScaleWheelView.getSelectedText());
                mDefaultScaleCode = mAllScaleTagCode.get(mScaleWheelView.getSelected());
                dl.dismiss();
            }
        });
        mScaleWheelView.setCyclic(false);
        mScaleWheelView.setData(datas);
        mScaleWheelView.setDefault(defaultSelect);
    }

    public void checkCompanyName(final String CompanyName) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean resultEntity = UserRepository.checkCompanyName(CompanyName);
                return resultEntity;
            }

            @Override
            protected void onPostExecute(Boolean result) {
                if (dialog != null)
                    dialog.dismiss();
                if (!result) {
                    CompanyAuditEntity entity = new CompanyAuditEntity();
                    if ("9".equals(mCompanyAuditStatus)) {
                        entity = mCompanyAuditEntity;
                    } else {
                        entity.CompanyId = CompanyId;
                        entity.Company = new CompanyEntity();
                    }
                    entity.Company.CompanyName = mCompanyName.getText().toString().trim();
                    entity.Company.CompanyAbbr = mInputCompanyShortName.getText().toString().trim();
                    entity.Company.Industry = mCompanyIndustry.getText().toString();
                    entity.Company.CompanySize = mDefaultScaleCode;
                    entity.Company.Region = mCompanyCityCode;
                    entity.Company.CompanyId = CompanyId;
                    entity.Licence = path;
                    Intent toRequest = new Intent(getApplicationContext(), LegalPersonInformationActivity.class);
                    if ("9".equals(mCompanyAuditStatus)) {
                        toRequest.putExtra("RejectAudit", "RejectAudit");
                    }
                    toRequest.putExtra("CompanyAuditEntity", JsonUtil.ToJson(entity));
                    startActivityForResult(toRequest, 100);
                } else {
                    ToastUtil.showInfo(getString(R.string.company_already_exist));
                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    public void getRejectCompanyInfo(final long CompanyId) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<CompanyAuditEntity>() {
            @Override
            protected CompanyAuditEntity doInBackground(Void... params) {
                CompanyAuditEntity resultEntity = CompanyRepository.getRejectCompanyInfo(CompanyId);
                return resultEntity;
            }

            @Override
            protected void onPostExecute(CompanyAuditEntity result) {
                if (dialog != null)
                    dialog.dismiss();
                if (result != null) {
                    mCompanyAuditEntity = result;
                    mOldCompanyName = result.Company.CompanyName;
                    mCompanyName.setText(result.Company.CompanyName);
                    mCompanyName.setSelection(result.Company.CompanyName.length());
                    mInputCompanyShortName.setText(result.Company.CompanyAbbr);
                    mCompanyIndustry.setText(result.Company.Industry);
                    mDefaultScaleCode = result.Company.CompanySize;
                    mCompanyCityCode = result.Company.Region;
                    if (!TextUtils.isEmpty(result.Company.CompanySizeText)) {
                        mCompanyScale.setText(result.Company.CompanySizeText);
                    }
                    if (!TextUtils.isEmpty(result.Company.RegionText)) {
                        mCompanyCity.setText(result.Company.RegionText);
                    }
                    if (!TextUtils.isEmpty(result.RejectReason)){
                        mRejectHintText.setText(result.RejectReason);
                    } else {
                        mAddHint.setVisibility(View.GONE);
                    }
                    path = result.Licence;
                    ImageLoader.getInstance().displayImage(result.Licence, mShowPicture, optionsPhoto, animateFirstListener);
                    mShowPicture.setVisibility(View.VISIBLE);
                    mDelete.setVisibility(View.VISIBLE);
                    mAddPicture.setVisibility(View.GONE);
                } else {
                    ToastUtil.showInfo(getString(R.string.company_already_exist));
                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
            }
        }.execute();
    }

    public void showDialog() {
        final Dialog dl = new Dialog(this);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(false);
        View dialog_view = View.inflate(getApplicationContext(), R.layout.dialog_accredit, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = dp2px(260);
        dialogWindow.setAttributes(lp);
        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dl.show();
        TextView close = (TextView) dialog_view.findViewById(R.id.dialog_tips_cancel);
        close.setText(getString(R.string.remodify_company_name));
        TextView ok = (TextView) dialog_view.findViewById(R.id.dialog_tips_ok);
        TextView content = (TextView) dialog_view.findViewById(R.id.dialog_tips_content);
        content.setText(getString(R.string.remodify_company_name_hint));
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
            }
        });
        ok.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // 判断是否是继续建立档案，是，则继续建立，否则执行其他操作
                checkCompanyName(mCompanyName.getText().toString().trim());
                dl.dismiss();
            }
        });
    }

    public void getTags() {
        new AsyncRunnable<HashMap<String, List<BizDictEntity>>>() {

            @Override
            protected HashMap<String, List<BizDictEntity>> doInBackground(Void... params) {
                HashMap<String, List<BizDictEntity>> entities = DictionaryPool.loadScaleDictionaries();
                return entities;
            }

            @Override
            protected void onPostExecute(HashMap<String, List<BizDictEntity>> entities) {
                if (entities != null) {
                    if (entities.size() != 0) {
                        List<BizDictEntity> bizDictEntities = entities.get(DictionaryPool.Code_CompanySize);
                        for (int i=0;i<bizDictEntities.size();i++){
                            mAllScaleTagText.add(bizDictEntities.get(i).Name);
                            mAllScaleTagCode.add(bizDictEntities.get(i).Code);
                        }
                    } else {

                    }
                } else {

                }

            }

            protected void onPostError(Exception ex) {
            }

        }.execute();
    }
}