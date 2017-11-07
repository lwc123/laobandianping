package com.juxian.bosscomments.ui;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.widget.TouchImageView;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import org.xutils.image.ImageOptions;
import org.xutils.x;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by nene on 2016/11/30.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/30 13:30]
 * @Version: [v1.0]
 */
public class ShowBigImgActivity extends BaseActivity implements View.OnClickListener, ViewPager.OnPageChangeListener, TouchImageView.onClickPhotoListener {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.activity_viewpager)
    ViewPager mViewPager;
    @BindView(R.id.current_img)
    TextView mCurrentImage;
    @BindView(R.id.total_img_number)
    TextView mTotalImageNumber;
    private Intent mIntent;
    /**
     * 装ImageView数组
     */
    private ImageView[] mImageViews;
    private ArrayList<String> mImageUrls;
    private int index;
    private ImageLoadingListener animateFirstListener = new Global.AnimateFirstDisplayListener();
    DisplayImageOptions center_background = Global.Constants.DEFAULT_MY_CENTER_AVATAR_OPTIONS;
    private ImageOptions xUtilsOptions = new ImageOptions.Builder().build();

    @Override
    public int getContentViewId() {
        return R.layout.activity_show_big_img;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ButterKnife.bind(this);
        title.setText(getString(R.string.examine_image));
        back.setOnClickListener(this);
        mIntent = getIntent();
        mImageUrls = mIntent.getStringArrayListExtra("ImageUrls");
        index = mIntent.getIntExtra("index", 0);
        if (mImageUrls.size() == 1) {
            mCurrentImage.setVisibility(View.GONE);
            mTotalImageNumber.setVisibility(View.GONE);
        } else {
//            mTotalImageNumber.setText(mImageUrls.size() + "");
            mCurrentImage.setVisibility(View.VISIBLE);
            mTotalImageNumber.setVisibility(View.VISIBLE);
            mTotalImageNumber.setText("/" + mImageUrls.size());
        }

        //将图片装载到数组中
        mImageViews = new ImageView[mImageUrls.size()];
        for (int i = 0; i < mImageViews.length; i++) {
            TouchImageView imageView = new TouchImageView(this,this);
            imageView.setMaxZoom(5f);
            mImageViews[i] = imageView;
            if (mImageUrls.get(i).startsWith("http://")) {
                ImageLoader.getInstance().displayImage(mImageUrls.get(i), imageView, center_background, animateFirstListener);
            } else {
                x.image().bind(imageView, mImageUrls.get(i), xUtilsOptions);
//                Bitmap bitmap = BitmapFactory.decodeFile(mImageUrls.get(i));
//                imageView.setImageBitmap(bitmap);
            }
        }
        mViewPager.setAdapter(new MyViewPagerAdapter());
        //设置监听，主要是设置点点的背景
        mViewPager.addOnPageChangeListener(this);
        //设置ViewPager的默认项, 设置为长度的100倍，这样子开始就能往左滑动
        mViewPager.setCurrentItem(index);
        setSystemBarTintManager(this);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
//                setResult(RESULT_OK);
                finish();
                break;
        }
    }

    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

    }

    @Override
    public void onPageSelected(int position) {
        mCurrentImage.setText((position + 1) + "");
    }

    @Override
    public void onPageScrollStateChanged(int state) {

    }

    @Override
    public void clickPhoto() {
        finish();
    }

    public class MyViewPagerAdapter extends PagerAdapter {

        @Override
        public int getCount() {
            return mImageViews.length;
        }

        @Override
        public boolean isViewFromObject(View arg0, Object arg1) {
            return arg0 == arg1;
        }

//        @Override
//        public void destroyItem(View container, int position, Object object) {
//            ((ViewPager)container).removeView(mImageViews[position % mImageViews.length]);
//        }

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            ((ViewPager) container).removeView(mImageViews[position]);
        }

        /**
         * 载入图片进去，用当前的position 除以 图片数组长度取余数是关键
         */
//        @Override
//        public Object instantiateItem(View container, int position) {
//            ((ViewPager)container).addView(mImageViews[position % mImageViews.length], 0);
//            return mImageViews[position % mImageViews.length];
//        }
        @Override
        public Object instantiateItem(ViewGroup container, int position) {
            ((ViewPager) container).addView(mImageViews[position], 0);
            return mImageViews[position];
        }
    }
}
