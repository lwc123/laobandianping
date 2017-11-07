package me.nereo.multi_image_selector;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;

import java.io.File;

import me.nereo.multi_image_selector.utils.ImageTools;
import me.nereo.multi_image_selector.utils.SystemBarTintManager;
import me.nereo.multi_image_selector.utils.ToastUtil;
import me.nereo.multi_image_selector.view.ActionbarView;
import me.nereo.multi_image_selector.view.ClipImageLayout;


/**
 * http://blog.csdn.net/lmj623565791/article/details/39761281
 *
 * @author zhy
 */
public class CutImageActivity extends Activity {
    private ClipImageLayout mClipImageLayout;
    private ActionbarView actionbar;
    private String path;
    private String dirPath;
    private String photoName;
    private Bitmap bitmap;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.pic_cutimage_activity);
//		DisplayMetrics metrics = new DisplayMetrics();
//		getWindowManager().getDefaultDisplay().getMetrics(metrics);
        path = getIntent().getStringExtra("path");
        dirPath = getIntent().getStringExtra("dirPath");
        photoName = getIntent().getStringExtra("photoName");
        actionbar = (ActionbarView) findViewById(R.id.pic_cutimage_actionbar);
        mClipImageLayout = (ClipImageLayout) findViewById(R.id.id_clipImageLayout);
        // degree = ImageTools.readPictureDegree(path);
        bitmap = ImageTools.getResizedBitmap(path, 480, 800);
        // if(degree != 0){
        // bitmap = ImageTools.rotateBitmap(bitmap, degree);
        // }
        // bitmap = BitmapFactory.decodeFile(path);
        mClipImageLayout.setImage(bitmap);
        actionbar.setTitle("裁剪图片");
        actionbar.setRightText(R.string.pic_confirm);
        actionbar.setOnRightClick(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                if (ImageTools.RemainingSpace() / 1024 < 300) {
                    ToastUtil.show(CutImageActivity.this, "SD卡存储空间不足!");
                    return;
                }
                Bitmap bitmap = mClipImageLayout.clip();
                File file = ImageTools.savePhotoToSDCard(bitmap, dirPath,
                        photoName);
                Intent intent = new Intent();
                if (file == null) {
                    intent.putExtra("path", "");
                } else {
                    intent.putExtra("path", file.getAbsolutePath());
                }
                setResult(RESULT_OK, intent);
                finish();
            }
        });
        SystemBarTintManager tintManager = new SystemBarTintManager(this);
        tintManager.setStatusBarTintEnabled(true);
        tintManager.setStatusBarTintResource(R.color.mis_actionbar_color);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (bitmap != null) {
            if (!bitmap.isRecycled()) {
                bitmap.recycle();
                bitmap = null;
            }
        }
    }

}
