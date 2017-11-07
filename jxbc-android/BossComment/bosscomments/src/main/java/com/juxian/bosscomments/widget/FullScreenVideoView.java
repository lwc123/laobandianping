package com.juxian.bosscomments.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.view.WindowManager;
import android.widget.VideoView;

/**
 * Created by Tam on 2017/2/11.
 */
public class FullScreenVideoView extends VideoView {

    public FullScreenVideoView(Context context) {
        super(context);
    }

    public FullScreenVideoView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public FullScreenVideoView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);

    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        WindowManager wm = (WindowManager) getContext().getSystemService(Context.WINDOW_SERVICE);
        int width = wm.getDefaultDisplay().getWidth();
        int height = wm.getDefaultDisplay().getHeight();
        setMeasuredDimension(width, height);//设置当前view大小是屏幕的宽和高
    }
}