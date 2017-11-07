package com.juxian.bosscomments.widget;

import android.content.Context;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.view.MotionEvent;

/**
 * Created by nene on 2016/12/1.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/1 18:43]
 * @Version: [v1.0]
 */
public class NoScrollViewPager extends ViewPager {
    private boolean scrollble = true;

    public NoScrollViewPager(Context context) {
        super(context);
    }

    public NoScrollViewPager(Context context, AttributeSet attrs) {
        super(context, attrs);
    }


    @Override
    public boolean onTouchEvent(MotionEvent arg0) {
        /*return false;//super.onTouchEvent(arg0);*/
        if(scrollble)
            return false;
        else
            return super.onTouchEvent(arg0);
    }
    @Override
    public boolean onInterceptTouchEvent(MotionEvent arg0) {
        if(scrollble)
            return false;
        else
            return super.onInterceptTouchEvent(arg0);
    }


    public boolean isScrollble() {
        return scrollble;
    }

    public void setScrollble(boolean scrollble) {
        this.scrollble = scrollble;
    }
}
