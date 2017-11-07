package com.juxian.bosscomments.ui;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.hardware.Camera;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.Spinner;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.ImageGridAdapter;
import com.juxian.bosscomments.models.ImageBucket;
import com.juxian.bosscomments.models.ImageItem;
import com.juxian.bosscomments.utils.AlbumHelper;
import com.juxian.bosscomments.utils.Bimp;
import com.juxian.bosscomments.utils.PermissionUtils;
import com.juxian.bosscomments.utils.SystemBarTintManager;
import com.juxian.bosscomments.utils.checkSelfPermissionUtils;

import net.juxian.appgenome.utils.FileUtil;
import net.juxian.appgenome.utils.ImageUtils;
import net.juxian.appgenome.widget.ToastUtil;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * @author 付晓龙
 * @ClassName: ImageGridActivity
 * @说明:网格图片
 * @date 2016-3-15 下午5:31:53
 */
public class ImageGridActivity extends Activity {
    public static final String EXTRA_IMAGE_LIST = "imagelist";
    List<ImageItem> dataList;
    GridView gridView;
    ImageGridAdapter adapter;
    // Button bt;
    ImageView image_grid_exit;
    ArrayList<String> list;
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_register)
    TextView tips;
    @BindView(R.id.include_head_title_register_re)
    RelativeLayout tips_re;
    // 开始头部选择按钮
    @BindView(R.id.include_head_title_spinner)
    Spinner spinner;
    private ArrayAdapter<CharSequence> photos = null;// 要使用的Adapter
    List<String> content;
    ArrayAdapter<String> adapter1; // 声明一个ArrayAdapter用来加载下拉数据[/mw_shl_code]
    // 增加头部选择按钮
    List<ImageBucket> dataList1;
    AlbumHelper helper;
    private String mTag;
    private int mMax;
    //
    private String path = "";
    Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case 0:
                    if ("nine".equals(mTag)) {
                        ToastUtil.showInfo(getString(R.string.max_select_nine_picture));
                    } else if ("shortvideo".equals(mTag)) {
                        ToastUtil.showInfo(getString(R.string.max_select_one_picture));
                    } else {
                        ToastUtil.showInfo(getString(R.string.max_select_two_picture));
                    }
                    break;
                default:
                    break;
            }
        }
    };
    private int NetPicNum;

    @SuppressWarnings("unchecked")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_image_grid);
        ButterKnife.bind(this);
        content = new ArrayList<String>();
        title.setText(getString(R.string.photo_album));

        mTag = getIntent().getStringExtra("Tag");
        NetPicNum = getIntent().getIntExtra("NetPic", 0);
        if ("shortvideo".equals(mTag)) {
            mMax = 1;
        } else if ("two".equals(mTag)) {
            mMax = 2;
        } else {
            mMax = 9;
        }

        title.setVisibility(View.GONE);
        spinner.setVisibility(View.VISIBLE);
        // 修改头部spinner
        helper = AlbumHelper.getHelper();
        helper.init(getApplicationContext());
        dataList1 = helper.getImagesBucketList(false);
        //
        for (int i = 0; i < dataList1.size(); i++) {// 顶部spinner数据源
            content.add(dataList1.get(i).bucketName);
        }
        adapter1 = new ArrayAdapter<String>(ImageGridActivity.this,
                R.layout.item_spinner_item, content);
        adapter1.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        // 将数据加载进下拉列表当中
        spinner.setAdapter(adapter1);
        // 添加事件Spinner事件监听，当点击下拉列表中的某一选项之后触发该事件
        spinner.setOnItemSelectedListener(new SpinnerSelectedListener());
        tips.setVisibility(View.VISIBLE);
        back.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                finish();
            }
        });

        dataList = dataList1.get(0).imageList;

        Collections.reverse(dataList);
        image_grid_exit = (ImageView) findViewById(R.id.image_grid_exit);
        image_grid_exit.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent().setClass(ImageGridActivity.this,
                        PicActivity.class));
                finish();
            }
        });
        tips.setText(getString(R.string.complete) + 0 + "/" + (mMax-(Bimp.drr.size() + NetPicNum)));
        tips_re.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                if (Bimp.drr.size() == 0 && adapter.map.size() == 0) {
                    ToastUtil.showInfo(getString(R.string.please_select_picture));
                    return;
                }
                onSelectedCompleted();

            }
        });
        initView();

        SystemBarTint(this);
    }

    private void SystemBarTint(Activity activity) {
        SystemBarTintManager tintManager = new SystemBarTintManager(activity);
        tintManager.setStatusBarTintEnabled(true);
        tintManager.setStatusBarTintResource(R.color.main_color);
    }

    class SpinnerSelectedListener implements OnItemSelectedListener {

        public void onItemSelected(AdapterView<?> arg0, View arg1, int arg2,
                                   long arg3) {
            dataList = dataList1.get(arg2).imageList;
            initView();
            // Toast.makeText(ImageGridActivity.this, content.get(arg2), 3000)
            // .show();
        }

        public void onNothingSelected(AdapterView<?> arg0) {
        }
    }

    private void onSelectedCompleted() {
        list = new ArrayList<String>();
        Collection<String> c = adapter.map.values();
        Iterator<String> it = c.iterator();
        for (; it.hasNext(); ) {
            list.add(it.next());
        }
        for (int i = 0; i < list.size(); i++) {
            if (Bimp.drr.size() < mMax) {
                boolean exists = false;
                for (String imagePath : Bimp.drr) {
                    if (imagePath.equals(list.get(i))) {
                        exists = true;
                        break;
                    }
                }

                if (false == exists) {
                    Bimp.drr.add(list.get(i));
                }
            }
        }
        ImageUtils.saveFilePaths.clear();
//        final Dialog dialog = DialogUtil.showLoadingDialog();
        new Thread() {
            @Override
            public void run() {
                for (int i = 0; i < Bimp.drr.size(); i++) {
                    ImageUtils.writeToFile(getApplicationContext(), ImageUtils.getSmallBitmap(getApplicationContext(), Bimp.drr.get(i)), "com.juxian.bosscomments/OutImage", System.currentTimeMillis() + "");
                }
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        setResult(RESULT_OK);
//                        dialog.dismiss();
                        finish();
                    }
                });
            }
        }.start();
    }

    private void initView() {
        gridView = (GridView) findViewById(R.id.gridview);
        gridView.setSelector(new ColorDrawable(Color.TRANSPARENT));
        adapter = new ImageGridAdapter(ImageGridActivity.this, dataList, mHandler, mMax, NetPicNum);
        gridView.setAdapter(adapter);
        adapter.setTextCallback(new ImageGridAdapter.TextCallback() {
            public void onListen(int count) {
                if (Bimp.drr.size() <= 0) {
                    tips.setText(getString(R.string.complete) + ((count - Bimp.drr.size()) + NetPicNum) + "/" + mMax);
                } else {
                    tips.setText(getString(R.string.complete) + (count) + "/" + (mMax-(Bimp.drr.size() + NetPicNum)));
                }
            }
        });
        gridView.setOnItemClickListener(new OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view,
                                    int position, long id) {
                if (position >= 1) {
                    adapter.notifyDataSetChanged();
                } else {
                    if (Build.VERSION.SDK_INT < 23) {
                        try {
                            Camera c = null;
                            c = Camera.open();
                        } catch (Exception e){

                        } finally {
                            if (ContextCompat.checkSelfPermission(ImageGridActivity.this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
                                checkSelfPermissionUtils.checkPermission(ImageGridActivity.this, Manifest.permission.CAMERA);
                            }
                        }
                        if (ContextCompat.checkSelfPermission(ImageGridActivity.this, Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED) {
                            photo();
                        }
                    } else {
                        if (ContextCompat.checkSelfPermission(ImageGridActivity.this, Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED) {
                            PermissionUtils.requestPermission(ImageGridActivity.this, PermissionUtils.CODE_CAMERA, mPermissionGrant);
                        } else {
                            photo();
                        }
                    }
//                    if (ContextCompat.checkSelfPermission(ImageGridActivity.this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
//                        checkSelfPermissionUtils.checkPermission(ImageGridActivity.this, Manifest.permission.CAMERA);
//                    } else {
//                        photo();
//                    }
                }
            }
        });
    }

    private PermissionUtils.PermissionGrant mPermissionGrant = new PermissionUtils.PermissionGrant() {
        @Override
        public void onPermissionGranted(int requestCode) {
            switch (requestCode) {
                case PermissionUtils.CODE_RECORD_AUDIO:

                    break;
                case PermissionUtils.CODE_GET_ACCOUNTS:
                    break;
                case PermissionUtils.CODE_READ_PHONE_STATE:
                    break;
                case PermissionUtils.CODE_CALL_PHONE:
                    break;
                case PermissionUtils.CODE_CAMERA:
                    photo();
                    break;
                case PermissionUtils.CODE_ACCESS_FINE_LOCATION:
                    break;
                case PermissionUtils.CODE_ACCESS_COARSE_LOCATION:
                    break;
                case PermissionUtils.CODE_READ_EXTERNAL_STORAGE:
                    break;
                case PermissionUtils.CODE_WRITE_EXTERNAL_STORAGE:
                    break;
                default:
                    break;
            }
        }
    };

    @Override
    public void onRequestPermissionsResult(final int requestCode, @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        PermissionUtils.requestPermissionsResult(this, requestCode, permissions, grantResults, mPermissionGrant);
    }

    public void photo() {
        // + "/formats/"
        Intent openCameraIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        // File file = new
        // File(Environment.getExternalStorageDirectory().toString(),
        // String.valueOf(System.currentTimeMillis())+ ".jpg");
        File file = new File(FileUtil.getCameraPath().toString(),
                String.valueOf(System.currentTimeMillis()) + ".jpg");
        path = file.getPath();
        Uri imageUri = Uri.fromFile(file);
        openCameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, imageUri);
        startActivityForResult(openCameraIntent, 1);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        // startActivity(new Intent().setClass(ImageGridActivity.this,
        // PicActivity.class));
        finish();
        dataList.clear();
        return super.onKeyDown(keyCode, event);
    }

    @Override
    protected void onRestart() {
        adapter.setTextCallback(new ImageGridAdapter.TextCallback() {
            public void onListen(int count) {
                if (Bimp.drr.size() <= 0) {
                    tips.setText(getString(R.string.complete) + ((count - Bimp.drr.size()) + NetPicNum) + "/" + mMax);
                } else {
                    tips.setText(getString(R.string.complete) + (count) + "/" + (mMax-(Bimp.drr.size() + NetPicNum)));
                }
            }
        });
//        tips.setText("完成" + (Bimp.drr.size() + NetPicNum) + "/" + mMax);

        super.onRestart();
    }

    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 1: // 确定
                if (resultCode == RESULT_OK) {
                    String sdStatus = Environment.getExternalStorageState();
                    if (!sdStatus.equals(Environment.MEDIA_MOUNTED)) {
                        ToastUtil.showInfo(getString(R.string.storage_space_not_use));
                        return;
                    }
                    if ((Bimp.drr.size() + NetPicNum) < mMax && resultCode == -1) {
                        Bimp.drr.add(path);
//                    finish();
                    } else {
                        ToastUtil.showInfo("已有" + mMax + "张图片");
                        finish();
                    }
                    new Thread() {
                        @Override
                        public void run() {
                            ImageUtils.writeToFile(getApplicationContext(), ImageUtils.getSmallBitmap(getApplicationContext(), path), "com.juxian.bosscomments/OutImage", System.currentTimeMillis() + "");
                            runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    setResult(RESULT_OK);
                                    finish();
                                }
                            });
                        }
                    }.start();
                }
                break;
            default:
                break;
        }
    }
}
