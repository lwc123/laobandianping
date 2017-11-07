package com.juxian.bosscomments.utils;

import android.content.Context;
import android.util.TypedValue;

/**
 * Created by nene on 2016/12/5.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/5 11:11]
 * @Version: [v1.0]
 */
public class Dp2pxUtil {
    public static int dp2px(int dp, Context context) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp, context.getResources().getDisplayMetrics());
    }
}
