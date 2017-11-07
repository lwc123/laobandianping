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
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.HoldPostAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.imageCrop.ui.ImageCropActivity;
import com.juxian.bosscomments.models.BizDictEntity;
import com.juxian.bosscomments.models.EmployeArchiveEntity;
import com.juxian.bosscomments.models.ImageBucket;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.models.ResultEntity;
import com.juxian.bosscomments.models.WorkItemEntity;
import com.juxian.bosscomments.modules.DictionaryPool;
import com.juxian.bosscomments.presenter.AddEmployeeArchivePresenter;
import com.juxian.bosscomments.presenter.AddEmployeeArchivePresenterImpl;
import com.juxian.bosscomments.utils.AlbumHelper;
import com.juxian.bosscomments.utils.DialogUtils;
import com.juxian.bosscomments.utils.PermissionUtils;
import com.juxian.bosscomments.utils.checkSelfPermissionUtils;
import com.juxian.bosscomments.view.AddEmployeeArchiveView;
import com.juxian.bosscomments.widget.ResultListView;
import com.juxian.bosscomments.widget.RoundAngleImageView;
import com.kankan.wheel.widget.OnWheelChangedListener;
import com.kankan.wheel.widget.WheelView;
import com.kankan.wheel.widget.adapters.ArrayWheelAdapter;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.ActivityManager;
import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.ImageUtil;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import butterknife.BindView;
import butterknife.ButterKnife;
import de.hdodenhof.circleimageview.CircleImageView;
import me.nereo.multi_image_selector.MultiImageSelector;

/**
 * Created by nene on 2016/11/23.
 * 添加员工档案
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/23 15:27]
 * @Version: [v1.0]
 */
public class AddEmployeeRecordActivity extends BaseActivity implements View.OnClickListener, AddEmployeeArchiveView {

    private InputMethodManager manager;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.activity_entry_time)
    RelativeLayout mEntryTime;
    @BindView(R.id.activity_departure_time)
    RelativeLayout mDepartureTime;
    @BindView(R.id.activity_education_background)
    RelativeLayout mEducationBackGround;
    @BindView(R.id.activity_employee_photo)
    CircleImageView mEmployeePhoto;
    @BindView(R.id.activity_employee_name)
    EditText mEmployeeNameText;
    @BindView(R.id.activity_identity_card_number)
    EditText mIdentityCardNumberText;
    @BindView(R.id.activity_phone_number)
    EditText mPhoneNumberText;
    @BindView(R.id.edit_entry_time)
    TextView mEntryTimeText;
    @BindView(R.id.edit_departure_time)
    TextView mDepartureTimeText;
    @BindView(R.id.edit_school_of_graduation)
    EditText mSchoolOfGraduationText;
    @BindView(R.id.edit_education_background)
    TextView mEducationBackgroundText;
    @BindView(R.id.include_button_button)
    Button mSave;
    @BindView(R.id.add_employee_rg)
    RadioGroup mSelectJobState;
    @BindView(R.id.on_the_job)
    RadioButton mInWork;
    @BindView(R.id.leave_office)
    RadioButton mLeaveOffice;
    @BindView(R.id.id_hold_a_post)
    LinearLayout mAddHoldPost;
    @BindView(R.id.scrollview)
    ScrollView scrollView;
    @BindView(R.id.position_listView)
    ResultListView mPositionListView;
    @BindView(R.id.include_head_title_tab3)
    TextView mSaveText;
    @BindView(R.id.include_head_title_re2)
    RelativeLayout mSaveTop;
    @BindView(R.id.web_prompt)
    RelativeLayout mWebPrompt;
    @BindView(R.id.select_send_sms)
    LinearLayout mSelectSendSms;
    @BindView(R.id.send_sms_check)
    CheckBox mSendSmsCheck;
    private HoldPostAdapter adapter;
    private List<WorkItemEntity> entities;
    private List<WorkItemEntity> sortEntities;
    private static final int CHANGE_AVATAR = 520, ENTRY_TIME = 600, DEPARTURE_TIME = 700, EDUCATION_BACKGROUND = 800, H0LD_POST = 900, CHANGE_POST = 920;
    private static SimpleDateFormat sdfymdhms = new SimpleDateFormat("yyyy年MM月dd日");
    private Date startTime, endTime;
    public static final String EMPLOYEE_RECORD_TYPE = "EmployeeRecordType", OPERATION_TYPE = "mOperationType", ARCHIVE_ID = "archiveId";
    private String mEmployeeRecordType;
    private String mOperationType;
    private String mAvatar;
    private AddEmployeeArchivePresenter mAddEmployeeArchivePresenter;
    private Dialog dialog;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_EMPLOYEE_AVATAR_OPTIONS;
    private long mArchiveId;
    private EmployeArchiveEntity mEmployeeArchiveDetail;
    private String mDepartureTimeResult;

    /**
     * 时间选择器部分
     */

    private List<String> list_year;
    private int type;
    /**
     * 年份
     */
    protected String[] year;
    protected String[] year1;
    /**
     * 月份
     */
    protected String[] month;
    protected String[] month1;
    /**
     * 天数
     */
    protected String[] days;
    protected String[] days1;
    /**
     * 当前选择的年份，带1的是存储有年字的，不带1的是存数字
     */
    protected String mCurrentYear;
    protected String mCurrentYear1;
    /**
     * 当前选择的月份
     */
    protected String mCurrentMonth;
    protected String mCurrentMonth1;
    /**
     * 当前选择的日
     */
    protected String mCurrentDay;
    protected String mCurrentDay1;
    private Calendar calendar;
    private int nowYear;

    protected String[] mAllBottomSalary = {"大专以下", "大专", "本科", "硕士", "博士"};
    protected String[] mAllAcademicCode;
    /**
     * 当前学历
     */
    protected String mCurrentBottomSalary;
    protected String mCurrentAcademic;
    private String mDefaultAcademic;
    private int index;
    private ArrayList<String> mSelectPath;

    @Override
    public int getContentViewId() {
        return R.layout.activity_add_employee_record;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        isCheckNet = true;
        super.onCreate(savedInstanceState);
    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        manager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
        initViewsData();
        initListener();
        setSystemBarTintManager(this);
    }

//    @Override
//    protected void onResume() {
//        super.onResume();
//        ActivityManager.setCurrent(this);
//    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.add_employee_record_title));
        mSave.setText(getString(R.string.submit));
        mSaveText.setText(getString(R.string.submit));
        mSaveTop.setVisibility(View.VISIBLE);
        mSaveText.setVisibility(View.VISIBLE);

        mAddEmployeeArchivePresenter = new AddEmployeeArchivePresenterImpl(getApplicationContext(), this);
//        getTags();
        sortEntities = new ArrayList<>();
        entities = new ArrayList<>();
        adapter = new HoldPostAdapter(entities, getApplicationContext());
        mPositionListView.setAdapter(adapter);
        mEmployeeRecordType = getIntent().getStringExtra(EMPLOYEE_RECORD_TYPE);
        mOperationType = getIntent().getStringExtra(OPERATION_TYPE);
        if ("Build".equals(mOperationType)) {
            mSelectSendSms.setVisibility(View.VISIBLE);
            if ("OnActive".equals(mEmployeeRecordType)) {
                mInWork.setChecked(true);
            } else if ("Departure".equals(mEmployeeRecordType)) {
                mLeaveOffice.setChecked(true);
            } else {

            }
        } else {
            // 则，此时是修改。根据档案id获取档案信息
            title.setText("修改员工档案");
            mIdentityCardNumberText.setEnabled(false);
            mArchiveId = getIntent().getLongExtra(ARCHIVE_ID, 0);
//            mAddEmployeeArchivePresenter.getArchiveDetail(AppConfig.getCurrentUseCompany(), mArchiveId);
        }
    }

    @Override
    public void loadPageData() {
        super.loadPageData();
        getTags();
        if ("Build".equals(mOperationType)) {

        } else {
            mAddEmployeeArchivePresenter.getArchiveDetail(AppConfig.getCurrentUseCompany(), mArchiveId);
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mEmployeePhoto.setOnClickListener(this);
        mEntryTime.setOnClickListener(this);
        mDepartureTime.setOnClickListener(this);
        mEducationBackGround.setOnClickListener(this);
        mSave.setOnClickListener(this);
        mAddHoldPost.setOnClickListener(this);
        mSaveTop.setOnClickListener(this);
        mWebPrompt.setOnClickListener(this);
        mInWork.setOnClickListener(this);
        mLeaveOffice.setOnClickListener(this);
        mSelectSendSms.setOnClickListener(this);

        scrollView.setOnTouchListener(new View.OnTouchListener() {

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                // TODO Auto-generated method stub
                Global.CloseKeyBoard(mEmployeeNameText);
                return false;
            }
        });
        mPositionListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                index = i;
                Intent HoldPost = new Intent(getApplicationContext(), HoldPostActivity.class);
                HoldPost.putExtra(Global.LISTVIEW_ITEM_TAG, "change");
                HoldPost.putExtra("WorkItemEntity", JsonUtil.ToJson(entities.get(i)));
                HoldPost.putExtra("mEntryTime", mEntryTimeText.getText().toString().trim());
                HoldPost.putExtra("mDepartureTime", mDepartureTimeText.getText().toString().trim());
                startActivityForResult(HoldPost, CHANGE_POST);
            }
        });
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
        super.onClick(v);
        Pattern idNumPattern = Pattern.compile("(\\d{14}[0-9a-zA-Z])|(\\d{17}[0-9a-zA-Z])");
        String ssString = "^1\\d{10}$";
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                if ("Build".equals(mOperationType)) {
                    if (!TextUtils.isEmpty(mAvatar) || mInWork.isChecked() || mLeaveOffice.isChecked() || !TextUtils.isEmpty(mEmployeeNameText.getText().toString()) ||
                            !TextUtils.isEmpty(mIdentityCardNumberText.getText().toString()) || !TextUtils.isEmpty(mPhoneNumberText.getText().toString()) ||
                            !TextUtils.isEmpty(mEntryTimeText.getText().toString()) || !TextUtils.isEmpty(mDepartureTimeText.getText().toString()) ||
                            !TextUtils.isEmpty(mSchoolOfGraduationText.getText().toString()) || !TextUtils.isEmpty(mEducationBackgroundText.getText().toString()) ||
                            entities.size() > 0) {
                        DialogUtils.showStandardTitleDialog(this, "否", "是", "温馨提示", "信息尚未保存，是否离开？", new DialogUtils.StandardTitleDialogListener() {
                            @Override
                            public void LeftBtMethod() {

                            }

                            @Override
                            public void RightBtMethod() {
                                deleteImages();
                                AddEmployeeRecordActivity.this.finish();
                            }
                        });
                    } else {
                        deleteImages();
                        finish();
                    }
                } else {
                    deleteImages();
                    finish();
                }
                break;
            case R.id.activity_employee_photo:
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
                        MultiImageSelector selector = MultiImageSelector.create(AddEmployeeRecordActivity.this);
                        selector.showCamera(true);
                        selector.count(9);
                        selector.single();
                        selector.origin(mSelectPath);
                        selector.start(AddEmployeeRecordActivity.this, CHANGE_AVATAR);
                    }
                } else {
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                        PermissionUtils.requestPermission(this, PermissionUtils.CODE_READ_EXTERNAL_STORAGE, mPermissionGrant);
                    } else {
                        MultiImageSelector selector = MultiImageSelector.create(AddEmployeeRecordActivity.this);
                        selector.showCamera(true);
                        selector.count(9);
                        selector.single();
                        selector.origin(mSelectPath);
                        selector.start(AddEmployeeRecordActivity.this, CHANGE_AVATAR);
                    }
                }
                break;
            case R.id.activity_entry_time:
                Intent intent = new Intent(this, EditTimeActivity.class);
                intent.putExtra("data", mEntryTimeText.getText().toString().trim());
                startActivityForResult(intent, ENTRY_TIME);
//                showSelectScaleDialog(mEntryTimeText, 1);
                break;
            case R.id.activity_departure_time:
                if (!mLeaveOffice.isChecked()) {
                    ToastUtil.showInfo("只有离任状态的员工才可以选择离任时间");
                    return;
                }
                Intent intent1 = new Intent(this, EditTimeActivity.class);
                intent1.putExtra("data", mDepartureTimeText.getText().toString().trim());
                startActivityForResult(intent1, DEPARTURE_TIME);
//                showSelectScaleDialog(mDepartureTimeText, 2);
                break;
            case R.id.activity_education_background:
                showSelectEduBackground();
                break;
            case R.id.include_button_button:
                Log.e(Global.LOG_TAG, ""+ActivityManager.getCurrent().getClass().getName());
                addEmployeeArchice(idNumPattern, ssString);
                break;
            case R.id.id_hold_a_post:
                Intent HoldPost = new Intent(getApplicationContext(), HoldPostActivity.class);
                HoldPost.putExtra("mEntryTime", mEntryTimeText.getText().toString().trim());
                HoldPost.putExtra("mDepartureTime", mDepartureTimeText.getText().toString().trim());
                startActivityForResult(HoldPost, H0LD_POST);
                break;
            case R.id.include_head_title_re2:
                addEmployeeArchice(idNumPattern, ssString);
                break;
            case R.id.web_prompt:
                Intent WebPrompt = new Intent(getApplicationContext(), WebPromptActivity.class);
                startActivity(WebPrompt);
                break;
            case R.id.on_the_job:
                mDepartureTime.setVisibility(View.GONE);
                mDepartureTimeText.setText("");
                break;
            case R.id.leave_office:
                mDepartureTime.setVisibility(View.VISIBLE);
                break;
            case R.id.select_send_sms:
                if (mSendSmsCheck.isChecked()) {
                    mSendSmsCheck.setChecked(false);
                } else {
                    mSendSmsCheck.setChecked(true);
                }
                break;
            default:
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
                    MultiImageSelector selector = MultiImageSelector.create(AddEmployeeRecordActivity.this);
                    selector.showCamera(true);
                    selector.count(9);
                    selector.single();
                    selector.origin(mSelectPath);
                    selector.start(AddEmployeeRecordActivity.this, CHANGE_AVATAR);
                    break;
                case PermissionUtils.CODE_WRITE_EXTERNAL_STORAGE:
                    break;
                default:
                    break;
            }
        }
    };

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


    @Override
    public void onRequestPermissionsResult(final int requestCode, @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        PermissionUtils.requestPermissionsResult(this, requestCode, permissions, grantResults, mPermissionGrant);
    }

    public void addEmployeeArchice(Pattern idNumPattern, String ssString) {
//        if ("Build".equals(mOperationType)) {
//            if (TextUtils.isEmpty(mAvatar)) {
//                ToastUtil.showInfo(getString(R.string.please_select_employee_avatar));
//                return;
//            }
//        }
        if (!mInWork.isChecked() && !mLeaveOffice.isChecked()) {
            ToastUtil.showInfo(getString(R.string.please_select_current_status));
            return;
        }
        if (TextUtils.isEmpty(mEmployeeNameText.getText().toString())) {
            ToastUtil.showInfo(getString(R.string.input_employee_name));
            return;
        }
        if (mEmployeeNameText.getText().toString().length() > 5) {
            ToastUtil.showInfo(getString(R.string.employee_record_name_limit));
            return;
        }
        if (TextUtils.isEmpty(mIdentityCardNumberText.getText().toString())) {
            ToastUtil.showInfo(getString(R.string.employee_identity_number_not_empty));
            return;
        }
        if ("Build".equals(mOperationType)) {
            Matcher idNumMatcher = idNumPattern.matcher(mIdentityCardNumberText.getText().toString());
            if (!idNumMatcher.matches()) {
                ToastUtil.showInfo(getString(R.string.employee_identity_number_error));
                mIdentityCardNumberText.requestFocus();
                return;
            }
        }
        if (TextUtils.isEmpty(mPhoneNumberText.getText().toString())) {
            ToastUtil.showInfo(getString(R.string.mobile_phone_is_empty));
            mPhoneNumberText.requestFocus();
            return;
        }
        Matcher m = Pattern.compile(ssString).matcher(mPhoneNumberText.getText().toString());
        if (!m.matches() || mPhoneNumberText.getText().toString().length() != 11) {
            mPhoneNumberText.requestFocus();
            ToastUtil.showError(getString(R.string.phone_pattern_false));
            return;
        }
        if (TextUtils.isEmpty(mEntryTimeText.getText().toString())) {
            ToastUtil.showInfo(getString(R.string.please_select_entry_time));
            return;
        }
        if (mLeaveOffice.isChecked() && TextUtils.isEmpty(mDepartureTimeText.getText().toString())) {
            ToastUtil.showInfo(getString(R.string.please_select_departure_time));
            return;
        }
        try {
            startTime = sdfymdhms.parse(mEntryTimeText.getText().toString());
            if (mLeaveOffice.isChecked()) {
                endTime = sdfymdhms.parse(mDepartureTimeText.getText().toString());
            } else {

            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        if (mLeaveOffice.isChecked()) {
            if (startTime.after(endTime)) {
                ToastUtil.showInfo(getString(R.string.time_limit));
                return;
            }
        }
        if (TextUtils.isEmpty(mSchoolOfGraduationText.getText().toString())) {
            ToastUtil.showInfo(getString(R.string.please_input_school_of_graduation));
            mSchoolOfGraduationText.requestFocus();
            return;
        }
        if (mSchoolOfGraduationText.getText().toString().length() > 30) {
            ToastUtil.showInfo(getString(R.string.school_of_graduation_limit));
            mSchoolOfGraduationText.requestFocus();
            return;
        }
        if (TextUtils.isEmpty(mEducationBackgroundText.getText().toString())) {
            ToastUtil.showInfo(getString(R.string.please_select_education_background));
            return;
        }
        if (entities.size() < 1) {
            ToastUtil.showInfo(getString(R.string.please_add_post));
            return;
        }
        EmployeArchiveEntity entity = new EmployeArchiveEntity();
        if ("Build".equals(mOperationType)) {
            entity.IDCard = mIdentityCardNumberText.getText().toString().trim();
            if (TextUtils.isEmpty(mAvatar)) {

            } else {
                entity.Picture = ImageUtil.toUploadBase64(mAvatar);
            }
        } else {
            entity = mEmployeeArchiveDetail;
            if (entity.WorkItems != null)
                entity.WorkItems.clear();
            if (TextUtils.isEmpty(mAvatar)) {

            } else {
                entity.Picture = ImageUtil.toUploadBase64(mAvatar);
            }
        }
        if (mInWork.isChecked()) {
            entity.IsDimission = 0;
        } else {
            entity.IsDimission = 1;
        }
        entity.CompanyId = AppConfig.getCurrentUseCompany();
        entity.RealName = mEmployeeNameText.getText().toString().trim();
        entity.MobilePhone = mPhoneNumberText.getText().toString().trim();
        entity.EntryTime = startTime;
        entity.DimissionTime = endTime;
        entity.WorkItems = new ArrayList<>();
        entity.WorkItems.addAll(entities);
        entity.GraduateSchool = mSchoolOfGraduationText.getText().toString().trim();
//        entity.Education = mEducationBackgroundText.getText().toString().trim();
        for (int i = 0; i < mAllBottomSalary.length; i++) {
            if ((mEducationBackgroundText.getText().toString().trim()).equals(mAllBottomSalary[i])) {
                entity.Education = mAllAcademicCode[i];
            }
        }
        if (mSendSmsCheck.isChecked()) {
            entity.IsSendSms = true;
        } else {
            entity.IsSendSms = false;
        }
        if ("Build".equals(mOperationType)) {
            mAddEmployeeArchivePresenter.checkIDCard(entity);
        } else {
            mAddEmployeeArchivePresenter.updateEmployeeArchive(entity);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case ENTRY_TIME:
                if (resultCode == RESULT_OK) {
                    String year = data.getStringExtra("year");
                    String month = data.getStringExtra("month");
                    String day = data.getStringExtra("day");
                    mEntryTimeText.setText(year + month + day);
                }
                break;
            case DEPARTURE_TIME:
                if (resultCode == RESULT_OK) {
                    String year = data.getStringExtra("year");
                    String month = data.getStringExtra("month");
                    String day = data.getStringExtra("day");
                    mDepartureTimeResult = year + month + day;
                    if ("3000年01月01日".equals(mDepartureTimeResult)) {
                        mDepartureTimeText.setText("至今");
                    } else {
                        mDepartureTimeText.setText(mDepartureTimeResult);
                    }
                }
                break;
            case EDUCATION_BACKGROUND:
                if (resultCode == RESULT_OK) {
                    String education_background = data.getStringExtra("Education_Background");
                    mEducationBackgroundText.setText(education_background);
                }
                break;
            case H0LD_POST:
                if (resultCode == RESULT_OK) {
                    sortEntities.clear();
                    WorkItemEntity entity = JsonUtil.ToEntity(data.getStringExtra("WorkItemEntity"), WorkItemEntity.class);
                    sortEntities.add(entity);
                    // 判断entities中是否有数据，有则是修改的情况
                    if (entities.size() != 0) {
                        for (int i = 0; i < entities.size(); i++) {
                            sortEntities.add(entities.get(i));
                        }
                    }
                    WorkItemEntity[] arrayEntities = new WorkItemEntity[sortEntities.size()];
                    WorkItemEntity[] copyArrayEntities = new WorkItemEntity[sortEntities.size()];
                    for (int i = 0; i < sortEntities.size(); i++) {
                        arrayEntities[i] = sortEntities.get(i);
                    }
                    entities.clear();
                    copyArrayEntities = sortPositionEntity(arrayEntities);
                    for (int i = 0; i < sortEntities.size(); i++) {
                        entities.add(copyArrayEntities[i]);
                    }
                    adapter.notifyDataSetChanged();
                }
                break;
            case CHANGE_AVATAR:
                if (resultCode == RESULT_OK) {
                    mSelectPath = data.getStringArrayListExtra(MultiImageSelector.EXTRA_RESULT);

                    mAvatar = mSelectPath.get(0);
                    Bitmap bitmap = BitmapFactory.decodeFile(mAvatar);
                    mEmployeePhoto.setImageBitmap(bitmap);
//                    mAvatar = data.getStringExtra("path");
//                    Bitmap bitmap = BitmapFactory.decodeFile(mAvatar);
//                    mEmployeePhoto.setImageBitmap(bitmap);
                }
                break;
            case CHANGE_POST:
                if (resultCode == RESULT_OK) {
                    entities.remove(index);
                    sortEntities.clear();
                    WorkItemEntity entity = JsonUtil.ToEntity(data.getStringExtra("WorkItemEntity"), WorkItemEntity.class);
                    sortEntities.add(entity);
                    // 判断entities中是否有数据，有则是修改的情况
                    if (entities.size() != 0) {
                        for (int i = 0; i < entities.size(); i++) {
                            sortEntities.add(entities.get(i));
                        }
                    }
                    WorkItemEntity[] arrayEntities = new WorkItemEntity[sortEntities.size()];
                    WorkItemEntity[] copyArrayEntities = new WorkItemEntity[sortEntities.size()];
                    for (int i = 0; i < sortEntities.size(); i++) {
                        arrayEntities[i] = sortEntities.get(i);
                    }
                    entities.clear();
                    copyArrayEntities = sortPositionEntity(arrayEntities);
                    for (int i = 0; i < sortEntities.size(); i++) {
                        entities.add(copyArrayEntities[i]);
                    }
                    adapter.notifyDataSetChanged();
                }
                break;
            default:
        }
    }

    /**
     * 职务针对时间排序
     *
     * @param arrayEntities
     * @return
     */
    public WorkItemEntity[] sortPositionEntity(WorkItemEntity[] arrayEntities) {
        WorkItemEntity tempEntity;
        for (int i = 0; i < sortEntities.size(); i++) {
            for (int j = i + 1; j < sortEntities.size(); j++) {
                if (arrayEntities[i].PostEndTime.before(arrayEntities[j].PostEndTime)) {
                    tempEntity = arrayEntities[i];
                    arrayEntities[i] = arrayEntities[j];
                    arrayEntities[j] = tempEntity;
                } else if (arrayEntities[i].PostEndTime.after(arrayEntities[j].PostEndTime)) {

                } else {
                    if (arrayEntities[i].PostStartTime.before(arrayEntities[j].PostStartTime)) {
                        tempEntity = arrayEntities[i];
                        arrayEntities[i] = arrayEntities[j];
                        arrayEntities[j] = tempEntity;
                    } else if (arrayEntities[i].PostStartTime.after(arrayEntities[j].PostStartTime)) {

                    } else {

                    }
                }
            }
        }
        return arrayEntities;
    }

    public void showDialog(final boolean isFinish, String ContentText, String Button1, String Button2, final Class<?> GoalIntentClass, final boolean isBuild, final EmployeArchiveEntity entity) {
        final Dialog dl = new Dialog(this);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(false);
        View dialog_view = View.inflate(getApplicationContext(), R.layout.dialog_tips, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
        lp.width = dp2px(260);
        dialogWindow.setAttributes(lp);
        dialogWindow.setBackgroundDrawableResource(R.drawable.chuntouming);
        dl.show();
        TextView content = (TextView) dialog_view.findViewById(R.id.dialog_tips_content);
        content.setText(ContentText);
        TextView close = (TextView) dialog_view.findViewById(R.id.dialog_tips_cancel);
        close.setText(Button1);
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
                if (isFinish)
                    finish();
            }
        });
        TextView login = (TextView) dialog_view.findViewById(R.id.dialog_tips_ok);
        login.setText(Button2);
        login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // 判断是否是继续建立档案，是，则继续建立，否则执行其他操作
                dl.dismiss();
                if (isBuild) {
                    Intent intent = new Intent(getApplicationContext(), GoalIntentClass);
                    intent.putExtra("Tag", "Have");
                    intent.putExtra("isContinue", "continue");
                    intent.putExtra("EmployeArchiveEntity", JsonUtil.ToJson(entity));
                    startActivity(intent);
                    finish();
                } else {
//                    PostEmployeArchive(entity);
                    mAddEmployeeArchivePresenter.addEmployeeArchive(entity);
                }
            }
        });
    }

    private int yearIndex;
    private int monthIndex;
    private int dayIndex;

    /**
     * 年月日时间选择器
     *
     * @param textView
     * @param tag
     */
    public void showSelectScaleDialog(final TextView textView, int tag) {
        final Dialog dl = new Dialog(this);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(true);
        View dialog_view = View.inflate(getApplicationContext(), R.layout.activity_edit_time, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        setWindowParams(dialogWindow);
        dl.show();
        final WheelView mViewYear = (WheelView) dialog_view.findViewById(R.id.id_year);
        final WheelView mViewMonth = (WheelView) dialog_view.findViewById(R.id.id_mouth);
        final WheelView mViewDay = (WheelView) dialog_view.findViewById(R.id.id_day);
        TextView mBtnConfirm = (TextView) dialog_view.findViewById(R.id.btn_confirm);
        TextView cancel = (TextView) dialog_view.findViewById(R.id.cancel);
        final TextView current_date = (TextView) dialog_view.findViewById(R.id.current_date);
        TextView start_time = (TextView) dialog_view.findViewById(R.id.start_time);
        if (tag == 1) {
            start_time.setText(getString(R.string.employee_entry_time));
        } else {
            start_time.setText(getString(R.string.employee_departure_time));
        }
        mViewYear.addChangingListener(new OnWheelChangedListener() {
            @Override
            public void onChanged(WheelView wheel, int oldValue, int newValue) {
                updateMonth(mViewYear, mViewMonth, mViewDay);
                yearIndex = mViewYear.getCurrentItem();
                current_date.setText(mCurrentYear1 + mCurrentMonth1 + mCurrentDay1);
            }
        });
        mViewMonth.addChangingListener(new OnWheelChangedListener() {
            @Override
            public void onChanged(WheelView wheel, int oldValue, int newValue) {
                updateDay(mViewMonth, mViewDay);
                monthIndex = mViewMonth.getCurrentItem();
                current_date.setText(mCurrentYear1 + mCurrentMonth1 + mCurrentDay1);
            }
        });
        mViewDay.addChangingListener(new OnWheelChangedListener() {
            @Override
            public void onChanged(WheelView wheel, int oldValue, int newValue) {
                int pCurrent = mViewDay.getCurrentItem();
                mCurrentDay = days[pCurrent];
                mCurrentDay1 = days1[pCurrent];
                dayIndex = mViewDay.getCurrentItem();
                current_date.setText(mCurrentYear1 + mCurrentMonth1 + mCurrentDay1);
            }
        });
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
            }
        });
        mBtnConfirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                textView.setText(mCurrentYear1 + mCurrentMonth1 + mCurrentDay1);
                dl.dismiss();
            }
        });
        list_year = new ArrayList<String>();
        initYear();
        year = new String[list_year.size()];
        year1 = new String[list_year.size()];
        for (int i = 0; i < list_year.size(); i++) {
            year[i] = list_year.get(i);
            year1[i] = list_year.get(i) + "年";
        }

        mViewYear.setViewAdapter(new ArrayWheelAdapter<String>(getApplicationContext(), year1));
        mViewYear.setCyclic(false);
        mViewMonth.setCyclic(true);
        mViewDay.setCyclic(true);
        // 设置可见条目数量
        mViewYear.setVisibleItems(5);
        mViewMonth.setVisibleItems(5);
        mViewDay.setVisibleItems(5);
        mCurrentYear = year[0];

        mViewYear.setCurrentItem(yearIndex);
        mViewMonth.setCurrentItem(monthIndex);
        mViewDay.setCurrentItem(dayIndex);
        updateMonth(mViewYear, mViewMonth, mViewDay);
        current_date.setText(mCurrentYear1 + mCurrentMonth1 + mCurrentDay1 + "");
    }

    private void initYear() {
        calendar = Calendar.getInstance();
        nowYear = calendar.get(Calendar.YEAR);
        for (int i = nowYear; i >= nowYear - 30; i--) {
            list_year.add(i + "");
        }
    }

    private void updateMonth(WheelView mViewYear, WheelView mViewMonth, WheelView mViewDay) {
        int pCurrent = mViewYear.getCurrentItem();
        mCurrentYear = year[pCurrent];
        mCurrentYear1 = year1[pCurrent];
        String str = null;
        if (Integer.parseInt(mCurrentYear) < nowYear) {
            initMonth(12);
        } else {
            int nowMonth = calendar.get(Calendar.MONTH);
            initMonth(nowMonth + 1);
        }
        if ((month1.length) < 5) {
            mViewMonth.setCyclic(false);
        } else {
            mViewMonth.setCyclic(true);
        }
        mViewMonth.setViewAdapter(new ArrayWheelAdapter<String>(getApplicationContext(), month1));
        // 在滚动年份变化时，有可能当前选中的年所拥有的月份少于12月，那么就需要判断之前选中的是哪个月，如果是超过现在所有的月份，则设置选中最后一个
        if (mViewMonth.getCurrentItem() > month.length - 1)
            mViewMonth.setCurrentItem(month.length - 1);
        mCurrentMonth = month[mViewMonth.getCurrentItem()];
        mCurrentMonth1 = month1[mViewMonth.getCurrentItem()];
        updateDay(mViewMonth, mViewDay);
    }

    public void initMonth(int length) {
        String str = null;
        month = new String[length];
        month1 = new String[length];
        for (int i = 1; i <= length; i++) {
            if (i < 10) {
                str = "0" + i;
            } else {
                str = i + "";
            }
            month[i - 1] = str;
            month1[i - 1] = str + "月";
        }
    }

    /**
     * 根据当前的月，更新日WheelView的信息
     */
    private void updateDay(WheelView mViewMonth, WheelView mViewDay) {
        int mCurrent = mViewMonth.getCurrentItem();
        mCurrentMonth = month[mCurrent];
        mCurrentMonth1 = month1[mCurrent];
        String str = null;
        int currentYear = Integer.parseInt(mCurrentYear);
        int currentMouth = Integer.parseInt(mCurrentMonth);
        if (currentYear < nowYear) {
            // 前面两个是闰年，最后一个是平年
            if (((currentYear % 100) != 0 && currentYear % 4 == 0) || currentYear % 400 == 0) {
                setDays(true, 29, currentMouth);
            } else {
                setDays(true, 28, currentMouth);
            }
        } else {
            int nowMonth = calendar.get(Calendar.MONTH);
            int nowDay = calendar.get(Calendar.DAY_OF_MONTH);
            if (((currentYear % 100) != 0 && currentYear % 4 == 0) || currentYear % 400 == 0) {
                if (currentMouth < nowMonth + 1) {
                    setDays(true, 29, currentMouth);
                } else {
                    initDays(nowDay);
                }
            } else {
                if (currentMouth < nowMonth + 1) {
                    setDays(true, 28, currentMouth);
                } else {
                    initDays(nowDay);
                }
            }
        }
        if (days1.length < 5) {
            mViewDay.setCyclic(false);
        } else {
            mViewDay.setCyclic(true);
        }
        mViewDay.setViewAdapter(new ArrayWheelAdapter<String>(getApplicationContext(), days1));
        if (mViewDay.getCurrentItem() > days.length - 1)
            mViewDay.setCurrentItem(days.length - 1);
        mCurrentDay = days[mViewDay.getCurrentItem()];
        mCurrentDay1 = days1[mViewDay.getCurrentItem()];
    }

    /**
     * 设置日
     *
     * @param isRunYear
     * @param febDays
     * @param currentMouth
     */
    public void setDays(boolean isRunYear, int febDays, int currentMouth) {
        if (isRunYear) {
            if (currentMouth == 2) {
                initDays(febDays);
            } else if (currentMouth == 4 || currentMouth == 6 || currentMouth == 9 || currentMouth == 11) {
                initDays(30);
            } else {
                initDays(31);
            }
        }
    }

    /**
     * 初始化日
     *
     * @param length
     */
    public void initDays(int length) {
        days = new String[length];
        days1 = new String[length];
        for (int i = 0; i < length; i++) {
            if ((i + 1) < 10) {
                days[i] = "0" + (i + 1) + "";
                days1[i] = "0" + (i + 1) + "日";
            } else {
                days[i] = (i + 1) + "";
                days1[i] = (i + 1) + "日";
            }
        }
    }

    private int pCurrent;

    public void showSelectEduBackground() {
        final Dialog dl = new Dialog(this);
        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(true);
        View dialog_view = View.inflate(getApplicationContext(), R.layout.activity_one_wheel, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        setWindowParams(dialogWindow);
        dl.show();
        final WheelView mViewSelectCompanyScale = (WheelView) dialog_view.findViewById(R.id.id_company_person_number);
        TextView mBtnConfirm = (TextView) dialog_view.findViewById(R.id.btn_confirm);
        TextView start_time = (TextView) dialog_view.findViewById(R.id.start_time);
        start_time.setText("选择学历");
        TextView cancel = (TextView) dialog_view.findViewById(R.id.cancel);
        mViewSelectCompanyScale.addChangingListener(new OnWheelChangedListener() {
            @Override
            public void onChanged(WheelView wheel, int oldValue, int newValue) {
                if (wheel == mViewSelectCompanyScale) {

                    pCurrent = mViewSelectCompanyScale.getCurrentItem();
                    mCurrentBottomSalary = mAllBottomSalary[pCurrent];
                    mCurrentAcademic = mAllAcademicCode[pCurrent];
                }
            }
        });
        // 添加onclick事件
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
            }
        });
        mBtnConfirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mEducationBackgroundText.setText(mCurrentBottomSalary);
                mDefaultAcademic = mCurrentAcademic;
                dl.dismiss();
            }
        });
        mViewSelectCompanyScale.setViewAdapter(new ArrayWheelAdapter<String>(
                getApplicationContext(), mAllBottomSalary));
        // 设置可见条目数量
        mViewSelectCompanyScale.setVisibleItems(5);
        mViewSelectCompanyScale.setCurrentItem(pCurrent);
        // 设置默认选中
        mCurrentAcademic = mAllAcademicCode[0];
        mCurrentBottomSalary = mAllBottomSalary[0];
    }

    @Override
    public void callBackcheckIDCard(ResultEntity checkResult, EmployeArchiveEntity entity) {
        if (checkResult != null) {
            // false是身份证号已经存在
            if (checkResult.Success) {
                mAddEmployeeArchivePresenter.addEmployeeArchive(entity);
//                showDialog(false, "确定要建立员工档案？", getString(R.string.close_dialog), getString(R.string.ok), null, false, entity);
            } else {
                ToastUtil.showInfo(checkResult.ErrorMessage);
            }
        } else {
            ToastUtil.showInfo("身份证号已在该公司档案数据中，请重新输入！");
        }
    }

    @Override
    public void callBackAddEmployeeArchive(ResultEntity resultEntity) {
        if (resultEntity != null) {
            if (resultEntity.Success) {
                deleteImages();
                EmployeArchiveEntity entity = JsonUtil.ToEntity(resultEntity.JsonModel, EmployeArchiveEntity.class);
                if ("SelectArchive".equals(getIntent().getStringExtra("ArchiveList"))) {
                    Intent intent = new Intent();
                    intent.putExtra("ArchiveInformation", resultEntity.JsonModel);
                    setResult(RESULT_OK, intent);
                    finish();
                } else {
                    if (mInWork.isChecked()) {
                        showDialog(true, "操作成功", "返回", "添加阶段评价", AddBossCommentActivity.class, true, entity);
                    } else {
                        showDialog(true, "操作成功", "返回", "添加离任报告", AddDepartureReportActivity.class, true, entity);
                    }
                }
            } else {
                ToastUtil.showInfo(resultEntity.ErrorMessage);
            }
        } else {
            ToastUtil.showInfo("建立失败");
        }
    }

    @Override
    public void callBackAddEmployeeArchiveFailure(String msg, Exception e) {
//        optionsCheckNetStatus();
    }

    @Override
    public void callBackGetArchiveDetail(EmployeArchiveEntity resultEntity) {
        if (resultEntity == null) {

        } else {
            firstLoadData = false;
            mEmployeeArchiveDetail = resultEntity;
            ImageLoader.getInstance().displayImage(resultEntity.Picture, mEmployeePhoto, options, animateFirstListener);
            if (resultEntity.IsDimission == 0) {
                mInWork.setChecked(true);
            } else {
                mLeaveOffice.setChecked(true);
            }
            if (!TextUtils.isEmpty(resultEntity.RealName)) {
                mEmployeeNameText.setText(resultEntity.RealName);
                mEmployeeNameText.setSelection(resultEntity.RealName.length());
            }
            MemberEntity currentUser = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);
            if (!TextUtils.isEmpty(resultEntity.IDCard)) {
                if (currentUser.Role == MemberEntity.CompanyMember_Role_Boss) {
                    mIdentityCardNumberText.setText(resultEntity.IDCard);
                } else {
                    String IDCardStr = null;
                    if (resultEntity.IDCard.length() == 18) {
                        IDCardStr = resultEntity.IDCard.substring(0, 4) + "**************";
                    } else {
                        IDCardStr = resultEntity.IDCard.substring(0, 4) + "***********";
                    }
                    mIdentityCardNumberText.setText(IDCardStr);
                }
            }
            if (!TextUtils.isEmpty(resultEntity.MobilePhone)) {
                mPhoneNumberText.setText(resultEntity.MobilePhone);
            }
            mEntryTimeText.setText(sdfymdhms.format(resultEntity.EntryTime));
            if (mInWork.isChecked()) {
                mDepartureTimeText.setText("");
            } else {
                mDepartureTimeText.setText(sdfymdhms.format(resultEntity.DimissionTime));
            }
            if (!TextUtils.isEmpty(resultEntity.GraduateSchool)) {
                mSchoolOfGraduationText.setText(resultEntity.GraduateSchool);
            }
            if (!TextUtils.isEmpty(resultEntity.EducationText)) {
                mEducationBackgroundText.setText(resultEntity.EducationText);
            }
            mDefaultAcademic = resultEntity.Education;
            mIdentityCardNumberText.setEnabled(false);
            entities.addAll(resultEntity.WorkItems);
            adapter.notifyDataSetChanged();
        }
    }

    @Override
    public void callBackGetArchiveDetailFailure(String msg, Exception e) {
        secondCheckNetStatus();
    }

    @Override
    public void callBackUpdateEmployeeArchive(ResultEntity resultEntity) {
        if (resultEntity != null) {
            if (resultEntity.Success) {
                deleteImages();
                EmployeArchiveEntity entity = JsonUtil.ToEntity(resultEntity.JsonModel, EmployeArchiveEntity.class);
                if (mInWork.isChecked()) {
                    DialogUtils.showEmployeeRecordDialog(this, "保存成功！", "添加工作评价", AddBossCommentActivity.class, entity);
                } else {
                    DialogUtils.showEmployeeRecordDialog(this, "保存成功！", "添加离职报告", AddDepartureReportActivity.class, entity);
                }
            } else {
                ToastUtil.showInfo(resultEntity.ErrorMessage);
            }
        } else {
            ToastUtil.showInfo("修改失败");
        }
    }

    @Override
    public void callBackUpdateEmployeeArchiveFailure(String msg, Exception e) {
//        optionsCheckNetStatus();
    }

    @Override
    public void showAddEmployeeArchiveProgress() {
        dialog = DialogUtil.showLoadingDialog();
    }

    @Override
    public void hideAddEmployeeArchiveProgress() {
        if (dialog != null)
            dialog.dismiss();
    }

    public void getTags() {
        new AsyncRunnable<HashMap<String, List<BizDictEntity>>>() {

            @Override
            protected HashMap<String, List<BizDictEntity>> doInBackground(Void... params) {
                HashMap<String, List<BizDictEntity>> entities = DictionaryPool.loadAcademicDictionaries();
                return entities;
            }

            @Override
            protected void onPostExecute(HashMap<String, List<BizDictEntity>> entities) {
                if (entities != null) {
                    if (entities.size() != 0) {
                        List<BizDictEntity> Academics = entities.get(DictionaryPool.Code_Ccademic);
                        mAllBottomSalary = new String[Academics.size()];
                        mAllAcademicCode = new String[Academics.size()];
                        for (int i = 0; i < Academics.size(); i++) {
                            mAllBottomSalary[i] = Academics.get(i).Name;
                            mAllAcademicCode[i] = Academics.get(i).Code;
                        }
                        firstLoadData = false;
                    } else {

                    }
                } else {

                }

            }

            protected void onPostError(Exception ex) {
                secondCheckNetStatus();
            }

        }.execute();
    }
}
