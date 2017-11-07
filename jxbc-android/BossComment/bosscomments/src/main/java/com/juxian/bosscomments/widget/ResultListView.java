package com.juxian.bosscomments.widget;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ListView;

/**
 * Created by nene on 2016/11/1.
 *
 * @ProjectName: [BossComment]
 * @Package: [com.juxian.bosscomments.widget]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/1 16:11]
 * @Version: [v1.0]
 */
public class ResultListView extends ListView {
    public ResultListView(Context context) {
        super(context);
    }

    public ResultListView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public ResultListView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int expandSpec = MeasureSpec.makeMeasureSpec(Integer.MAX_VALUE >> 2,
                MeasureSpec.AT_MOST);
        super.onMeasure(widthMeasureSpec, expandSpec);
    }
}
