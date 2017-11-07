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
import android.view.Window;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.imageCrop.ui.ImageCropActivity;
import com.juxian.bosscomments.models.BizDictEntity;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.ImageBucket;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.modules.DictionaryPool;
import com.juxian.bosscomments.repositories.CompanyRepository;
import com.juxian.bosscomments.utils.AlbumHelper;
import com.juxian.bosscomments.utils.PermissionUtils;
import com.juxian.bosscomments.utils.SystemBarTintManager;
import com.juxian.bosscomments.utils.checkSelfPermissionUtils;
import com.juxian.bosscomments.widget.RoundAngleImageView;
import com.kankan.wheel.widget.OnWheelChangedListener;
import com.kankan.wheel.widget.WheelView;
import com.kankan.wheel.widget.adapters.ArrayWheelAdapter;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.ImageUtil;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import me.nereo.multi_image_selector.MultiImageSelector;

/**
 * 修改企业信息
 * Created by Tam on 2016/12/10.
 */
public class ModifyCpInfoActivity extends RemoteDataActivity implements View.OnClickListener {

    private InputMethodManager manager;
    @BindView(R.id.back)
    ImageView back;
    @BindView(R.id.photo)
    RelativeLayout mChangeCompanyLogo;
    @BindView(R.id.user_photo)
    RoundAngleImageView mCompanyLogo;
    @BindView(R.id.activity_modify_cp_info_company_whole_name)
    TextView mCompanyName;
    @BindView(R.id.activity_modify_cp_info_name)
    EditText mCompanySimpleName;
    @BindView(R.id.activity_modify_cp_info_field_real)
    TextView mCompanyField;
    @BindView(R.id.activity_modify_cp_info_size_real)
    TextView mCompanySize;
    @BindView(R.id.activity_modify_cp_info_city_real)
    TextView mCompanyCity;
    @BindView(R.id.include_button_button)
    Button mSaveCompanyInfo;
    @BindView(R.id.headcolor)
    View view;
    @BindView(R.id.activity_modify_cp_info_company_field)
    RelativeLayout mChangeCompanyIndustry;
    @BindView(R.id.activity_modify_cp_info_company_size)
    RelativeLayout mChangeCompanySize;
    private SystemBarTintManager tintManager;
    private CompanyEntity mCompanyEntity;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_MY_CENTER_AVATAR_OPTIONS;
    private String mAvatar;
    private String CompanySizeCode;
    private String RegionCode;
    private String CityCode;
    /**
     * 规模
     */
    protected String[] mAllBottomSalary = {"1-49", "50-99", "100-499", "500-999", "1000-1999",
            "2000-4999", "5000-9999", "10000人以上"};
    protected String[] mAllScaleCode;
    /**
     * 当前钱的下限值
     */
    protected String mCurrentBottomSalary;
    protected String mCurrentScaleCode;
    private ArrayList<String> mSelectPath;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public int getContentViewId() {
        return R.layout.activity_modify_cp_info;
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        MemberEntity currentMemberEntity = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);
        if (currentMemberEntity.Role == MemberEntity.CompanyMember_Role_Admin || currentMemberEntity.Role == MemberEntity.CompanyMember_Role_Boss) {
            mSaveCompanyInfo.setText("保存");
        } else {
            mSaveCompanyInfo.setVisibility(View.GONE);
        }
        mCompanyEntity = JsonUtil.ToEntity(getIntent().getStringExtra("CompanyEntity"), CompanyEntity.class);
        if (mCompanyEntity != null) {
            ImageLoader.getInstance().displayImage(mCompanyEntity.CompanyLogo, mCompanyLogo, options, animateFirstListener);
            mCompanyName.setText(mCompanyEntity.CompanyName);
            mCompanySimpleName.setText(mCompanyEntity.CompanyAbbr);
            mCompanySimpleName.setSelection(mCompanyEntity.CompanyAbbr.length());
            mCompanyField.setText(mCompanyEntity.Industry);
            CompanySizeCode = mCompanyEntity.CompanySize;
            mCompanySize.setText(mCompanyEntity.CompanySizeText);
            RegionCode = mCompanyEntity.Region;
            mCompanyCity.setText(mCompanyEntity.RegionText);
        }
    }

    @Override
    public void initPageView() {
        ButterKnife.bind(this);
        manager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
        initViewsData();
        initListener();
//        setSystemBarTintManager(this);
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
        getTags();
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
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mSaveCompanyInfo.setOnClickListener(this);
        mChangeCompanyLogo.setOnClickListener(this);
        mChangeCompanyIndustry.setOnClickListener(this);
        mChangeCompanySize.setOnClickListener(this);
        mCompanyCity.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.back:
                InputMethodManager imm = (InputMethodManager) getApplicationContext().getSystemService(Context.INPUT_METHOD_SERVICE);
                imm.hideSoftInputFromWindow(mCompanySimpleName.getWindowToken(), 0); //强制隐藏键盘
                deleteImages();
                finish();
                break;
            case R.id.photo:
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
//                        Intent intent3 = new Intent(getApplicationContext(), EditPhotoGridActivity.class);
//                        intent3.putExtra(Global.LISTVIEW_ITEM_TAG, ImageCropActivity.EDIT_AVATAR_IMAGE_TAG);
//                        startActivityForResult(intent3, 520);
                        MultiImageSelector selector = MultiImageSelector.create(ModifyCpInfoActivity.this);
                        selector.showCamera(true);
                        selector.count(9);
//                        if (mChoiceMode.getCheckedRadioButtonId() == R.id.single) {
                            selector.single();
//                        } else {
//                        selector.multi();
//                        }
                        selector.origin(mSelectPath);
                        selector.start(ModifyCpInfoActivity.this, 520);
                    }
                } else {
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                        PermissionUtils.requestPermission(this, PermissionUtils.CODE_READ_EXTERNAL_STORAGE, mPermissionGrant);
                    } else {
                        MultiImageSelector selector = MultiImageSelector.create(ModifyCpInfoActivity.this);
                        selector.showCamera(true);
                        selector.count(9);
//                        if (mChoiceMode.getCheckedRadioButtonId() == R.id.single) {
                        selector.single();
//                        } else {
//                        selector.multi();
//                        }
                        selector.origin(mSelectPath);
                        selector.start(ModifyCpInfoActivity.this, 520);
                    }
                }

                break;
            case R.id.activity_modify_cp_info_company_field:
                Intent toSelectIndustry = new Intent(getApplicationContext(), EditIndustryLableActivity.class);
                startActivityForResult(toSelectIndustry, 200);
                break;
            case R.id.activity_modify_cp_info_company_size:
//                Intent toSelectCompanySize = new Intent(getApplicationContext(), OneWheelActivity.class);
//                startActivityForResult(toSelectCompanySize, 300);
                showSelectScaleDialog();
                break;
            case R.id.include_button_button:
                if (!TextUtils.isEmpty(mAvatar)) {
                    mCompanyEntity.CompanyLogo = ImageUtil.toUploadBase64(mAvatar);
                }
                if (TextUtils.isEmpty(mCompanySimpleName.getText().toString().trim())) {
                    ToastUtil.showInfo(getString(R.string.company_abbreviation));
                    return;
                }
                mCompanyEntity.CompanyAbbr = mCompanySimpleName.getText().toString().trim();
                mCompanyEntity.Industry = mCompanyField.getText().toString().trim();
                mCompanyEntity.CompanySize = CompanySizeCode;
                mCompanyEntity.Region = RegionCode;
                Log.e(Global.LOG_TAG, mCompanyEntity.toString());
                updateCompanyInfo(mCompanyEntity);
                break;
            case R.id.activity_modify_cp_info_city_real:
                Intent SelectCity = new Intent(getApplicationContext(), SelectCityActivity.class);
                startActivityForResult(SelectCity, 100);
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
                    MultiImageSelector selector = MultiImageSelector.create(ModifyCpInfoActivity.this);
                    selector.showCamera(true);
                    selector.count(9);
//                        if (mChoiceMode.getCheckedRadioButtonId() == R.id.single) {
                    selector.single();
//                        } else {
//                        selector.multi();
//                        }
                    selector.origin(mSelectPath);
                    selector.start(ModifyCpInfoActivity.this, 520);
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
//                        mAvatar = data.getStringExtra("path");
                        mAvatar = mSelectPath.get(0);
                        Bitmap bitmap = BitmapFactory.decodeFile(mAvatar);
                        mCompanyLogo.setImageBitmap(bitmap);
                    }
                }
                break;
            case 200:
                // 选择行业
                if (resultCode == RESULT_OK) {
                    mCompanyField.setText(data.getStringExtra("industry"));
                }
                break;
            case 300:
                if (resultCode == RESULT_OK) {
                    mCompanySize.setText(data.getStringExtra("CompanyScale"));
                    CompanySizeCode = data.getStringExtra("CompanyScaleCode");
                }
                break;
            case 100:
                if (resultCode == RESULT_OK) {
                    mCompanyCity.setText(data.getStringExtra("city"));
                    RegionCode = data.getStringExtra("CityCode");
                }
                break;

        }
    }

    private void updateCompanyInfo(final CompanyEntity entity) {
        // 获取企业信息，根据之前保存的企业id查询
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean isSuccess = CompanyRepository.updateCompanyInfo(entity);
                return isSuccess;
            }

            @Override
            protected void onPostExecute(Boolean isSuccess) {
                if (dialog != null)
                    dialog.dismiss();
                if (isSuccess) {
                    ToastUtil.showInfo(getString(R.string.change_success));
                    deleteImages();
                    finish();
                } else {
//                    ToastUtil.showInfo(getString(R.string.change_false));
                    onRemoteError();
                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                onRemoteError();
//                Log.e(Global.LOG_TAG, "net abnormal!");
            }
        }.execute();
    }

    int pCurrent;

    public void showSelectScaleDialog() {
        final Dialog dl = new Dialog(this);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(true);
        View dialog_view = View.inflate(getApplicationContext(), R.layout.activity_one_wheel, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        setWindowParams(dialogWindow);
        dl.show();
        final WheelView mViewSelectCompanyScale = (WheelView) dialog_view.findViewById(R.id.id_company_person_number);
        TextView cancel = (TextView) dialog_view.findViewById(R.id.cancel);
        TextView btn_confirm = (TextView) dialog_view.findViewById(R.id.btn_confirm);
        TextView start_time = (TextView) dialog_view.findViewById(R.id.start_time);
        start_time.setText("公司规模");
        mViewSelectCompanyScale.addChangingListener(new OnWheelChangedListener() {
            @Override
            public void onChanged(WheelView wheel, int oldValue, int newValue) {
                if (wheel == mViewSelectCompanyScale) {
                    pCurrent = mViewSelectCompanyScale.getCurrentItem();
                    mCurrentBottomSalary = mAllBottomSalary[pCurrent];
                    mCurrentScaleCode = mAllScaleCode[pCurrent];
                }
            }
        });
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
            }
        });
        btn_confirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                CompanySizeCode = mCurrentScaleCode;
                mCompanySize.setText(mCurrentBottomSalary);
                dl.dismiss();
            }
        });
        mViewSelectCompanyScale.setViewAdapter(new ArrayWheelAdapter<String>(
                getApplicationContext(), mAllBottomSalary));
        // 设置可见条目数量
        mViewSelectCompanyScale.setVisibleItems(5);
        mViewSelectCompanyScale.setCurrentItem(pCurrent);
        // 设置默认选中
        mCurrentScaleCode = mAllScaleCode[pCurrent];
        mCurrentBottomSalary = mAllBottomSalary[pCurrent];
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
                        IsInitData = true;
                        List<BizDictEntity> bizDictEntities = entities.get(DictionaryPool.Code_CompanySize);
                        mAllBottomSalary = new String[bizDictEntities.size()];
                        mAllScaleCode = new String[bizDictEntities.size()];
                        for (int i = 0; i < bizDictEntities.size(); i++) {
                            mAllBottomSalary[i] = bizDictEntities.get(i).Name;
                            mAllScaleCode[i] = bizDictEntities.get(i).Code;
                        }
                        for (int i=0;i<mAllBottomSalary.length;i++){
                            if (mAllBottomSalary[i].equals(mCompanySize.getText())){
                                pCurrent = i;
                            }
                        }
                    } else {
                        onRemoteError();
                    }
                } else {
                    onRemoteError();
                }

            }

            protected void onPostError(Exception ex) {
                onRemoteError();
            }

        }.execute();
    }
}
