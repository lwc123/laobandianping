package com.juxian.bosscomments.widget;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Typeface;
import android.os.Build;
import android.util.AttributeSet;


import com.juxian.bosscomments.common.Global;

import java.lang.reflect.Field;

/**
 * @ClassName: TextView
 * @说明:
 * @author 付晓龙
 * @date 2015-10-30 上午10:42:55
 */

public class TextView extends android.widget.TextView {
	public Typeface typeface;

	public TextView(Context paramContext) {

		super(paramContext);
		init(paramContext);
	}

	public TextView(Context paramContext, AttributeSet paramAttributeSet) {
		super(paramContext, paramAttributeSet);
		init(paramContext);
	}

	public TextView(Context paramContext, AttributeSet paramAttributeSet,
			int paramInt) {
		super(paramContext, paramAttributeSet, paramInt);
		init(paramContext);
	}

	private float getTextLineSpacing() {
		try {
			Field localField = android.widget.TextView.class
					.getDeclaredField("mSpacingAdd");
			localField.setAccessible(true);
			float f = localField.getFloat(this);
			return f;
		} catch (Exception localException) {
			localException.printStackTrace();
		}
		return 0.0F;
	}

	private void init(Context paramContext) {
		if ((!isInEditMode()) && (Global.APP_TYPEFACE != null))
			setTypeface(Global.APP_TYPEFACE);
	}

	protected void onDraw(Canvas paramCanvas) {
		if (Build.VERSION.SDK_INT >= 21) {
			super.onDraw(paramCanvas);
			return;
		}
		paramCanvas.translate(0.0F, getTextLineSpacing() / 2.0F);
		super.onDraw(paramCanvas);
	}
}