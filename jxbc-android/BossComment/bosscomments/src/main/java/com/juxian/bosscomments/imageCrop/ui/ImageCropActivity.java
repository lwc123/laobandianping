package com.juxian.bosscomments.imageCrop.ui;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.juxian.bosscomments.imageCrop.utils.ImagePicker;
import com.juxian.bosscomments.imageCrop.view.CropImageView;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.utils.Bimp;
import com.juxian.bosscomments.utils.FileUtil;
import com.juxian.bosscomments.utils.SystemBarTintManager;

import java.io.File;

public class ImageCropActivity extends Activity implements View.OnClickListener, CropImageView.OnBitmapSaveCompleteListener {

    private CropImageView mCropImageView;
    private Bitmap mBitmap;
    private boolean mIsSaveRectangle;
    private int mOutputX;
    private int mOutputY;
    //private ArrayList<ImageItem> mImageItems;
    private ImagePicker imagePicker;
    private String tag;
    private String imagePath;
    private SystemBarTintManager tintManager;
    public static final String UPLOADING_IDENTITY_PHOTO = "uploading_identity_photo",EDIT_AVATAR_IMAGE_TAG = "PersonalCenterFragment";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_image_crop);
        Bimp.drr.clear();
        imagePicker = ImagePicker.getInstance();
        tag = getIntent().getStringExtra(Global.LISTVIEW_ITEM_TAG);
        //初始化View
        findViewById(R.id.btn_back).setOnClickListener(this);
        Button btn_ok = (Button) findViewById(R.id.btn_ok);
        Button crop = (Button) findViewById(R.id.ok_crop);
        btn_ok.setText(getString(R.string.complete));
        btn_ok.setOnClickListener(this);
        crop.setOnClickListener(this);
        TextView tv_des = (TextView) findViewById(R.id.tv_des);
        tv_des.setText("裁剪");
        mCropImageView = (CropImageView) findViewById(R.id.cv_crop_image);
        mCropImageView.setOnBitmapSaveCompleteListener(this);

//        tintManager = new SystemBarTintManager(this);
//        tintManager.setStatusBarTintEnabled(true);
//        tintManager.setStatusBarTintResource(R.color.main_color);

        //获取需要的参数
//        mOutputX = 800;
//        mOutputY = 800;
        mIsSaveRectangle = true;

        imagePath = getIntent().getStringExtra("path");

        mCropImageView.setFocusStyle(imagePicker.getStyle());


        if (UPLOADING_IDENTITY_PHOTO.equals(tag)) {// 身份信息认证
            mCropImageView.setFocusWidth(648);
            mCropImageView.setFocusHeight(230);
            mOutputX = 1296;
            mOutputY = 460;
        } else if (EDIT_AVATAR_IMAGE_TAG.equals(tag)) {// 上传头像
            mCropImageView.setFocusWidth(600);
            mCropImageView.setFocusHeight(600);
            mOutputX = 600;
            mOutputY = 600;
        } else {
            mCropImageView.setFocusWidth(600);
            mCropImageView.setFocusHeight(600);
            mOutputX = 600;
            mOutputY = 600;
        }
        //缩放图片，压缩的是像素
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(imagePath, options);
        DisplayMetrics displayMetrics = getResources().getDisplayMetrics();
        options.inSampleSize = calculateInSampleSize(options, displayMetrics.widthPixels, displayMetrics.heightPixels);
        options.inJustDecodeBounds = false;
        mBitmap = BitmapFactory.decodeFile(imagePath, options);
        mCropImageView.setImageBitmap(mBitmap);

//        mCropImageView.setImageURI(Uri.fromFile(new File(imagePath)));
    }

    public int calculateInSampleSize(BitmapFactory.Options options, int reqWidth, int reqHeight) {
        int width = options.outWidth;
        int height = options.outHeight;
        int inSampleSize = 1;
        if (height > reqHeight || width > reqWidth) {
            if (width > height) {
                inSampleSize = width / reqWidth;
            } else {
                inSampleSize = height / reqHeight;
            }
        }
        return inSampleSize;
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.btn_back) {
            setResult(RESULT_CANCELED);
            finish();
        } else if (id == R.id.btn_ok) {
            mCropImageView.saveBitmapToFile(imagePicker.getCropCacheFolder(this), mOutputX, mOutputY, mIsSaveRectangle);
        } else if (id == R.id.ok_crop) {
            mCropImageView.saveBitmapToFile(imagePicker.getCropCacheFolder(this), mOutputX, mOutputY, mIsSaveRectangle);
        }
    }

    @Override
    public void onBitmapSaveSuccess(File file) {
        // Toast.makeText(ImageCropActivity.this, "裁剪成功:" + file.getAbsolutePath(), Toast.LENGTH_SHORT).show();
        Intent mIntent = new Intent();
        mIntent.putExtra("path", file.toString());
        Log.e(Global.LOG_TAG,"1:"+imagePath);
        setResult(RESULT_OK, mIntent);
        finish();
        //裁剪后替换掉返回数据的内容，但是不要改变全局中的选中数据
        // mImageItems.remove(0);
//        ImageItem imageItem = new ImageItem();
//        imageItem.path = file.getAbsolutePath();
        //  mImageItems.add(imageItem);

//        Intent intent = new Intent();
//        intent.putExtra(ImagePicker.EXTRA_RESULT_ITEMS, mImageItems);
//        setResult(ImagePicker.RESULT_CODE_ITEMS, intent);   //单选不需要裁剪，返回数据
        // finish();
    }

    @Override
    public void onBitmapSaveError(File file) {

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (null != mBitmap && !mBitmap.isRecycled()) {
            mBitmap.recycle();
            mBitmap = null;
        }
    }
}
