package com.juxian.bosscomments.ui;

import android.Manifest;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.AnimationDrawable;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioRecord;
import android.media.MediaPlayer;
import android.media.MediaRecorder;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.AddBossCommentGridAdapter;
import com.juxian.bosscomments.adapter.AllAuditorAdapter;
import com.juxian.bosscomments.adapter.RadioButtonGridAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.models.BizDictEntity;
import com.juxian.bosscomments.models.DepartureTagEntity;
import com.juxian.bosscomments.models.EmployeArchiveEntity;
import com.juxian.bosscomments.models.ImageBucket;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.models.WorkItemEntity;
import com.juxian.bosscomments.modules.DictionaryPool;
import com.juxian.bosscomments.presenter.AddDepartureReportPresenter;
import com.juxian.bosscomments.presenter.AddDepartureReportPresenterImpl;
import com.juxian.bosscomments.utils.AlbumHelper;
import com.juxian.bosscomments.utils.Bimp;
import com.juxian.bosscomments.utils.DialogUtils;
import com.juxian.bosscomments.utils.PermissionUtils;
import com.juxian.bosscomments.utils.Player;
import com.juxian.bosscomments.utils.checkSelfPermissionUtils;
import com.juxian.bosscomments.view.DepartureReportView;
import com.juxian.bosscomments.widget.NoScrollGridView;
import com.juxian.bosscomments.widget.ResultListView;
import com.juxian.bosscomments.widget.RoundAngleImageView;
import com.juxian.bosscomments.widget.VoicePopupWindow;
import com.juxian.bosscomments.widget.rangeseekbar.RangeSeekBar;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.FileUtil;
import net.juxian.appgenome.utils.ImageUtil;
import net.juxian.appgenome.utils.ImageUtils;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import butterknife.BindView;
import butterknife.ButterKnife;
import cn.sopho.destiny.lamelibrary.MP3Recorder;
import cn.sopho.destiny.lamelibrary.PCMFormat;
import me.nereo.multi_image_selector.MultiImageSelector;

/**
 * Created by nene on 2016/11/30.
 * 添加离任报告
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/30 15:25]
 * @Version: [v1.0]
 */
public class AddDepartureReportActivity extends BaseActivity implements View.OnClickListener, AddBossCommentGridAdapter.ImageDeleteListener,
        DepartureReportView, VoicePopupWindow.PlayOrDeleteVoiceListener, DialogUtils.ArchiveDialogListener,AllAuditorAdapter.AuditorDeleteListener {

    private InputMethodManager manager;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.activity_select_employee_record)
    RelativeLayout mSelectEmployeeRecord;// 选择员工档案
    @BindView(R.id.activity_employee_record)
    LinearLayout mEmployeeRecord;// 员工档案条目
    @BindView(R.id.employee_record_basic_message)
    RelativeLayout mEmployeeRecordChange;
    @BindView(R.id.activity_edit_message_photo_name)
    TextView mEmployeeName;
    @BindView(R.id.employee_position)
    TextView mEmployeePosition;
    @BindView(R.id.employee_department)
    TextView mEmployeeDepartment;
    @BindView(R.id.change_departure_position)
    TextView mNewBuildPosition;// 新建离任职务
    @BindView(R.id.activity_select_comment_time)
    RelativeLayout mSelectTime;// 离任时间条目
    @BindView(R.id.activity_edit_phone)
    RelativeLayout mDepartureSalary;// 离任薪水条目
    @BindView(R.id.edit_select_comment_time)
    TextView mDepartureTime;// 显示离任时间
    @BindView(R.id.activity_phone_number)
    EditText mInputSalary;// 显示离任薪水
    @BindView(R.id.departure_cause_gridview)
    NoScrollGridView mDepartureCause;
    @BindView(R.id.supplementary_instruction)
    EditText mSupplementaryInstruction;// 离任原因补充说明
    @BindView(R.id.current_img)
    TextView mCurrentInstructionNumber;// 离任补充说明当前字数
    @BindView(R.id.rangeSeekBar1)
    RangeSeekBar mRangeSeekBar1;
    @BindView(R.id.rangeSeekBar2)
    RangeSeekBar mRangeSeekBar2;
    @BindView(R.id.rangeSeekBar3)
    RangeSeekBar mRangeSeekBar3;
    @BindView(R.id.rangeSeekBar4)
    RangeSeekBar mRangeSeekBar4;
    @BindView(R.id.rangeSeekBar5)
    RangeSeekBar mRangeSeekBar5;
    @BindView(R.id.rangeSeekBar6)
    RangeSeekBar mRangeSeekBar6;
    @BindView(R.id.rangeSeekBar1_grade)
    TextView mRangeSeekBar1Grade;
    @BindView(R.id.rangeSeekBar2_grade)
    TextView mRangeSeekBar2Grade;
    @BindView(R.id.rangeSeekBar3_grade)
    TextView mRangeSeekBar3Grade;
    @BindView(R.id.rangeSeekBar4_grade)
    TextView mRangeSeekBar4Grade;
    @BindView(R.id.rangeSeekBar5_grade)
    TextView mRangeSeekBar5Grade;
    @BindView(R.id.rangeSeekBar6_grade)
    TextView mRangeSeekBar6Grade;
    @BindView(R.id.boss_comment_content)
    EditText mLeaveComments;// 离任评语
    @BindView(R.id.total_content_number)
    TextView mLeaveCommentsCurrentNumber;// 离任评语当前字数
    @BindView(R.id.camera)
    ImageView mCamera;
    @BindView(R.id.record_voice)
    ImageView record_voice;
    @BindView(R.id.img_gridview)
    NoScrollGridView mImageViewsGridView;
    @BindView(R.id.voice)
    RelativeLayout voice;
    @BindView(R.id.click_voice)
    LinearLayout mClickVoice;
    @BindView(R.id.playing_ani)
    ImageView playing_ani;
    @BindView(R.id.voice_time_length)
    TextView mVoiceTime;
    @BindView(R.id.delete_voice)
    ImageView mDeleteVoice;
    @BindView(R.id.aspiration_gridview)
    NoScrollGridView mCompanyAspirationCause;
    @BindView(R.id.all_auditor)
    ResultListView mAllAuditor;
    @BindView(R.id.add_comment_auditor)
    ImageView mAddCommentAuditor;
    @BindView(R.id.include_button_button)
    Button mSubmit;
    @BindView(R.id.include_head_title_tab3)
    TextView mSubmitReportBt;
    @BindView(R.id.include_head_title_re2)
    RelativeLayout mSubmitReport;
    @BindView(R.id.scrollview)
    ScrollView scrollview;
    @BindView(R.id.activity_employee_photo)
    RoundAngleImageView mEmployeeAvatar;// 档案头像
    @BindView(R.id.add_hint)
    RelativeLayout mAddHint;
    @BindView(R.id.cancel_hint)
    ImageView mCancelHint;
    @BindView(R.id.select_send_sms)
    LinearLayout mSelectSendSms;
    @BindView(R.id.send_sms_check)
    CheckBox mSendSmsCheck;
    @BindView(R.id.auditor_title)
    TextView mAuditorTitle;
    private int numContent = 100;
    private int numLeaveCommentsCurrent = 500;
    private List<DepartureTagEntity> DepartureCauses;
    private List<DepartureTagEntity> CompanyAspirations;
    private RadioButtonGridAdapter DepartureCauseAdapter;// 离任原因gridview
    private RadioButtonGridAdapter CompanyAspirationAdapter;// 返聘意愿gridview
    private EmployeArchiveEntity employeArchiveEntity;// 选择的档案信息
    private long mArchiveId;// 档案id，即所要添加阶段评价的档案id
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_AVATAR_OPTIONS;
    private static SimpleDateFormat sdfymdhms = new SimpleDateFormat("yyyy年MM月dd日");
    private AllAuditorAdapter mAllAuditorAdapter;// 用于mAllAuditor列表
    private List<MemberEntity> mAuditors;// 审核人集合
    private ArrayList<String> imgs;
    private File file;
    private MP3Recorder mRecorder;
    private File voiceFilePath;
    private MediaPlayer mediaPlayer;
    private int VoiceLength;
    private boolean isPlaying;
    private String mNetVoiceUrl;
    private Player player;
    private Date mEntryTime;
    private VoicePopupWindow mVoicePopupWindow;
    private int mCurrentUserIsAuditor;

    private Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if (msg.what == 1) {
//                showProgresbarDialog();
                mRecordTimer.schedule(new TimerTask() {
                    int m = 0;

                    @Override
                    public void run() {
                        if (mRecorder.isRecording()) {
                            VoiceLength = ++m;
                        }
                        mVoicePopupWindow.setVoiceLength(m);
                    }
                }, 0, 1000);
            }
        }
    };
    private Handler mPopHandler;
    private Timer mRecordTimer;
    private AnimationDrawable voiceAnimation = null;
    private AddBossCommentGridAdapter adapter;
    private Dialog dialog;
    private AddDepartureReportPresenter mAddDepartureReportPresenter;
    private String mOperation;
    private ArchiveCommentEntity mCurrentArchiveComment;
    private ArrayList<String> changeImgs;
    private ArrayList<String> mSelectPath;

    @Override
    public int getContentViewId() {
        return R.layout.activity_add_departure_report;
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
        initRecord();
        initViewsData();
        initListener();
        setSystemBarTintManager(this);
    }

    public void initRecord() {
        file = ImageUtils.getFileCacheDirectory(getApplicationContext(), "com.juxian.bosscomments/OutVoice");
        if (!file.exists() || file.isDirectory())
            file.mkdirs();
        voiceFilePath = new File(file, System.currentTimeMillis() + ".mp3");
        mRecorder = new MP3Recorder(voiceFilePath, mHandler);
        player = new Player(getApplicationContext());
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText(getString(R.string.add_departure_report));
        mSubmitReportBt.setVisibility(View.VISIBLE);
        mSubmitReportBt.setText(getString(R.string.submit));
        mSubmitReport.setVisibility(View.VISIBLE);
        mSubmit.setText(getString(R.string.submit));
        mAuditorTitle.setText("添加审核人（一人通过审核即生效）");

        mAddDepartureReportPresenter = new AddDepartureReportPresenterImpl(getApplicationContext(), this);
        mRangeSeekBar1.setSelectedMaxValue(0);
        mRangeSeekBar2.setSelectedMaxValue(0);
        mRangeSeekBar3.setSelectedMaxValue(0);
        mRangeSeekBar4.setSelectedMaxValue(0);
        mRangeSeekBar5.setSelectedMaxValue(0);
        mRangeSeekBar6.setSelectedMaxValue(0);
        if (Bimp.drr.size() != 0) {
            Bimp.drr.clear();
        }
        if (ImageUtils.saveFilePaths.size() != 0) {
            ImageUtils.saveFilePaths.clear();
        }
        // 判断操作方式
        mOperation = getIntent().getStringExtra("Operation");
        if ("Change".equals(mOperation)) {
            title.setText("修改离任报告");
        }
        DepartureCauses = new ArrayList<>();
        CompanyAspirations = new ArrayList<>();
//        getTags();
        DepartureCauseAdapter = new RadioButtonGridAdapter(DepartureCauses, getApplicationContext());
        CompanyAspirationAdapter = new RadioButtonGridAdapter(CompanyAspirations, getApplicationContext());
        mDepartureCause.setAdapter(DepartureCauseAdapter);
        mCompanyAspirationCause.setAdapter(CompanyAspirationAdapter);

        imgs = new ArrayList<>();
        changeImgs = new ArrayList<>();
        mPopHandler = new Handler();
        if ("Have".equals(getIntent().getStringExtra("Tag"))) {
            mEmployeeRecord.setVisibility(View.VISIBLE);
            mSelectEmployeeRecord.setVisibility(View.GONE);
        } else {
            mEmployeeRecord.setVisibility(View.GONE);
            mSelectEmployeeRecord.setVisibility(View.VISIBLE);
        }

        adapter = new AddBossCommentGridAdapter(imgs, this, this);
        mImageViewsGridView.setAdapter(adapter);

        initArchive();
        initAuditors();
    }

    @Override
    public void loadPageData() {
        super.loadPageData();
        getTags();
    }

    public void initArchive() {
        // 添加档案之后，跳转过来的
        if ("continue".equals(getIntent().getStringExtra("isContinue"))) {
            employeArchiveEntity = JsonUtil.ToEntity(getIntent().getStringExtra("EmployeArchiveEntity"), EmployeArchiveEntity.class);
            mArchiveId = employeArchiveEntity.ArchiveId;
            mEmployeeRecord.setVisibility(View.VISIBLE);
            mSelectEmployeeRecord.setVisibility(View.GONE);
            Bitmap bitmap = BitmapFactory.decodeFile(employeArchiveEntity.Picture);
            mEmployeeAvatar.setImageBitmap(bitmap);
//            ImageLoader.getInstance().displayImage(employeArchiveEntity.Picture, mEmployeeAvatar, options, animateFirstListener);
            mEmployeeName.setText(employeArchiveEntity.RealName);
            mEmployeePosition.setText(employeArchiveEntity.WorkItem.PostTitle);
            mEmployeeDepartment.setText(employeArchiveEntity.WorkItem.Department);
            mEntryTime = employeArchiveEntity.EntryTime;
        }
    }

    public void initAuditors() {
        mAuditors = new ArrayList<>();
        MemberEntity entity = JsonUtil.ToEntity(AppConfig.getBossInformation(), MemberEntity.class);
        mAuditors.add(entity);
        mAllAuditorAdapter = new AllAuditorAdapter(mAuditors, getApplicationContext(),this);
        mAllAuditor.setAdapter(mAllAuditorAdapter);
        if ("Change".equals(mOperation)) {
            mSelectSendSms.setVisibility(View.GONE);
        } else {
            MemberEntity currentMemberEntity = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);
            if (currentMemberEntity.PassportId == entity.PassportId) {
                mSelectSendSms.setVisibility(View.VISIBLE);
            }
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mSelectEmployeeRecord.setOnClickListener(this);
        mSelectTime.setOnClickListener(this);
        mCamera.setOnClickListener(this);
        record_voice.setOnClickListener(this);
        mClickVoice.setOnClickListener(this);
        mDeleteVoice.setOnClickListener(this);
        mAddCommentAuditor.setOnClickListener(this);
        mSubmit.setOnClickListener(this);
        mSubmitReport.setOnClickListener(this);
        mNewBuildPosition.setOnClickListener(this);
        mSelectSendSms.setOnClickListener(this);
        if ("Change".equals(mOperation)) {

        } else {
            if ("continue".equals(getIntent().getStringExtra("isContinue"))) {

            } else {
                mEmployeeRecordChange.setOnClickListener(this);
            }
        }
        mSupplementaryInstruction.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void afterTextChanged(Editable editable) {
                int number = editable.length();
                mCurrentInstructionNumber.setText("" + number);
                if (mSupplementaryInstruction.getText().toString().length() > numContent) {
                    mCurrentInstructionNumber.setTextColor(AddDepartureReportActivity.this
                            .getResources().getColor(
                                    R.color.above_proof));
                }
                if (mSupplementaryInstruction.getText().toString().length() <= numContent) {
                    mCurrentInstructionNumber.setTextColor(AddDepartureReportActivity.this
                            .getResources()
                            .getColor(R.color.menu_color));
                }
            }
        });
        mLeaveComments.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void afterTextChanged(Editable editable) {
                int number = editable.length();
                mLeaveCommentsCurrentNumber.setText("" + number);
                if (mLeaveComments.getText().toString().length() > numLeaveCommentsCurrent) {
                    mLeaveCommentsCurrentNumber.setTextColor(AddDepartureReportActivity.this
                            .getResources().getColor(
                                    R.color.above_proof));
                }
                if (mLeaveComments.getText().toString().length() <= numLeaveCommentsCurrent) {
                    mLeaveCommentsCurrentNumber.setTextColor(AddDepartureReportActivity.this
                            .getResources()
                            .getColor(R.color.menu_color));
                }
            }
        });
        scrollview.setOnTouchListener(new View.OnTouchListener() {

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                // TODO Auto-generated method stub
                Global.CloseKeyBoard(mLeaveComments);
                return false;
            }
        });
        mInputSalary.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                if (charSequence.toString().contains(".")) {
                    if (charSequence.length() - 1 - charSequence.toString().indexOf(".") > 2) {
                        charSequence = charSequence.toString().subSequence(0,
                                charSequence.toString().indexOf(".") + 3);
                        mInputSalary.setText(charSequence);
                        mInputSalary.setSelection(charSequence.length());
                    }
                }
                if (charSequence.toString().trim().substring(0).equals(".")) {
                    charSequence = "0" + charSequence;
                    mInputSalary.setText(charSequence);
                    mInputSalary.setSelection(2);
                }

                if (charSequence.toString().startsWith("0")
                        && charSequence.toString().trim().length() > 1) {
                    if (!charSequence.toString().substring(1, 2).equals(".")) {
                        mInputSalary.setText(charSequence.subSequence(0, 1));
                        mInputSalary.setSelection(1);
                        return;
                    }
                }
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });
        mRangeSeekBar1.setOnRangeSeekBarChangeListener(new RangeSeekBarChangeListener(mRangeSeekBar1Grade));
        mRangeSeekBar2.setOnRangeSeekBarChangeListener(new RangeSeekBarChangeListener(mRangeSeekBar2Grade));
        mRangeSeekBar3.setOnRangeSeekBarChangeListener(new RangeSeekBarChangeListener(mRangeSeekBar3Grade));
        mRangeSeekBar4.setOnRangeSeekBarChangeListener(new RangeSeekBarChangeListener(mRangeSeekBar4Grade));
        mRangeSeekBar5.setOnRangeSeekBarChangeListener(new RangeSeekBarChangeListener(mRangeSeekBar5Grade));
        mRangeSeekBar6.setOnRangeSeekBarChangeListener(new RangeSeekBarChangeListener(mRangeSeekBar6Grade));
        mCancelHint.setOnClickListener(this);
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
    public void onBackPressed() {
        deleteImages();
        imgs.clear();
        super.onBackPressed();
    }

    private void deleteImages(){
        for (int i = 0; i < ImageUtils.saveFilePaths.size(); i++) {
            File imageFile = new File(ImageUtils.saveFilePaths.get(i));
            if (imageFile.exists()) {
                imageFile.delete();
            }
        }
        ImageUtils.saveFilePaths.clear();
        if (voiceFilePath.exists())
            voiceFilePath.delete();
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (player.isPlaying)
            player.stop();
        if (isPlaying)
            stopPlayVoice();
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                if ("Change".equals(mOperation)) {
                    finish();
                } else {
                    if (employeArchiveEntity != null || !TextUtils.isEmpty(mDepartureTime.getText().toString()) || !TextUtils.isEmpty(mInputSalary.getText().toString()) ||
                            DepartureCauseAdapter.getCurrentSelect() != null || !TextUtils.isEmpty(mSupplementaryInstruction.getText().toString().trim()) ||
                            (Integer) mRangeSeekBar1.getSelectedMaxValue() != 0 || (Integer) mRangeSeekBar2.getSelectedMaxValue() != 0 ||
                            (Integer) mRangeSeekBar3.getSelectedMaxValue() != 0 || (Integer) mRangeSeekBar4.getSelectedMaxValue() != 0 ||
                            (Integer) mRangeSeekBar5.getSelectedMaxValue() != 0 || (Integer) mRangeSeekBar6.getSelectedMaxValue() != 0 ||
                            CompanyAspirationAdapter.getCurrentSelect() != null || !TextUtils.isEmpty(mLeaveComments.getText().toString()) ||
                            voiceFilePath.exists() || imgs.size() > 0 || mAuditors.size() > 1) {
                        DialogUtils.showStandardTitleDialog(this, "否", "是", "温馨提示", "信息尚未保存，是否离开？", new DialogUtils.StandardTitleDialogListener() {
                            @Override
                            public void LeftBtMethod() {

                            }

                            @Override
                            public void RightBtMethod() {
                                // 点评成功或者不点评直接退出的时候，删除相应的压缩图片，减小缓存大小
                                deleteImages();
                                imgs.clear();
                                AddDepartureReportActivity.this.finish();
                            }
                        });
                    } else {
                        finish();
                    }
                }
                break;
            case R.id.activity_select_employee_record:
                // 选择员工档案
                Intent SelectRecord = new Intent(getApplicationContext(), AllEmployeeRecordActivity.class);
                SelectRecord.putExtra("CommentType", "DeportReport");
                SelectRecord.putExtra("ArchiveList", "SelectArchive");
                startActivityForResult(SelectRecord, 500);
                break;
            case R.id.employee_record_basic_message:
                Intent SelectRecord1 = new Intent(getApplicationContext(), AllEmployeeRecordActivity.class);
                SelectRecord1.putExtra("CommentType", "DeportReport");
                SelectRecord1.putExtra("ArchiveList", "SelectArchive");
                startActivityForResult(SelectRecord1, 500);
                break;
            case R.id.activity_select_comment_time:
                // 选择离任时间
                Intent SelectDepartureTime = new Intent(getApplicationContext(), EditTimeActivity.class);
                if (TextUtils.isEmpty(mDepartureTime.getText().toString().trim())){
                    SelectDepartureTime.putExtra("data", sdfymdhms.format(new Date()));
                } else {
                    SelectDepartureTime.putExtra("data", mDepartureTime.getText().toString().trim());
                }
                startActivityForResult(SelectDepartureTime, 600);
                break;
            case R.id.camera:
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
                        if (imgs.size() >= 9) {
                            ToastUtil.showInfo(getString(R.string.max_select_nine_picture));
                            return;
                        }
                        MultiImageSelector selector = MultiImageSelector.create(AddDepartureReportActivity.this);
                        selector.showCamera(true);
                        selector.count(9-changeImgs.size());
//                        if (mChoiceMode.getCheckedRadioButtonId() == R.id.single) {
//                            selector.single();
//                        } else {
                        selector.multi();
//                        }
                        selector.origin(mSelectPath);
                        selector.start(AddDepartureReportActivity.this, 520);
                    }
                } else {
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                        PermissionUtils.requestPermission(this, PermissionUtils.CODE_READ_EXTERNAL_STORAGE, mPermissionGrant);
                    } else {
                        if (imgs.size() >= 9) {
                            ToastUtil.showInfo(getString(R.string.max_select_nine_picture));
                            return;
                        }
//                        Intent ChangeAvatar1 = new Intent(getApplicationContext(), ImageGridActivity.class);
//                        if ("Change".equals(mOperation)) {
//                            ChangeAvatar1.putExtra("NetPic", changeImgs.size());
//                        }
//                        ChangeAvatar1.putExtra("Tag", "nine");
//                        startActivityForResult(ChangeAvatar1, 520);
                        MultiImageSelector selector = MultiImageSelector.create(AddDepartureReportActivity.this);
                        selector.showCamera(true);
                        selector.count(9-changeImgs.size());
//                        if (mChoiceMode.getCheckedRadioButtonId() == R.id.single) {
//                            selector.single();
//                        } else {
                        selector.multi();
//                        }
                        selector.origin(mSelectPath);
                        selector.start(AddDepartureReportActivity.this, 520);
                    }
                }
                break;
            case R.id.record_voice:
                if (Build.VERSION.SDK_INT < 23) {
                    AudioRecord mRecorders = null;
                    try {
                        int mBufferSize = AudioRecord.getMinBufferSize(44100,
                                AudioFormat.CHANNEL_IN_MONO, PCMFormat.PCM_16BIT.getAudioFormat());
                        mRecorders = new AudioRecord(MediaRecorder.AudioSource.MIC,
                                44100, AudioFormat.CHANNEL_IN_MONO, PCMFormat.PCM_16BIT.getAudioFormat(),
                                mBufferSize);
                        mRecorders.startRecording();
                    } catch (Exception e){

                    } finally {
                        mRecorders.stop();
                        if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED) {
                            checkSelfPermissionUtils.checkPermission(this, Manifest.permission.RECORD_AUDIO);
                        }
                    }
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED) {
                        if (voiceFilePath.exists() || mNetVoiceUrl != null) {
                            // 判断语音是否存在，存在则不让点击再次录音
                            record_voice.setImageResource(R.drawable.no_record_voice);
                            ToastUtil.showInfo(getString(R.string.voice_record_limit));
                            return;
                        }
                        mRecordTimer = new Timer();
                        mVoicePopupWindow = new VoicePopupWindow(this, getApplicationContext(), mRecorder, record_voice, voiceFilePath, mVoiceTime, voice, mRecordTimer, this, mPopHandler);
                        mVoicePopupWindow.showAtLocation(AddDepartureReportActivity.this.getWindow().getDecorView(), Gravity.BOTTOM, 0, 0);
                    }
                } else {
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED) {
                        PermissionUtils.requestPermission(this, PermissionUtils.CODE_RECORD_AUDIO, mPermissionGrant);
                    } else {
                        if (voiceFilePath.exists() || mNetVoiceUrl != null) {
                            // 判断语音是否存在，存在则不让点击再次录音
                            record_voice.setImageResource(R.drawable.no_record_voice);
                            ToastUtil.showInfo(getString(R.string.voice_record_limit));
                            return;
                        }
                        mRecordTimer = new Timer();
                        mVoicePopupWindow = new VoicePopupWindow(this, getApplicationContext(), mRecorder, record_voice, voiceFilePath, mVoiceTime, voice, mRecordTimer, this, mPopHandler);
                        mVoicePopupWindow.showAtLocation(AddDepartureReportActivity.this.getWindow().getDecorView(), Gravity.BOTTOM, 0, 0);
                    }
                }
                break;
            case R.id.click_voice:
                // 试听录音
                if ("Change".equals(mOperation)) {
                    if (TextUtils.isEmpty(mNetVoiceUrl)) {
                        playOrStopVoice();
                    } else {
                        Log.e(Global.LOG_TAG, "bofang");
                        playOrStopVoice(mNetVoiceUrl);
                    }
                } else {
                    playOrStopVoice();
                }
                break;
            case R.id.delete_voice:
                mNetVoiceUrl = null;
                deleteVoiceFile();
                break;
            case R.id.add_comment_auditor:
                // 添加审核人
                Intent SelectAuditor = new Intent(getApplicationContext(), SelectAuditorActivity.class);
                startActivityForResult(SelectAuditor, 400);
                break;
            case R.id.include_button_button:
                clickPost();
                break;
            case R.id.include_head_title_re2:
                clickPost();
                break;
            case R.id.cancel_hint:
                mAddHint.setVisibility(View.GONE);
                break;
            case R.id.change_departure_position:
                // 新建离任职务
                Intent HoldPost = new Intent(getApplicationContext(), HoldPostActivity.class);
                HoldPost.putExtra("ArchiveId", mArchiveId);
                HoldPost.putExtra("new_build", "new_build");
                startActivityForResult(HoldPost, 700);
                break;
            case R.id.select_send_sms:
                if (mSendSmsCheck.isChecked()) {
                    mSendSmsCheck.setChecked(false);
                } else {
                    mSendSmsCheck.setChecked(true);
                }
                break;
        }
    }

    private PermissionUtils.PermissionGrant mPermissionGrant = new PermissionUtils.PermissionGrant() {
        @Override
        public void onPermissionGranted(int requestCode) {
            switch (requestCode) {
                case PermissionUtils.CODE_RECORD_AUDIO:
                    if (voiceFilePath.exists() || mNetVoiceUrl != null) {
                        // 判断语音是否存在，存在则不让点击再次录音
                        record_voice.setImageResource(R.drawable.no_record_voice);
                        ToastUtil.showInfo(getString(R.string.voice_record_limit));
                        return;
                    }
                    mRecordTimer = new Timer();
                    mVoicePopupWindow = new VoicePopupWindow(AddDepartureReportActivity.this, getApplicationContext(), mRecorder, record_voice, voiceFilePath, mVoiceTime, voice, mRecordTimer, AddDepartureReportActivity.this, mPopHandler);
                    mVoicePopupWindow.showAtLocation(AddDepartureReportActivity.this.getWindow().getDecorView(), Gravity.BOTTOM, 0, 0);
                    break;
                case PermissionUtils.CODE_GET_ACCOUNTS:
                    Toast.makeText(AddDepartureReportActivity.this, "Result Permission Grant CODE_GET_ACCOUNTS", Toast.LENGTH_SHORT).show();
                    break;
                case PermissionUtils.CODE_READ_PHONE_STATE:
                    Toast.makeText(AddDepartureReportActivity.this, "Result Permission Grant CODE_READ_PHONE_STATE", Toast.LENGTH_SHORT).show();
                    break;
                case PermissionUtils.CODE_CALL_PHONE:
                    Toast.makeText(AddDepartureReportActivity.this, "Result Permission Grant CODE_CALL_PHONE", Toast.LENGTH_SHORT).show();
                    break;
                case PermissionUtils.CODE_CAMERA:
                    Toast.makeText(AddDepartureReportActivity.this, "Result Permission Grant CODE_CAMERA", Toast.LENGTH_SHORT).show();
                    break;
                case PermissionUtils.CODE_ACCESS_FINE_LOCATION:
                    Toast.makeText(AddDepartureReportActivity.this, "Result Permission Grant CODE_ACCESS_FINE_LOCATION", Toast.LENGTH_SHORT).show();
                    break;
                case PermissionUtils.CODE_ACCESS_COARSE_LOCATION:
                    Toast.makeText(AddDepartureReportActivity.this, "Result Permission Grant CODE_ACCESS_COARSE_LOCATION", Toast.LENGTH_SHORT).show();
                    break;
                case PermissionUtils.CODE_READ_EXTERNAL_STORAGE:
                    if (imgs.size() >= 9) {
                        ToastUtil.showInfo(getString(R.string.max_select_nine_picture));
                        return;
                    }
                    MultiImageSelector selector = MultiImageSelector.create(AddDepartureReportActivity.this);
                    selector.showCamera(true);
                    selector.count(9-changeImgs.size());
//                        if (mChoiceMode.getCheckedRadioButtonId() == R.id.single) {
//                            selector.single();
//                        } else {
                    selector.multi();
//                        }
                    selector.origin(mSelectPath);
                    selector.start(AddDepartureReportActivity.this, 520);
                    break;
                case PermissionUtils.CODE_WRITE_EXTERNAL_STORAGE:
                    Toast.makeText(AddDepartureReportActivity.this, "Result Permission Grant CODE_WRITE_EXTERNAL_STORAGE", Toast.LENGTH_SHORT).show();
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
    public boolean dispatchTouchEvent(MotionEvent event) {
        if (mVoicePopupWindow != null && mVoicePopupWindow.isShowing()) {
            return false;
        }
        return super.dispatchTouchEvent(event);
    }

    public void clickPost() {
        if (employeArchiveEntity == null) {
            ToastUtil.showInfo("请选择档案");
            return;
        }
        if (TextUtils.isEmpty(mDepartureTime.getText().toString())) {
            ToastUtil.showInfo(getString(R.string.please_select_dimission_time));
            return;
        }
        if (mDepartureTime.getText().toString().equals(sdfymdhms.format(mEntryTime))){

        } else {
            try {
                if (mEntryTime.after(sdfymdhms.parse(mDepartureTime.getText().toString()))) {
                    ToastUtil.showInfo("离职时间小于入职时间，请重新填写");
                    return;
                }
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        if (!TextUtils.isEmpty(mInputSalary.getText().toString())) {
            if (Double.parseDouble(mInputSalary.getText().toString().trim()) > 999 || Double.parseDouble(mInputSalary.getText().toString().trim()) < 3) {
                ToastUtil.showInfo(getString(R.string.wage_income_length_limit));
                return;
            }
        }
        if (DepartureCauseAdapter.getCurrentSelect() == null) {
            ToastUtil.showInfo(getString(R.string.please_select_departure_cause));
            return;
        }
//        if (TextUtils.isEmpty(DepartureCauseAdapter.getCurrentSelect())) {
//            ToastUtil.showInfo(getString(R.string.please_select_departure_cause));
//            return;
//        }
        if (mSupplementaryInstruction.getText().toString().trim().length() > 100) {
            ToastUtil.showInfo(getString(R.string.supplementary_instruction_length_limit));
            return;
        }
        if (TextUtils.isEmpty(mLeaveComments.getText().toString())) {
            ToastUtil.showInfo(getString(R.string.please_input_leave_comments));
            mLeaveComments.requestFocus();
            return;
        }
        if (CompanyAspirationAdapter.getCurrentSelect() == null) {
            ToastUtil.showInfo(getString(R.string.please_select_company_aspiration));
            return;
        }
//        if (TextUtils.isEmpty(CompanyAspirationAdapter.getCurrentSelect())) {
//            ToastUtil.showInfo(getString(R.string.please_select_company_aspiration));
//            return;
//        }
        if (mLeaveComments.getText().toString().length() > 500) {
            ToastUtil.showInfo(getString(R.string.leave_comments_length_limit));
            mLeaveComments.requestFocus();
            return;
        }
        if ("Change".equals(mOperation)) {
            clickChange();
        } else {
            clickAdd();
        }
    }

    public void clickAdd() {
        ArchiveCommentEntity entity = new ArchiveCommentEntity();
        entity.CompanyId = AppConfig.getCurrentUseCompany();
        entity.ArchiveId = mArchiveId;
        entity.CommentType = 1;
        try {
            entity.DimissionTime = sdfymdhms.parse(mDepartureTime.getText().toString());
        } catch (ParseException e) {
            e.printStackTrace();
        }
        entity.DimissionSalary = mInputSalary.getText().toString().trim();
        entity.DimissionReason = DepartureCauseAdapter.getCurrentSelect().Code;
        entity.DimissionSupply = mSupplementaryInstruction.getText().toString().trim();
        entity.WorkAbility = (Integer) mRangeSeekBar1.getSelectedMaxValue();
        entity.WorkAttitude = (Integer) mRangeSeekBar2.getSelectedMaxValue();
        entity.WorkPerformance = (Integer) mRangeSeekBar3.getSelectedMaxValue();
        entity.HandoverTimely = (Integer) mRangeSeekBar4.getSelectedMaxValue();
        entity.HandoverOverall = (Integer) mRangeSeekBar5.getSelectedMaxValue();
        entity.HandoverSupport = (Integer) mRangeSeekBar6.getSelectedMaxValue();
        entity.WantRecall = CompanyAspirationAdapter.getCurrentSelect().Code;
        entity.WorkComment = mLeaveComments.getText().toString();
        entity.AuditPersons = new ArrayList<>();
        for (int i = 0; i < mAuditors.size(); i++) {
            entity.AuditPersons.add(mAuditors.get(i).PassportId);
        }
//        Log.e(Global.LOG_TAG, entity.toString());
//        if (imgs.size() > 0) {
//            entity.WorkCommentImages = new String[imgs.size()];
//            for (int i = 0; i < imgs.size(); i++) {
//                entity.WorkCommentImages[i] = ImageUtil.toUploadBase64(imgs.get(i));
//            }
//        }
        if (voiceFilePath.exists()) {
            try {
                entity.WorkCommentVoiceSecond = VoiceLength;
                entity.WorkCommentVoice = FileUtil.encodeBase64File(voiceFilePath.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        mCurrentUserIsAuditor = 0;
        MemberEntity memberEntity = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);
        for (int i = 0; i < mAuditors.size(); i++) {
            if (memberEntity.PassportId == mAuditors.get(i).PassportId) {
                mCurrentUserIsAuditor++;
            }
        }
        if (mSendSmsCheck.isChecked()) {
            entity.IsSendSms = true;
        } else {
            entity.IsSendSms = false;
        }
        mAddDepartureReportPresenter.addDepartureReport(imgs,entity);
//        if (mCurrentUserIsAuditor == 1) {
//            DialogUtils.showArchiveDialog(this, getString(R.string.stage_archive_dialog_one), entity, this);
//        } else {
//            DialogUtils.showArchiveDialog(this, getString(R.string.stage_archive_dialog_two), entity, this);
//        }

    }

    public void clickChange() {
        try {
            mCurrentArchiveComment.DimissionTime = sdfymdhms.parse(mDepartureTime.getText().toString());
        } catch (ParseException e) {
            e.printStackTrace();
        }
        mCurrentArchiveComment.DimissionSalary = mInputSalary.getText().toString().trim();
        if (DepartureCauseAdapter.getCurrentSelect() != null) {
            mCurrentArchiveComment.DimissionReason = DepartureCauseAdapter.getCurrentSelect().Code;
        }
        mCurrentArchiveComment.DimissionSupply = mSupplementaryInstruction.getText().toString().trim();
        mCurrentArchiveComment.WorkAbility = (Integer) mRangeSeekBar1.getSelectedMaxValue();
        mCurrentArchiveComment.WorkAttitude = (Integer) mRangeSeekBar2.getSelectedMaxValue();
        mCurrentArchiveComment.WorkPerformance = (Integer) mRangeSeekBar3.getSelectedMaxValue();
        mCurrentArchiveComment.HandoverTimely = (Integer) mRangeSeekBar4.getSelectedMaxValue();
        mCurrentArchiveComment.HandoverOverall = (Integer) mRangeSeekBar5.getSelectedMaxValue();
        mCurrentArchiveComment.HandoverSupport = (Integer) mRangeSeekBar6.getSelectedMaxValue();
        if (CompanyAspirationAdapter.getCurrentSelect() != null) {
            mCurrentArchiveComment.WantRecall = CompanyAspirationAdapter.getCurrentSelect().Code;
        }
        mCurrentArchiveComment.WorkComment = mLeaveComments.getText().toString();
        mCurrentArchiveComment.AuditPersons = new ArrayList<>();
        for (int i = 0; i < mAuditors.size(); i++) {
            mCurrentArchiveComment.AuditPersons.add(mAuditors.get(i).PassportId);
        }
//        if (imgs.size() > 0) {
//            mCurrentArchiveComment.WorkCommentImages = new String[imgs.size()];
//            for (int i = 0; i < imgs.size(); i++) {
//                if (imgs.get(i).startsWith("http")) {
//                    mCurrentArchiveComment.WorkCommentImages[i] = imgs.get(i);
//                } else {
//                    mCurrentArchiveComment.WorkCommentImages[i] = ImageUtil.toUploadBase64(imgs.get(i));
//                }
//            }
//        }
        if (voiceFilePath.exists()) {
            try {
                mCurrentArchiveComment.WorkCommentVoiceSecond = VoiceLength;
                mCurrentArchiveComment.WorkCommentVoice = FileUtil.encodeBase64File(voiceFilePath.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        mCurrentUserIsAuditor = 0;
        MemberEntity memberEntity = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);
        for (int i = 0; i < mAuditors.size(); i++) {
            if (memberEntity.PassportId == mAuditors.get(i).PassportId) {
                mCurrentUserIsAuditor++;
            }
        }
        mAddDepartureReportPresenter.updateDepartureReport(changeImgs,mSelectPath,mCurrentArchiveComment);
//        if (mCurrentUserIsAuditor == 1) {
//            DialogUtils.showArchiveDialog(this, getString(R.string.stage_archive_dialog_one), mCurrentArchiveComment, this);
//        } else {
//            DialogUtils.showArchiveDialog(this, getString(R.string.stage_archive_dialog_two), mCurrentArchiveComment, this);
//        }

    }

    @Override
    public void LeftBtMethod() {
        if ("Change".equals(mOperation)) {
//            ToastUtil.showInfo("修改成功");
            setResult(RESULT_OK);
            finish();
        } else {
            Intent AddComments = new Intent(getApplicationContext(), MyCommentActivity.class);
            startActivity(AddComments);
            finish();
        }
    }

    @Override
    public void RightBtMethod(ArchiveCommentEntity entity) {
        mEmployeeRecord.setVisibility(View.GONE);
        mSelectEmployeeRecord.setVisibility(View.VISIBLE);
        employeArchiveEntity = null;
        mSupplementaryInstruction.setText("");
        mDepartureTime.setText("");
        mInputSalary.setText("");
        mRangeSeekBar1.setSelectedMaxValue(0);
        mRangeSeekBar2.setSelectedMaxValue(0);
        mRangeSeekBar3.setSelectedMaxValue(0);
        mRangeSeekBar4.setSelectedMaxValue(0);
        mRangeSeekBar5.setSelectedMaxValue(0);
        mRangeSeekBar6.setSelectedMaxValue(0);
        mLeaveComments.setText("");
//        DepartureCauseAdapter = new RadioButtonGridAdapter(DepartureCauses, getApplicationContext());
//        CompanyAspirationAdapter = new RadioButtonGridAdapter(CompanyAspirations, getApplicationContext());
        mAuditors.clear();
        MemberEntity entity2 = JsonUtil.ToEntity(AppConfig.getBossInformation(), MemberEntity.class);
        mAuditors.add(entity2);
        mAllAuditorAdapter.notifyDataSetChanged();

        ArrayList<DepartureTagEntity> DepartureCausesList = new ArrayList<>();
        DepartureCausesList.addAll(DepartureCauses);
        DepartureCauses.clear();
        for (int i=0;i<DepartureCausesList.size();i++){
            DepartureTagEntity entity1 = new DepartureTagEntity();
            entity1.TagName = DepartureCausesList.get(i).TagName;
            entity1.Code = DepartureCausesList.get(i).Code;
            entity1.isChecked = false;
            DepartureCauses.add(entity1);
        }
        DepartureCauseAdapter.notifyDataSetChanged();

        ArrayList<DepartureTagEntity> CompanyAspirationsList = new ArrayList<>();
        CompanyAspirationsList.addAll(CompanyAspirations);
        CompanyAspirations.clear();
        for (int i=0;i<CompanyAspirationsList.size();i++){
            DepartureTagEntity entity1 = new DepartureTagEntity();
            entity1.TagName = CompanyAspirationsList.get(i).TagName;
            entity1.Code = CompanyAspirationsList.get(i).Code;
            entity1.isChecked = false;
            CompanyAspirations.add(entity1);
        }
        CompanyAspirationAdapter.notifyDataSetChanged();

        voice.setVisibility(View.GONE);
        record_voice.setImageResource(R.drawable.record_voice);
        imgs.clear();
        adapter.notifyDataSetChanged();
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
                    if (imgs.size() > 0) {
                        mImageViewsGridView.setVisibility(View.VISIBLE);
                    }
                    adapter.notifyDataSetChanged();
//                    imgs.clear();
//                    if (changeImgs.size() > 0) {
//                        imgs.addAll(changeImgs);
//                    }
//                    imgs.addAll(ImageUtils.saveFilePaths);
//                    if (imgs.size() > 0) {
//                        mImageViewsGridView.setVisibility(View.VISIBLE);
//                    }
//                    adapter.notifyDataSetChanged();
                }
                break;
            case 400:
                if (resultCode == RESULT_OK) {
                    ArrayList<String> AuditorStrings = new ArrayList<String>();
                    AuditorStrings.addAll(data.getStringArrayListExtra("AuditorStrings"));
                    int n = 0;
                    for (int i = 0; i < AuditorStrings.size(); i++) {
                        MemberEntity AuditorMember = JsonUtil.ToEntity(AuditorStrings.get(i), MemberEntity.class);
                        for (int j = 0; j < mAuditors.size(); j++) {
                            if (AuditorMember.MemberId == mAuditors.get(j).MemberId) {
                                n++;
                            }
                        }
                        if (n > 0) {
                            n = 0;
                        } else {
                            mAuditors.add(AuditorMember);
                        }
                    }
                    if ("Change".equals(mOperation)) {

                    } else {
                        int m = 0;
                        MemberEntity currentMemberEntity = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);
                        for (int j = 0; j < mAuditors.size(); j++) {
                            if (currentMemberEntity.PassportId == mAuditors.get(j).PassportId) {
                                m++;
                            }
                        }
                        if (m > 0) {
                            mSelectSendSms.setVisibility(View.VISIBLE);
                        } else {
                            mSelectSendSms.setVisibility(View.GONE);
                        }
                    }
                    mAllAuditorAdapter.notifyDataSetChanged();
                }
                break;
            case 500:
                // 接收选择的档案信息
                if (resultCode == RESULT_OK) {
                    employeArchiveEntity = JsonUtil.ToEntity(data.getStringExtra("ArchiveInformation"), EmployeArchiveEntity.class);
                    mArchiveId = employeArchiveEntity.ArchiveId;
                    mEmployeeRecord.setVisibility(View.VISIBLE);
                    mSelectEmployeeRecord.setVisibility(View.GONE);
                    ImageLoader.getInstance().displayImage(employeArchiveEntity.Picture, mEmployeeAvatar, options, animateFirstListener);
                    mEmployeeName.setText(employeArchiveEntity.RealName);
                    mEmployeePosition.setText(employeArchiveEntity.WorkItem.PostTitle);
                    mEmployeeDepartment.setText(employeArchiveEntity.WorkItem.Department);
                    mEntryTime = employeArchiveEntity.EntryTime;
                }
                break;
            case 600:
                if (resultCode == RESULT_OK) {
                    mDepartureTime.setText(data.getStringExtra("year") + data.getStringExtra("month") + data.getStringExtra("day"));
                }
                break;
            case 700:
                if (resultCode == RESULT_OK) {
                    WorkItemEntity entity = JsonUtil.ToEntity(data.getStringExtra("WorkItemEntity"), WorkItemEntity.class);
                    mEmployeePosition.setText(entity.PostTitle);
                    mEmployeeDepartment.setText(entity.Department);
                }
                break;
            default:
        }
    }

    @Override
    public void onDeleteImage(int position) {
        String deletePath = imgs.get(position);
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
        imgs.remove(position);

        if (imgs.size() == 0) {
            mImageViewsGridView.setVisibility(View.GONE);
        }
        adapter.notifyDataSetChanged();
    }

    @Override
    public void callBackDepartureReportArchive(Long archiveId, ArchiveCommentEntity entity) {
        if (archiveId > 0) {
            deleteImages();
            Bimp.drr.clear();
            if (mCurrentUserIsAuditor == 1) {
                DialogUtils.showArchiveDialog(this,true, "去查看","继续添加","提交成功！", getString(R.string.stage_archive_dialog_five), mCurrentArchiveComment, this);
            } else {
                DialogUtils.showArchiveDialog(this,true, "去查看","继续添加","提交成功！", getString(R.string.stage_archive_dialog_six), mCurrentArchiveComment, this);
            }
//            ToastUtil.showInfo("添加成功");
//            finish();
        } else {
            ToastUtil.showInfo("添加失败");
        }
    }

    @Override
    public void callBaceDepartureReportDetail(ArchiveCommentEntity entity) {
        if (entity != null) {
            firstLoadData = false;

            mCurrentArchiveComment = entity;
            employeArchiveEntity = entity.EmployeArchive;
            if (entity.WorkCommentImages != null) {
                if (entity.WorkCommentImages.length > 0) {
                    for (int i = 0; i < entity.WorkCommentImages.length; i++) {
                        changeImgs.add(entity.WorkCommentImages[i]);
                    }
                }
                imgs.addAll(changeImgs);
                if (imgs.size() > 0) {
                    mImageViewsGridView.setVisibility(View.VISIBLE);
                }
                adapter.notifyDataSetChanged();
            }
            if (!TextUtils.isEmpty(entity.WorkCommentVoice)) {
                mNetVoiceUrl = entity.WorkCommentVoice;
                record_voice.setImageResource(R.drawable.no_record_voice);
                voice.setVisibility(View.VISIBLE);
            }
            mEntryTime = entity.EmployeArchive.EntryTime;
            mVoiceTime.setText(entity.WorkCommentVoiceSecond + "″");
            ImageLoader.getInstance().displayImage(entity.EmployeArchive.Picture, mEmployeeAvatar, options, animateFirstListener);
            mEmployeeName.setText(entity.EmployeArchive.RealName);
            if (entity.EmployeArchive.WorkItem != null) {
                if (!TextUtils.isEmpty(entity.EmployeArchive.WorkItem.PostTitle)) {
                    mEmployeePosition.setText(entity.EmployeArchive.WorkItem.PostTitle);
                } else {
                    mEmployeePosition.setText("");
                }
                if (!TextUtils.isEmpty(entity.EmployeArchive.WorkItem.Department)) {
                    mEmployeeDepartment.setText(entity.EmployeArchive.WorkItem.Department);
                } else {
                    mEmployeeDepartment.setText("");
                }
            }
            mDepartureTime.setText(sdfymdhms.format(entity.DimissionTime));
            mInputSalary.setText(entity.DimissionSalary);
            if (!TextUtils.isEmpty(entity.WorkComment)) {
                mLeaveComments.setText(entity.WorkComment);
            }
            if (!TextUtils.isEmpty(entity.DimissionSupply)){
                mSupplementaryInstruction.setText(entity.DimissionSupply);
                mSupplementaryInstruction.setSelection(mSupplementaryInstruction.getText().length());
            }
            mRangeSeekBar1.setSelectedMaxValue(entity.WorkAbility);
            mRangeSeekBar2.setSelectedMaxValue(entity.WorkAttitude);
            mRangeSeekBar3.setSelectedMaxValue(entity.WorkPerformance);
            mRangeSeekBar4.setSelectedMaxValue(entity.HandoverTimely);
            mRangeSeekBar5.setSelectedMaxValue(entity.HandoverOverall);
            mRangeSeekBar6.setSelectedMaxValue(entity.HandoverSupport);
            List<MemberEntity> mAuditPersonList = new ArrayList<>();
            if (entity.AuditPersonList.size() > 0) {
                mAuditors.clear();
                for (int i=0;i<entity.AuditPersonList.size();i++){
                    if (entity.AuditPersonList.get(i).Role != MemberEntity.CompanyMember_Role_Boss)
                        mAuditPersonList.add(entity.AuditPersonList.get(i));
                }
                MemberEntity auditEntity = JsonUtil.ToEntity(AppConfig.getBossInformation(), MemberEntity.class);
                mAuditors.add(auditEntity);
                mAuditors.addAll(mAuditPersonList);
                mAllAuditorAdapter.notifyDataSetChanged();
            }
//            if (entity.AuditPersonList.size() > 0) {
//                mAuditors.clear();
//                mAuditors.addAll(entity.AuditPersonList);
//                mAllAuditorAdapter.notifyDataSetChanged();
//            }
            for (int i = 0; i < DepartureCauses.size(); i++) {
                if (entity.DimissionReason.equals(DepartureCauses.get(i).Code)) {
                    DepartureCauses.get(i).isChecked = true;
                }
            }
            DepartureCauseAdapter.notifyDataSetChanged();
            for (int i = 0; i < CompanyAspirations.size(); i++) {
                if (entity.WantRecall.equals(CompanyAspirations.get(i).Code)) {
                    CompanyAspirations.get(i).isChecked = true;
                }
            }
            CompanyAspirationAdapter.notifyDataSetChanged();
        } else {

        }
    }

    @Override
    public void callBaceUpdateDepartureReport(Boolean isSuccess, ArchiveCommentEntity entity) {
        if (isSuccess) {
            if (mCurrentUserIsAuditor == 1) {
                DialogUtils.showArchiveDialog(this,false, "我知道了","继续添加","操作成功！", getString(R.string.stage_archive_dialog_seven), mCurrentArchiveComment, this);
            } else {
                DialogUtils.showArchiveDialog(this,false, "我知道了","继续添加","操作成功！", getString(R.string.stage_archive_dialog_eight), mCurrentArchiveComment, this);
            }
//            ToastUtil.showInfo("修改成功");
//            setResult(RESULT_OK);
//            finish();
        } else {
            ToastUtil.showInfo("修改失败");
        }
    }

    @Override
    public void callBackDepartureReportArchiveFailure(String msg, Exception e) {
//        optionsCheckNetStatus();
    }

    @Override
    public void callBaceDepartureReportDetailFailure(String msg, Exception e) {
        secondCheckNetStatus();
    }

    @Override
    public void callBaceUpdateDepartureReportFailure(String msg, Exception e) {
//        optionsCheckNetStatus();
    }

    @Override
    public void showProgress() {
        dialog = DialogUtil.showLoadingDialog();
    }

    @Override
    public void hideProgress() {
        if (dialog != null)
            dialog.dismiss();
    }

    @Override
    public void onDeleteAuditor(int position) {
        if ("Change".equals(mOperation)) {

        } else {
            int m = 0;
            MemberEntity currentMemberEntity = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);
            for (int j = 0; j < mAuditors.size(); j++) {
                if (currentMemberEntity.PassportId == mAuditors.get(j).PassportId) {
                    m++;
                }
            }
            if (m > 0) {
                mSelectSendSms.setVisibility(View.VISIBLE);
            } else {
                mSelectSendSms.setVisibility(View.GONE);
            }
        }
    }

    class RangeSeekBarChangeListener implements RangeSeekBar.OnRangeSeekBarChangeListener {

        private TextView grade;

        public RangeSeekBarChangeListener(TextView grade) {
            this.grade = grade;
        }

        @Override
        public void onRangeSeekBarValuesChanged(RangeSeekBar bar, Number minValue, Number maxValue) {
            if (maxValue.intValue() < 30) {
                grade.setText("极差");
            } else if (maxValue.intValue() < 60 && maxValue.intValue() >= 30) {
                grade.setText("差");
            } else if (maxValue.intValue() < 80 && maxValue.intValue() >= 60) {
                grade.setText("一般");
            } else if (maxValue.intValue() < 90 && maxValue.intValue() >= 80) {
                grade.setText("良好");
            } else {
                grade.setText("优秀");
            }
        }
    }

    public void playVoice(String filePath) {
        if (!(new File(filePath).exists())) {
            return;
        }
        AudioManager audioManager = (AudioManager) this.getSystemService(Context.AUDIO_SERVICE);

        mediaPlayer = new MediaPlayer();
        audioManager.setMode(AudioManager.MODE_NORMAL);
        audioManager.setSpeakerphoneOn(true);
        mediaPlayer.setAudioStreamType(AudioManager.STREAM_RING);
//        } else {
//            audioManager.setSpeakerphoneOn(false);// 关闭扬声器
//            // 把声音设定成Earpiece（听筒）出来，设定为正在通话中
//            audioManager.setMode(AudioManager.MODE_IN_CALL);
//            mediaPlayer.setAudioStreamType(AudioManager.STREAM_VOICE_CALL);
//        }
        try {
            mediaPlayer.setDataSource(filePath);
            mediaPlayer.prepare();
            mediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {

                @Override
                public void onCompletion(MediaPlayer mp) {
                    // TODO Auto-generated method stub
                    mediaPlayer.release();
                    mediaPlayer = null;
                    stopPlayVoice(); // stop animation
                }

            });
            isPlaying = true;
            mediaPlayer.start();
            showAnimation();

        } catch (Exception e) {
            System.out.println();
        }
    }

    // show the voice playing animation
    private void showAnimation() {
        // play voice, and start animation
        playing_ani.setImageResource(R.drawable.voice_from_icon);
        voiceAnimation = (AnimationDrawable) playing_ani.getDrawable();
        voiceAnimation.start();
    }

    public void stopPlayVoice() {
        if (voiceAnimation != null) {
            voiceAnimation.stop();
        }
        playing_ani.setImageResource(R.drawable.yuyin);
        // stop play voice
        if (mediaPlayer != null) {
            mediaPlayer.stop();
            mediaPlayer.release();
        }
        isPlaying = false;
    }

    public void playOrStopVoice() {
        if (voiceFilePath.exists()) {
            if (!isPlaying)
                playVoice(voiceFilePath.toString());
            else
                stopPlayVoice();
        }
    }

    public void playOrStopVoice(String filePath) {
        if (!player.isPlaying) {
            player.setImageView(playing_ani);
            player.playUrl(filePath);
        } else {
            player.stop();
        }
    }

    public void deleteVoiceFile() {
        voice.setVisibility(View.GONE);
        if (isPlaying)
            stopPlayVoice();
        if (voiceFilePath.exists())
            voiceFilePath.delete();
        record_voice.setImageResource(R.drawable.record_voice);
    }

    public void getTags() {
        new AsyncRunnable<HashMap<String, List<BizDictEntity>>>() {

            @Override
            protected HashMap<String, List<BizDictEntity>> doInBackground(Void... params) {
                HashMap<String, List<BizDictEntity>> entities = DictionaryPool.loadDepartureDictionaries();
                return entities;
            }

            @Override
            protected void onPostExecute(HashMap<String, List<BizDictEntity>> entities) {
                if (entities != null) {
                    if (entities.size() != 0) {
                        for (int i = 0; i < entities.get(DictionaryPool.Code_Panicked).size(); i++) {
                            DepartureTagEntity entity = new DepartureTagEntity();
                            entity.Code = entities.get(DictionaryPool.Code_Panicked).get(i).Code;
                            entity.TagName = entities.get(DictionaryPool.Code_Panicked).get(i).Name;
                            entity.isChecked = false;
                            CompanyAspirations.add(entity);
                        }
                        DepartureCauseAdapter.notifyDataSetChanged();
                        for (int i = 0; i < entities.get(DictionaryPool.Code_Leaving).size(); i++) {
                            DepartureTagEntity entity = new DepartureTagEntity();
                            entity.Code = entities.get(DictionaryPool.Code_Leaving).get(i).Code;
                            entity.TagName = entities.get(DictionaryPool.Code_Leaving).get(i).Name;
                            entity.isChecked = false;
                            DepartureCauses.add(entity);
                        }
                        CompanyAspirationAdapter.notifyDataSetChanged();
                        if ("Change".equals(mOperation)) {
                            mAddDepartureReportPresenter.getDepartureReportDetail(AppConfig.getCurrentUseCompany(), getIntent().getLongExtra("CommentId", 0));
                        } else {
                            firstLoadData = false;
                        }
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

    @Override
    public void playVoice() {
        playOrStopVoice();
    }

    @Override
    public void deleteVoice() {
        deleteVoiceFile();
    }
}
