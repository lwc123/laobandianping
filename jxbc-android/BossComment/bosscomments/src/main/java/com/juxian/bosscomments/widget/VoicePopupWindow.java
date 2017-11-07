package com.juxian.bosscomments.widget;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.BitmapDrawable;
import android.os.Handler;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.*;
import android.widget.TextView;

import com.juxian.bosscomments.R;

import net.juxian.appgenome.widget.ToastUtil;

import java.io.File;
import java.io.IOException;
import java.util.Timer;

import cn.sopho.destiny.lamelibrary.MP3Recorder;

/**
 *
 */
public class VoicePopupWindow extends PopupWindow implements OnClickListener {

    private Activity mActivity;
    private Context context;
    private TextView mSure;
    private TextView mCancel;
    private ImageView mClickImage;
    private TextView mListeningTest;
    private TextView mRecordVoiceStatus;
    private TextView mVoiceTimeLength;
    private TextView mRecordVoiceHint;
    private MP3Recorder mRecorder;
    private ImageView record_voice;
    private File voiceFilePath;
    private TextView mVoiceTime;
    private RelativeLayout voice;
    private Timer mRecordTimer;
    private int voiceLength;
    private PlayOrDeleteVoiceListener listener;
    private Handler mPopHandler;

    public VoicePopupWindow(Activity activity, Context context,MP3Recorder mRecorder,ImageView record_voice,File voiceFilePath,
                            TextView mVoiceTime,RelativeLayout voice,Timer mRecordTimer,PlayOrDeleteVoiceListener listener,Handler mPopHandler) {
        super(activity);
        this.mActivity = activity;
        this.context = context;
        this.mRecorder = mRecorder;
        this.record_voice = record_voice;
        this.voiceFilePath = voiceFilePath;
        this.mVoiceTime = mVoiceTime;
        this.voice = voice;
        this.mRecordTimer = mRecordTimer;
        this.listener = listener;
        this.mPopHandler = mPopHandler;
        initView(context);
    }

    @SuppressWarnings("deprecation")
    private void initView(Context context) {
        View rootView = LayoutInflater.from(context).inflate(R.layout.dialog_voice, null);

        mSure = (TextView) rootView.findViewById(com.juxian.bosscomments.R.id.btn_confirm);
        mCancel = (TextView) rootView.findViewById(com.juxian.bosscomments.R.id.cancel);
        mClickImage = (ImageView) rootView.findViewById(com.juxian.bosscomments.R.id.click_record_voice);
        mListeningTest = (TextView) rootView.findViewById(com.juxian.bosscomments.R.id.listening_test);
        mRecordVoiceStatus = (TextView) rootView.findViewById(com.juxian.bosscomments.R.id.record_voice_status);
        mVoiceTimeLength = (TextView) rootView.findViewById(com.juxian.bosscomments.R.id.record_voice_length);
        mRecordVoiceHint = (TextView) rootView.findViewById(com.juxian.bosscomments.R.id.click_record_voice_hint);
        mSure.setOnClickListener(this);
        mCancel.setOnClickListener(this);
        mClickImage.setOnClickListener(this);
        mListeningTest.setOnClickListener(this);

        setContentView(rootView);
        setWidth(LinearLayout.LayoutParams.MATCH_PARENT);
        setHeight(LinearLayout.LayoutParams.WRAP_CONTENT);
        setFocusable(false);
        setBackgroundDrawable(new BitmapDrawable());
        setOutsideTouchable(false);
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.btn_confirm){
            if (mRecorder.isRecording()) {
                mRecorder.stop();
                if (voiceFilePath.exists()) {
                    if (getVoiceLength()<5){
                        ToastUtil.showInfo("录音时长最少5秒");
                        voiceFilePath.delete();
                        if (mRecordTimer != null)
                            mRecordTimer.cancel();
                        dismiss();
                        return;
                    }
                    mListeningTest.setVisibility(View.GONE);
                    record_voice.setImageResource(R.drawable.no_record_voice);
                    mRecordVoiceStatus.setText(mActivity.getString(R.string.record_end_time_length));
                    mRecordVoiceHint.setText(mActivity.getString(R.string.click_start_voice));
                    voice.setVisibility(View.VISIBLE);
                    mVoiceTime.setText(getVoiceLength() + "″");
                    if (mRecordTimer != null)
                        mRecordTimer.cancel();
                }
            }
            dismiss();
        } else if (id == R.id.cancel){
            if (mRecorder.isRecording()) {
                mRecorder.stop();
            }
            if (mRecordTimer != null)
                mRecordTimer.cancel();
            listener.deleteVoice();
            dismiss();
        } else if (id == R.id.click_record_voice){
            if (mRecorder.isRecording()) {
                mRecorder.stop();
                if (voiceFilePath.exists()) {
                    if (getVoiceLength()<5){
                        ToastUtil.showInfo("录音时长最少5秒");
                        voiceFilePath.delete();
                        if (mRecordTimer != null)
                            mRecordTimer.cancel();
                        dismiss();
                        return;
                    }
                    mListeningTest.setVisibility(View.GONE);
                    record_voice.setImageResource(R.drawable.no_record_voice);
                    mRecordVoiceStatus.setText(mActivity.getString(R.string.record_end_time_length));
                    mRecordVoiceHint.setText(mActivity.getString(R.string.click_start_voice));
                    voice.setVisibility(View.VISIBLE);
                    mVoiceTime.setText(getVoiceLength() + "″");
                    if (mRecordTimer != null)
                        mRecordTimer.cancel();
                }
            } else {
                if (voiceFilePath.exists()) {
                    // 判断语音是否存在，存在则不让点击再次录音
                    record_voice.setImageResource(R.drawable.no_record_voice);
                    ToastUtil.showInfo(mActivity.getString(R.string.voice_record_limit));
                    return;
                }
                try {
                    mRecordVoiceStatus.setText(mActivity.getString(R.string.now_recording));
                    mRecordVoiceHint.setText(mActivity.getString(R.string.click_end_voice));
                    mRecorder.start();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        } else if (id == R.id.listening_test){
            listener.playVoice();
        }
    }

    public void setVoiceLength(int mVoiceLength){
        this.voiceLength = mVoiceLength;
        mPopHandler.post(new Runnable() {
            @Override
            public void run() {
                if (mRecorder.isRecording()) {
                    mVoiceTimeLength.setText(voiceLength + "秒");
                }
                if (voiceLength == 120){
                    mRecorder.stop();
                    if (voiceFilePath.exists()) {
                        mListeningTest.setVisibility(View.GONE);
                        record_voice.setImageResource(com.juxian.bosscomments.R.drawable.no_record_voice);
                        mRecordVoiceStatus.setText(mActivity.getString(R.string.record_end_time_length));
                        mRecordVoiceHint.setText(mActivity.getString(R.string.click_start_voice));
                        voice.setVisibility(View.VISIBLE);
                        mVoiceTime.setText(voiceLength + "″");
                        if (mRecordTimer != null)
                            mRecordTimer.cancel();
                    }
                    dismiss();
                }
            }
        });

    }

    public int getVoiceLength(){
        return voiceLength;
    }

    public interface PlayOrDeleteVoiceListener{
        void playVoice();
        void deleteVoice();
    }
}
