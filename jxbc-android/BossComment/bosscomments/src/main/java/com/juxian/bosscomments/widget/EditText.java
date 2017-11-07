package com.juxian.bosscomments.widget;

import android.content.Context;
import android.util.AttributeSet;

import com.juxian.bosscomments.common.Global;


public class EditText extends android.widget.EditText {
	public String extendValue;

	public EditText(Context paramContext) {
		super(paramContext);
		init(paramContext);
	}

	public EditText(Context paramContext, AttributeSet paramAttributeSet) {
		super(paramContext, paramAttributeSet);
		init(paramContext);
	}

	public EditText(Context paramContext, AttributeSet paramAttributeSet,
			int paramInt) {
		super(paramContext, paramAttributeSet, paramInt);
		init(paramContext);
	}

	private void init(Context paramContext) {
		if ((!isInEditMode()) && (Global.APP_TYPEFACE != null))
			setTypeface(Global.APP_TYPEFACE);
	}
}