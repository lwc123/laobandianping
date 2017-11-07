package com.juxian.bosscomments.utils;

import android.content.Context;
import android.graphics.drawable.AnimationDrawable;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.util.Log;
import android.widget.ImageView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;

import java.io.IOException;

/**
 * Created by nene on 2016/11/3.
 *
 * @ProjectName: [BossComment]
 * @Package: [com.juxian.bosscomments.utils]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/3 11:03]
 * @Version: [v1.0]
 */
public class Player implements MediaPlayer.OnPreparedListener, MediaPlayer.OnBufferingUpdateListener {

    public MediaPlayer mediaPlayer;
    public boolean isPlaying = false;
    private Context context;
    private ImageView imageView;
    private AnimationDrawable voiceAnimation = null;

    public Player(Context context) {
        this.context = context;
//        try {
//            AudioManager audioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
//            mediaPlayer = new MediaPlayer();
//            audioManager.setMode(AudioManager.MODE_NORMAL);
//            audioManager.setSpeakerphoneOn(true);
//            mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
//        } catch (Exception e) {
//            Log.e("mediaPlayer", "error", e);
//        }
    }

    public void play() {
        isPlaying = true;
        mediaPlayer.start();
    }

    public void playUrl(String videoUrl) {
        try {
            AudioManager audioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
            mediaPlayer = new MediaPlayer();
            audioManager.setMode(AudioManager.MODE_NORMAL);
            audioManager.setSpeakerphoneOn(true);
            mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
//            mediaPlayer.setOnBufferingUpdateListener(this);
//            mediaPlayer.setOnPreparedListener(this);
            isPlaying = true;
            mediaPlayer.reset();
            mediaPlayer.setDataSource(videoUrl);
            mediaPlayer.prepare();//prepare之后自动播放
            mediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {

                @Override
                public void onCompletion(MediaPlayer mp) {
                    // TODO Auto-generated method stub
                    mediaPlayer.release();
                    mediaPlayer = null;
                    stop(); // stop animation
                }

            });
            mediaPlayer.start();
            showAnimation();
        } catch (IllegalArgumentException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IllegalStateException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    public void pause() {
        mediaPlayer.pause();
    }

    private void showAnimation() {
        // play voice, and start animation
        imageView.setImageResource(R.drawable.voice_from_icon);
        voiceAnimation = (AnimationDrawable) imageView.getDrawable();
        voiceAnimation.start();
    }

    public void stop() {
        if (voiceAnimation != null) {
            voiceAnimation.stop();
        }
        imageView.setImageResource(R.drawable.yuyin);
        if (mediaPlayer != null) {
            mediaPlayer.stop();
            mediaPlayer.release();
            mediaPlayer = null;
        }
        isPlaying = false;
    }

    public void setImageView(ImageView imageView) {
        this.imageView = imageView;
    }

    @Override
    public void onPrepared(MediaPlayer mediaPlayer) {
        mediaPlayer.start();
    }

    @Override
    public void onBufferingUpdate(MediaPlayer mediaPlayer, int i) {

    }
}
