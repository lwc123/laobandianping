package com.juxian.bosscomments.ui;

import android.Manifest;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
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
import android.view.Window;
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
import com.juxian.bosscomments.adapter.StageRadioButtonAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.models.BizDictEntity;
import com.juxian.bosscomments.models.DepartureTagEntity;
import com.juxian.bosscomments.models.EmployeArchiveEntity;
import com.juxian.bosscomments.models.ImageBucket;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.models.StageSectionEntity;
import com.juxian.bosscomments.modules.DictionaryPool;
import com.juxian.bosscomments.presenter.ArchiveCommentPresenter;
import com.juxian.bosscomments.presenter.ArchiveCommentPresenterImpl;
import com.juxian.bosscomments.repositories.ArchiveCommentRepository;
import com.juxian.bosscomments.utils.AlbumHelper;
import com.juxian.bosscomments.utils.Bimp;
import com.juxian.bosscomments.utils.DialogUtils;
import com.juxian.bosscomments.utils.PermissionUtils;
import com.juxian.bosscomments.utils.Player;
import com.juxian.bosscomments.utils.checkSelfPermissionUtils;
import com.juxian.bosscomments.view.ArchiveCommentView;
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
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import java.util.regex.Pattern;

import butterknife.BindView;
import butterknife.ButterKnife;
import cn.sopho.destiny.lamelibrary.MP3Recorder;
import cn.sopho.destiny.lamelibrary.PCMFormat;
import me.nereo.multi_image_selector.MultiImageSelector;

public class AddBossCommentActivity extends BaseActivity implements View.OnClickListener, AddBossCommentGridAdapter.ImageDeleteListener,
        ArchiveCommentView, DialogUtils.ArchiveDialogListener, VoicePopupWindow.PlayOrDeleteVoiceListener,AllAuditorAdapter.AuditorDeleteListener {

    private InputMethodManager manager;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_tab3)
    TextView mAddCommentText;
    @BindView(R.id.include_head_title_re2)
    RelativeLayout mAddComment;
    @BindView(R.id.include_button_button)
    Button search_btn;
    @BindView(R.id.scrollview)
    ScrollView scrollview;
    @BindView(R.id.boss_comment_content)
    EditText boss_comment_content;
    @BindView(R.id.total_content_number)
    TextView total_content_number;
    // 录音相关
    @BindView(R.id.voice)
    RelativeLayout voice;
    @BindView(R.id.click_voice)
    LinearLayout click_voice;
    @BindView(R.id.playing_ani)
    ImageView playing_ani;
    @BindView(R.id.voice_time_length)
    TextView mVoiceTime;
    @BindView(R.id.delete_voice)
    ImageView delete_voice;
    @BindView(R.id.record_voice)
    ImageView record_voice;
    // 拍照相关
    @BindView(R.id.camera)
    ImageView camera;
    @BindView(R.id.activity_select_employee_record)
    RelativeLayout mSelectEmployeeRecord;// 选择员工档案
    @BindView(R.id.activity_select_comment_time)
    RelativeLayout mSelectCommentTime;// 选择评价时间
    @BindView(R.id.edit_select_comment_time)
    TextView mCommentTime;// 显示选择的时间
    @BindView(R.id.activity_employee_record)
    LinearLayout mEmployeeRecord;// 显示头像和姓名
    @BindView(R.id.employee_record_basic_message)
    RelativeLayout mChangeEmployeeRecord;
    @BindView(R.id.activity_employee_photo)
    RoundAngleImageView mEmployeeAvatar;
    @BindView(R.id.activity_edit_message_photo_name)
    TextView mEmployeeName;
    @BindView(R.id.employee_position)
    TextView mEmployeePosition;
    @BindView(R.id.employee_department)
    TextView mEmployeeDepartment;
    @BindView(R.id.img_gridview)
    NoScrollGridView mImageViewsGridView;
    @BindView(R.id.all_auditor)
    ResultListView mAllAuditor;
    @BindView(R.id.add_comment_auditor)
    ImageView mAddAuditor;
    @BindView(R.id.add_comment_gridview)
    NoScrollGridView mStateTimeGridView;
    @BindView(R.id.rangeSeekBar1)
    RangeSeekBar mRangeSeekBar1;
    @BindView(R.id.rangeSeekBar2)
    RangeSeekBar mRangeSeekBar2;
    @BindView(R.id.rangeSeekBar3)
    RangeSeekBar mRangeSeekBar3;
    @BindView(R.id.rangeSeekBar1_grade)
    TextView mRangeSeekBar1Grade;
    @BindView(R.id.rangeSeekBar2_grade)
    TextView mRangeSeekBar2Grade;
    @BindView(R.id.rangeSeekBar3_grade)
    TextView mRangeSeekBar3Grade;
    @BindView(R.id.add_hint)
    RelativeLayout mAddHint;
    @BindView(R.id.cancel_hint)
    ImageView mCancelHint;
    @BindView(R.id.select_send_sms)
    LinearLayout mSelectSendSms;
    @BindView(R.id.send_sms_check)
    CheckBox mSendSmsCheck;
    private AddBossCommentGridAdapter adapter;
    private int numContent = 500;
    /**
     * 录音相关
     */
    private File file;
    private MP3Recorder mRecorder;
    private File voiceFilePath;
    private MediaPlayer mediaPlayer;
    private AnimationDrawable voiceAnimation = null;
    private Handler mPopHandler;
    private Timer mRecordTimer;
    private boolean isPlaying;
    private int VoiceLength;
    private String mNetVoiceUrl;
    private Player player;

    private Calendar calendar;
    private List<DepartureTagEntity> StateTimes;
    private StageRadioButtonAdapter StateTimeAdapter;
    private AllAuditorAdapter mAllAuditorAdapter;// 用于mAllAuditor列表
    private List<MemberEntity> mAuditors;// 审核人集合
    private EmployeArchiveEntity employeArchiveEntity;// 选择的档案信息
    private long mArchiveId;// 档案id，即所要添加阶段评价的档案id
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions options = Global.Constants.DEFAULT_AVATAR_OPTIONS;
    private ArrayList<String> imgs;

    protected ArrayList<String> years;
    private int nowYear;
    private List<String> list_year;
    private ArchiveCommentEntity mCurrentArchiveComment;
    private String mOperation;
    private ArrayList<String> changeImgs;
    private int mCurrentUserIsAuditor;
    private VoicePopupWindow mVoicePopupWindow;
    private int defaultNum = 0;
    private ArrayList<String> mSelectPath;

    @Override
    public int getContentViewId() {
        return R.layout.activity_add_boss_comment;
    }

    private Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if (msg.what == 1) {

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
            } else if (msg.what == 2) {
                for (int m = 0; m < StateTimes.size(); m++) {
                    StateTimes.get(m).isChecked = false;
                    StateTimes.get(m).isEnabled = true;
                }
                Log.e(Global.LOG_TAG, mCommentTime.getText().toString().trim());
                for (int i = 0; i < stageSectionEntityList.size(); i++) {
                    if (mCommentTime.getText().toString().trim().equals(stageSectionEntityList.get(i).StageYear)) {
                        for (int j = 0; j < stageSectionEntityList.get(i).StageSection.size(); j++) {
                            for (int m = 0; m < StateTimes.size(); m++) {
                                if (StateTimes.get(m).Code.equals(stageSectionEntityList.get(i).StageSection.get(j))) {
                                    StateTimes.get(m).isChecked = false;
                                    StateTimes.get(m).isEnabled = false;
                                    if ("Change".equals(mOperation)) {
                                        if (mCommentTime.getText().toString().trim().equals(mCurrentArchiveComment.StageYear)) {
                                            if (StateTimes.get(m).Code.equals(mCurrentArchiveComment.StageSection)) {
                                                StateTimes.get(m).isChecked = true;
                                                StateTimes.get(m).isEnabled = true;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                StateTimeAdapter.notifyDataSetChanged();
            }
        }
    };
    private Dialog dialog;
    private ArchiveCommentPresenter mArchiveCommentPresenter;
    private List<StageSectionEntity> stageSectionEntityList;

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
        title.setText(getString(R.string.add_synthesize_word_comment));
        mAddCommentText.setText(getString(R.string.submit));
        mAddComment.setVisibility(View.VISIBLE);
        mAddCommentText.setVisibility(View.VISIBLE);
        search_btn.setText(getString(R.string.submit));
        if (Bimp.drr.size() != 0) {
            Bimp.drr.clear();
        }
        if (ImageUtils.saveFilePaths.size() != 0) {
            ImageUtils.saveFilePaths.clear();
        }
        stageSectionEntityList = new ArrayList<>();
        years = new ArrayList<>();
        mArchiveCommentPresenter = new ArchiveCommentPresenterImpl(getApplicationContext(), this);
        mRangeSeekBar1.setSelectedMaxValue(0);
        mRangeSeekBar2.setSelectedMaxValue(0);
        mRangeSeekBar3.setSelectedMaxValue(0);
        calendar = Calendar.getInstance();
        mCommentTime.setText(calendar.get(Calendar.YEAR) + "年");
        if ("Have".equals(getIntent().getStringExtra("Tag"))) {
            mEmployeeRecord.setVisibility(View.VISIBLE);
            mSelectEmployeeRecord.setVisibility(View.GONE);
        } else {
            mEmployeeRecord.setVisibility(View.GONE);
            mSelectEmployeeRecord.setVisibility(View.VISIBLE);
        }
        mOperation = getIntent().getStringExtra("Operation");
//        if ("Change".equals(mOperation)) {
//            mArchiveCommentPresenter.getCommentDetail(AppConfig.getCurrentUseCompany(),getIntent().getLongExtra("CommentId", 0));
//        }
        if ("Change".equals(mOperation)) {
            title.setText("修改阶段评价");
        }
        mPopHandler = new Handler();
        imgs = new ArrayList<>();
        changeImgs = new ArrayList<>();

        adapter = new AddBossCommentGridAdapter(imgs, this, this);
        mImageViewsGridView.setAdapter(adapter);

        initArchive();
        initStageTime();
        initAuditors();
    }

    public void initArchive() {
        // 添加档案之后，跳转过来的
        if ("continue".equals(getIntent().getStringExtra("isContinue"))) {
            employeArchiveEntity = JsonUtil.ToEntity(getIntent().getStringExtra("EmployeArchiveEntity"), EmployeArchiveEntity.class);
            mArchiveId = employeArchiveEntity.ArchiveId;
            mEmployeeRecord.setVisibility(View.VISIBLE);
            mSelectEmployeeRecord.setVisibility(View.GONE);
//            Bitmap bitmap = BitmapFactory.decodeFile(employeArchiveEntity.Picture);
//            mEmployeeAvatar.setImageBitmap(bitmap);
            ImageLoader.getInstance().displayImage(employeArchiveEntity.Picture, mEmployeeAvatar, options, animateFirstListener);
            mEmployeeName.setText(employeArchiveEntity.RealName);
            mEmployeePosition.setText(employeArchiveEntity.WorkItem.PostTitle);
            mEmployeeDepartment.setText(employeArchiveEntity.WorkItem.Department);
        }
    }

    /**
     * 初始化阶段时间数据
     */
    public void initStageTime() {
        StateTimes = new ArrayList<>();
//        getTags();
        StateTimeAdapter = new StageRadioButtonAdapter(StateTimes, getApplicationContext());
        mStateTimeGridView.setAdapter(StateTimeAdapter);
    }

    @Override
    public void loadPageData() {
        super.loadPageData();
        getTags();
    }

    /**
     * 初始化审核人部分
     */
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
        mAddComment.setOnClickListener(this);
        search_btn.setOnClickListener(this);
        record_voice.setOnClickListener(this);
        camera.setOnClickListener(this);
        delete_voice.setOnClickListener(this);
        mSelectCommentTime.setOnClickListener(this);
        mSelectEmployeeRecord.setOnClickListener(this);
        mSelectSendSms.setOnClickListener(this);
        if ("Change".equals(mOperation)) {

        } else {
            if ("continue".equals(getIntent().getStringExtra("isContinue"))) {

            } else {
                mChangeEmployeeRecord.setOnClickListener(this);
            }
        }
        click_voice.setOnClickListener(this);
        mAddAuditor.setOnClickListener(this);
        scrollview.setOnTouchListener(new View.OnTouchListener() {

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                // TODO Auto-generated method stub
                Global.CloseKeyBoard(boss_comment_content);
                return false;
            }
        });
        boss_comment_content.addTextChangedListener(textWatcher);
        mRangeSeekBar1.setOnRangeSeekBarChangeListener(new RangeSeekBarChangeListener(mRangeSeekBar1Grade));
        mRangeSeekBar2.setOnRangeSeekBarChangeListener(new RangeSeekBarChangeListener(mRangeSeekBar2Grade));
        mRangeSeekBar3.setOnRangeSeekBarChangeListener(new RangeSeekBarChangeListener(mRangeSeekBar3Grade));
        mCancelHint.setOnClickListener(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
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

    // 返回null表示接收输入的字符,返回空字符串表示不接受输入的字符 ;
    private TextWatcher textWatcher = new TextWatcher() {

        @Override
        public void onTextChanged(CharSequence s, int start, int before,
                                  int count) {
        }

        @Override
        public void beforeTextChanged(CharSequence s, int start, int before,
                                      int count) {
        }

        @Override
        public void afterTextChanged(Editable s) {
            int number = s.length();
            total_content_number.setText("" + number);
            if (boss_comment_content.getText().toString().length() > numContent) {
                total_content_number.setTextColor(AddBossCommentActivity.this.getResources().getColor(R.color.above_proof));
            }
            if (boss_comment_content.getText().toString().length() <= numContent) {
                total_content_number.setTextColor(AddBossCommentActivity.this.getResources().getColor(R.color.menu_color));
            }
        }
    };

    @Override
    public void onBackPressed() {
        deleteImages();
        imgs.clear();
        super.onBackPressed();
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (player.isPlaying)
            player.stop();
        if (isPlaying)
            stopPlayVoice();
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
    public void onClick(View v) {
        super.onClick(v);

        switch (v.getId()) {
            case R.id.include_head_title_lin:
                if ("Change".equals(mOperation)) {
                    finish();
                } else {
                    if (employeArchiveEntity != null || StateTimeAdapter.getCurrentSelect() != null ||
                            (Integer) mRangeSeekBar1.getSelectedMaxValue() != 0 || (Integer) mRangeSeekBar2.getSelectedMaxValue() != 0 ||
                            (Integer) mRangeSeekBar3.getSelectedMaxValue() != 0 || !TextUtils.isEmpty(boss_comment_content.getText().toString()) ||
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
                                AddBossCommentActivity.this.finish();
                            }
                        });
                    } else {
                        finish();
                    }
                }
                break;
            case R.id.include_button_button:
                if ("Change".equals(mOperation)) {
                    clickChange();
                } else {
                    clickPost();
                }
                break;
            case R.id.include_head_title_re2:// 保存
                if ("Change".equals(mOperation)) {
                    clickChange();
                } else {
                    clickPost();
                }
                break;
            case R.id.delete_voice:
                // 删除语音，隐藏需要语音条目，如果是正在播放的，则停止播放，并且删除
                mNetVoiceUrl = null;
                deleteVoiceFile();
                break;
            case R.id.activity_select_comment_time:
                showSelectScaleDialog();
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
                        MultiImageSelector selector = MultiImageSelector.create(AddBossCommentActivity.this);
                        selector.showCamera(true);
                        selector.count(9-changeImgs.size());
//                        if (mChoiceMode.getCheckedRadioButtonId() == R.id.single) {
//                            selector.single();
//                        } else {
                        selector.multi();
//                        }
                        selector.origin(mSelectPath);
                        selector.start(AddBossCommentActivity.this, 520);
                    }
                } else {
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                        PermissionUtils.requestPermission(this, PermissionUtils.CODE_READ_EXTERNAL_STORAGE, mPermissionGrant);
                    } else {
                        if (imgs.size() >= 9) {
                            ToastUtil.showInfo(getString(R.string.max_select_nine_picture));
                            return;
                        }
                        MultiImageSelector selector = MultiImageSelector.create(AddBossCommentActivity.this);
                        selector.showCamera(true);
                        selector.count(9-changeImgs.size());
//                        if (mChoiceMode.getCheckedRadioButtonId() == R.id.single) {
//                            selector.single();
//                        } else {
                            selector.multi();
//                        }
                        selector.origin(mSelectPath);
                        selector.start(AddBossCommentActivity.this, 520);
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

//                        mRecorders.setAudioSource(MediaRecorder.AudioSource.MIC);
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
                        mVoicePopupWindow.showAtLocation(AddBossCommentActivity.this.getWindow().getDecorView(), Gravity.BOTTOM, 0, 0);
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
                        mVoicePopupWindow.showAtLocation(AddBossCommentActivity.this.getWindow().getDecorView(), Gravity.BOTTOM, 0, 0);
                    }
                }
                break;
            case R.id.click_voice:
                // 点击播放音频，先判断该文件是否存在，并且是否正在播放，如果是正在播放，则停止播放，如果不是正在播放则播放
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
            case R.id.add_comment_auditor:
                Intent SelectAuditor = new Intent(getApplicationContext(), SelectAuditorActivity.class);
                startActivityForResult(SelectAuditor, 400);
                break;
            case R.id.activity_select_employee_record:
                // 选择员工档案
                Intent SelectRecord = new Intent(getApplicationContext(), AllEmployeeRecordActivity.class);
                SelectRecord.putExtra("CommentType", "StageComment");
                SelectRecord.putExtra("ArchiveList", "SelectArchive");
                startActivityForResult(SelectRecord, 500);
                break;
            case R.id.employee_record_basic_message:
                Intent SelectRecord1 = new Intent(getApplicationContext(), AllEmployeeRecordActivity.class);
                SelectRecord1.putExtra("CommentType", "StageComment");
                SelectRecord1.putExtra("ArchiveList", "SelectArchive");
                startActivityForResult(SelectRecord1, 500);
                break;
            case R.id.cancel_hint:
                mAddHint.setVisibility(View.GONE);
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
                    if (voiceFilePath.exists() || mNetVoiceUrl != null) {
                        // 判断语音是否存在，存在则不让点击再次录音
                        record_voice.setImageResource(R.drawable.no_record_voice);
                        ToastUtil.showInfo(getString(R.string.voice_record_limit));
                        return;
                    }
                    mRecordTimer = new Timer();
                    mVoicePopupWindow = new VoicePopupWindow(AddBossCommentActivity.this, getApplicationContext(), mRecorder, record_voice, voiceFilePath, mVoiceTime, voice, mRecordTimer, AddBossCommentActivity.this, mPopHandler);
                    mVoicePopupWindow.showAtLocation(AddBossCommentActivity.this.getWindow().getDecorView(), Gravity.BOTTOM, 0, 0);
                    break;
                case PermissionUtils.CODE_GET_ACCOUNTS:
                    Toast.makeText(AddBossCommentActivity.this, "Result Permission Grant CODE_GET_ACCOUNTS", Toast.LENGTH_SHORT).show();
                    break;
                case PermissionUtils.CODE_READ_PHONE_STATE:
                    Toast.makeText(AddBossCommentActivity.this, "Result Permission Grant CODE_READ_PHONE_STATE", Toast.LENGTH_SHORT).show();
                    break;
                case PermissionUtils.CODE_CALL_PHONE:
                    Toast.makeText(AddBossCommentActivity.this, "Result Permission Grant CODE_CALL_PHONE", Toast.LENGTH_SHORT).show();
                    break;
                case PermissionUtils.CODE_CAMERA:
                    Toast.makeText(AddBossCommentActivity.this, "Result Permission Grant CODE_CAMERA", Toast.LENGTH_SHORT).show();
                    break;
                case PermissionUtils.CODE_ACCESS_FINE_LOCATION:
                    Toast.makeText(AddBossCommentActivity.this, "Result Permission Grant CODE_ACCESS_FINE_LOCATION", Toast.LENGTH_SHORT).show();
                    break;
                case PermissionUtils.CODE_ACCESS_COARSE_LOCATION:
                    Toast.makeText(AddBossCommentActivity.this, "Result Permission Grant CODE_ACCESS_COARSE_LOCATION", Toast.LENGTH_SHORT).show();
                    break;
                case PermissionUtils.CODE_READ_EXTERNAL_STORAGE:
                    if (imgs.size() >= 9) {
                        ToastUtil.showInfo(getString(R.string.max_select_nine_picture));
                        return;
                    }
                    MultiImageSelector selector = MultiImageSelector.create(AddBossCommentActivity.this);
                    selector.showCamera(true);
                    selector.count(9-changeImgs.size());
//                        if (mChoiceMode.getCheckedRadioButtonId() == R.id.single) {
//                            selector.single();
//                        } else {
                    selector.multi();
//                        }
                    selector.origin(mSelectPath);
                    selector.start(AddBossCommentActivity.this, 520);
                    break;
                case PermissionUtils.CODE_WRITE_EXTERNAL_STORAGE:
                    Toast.makeText(AddBossCommentActivity.this, "Result Permission Grant CODE_WRITE_EXTERNAL_STORAGE", Toast.LENGTH_SHORT).show();
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
                    existStageSection(AppConfig.getCurrentUseCompany(), mArchiveId, 0);
                }
                break;
            default:
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

    public void clickPost() {
        if (employeArchiveEntity == null) {
            ToastUtil.showInfo("请选择档案");
            return;
        }
        Pattern idNumPattern = Pattern.compile("(\\d{14}[0-9a-zA-Z])|(\\d{17}[0-9a-zA-Z])");
        if (StateTimeAdapter.getCurrentSelect() == null) {
            ToastUtil.showInfo(getString(R.string.please_select_stage_time));
            return;
        }
//        if (TextUtils.isEmpty(StateTimeAdapter.getCurrentSelect())) {
//            ToastUtil.showInfo(getString(R.string.please_select_stage_time));
//            return;
//        }
        if (TextUtils.isEmpty(boss_comment_content.getText().toString())) {
            ToastUtil.showInfo(getString(R.string.boss_comment_content_not_empty));
            boss_comment_content.requestFocus();
            return;
        }
//        Matcher idNumMatcher = idNumPattern.matcher(edit_identity_number.getText().toString());
        if (boss_comment_content.getText().toString().length() > 500) {
            ToastUtil.showInfo(getString(R.string.boss_comment_content_length_limit));
            boss_comment_content.requestFocus();
            return;
        }
        ArchiveCommentEntity entity = new ArchiveCommentEntity();
        entity.CompanyId = AppConfig.getCurrentUseCompany();
        entity.ArchiveId = mArchiveId;
        entity.StageYear = mCommentTime.getText().toString().trim();
        entity.StageSection = StateTimeAdapter.getCurrentSelect().Code;
        entity.WorkAbility = (Integer) mRangeSeekBar1.getSelectedMaxValue();
        entity.WorkAttitude = (Integer) mRangeSeekBar2.getSelectedMaxValue();
        entity.WorkPerformance = (Integer) mRangeSeekBar3.getSelectedMaxValue();
        entity.WorkComment = boss_comment_content.getText().toString();
        entity.AuditPersons = new ArrayList<>();
        for (int i = 0; i < mAuditors.size(); i++) {
            entity.AuditPersons.add(mAuditors.get(i).PassportId);
        }
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
        mArchiveCommentPresenter.addArchiveComment(imgs,entity);
//        if (mCurrentUserIsAuditor == 1) {
//            DialogUtils.showArchiveDialog(this, getString(R.string.stage_archive_dialog_one), entity, this);
//        } else {
//            DialogUtils.showArchiveDialog(this, getString(R.string.stage_archive_dialog_two), entity, this);
//        }
    }

    public void clickChange() {
        mCurrentArchiveComment.StageYear = mCommentTime.getText().toString().trim();
        mCurrentArchiveComment.StageSection = StateTimeAdapter.getCurrentSelect().Code;
        mCurrentArchiveComment.WorkAbility = (Integer) mRangeSeekBar1.getSelectedMaxValue();
        mCurrentArchiveComment.WorkAttitude = (Integer) mRangeSeekBar2.getSelectedMaxValue();
        mCurrentArchiveComment.WorkPerformance = (Integer) mRangeSeekBar3.getSelectedMaxValue();
        mCurrentArchiveComment.WorkComment = boss_comment_content.getText().toString();
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
        mArchiveCommentPresenter.updateArchiveComment(changeImgs,mSelectPath,mCurrentArchiveComment);
//        if (mCurrentUserIsAuditor == 1) {
//            DialogUtils.showArchiveDialog(this, getString(R.string.stage_archive_dialog_one), mCurrentArchiveComment, this);
//        } else {
//            DialogUtils.showArchiveDialog(this, getString(R.string.stage_archive_dialog_two), mCurrentArchiveComment, this);
//        }
//        DialogUtils.showArchiveDialog(this, getString(R.string.stage_archive_dialog_two), mCurrentArchiveComment, this);
//        mArchiveCommentPresenter.updateArchiveComment(mCurrentArchiveComment);
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
//        if ("Change".equals(mOperation)) {
//            mArchiveCommentPresenter.updateArchiveComment(mCurrentArchiveComment);
//        } else {
//            mArchiveCommentPresenter.addArchiveComment(entity);
//        }
        mEmployeeRecord.setVisibility(View.GONE);
        mSelectEmployeeRecord.setVisibility(View.VISIBLE);
        employeArchiveEntity = null;
        mCommentTime.setText("2017年");
        ArrayList<DepartureTagEntity> StateTimesList = new ArrayList<>();
        StateTimesList.addAll(StateTimes);
        StateTimes.clear();
        for (int i = 0; i < StateTimesList.size(); i++) {
            DepartureTagEntity entity1 = new DepartureTagEntity();
            entity1.TagName = StateTimesList.get(i).TagName;
            entity1.Code = StateTimesList.get(i).Code;
            entity1.isChecked = false;
            entity1.isEnabled = true;
            StateTimes.add(entity1);
        }
        StateTimeAdapter.notifyDataSetChanged();
        mRangeSeekBar1.setSelectedMaxValue(0);
        mRangeSeekBar2.setSelectedMaxValue(0);
        mRangeSeekBar3.setSelectedMaxValue(0);
        boss_comment_content.setText("");
        mAuditors.clear();
        MemberEntity entity2 = JsonUtil.ToEntity(AppConfig.getBossInformation(), MemberEntity.class);
        mAuditors.add(entity2);
        mAllAuditorAdapter.notifyDataSetChanged();
        voice.setVisibility(View.GONE);
        record_voice.setImageResource(R.drawable.record_voice);
        imgs.clear();
        adapter.notifyDataSetChanged();
        defaultNum = 0;
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
    protected void onDestroy() {
        super.onDestroy();
        if (Bimp.drr.size() != 0) {
            Bimp.drr.clear();
        }
    }

    public void showSelectScaleDialog() {
        final Dialog dl = new Dialog(this);

        dl.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dl.setCancelable(true);
        View dialog_view = View.inflate(getApplicationContext(), R.layout.advertise_one_wheelview, null);
        dl.setContentView(dialog_view);
        Window dialogWindow = dl.getWindow();
        setWindowParams(dialogWindow);
        dl.show();
        final com.pl.wheelview.WheelView mScaleWheelView = (com.pl.wheelview.WheelView) dialog_view.findViewById(R.id.experience_required);
        TextView mBtnConfirm = (TextView) dialog_view.findViewById(R.id.btn_confirm);
        TextView cancel = (TextView) dialog_view.findViewById(R.id.cancel);
        TextView start_time = (TextView) dialog_view.findViewById(R.id.start_time);
        start_time.setText("选择时间");
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dl.dismiss();
            }
        });
        mBtnConfirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mCommentTime.setText(mScaleWheelView.getSelectedText());
                defaultNum = mScaleWheelView.getSelected();
                if (mArchiveId > 0) {
                    Message message = mHandler.obtainMessage();
                    message.what = 2;
                    mHandler.sendMessage(message);
                }
                dl.dismiss();
            }
        });
        list_year = new ArrayList<String>();
        initYear();
        years.clear();
        for (int i = 0; i < list_year.size(); i++) {
            years.add(list_year.get(i) + "年");
        }
        mScaleWheelView.setCyclic(false);
        mScaleWheelView.setData(years);
        mScaleWheelView.setDefault(defaultNum);
    }

    private void initYear() {
        calendar = Calendar.getInstance();
        nowYear = calendar.get(Calendar.YEAR);
        for (int i = nowYear; i >= nowYear - 30; i--) {
            list_year.add(i + "");
        }
    }

    @Override
    public void callBackAddArchiveComment(Long archiveId, ArchiveCommentEntity entity) {
        if (archiveId > 0) {
            deleteImages();
            Bimp.drr.clear();
            if (mCurrentUserIsAuditor == 1) {
                DialogUtils.showArchiveDialog(this,true, "去查看","继续添加","操作成功！", getString(R.string.stage_archive_dialog_one), mCurrentArchiveComment, this);
            } else {
                DialogUtils.showArchiveDialog(this,true, "去查看","继续添加","操作成功！", getString(R.string.stage_archive_dialog_two), mCurrentArchiveComment, this);
            }
        } else {
            ToastUtil.showInfo(getString(R.string.comment_fail));
        }
    }

    @Override
    public void callBaceArchiveCommentDetail(ArchiveCommentEntity entity) {
        if (entity != null) {
            firstLoadData = false;
//            ToastUtil.showInfo("获取成功");
            mCurrentArchiveComment = entity;
            mArchiveId = entity.ArchiveId;
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
            mVoiceTime.setText(entity.WorkCommentVoiceSecond + "″");
            mRangeSeekBar1.setSelectedMaxValue(entity.WorkAbility);
            mRangeSeekBar2.setSelectedMaxValue(entity.WorkAttitude);
            mRangeSeekBar3.setSelectedMaxValue(entity.WorkPerformance);
            mCommentTime.setText(entity.StageYear);
            if (!TextUtils.isEmpty(entity.WorkComment)) {
                boss_comment_content.setText(entity.WorkComment);
            }
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
            existStageSection(entity.CompanyId, mArchiveId, 0);
        } else {
//            ToastUtil.showInfo("获取失败");
        }
    }

    @Override
    public void callBaceArchiveCommentDetailFailure(String msg, Exception e) {
        secondCheckNetStatus();
    }

    @Override
    public void callBaceUpdateArchiveComment(Boolean isSuccess, ArchiveCommentEntity entity) {
        if (isSuccess) {
            if (mCurrentUserIsAuditor == 1) {
                DialogUtils.showArchiveDialog(this, false, "我知道了", "继续添加","操作成功！", getString(R.string.stage_archive_dialog_three), null, this);
            } else {
                DialogUtils.showArchiveDialog(this, false, "我知道了", "继续添加","操作成功！", getString(R.string.stage_archive_dialog_four), null, this);
            }
//            ToastUtil.showInfo("修改成功");
//            setResult(RESULT_OK);
//            finish();
        } else {
            ToastUtil.showInfo("修改失败");
        }
    }

    @Override
    public void callBackArchiveComment(String msg, Exception e) {
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

    public void playOrStopVoice() {
        if (voiceFilePath.exists()) {
            if (!isPlaying)
                playVoice(voiceFilePath.toString());
            else
                stopPlayVoice();
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

    public void playOrStopVoice(String filePath) {
        if (!player.isPlaying) {
            player.setImageView(playing_ani);
            player.playUrl(filePath);
        } else {
            player.stop();
        }
    }

    private void existStageSection(final long CompanyId, final long ArchiveId, final int tag) {
        new AsyncRunnable<List<StageSectionEntity>>() {
            @Override
            protected List<StageSectionEntity> doInBackground(Void... params) {
                List<StageSectionEntity> stageSectionEntities = ArchiveCommentRepository.existsStageSection(CompanyId, ArchiveId);
                return stageSectionEntities;
            }

            @Override
            protected void onPostExecute(List<StageSectionEntity> stageSectionEntities) {
                if (stageSectionEntities != null) {
                    if (stageSectionEntities.size() != 0) {
                        stageSectionEntityList.clear();
                        stageSectionEntityList.addAll(stageSectionEntities);
                        if (tag == 0) {
                            // 判断是否需要对阶段时间做无法点击操作
                            if (mArchiveId > 0) {
                                Message message = mHandler.obtainMessage();
                                message.what = 2;
                                mHandler.sendMessage(message);
                            }
                        } else if (tag == 1) {
                            // 修改阶段评价时
                        }
                    } else {
                        stageSectionEntityList.clear();
                        stageSectionEntityList.addAll(stageSectionEntities);
                        if (mArchiveId > 0) {
                            Message message = mHandler.obtainMessage();
                            message.what = 2;
                            mHandler.sendMessage(message);
                        }
                    }
                } else {

                }
            }

            protected void onPostError(Exception ex) {

            }
        }.execute();
    }

    public void getTags() {
        new AsyncRunnable<HashMap<String, List<BizDictEntity>>>() {

            @Override
            protected HashMap<String, List<BizDictEntity>> doInBackground(Void... params) {
                HashMap<String, List<BizDictEntity>> entities = DictionaryPool.loadPeriodDictionaries();
                return entities;
            }

            @Override
            protected void onPostExecute(HashMap<String, List<BizDictEntity>> entities) {
                if (entities != null) {
                    if (entities.size() != 0) {
                        List<BizDictEntity> Periods = entities.get(DictionaryPool.Code_Period);
                        for (int i = 0; i < Periods.size(); i++) {
                            DepartureTagEntity entity = new DepartureTagEntity();
                            entity.TagName = Periods.get(i).Name;
                            entity.Code = Periods.get(i).Code;
                            entity.isChecked = false;
                            entity.isEnabled = true;
                            StateTimes.add(entity);
                        }
                        StateTimeAdapter.notifyDataSetChanged();
                        if ("Change".equals(mOperation)) {
                            mArchiveCommentPresenter.getCommentDetail(AppConfig.getCurrentUseCompany(), getIntent().getLongExtra("CommentId", 0));
                        } else {
                            firstLoadData = false;
                            if ("continue".equals(getIntent().getStringExtra("isContinue"))) {
                                existStageSection(AppConfig.getCurrentUseCompany(), mArchiveId, 0);
                            }
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
