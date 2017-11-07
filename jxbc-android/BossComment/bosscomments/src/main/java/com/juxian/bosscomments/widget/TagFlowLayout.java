package com.juxian.bosscomments.widget;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Rect;
import android.os.Bundle;
import android.os.Parcelable;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;


import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.TagAdapter;

import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

/**
 * Created by zhy on 15/9/10.
 */
public class TagFlowLayout extends FlowLayout implements TagAdapter.OnDataChangedListener
{
    private TagAdapter mTagAdapter;
    private boolean mAutoSelectEffect = true;
    private int mSelectedMax = -1;//-1为不限制数量
    private static final String TAG = "TagFlowLayout";
    private MotionEvent mMotionEvent;

    private Set<Integer> mSelectedView = new HashSet<Integer>();
    private Map<Integer,Date> intMap = new TreeMap<Integer,Date>();

    public TagFlowLayout(Context context, AttributeSet attrs, int defStyle)
    {
        super(context, attrs, defStyle);
        TypedArray ta = context.obtainStyledAttributes(attrs, R.styleable.TagFlowLayout);
        mAutoSelectEffect = ta.getBoolean(R.styleable.TagFlowLayout_auto_select_effect, true);
        mSelectedMax = ta.getInt(R.styleable.TagFlowLayout_max_select, -1);
        ta.recycle();

        if (mAutoSelectEffect)
        {
            setClickable(true);
        }
    }

    public TagFlowLayout(Context context, AttributeSet attrs)
    {
        this(context, attrs, 0);
    }

    public TagFlowLayout(Context context)
    {
        this(context, null);
    }


    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec)
    {
        int cCount = getChildCount();

        for (int i = 0; i < cCount; i++)
        {
            TagView tagView = (TagView) getChildAt(i);
            if (tagView.getVisibility() == View.GONE) continue;
            if (tagView.getTagView().getVisibility() == View.GONE)
            {
                tagView.setVisibility(View.GONE);
            }
        }
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    }

    public interface OnSelectListener
    {
        void onSelected(Set<Integer> selectPosSet);
    }

    private OnSelectListener mOnSelectListener;

    public void setOnSelectListener(OnSelectListener onSelectListener)
    {
        mOnSelectListener = onSelectListener;
        if (mOnSelectListener != null) setClickable(true);
    }

    public interface OnTagClickListener
    {
        boolean onTagClick(View view, int position, FlowLayout parent);
    }

    private OnTagClickListener mOnTagClickListener;


    public void setOnTagClickListener(OnTagClickListener onTagClickListener)
    {
        mOnTagClickListener = onTagClickListener;
        if (onTagClickListener != null) setClickable(true);
    }


    public void setAdapter(TagAdapter adapter)
    {
        //if (mTagAdapter == adapter)
        //  return;
        mTagAdapter = adapter;
        mTagAdapter.setOnDataChangedListener(this);
        mSelectedView.clear();
        changeAdapter();

    }

    private void changeAdapter()
    {
        removeAllViews();
        TagAdapter adapter = mTagAdapter;
        TagView tagViewContainer = null;
        HashSet preCheckedList = mTagAdapter.getPreCheckedList();
        for (int i = 0; i < adapter.getCount(); i++)
        {
            View tagView = adapter.getView(this, i, adapter.getItem(i));

            tagViewContainer = new TagView(getContext());
//            ViewGroup.MarginLayoutParams clp = (ViewGroup.MarginLayoutParams) tagView.getLayoutParams();
//            ViewGroup.MarginLayoutParams lp = new ViewGroup.MarginLayoutParams(clp);
//            lp.width = ViewGroup.LayoutParams.WRAP_CONTENT;
//            lp.height = ViewGroup.LayoutParams.WRAP_CONTENT;
//            lp.topMargin = clp.topMargin;
//            lp.bottomMargin = clp.bottomMargin;
//            lp.leftMargin = clp.leftMargin;
//            lp.rightMargin = clp.rightMargin;
            tagView.setDuplicateParentStateEnabled(true);
            tagViewContainer.setLayoutParams(tagView.getLayoutParams());
            tagViewContainer.addView(tagView);
            addView(tagViewContainer);


            if(preCheckedList.contains(i))
            {
                tagViewContainer.setChecked(true);
            }
        }
        mSelectedView.addAll(preCheckedList);

    }


    @Override
    public boolean onTouchEvent(MotionEvent event)
    {
        if (event.getAction() == MotionEvent.ACTION_UP)
        {
            mMotionEvent = MotionEvent.obtain(event);
        }
        return super.onTouchEvent(event);
    }

    @Override
    public boolean performClick()
    {
        if (mMotionEvent == null) return super.performClick();

        int x = (int) mMotionEvent.getX();
        int y = (int) mMotionEvent.getY();
        mMotionEvent = null;

        TagView child = findChild(x, y);
        int pos = findPosByView(child);
        if (child != null)
        {
            doSelect(child, pos);
            if (mOnTagClickListener != null)
            {
                return mOnTagClickListener.onTagClick(child.getTagView(), pos, this);
            }
        }
        return true;
    }

    public boolean setSelectStatus(int position){
//        if (mMotionEvent == null) return performClick();
//
//        int x = (int) mMotionEvent.getX();
//        int y = (int) mMotionEvent.getY();
//        mMotionEvent = null;

        TagView child = (TagView)getChildAt(position);
        int pos = findPosByView(child);
        if (child != null)
        {
            child.setChecked(false);
            mSelectedView.remove(position);
            intMap.remove(position);
//            doSelect(child, pos);
//            if (mOnTagClickListener != null)
//            {
//                return mOnTagClickListener.onTagClick(child.getTagView(), pos, this);
//            }
        }
        return true;
    }

    public void setMaxSelectCount(int count)
    {
        if (mSelectedView.size() > count)
        {
            Log.w(TAG, "you has already select more than " + count + " views , so it will be clear .");
            mSelectedView.clear();
        }
        mSelectedMax = count;
    }

    public Set<Integer> getSelectedList()
    {
        return new HashSet<Integer>(mSelectedView);
    }

    private void doSelect(TagView child, int position)
    {
        if (mAutoSelectEffect)
        {
            if (!child.isChecked())
            {
                //处理max_select=1的情况
                if(mSelectedMax == 1 && mSelectedView.size() == 1)
                {
                    Iterator<Integer> iterator = mSelectedView.iterator();
                    Integer preIndex = iterator.next();
                    TagView pre = (TagView) getChildAt(preIndex);
                    pre.setChecked(false);
                    child.setChecked(true);
                    mSelectedView.remove(preIndex);
                    mSelectedView.add(position);
                }else if(mSelectedMax != -1){
                    // 这个else if是我自己加的，目的是为了判断限制了最大的选择个数的时候，比如限制了最大可以选择三个，则在点击要选择第四个的时候，将之前的三个中的第一个的选中状态取消
//                    if (mSelectedMax > 0 && mSelectedView.size() >= mSelectedMax)
//                        return;
                    // 在选择的View的数量达到限制的个数的时候，通过点击的时间来判断，选择最早选中的那个进行取消选中状态
                    if (mSelectedView.size() == mSelectedMax){
//                        Iterator<Integer> iterator = mSelectedView.iterator();
                        Integer preIndex = -1;
                        // time1是当前时间
                        long time1 = System.currentTimeMillis();
                        // time2是时间差
                        long time2 = 0;
                        Set<Map.Entry<Integer, Date>> set = intMap.entrySet();
                        Iterator<Map.Entry<Integer, Date>> it = set.iterator();
                        while(it.hasNext()){
                            Map.Entry<Integer, Date> entry = it.next();
                            if ((time1 - entry.getValue().getTime()) > time2){
                                time2 = time1 - entry.getValue().getTime();
                                preIndex = entry.getKey();
                            }
                        }
                        TagView pre = (TagView) getChildAt(preIndex);
                        pre.setChecked(false);
                        child.setChecked(true);
                        mSelectedView.remove(preIndex);
                        intMap.remove(preIndex);
                        mSelectedView.add(position);
                        intMap.put(position,new Date());
                    }else if(mSelectedView.size() < mSelectedMax){
                        intMap.put(position,new Date());
                        child.setChecked(true);
                        mSelectedView.add(position);
                    }
                } else {
                    if (mSelectedMax > 0 && mSelectedView.size() >= mSelectedMax)
                        return;
                    child.setChecked(true);
                    mSelectedView.add(position);
                }
            } else
            {
                child.setChecked(false);
                mSelectedView.remove(position);
                intMap.remove(position);
            }
            if (mOnSelectListener != null)
            {
                mOnSelectListener.onSelected(new HashSet<Integer>(mSelectedView));
            }
        }
    }

    private static final String KEY_CHOOSE_POS = "key_choose_pos";
    private static final String KEY_DEFAULT = "key_default";


    @Override
    protected Parcelable onSaveInstanceState()
    {
        Bundle bundle = new Bundle();
        bundle.putParcelable(KEY_DEFAULT, super.onSaveInstanceState());

        String selectPos = "";
        if (mSelectedView.size() > 0)
        {
            for (int key : mSelectedView)
            {
                selectPos += key + "|";
            }
            selectPos = selectPos.substring(0, selectPos.length() - 1);
        }
        bundle.putString(KEY_CHOOSE_POS, selectPos);
        return bundle;
    }

    @Override
    protected void onRestoreInstanceState(Parcelable state)
    {
        if (state instanceof Bundle)
        {
            Bundle bundle = (Bundle) state;
            String mSelectPos = bundle.getString(KEY_CHOOSE_POS);
            if (!TextUtils.isEmpty(mSelectPos))
            {
                String[] split = mSelectPos.split("\\|");
                for (String pos : split)
                {
                    int index = Integer.parseInt(pos);
                    mSelectedView.add(index);

                    TagView tagView = (TagView) getChildAt(index);
                    tagView.setChecked(true);
                }

            }
            super.onRestoreInstanceState(bundle.getParcelable(KEY_DEFAULT));
            return;
        }
        super.onRestoreInstanceState(state);
    }

    private int findPosByView(View child)
    {
        final int cCount = getChildCount();
        for (int i = 0; i < cCount; i++)
        {
            View v = getChildAt(i);
            if (v == child) return i;
        }
        return -1;
    }

    private TagView findChild(int x, int y)
    {
        final int cCount = getChildCount();
        for (int i = 0; i < cCount; i++)
        {
            TagView v = (TagView) getChildAt(i);
            if (v.getVisibility() == View.GONE) continue;
            Rect outRect = new Rect();
            v.getHitRect(outRect);
            if (outRect.contains(x, y))
            {
                return v;
            }
        }
        return null;
    }

    @Override
    public void onChanged()
    {
        changeAdapter();
    }

    public Set<Integer> getSelectedView(){
    	return mSelectedView;
    }
    
    public void clearView(){
    	for (int i = 0; i < mSelectedView.size(); i++) {
    		TagView pre = (TagView) getChildAt(i);
    		pre.setChecked(false);
		}
    	intMap.clear();
    	mSelectedView.clear();
    }
}
