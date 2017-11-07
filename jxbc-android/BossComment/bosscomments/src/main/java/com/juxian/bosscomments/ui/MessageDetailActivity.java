package com.juxian.bosscomments.ui;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.MessageEntity;
import com.juxian.bosscomments.repositories.MessageRepository;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.JsonUtil;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Tam on 2017/2/9.
 */
public class MessageDetailActivity extends BaseActivity {
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.imageView_logo)
    ImageView imageView_logo;
    @BindView(R.id.mess_frag_title)
    TextView mess_frag_title;
    @BindView(R.id.mess_frag_time)
    TextView mess_frag_time;
    private DisplayImageOptions options = Global.Constants.DEFAULT_LOAD_PIC_OPTIONS;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    private SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    @Override
    public int getContentViewId() {
        return R.layout.activity_message_detail;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        initViewsData();
        initListener();
        setSystemBarTintManager(this);
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText("消息详情");
        MessageEntity messageEntity = JsonUtil.ToEntity(getIntent().getStringExtra("messageEntity"), MessageEntity.class);
        if (messageEntity != null) {
            ImageLoader.getInstance().displayImage(messageEntity.Picture, imageView_logo, options, animateFirstListener);
            mess_frag_title.setText(messageEntity.Content);
            FormatTime(mess_frag_time, messageEntity);
            readMsg(messageEntity.MessageId);
        }
    }

    public void readMsg(final long MsgID) {

        new AsyncRunnable<Boolean>() {
            @Override
            protected Boolean doInBackground(Void... params) {
                Boolean success = MessageRepository.readMsg(MsgID);
                return success;
            }

            @Override
            protected void onPostExecute(Boolean model) {
                if (model) {
//                    ToastUtil.showInfo("已读");
                } else {
                }
            }

            protected void onPostError(Exception ex) {
            }
        }.execute();
    }


    public void FormatTime(TextView view, MessageEntity messageEntity) {
        try {
            String ItemDateStr = mSimpleDateFormat.format(messageEntity.CreatedTime);
            String NowDateStr = mSimpleDateFormat.format(new Date());
            long l = mSimpleDateFormat.parse(NowDateStr).getTime() - mSimpleDateFormat.parse(ItemDateStr).getTime();
            long day = l / (24 * 60 * 60 * 1000); //0
            long hour = (l / (60 * 60 * 1000) - day * 24); //7
            long min = ((l / (60 * 1000)) - day * 24 * 60 - hour * 60); //25
            long s = (l / 1000 - day * 24 * 60 * 60 - hour * 60 * 60 - min * 60); //27
            if (day > 1) {
                view.setText(ItemDateStr);
            } else if (hour >= 1) {
                view.setText(hour + "小时前");
            } else if (min >= 1) {
                view.setText(min + "分钟前");
            } else if (s >= 0) {
                view.setText("刚刚");
            } else {
                view.setText("未知时间");
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        setResult(RESULT_OK);
        finish();
    }
}
