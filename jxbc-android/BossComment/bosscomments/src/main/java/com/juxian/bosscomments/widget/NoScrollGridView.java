package com.juxian.bosscomments.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.GridView;

public class NoScrollGridView extends GridView {
//    public static int gridviewHeight = 10;

    public NoScrollGridView(Context context) {
        super(context);

    }


    public NoScrollGridView(Context context, AttributeSet attrs) {
        super(context, attrs);
//
//        TypedArray typedArray = context.obtainStyledAttributes(attrs, R.styleable.NoScrollGridView);
//        gridviewHeight = typedArray.getDimensionPixelSize(R.styleable.NoScrollGridView_gridviewHeight, 10);
//
//        typedArray.recycle();

    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int expandSpec = MeasureSpec.makeMeasureSpec(Integer.MAX_VALUE >> 2, MeasureSpec.AT_MOST);
        super.onMeasure(widthMeasureSpec, expandSpec);
    }
}