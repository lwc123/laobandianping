package com.juxian.bosscomments.ui;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
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
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.juxian.bosscomments.imageCrop.ui.ImageCropActivity;
import com.juxian.bosscomments.models.ImageBucket;
import com.juxian.bosscomments.utils.Bimp;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.PhotoGridAdapter;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.ImageItem;
import com.juxian.bosscomments.utils.AlbumHelper;
import com.juxian.bosscomments.utils.PermissionUtils;
import com.juxian.bosscomments.utils.SystemBarTintManager;
import com.juxian.bosscomments.utils.checkSelfPermissionUtils;

import net.juxian.appgenome.utils.FileUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

public class EditPhotoGridActivity extends Activity {
    public static final String EXTRA_IMAGE_LIST = "imagelist";
    List<ImageItem> dataList;
    GridView gridView;
    PhotoGridAdapter adapter;
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
    private String tag;
    //
    @BindView(R.id.imagePhoto)
    ImageView takePhoto;
    private String path = "";
    Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case 0:
                    ToastUtil.showInfo(getString(R.string.max_select_one_picture));
                    break;
                default:
                    break;
            }
        }
    };

    @SuppressWarnings("unchecked")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_image_grid);
        ButterKnife.bind(this);
        initView();
        content = new ArrayList<String>();
        title.setText(getString(R.string.photo_album));
        title.setVisibility(View.GONE);
        spinner.setVisibility(View.VISIBLE);
        // 修改头部spinner
        helper = AlbumHelper.getHelper();
        helper.init(getApplicationContext());
        dataList1 = helper.getImagesBucketList(false);
        try {
            tag = getIntent().getStringExtra(Global.LISTVIEW_ITEM_TAG);
        } catch (Exception e) {
            e.printStackTrace();
        }
        //
        for (int i = 0; i < dataList1.size(); i++) {// 顶部spinner数据源
            content.add(dataList1.get(i).bucketName);
        }
        adapter1 = new ArrayAdapter<String>(EditPhotoGridActivity.this,
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
        image_grid_exit = (ImageView) findViewById(R.id.image_grid_exit);
        image_grid_exit.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent().setClass(EditPhotoGridActivity.this,
                        PicActivity.class));
                finish();
            }
        });
        // tips.setText("完成" + "(" + Bimp.drr.size() + "/9" + ")");

        tips_re.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                if (Bimp.drr.size() == 0 && adapter.map.size() == 0) {
                    ToastUtil.showInfo(getString(R.string.please_select_picture));
                    return;
                }
                onSelectedCompleted();

            }
        });
        if (dataList1 != null && dataList1.size() > 0) {
            dataList = dataList1.get(0).imageList;
            // dataList = (List<ImageItem>) getIntent().getSerializableExtra(
            // EXTRA_IMAGE_LIST);
            Collections.reverse(dataList);
            tips.setText(getString(R.string.complete));
            takePhoto.setVisibility(View.GONE);
        } else {
            gridView.setVisibility(View.GONE);
            spinner.setVisibility(View.GONE);
            tips.setText("");
            tips.setOnClickListener(null);
            tips_re.setOnClickListener(null);
            takePhoto.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (ContextCompat.checkSelfPermission(EditPhotoGridActivity.this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
                        checkSelfPermissionUtils.checkPermission(EditPhotoGridActivity.this, Manifest.permission.CAMERA);
                    } else {
                        if (Build.VERSION.SDK_INT < 23) {
                            try {
                                Camera c = null;
                                c = Camera.open();
                            } catch (Exception e){

                            } finally {
                                if (ContextCompat.checkSelfPermission(EditPhotoGridActivity.this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
                                    checkSelfPermissionUtils.checkPermission(EditPhotoGridActivity.this, Manifest.permission.CAMERA);
                                }
                            }
                            if (ContextCompat.checkSelfPermission(EditPhotoGridActivity.this, Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED) {
                                photo();
                            }
                        } else {
                            if (ContextCompat.checkSelfPermission(EditPhotoGridActivity.this, Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED) {
                                PermissionUtils.requestPermission(EditPhotoGridActivity.this, PermissionUtils.CODE_CAMERA, mPermissionGrant);
                            }
                        }
                    }
                }
            });
        }

//        setSystemBarTintManager(this,R.color.new_register_main_color);

        SystemBarTintManager tintManager = new SystemBarTintManager(this);
        tintManager.setStatusBarTintEnabled(true);
        tintManager.setStatusBarTintResource(R.color.main_color);
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
            if (Bimp.drr.size() < 1) {
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
        Global.single = adapter.singleData;
        Intent mIntent = new Intent(getBaseContext(), ImageCropActivity.class);
        mIntent.putExtra(Global.LISTVIEW_ITEM_TAG, tag);
        mIntent.putExtra("path", Bimp.drr.get(0));
        startActivityForResult(mIntent, 520);
        //	Intent mIntent = new Intent(getBaseContext(), CropImageUI.class);
//		mIntent.putExtra("tag", tag);
//		mIntent.putExtra("path", Bimp.drr.get(0));
//		startActivityForResult(mIntent, 520);
    }

    private void initView() {
        gridView = (GridView) findViewById(R.id.gridview);
        gridView.setSelector(new ColorDrawable(Color.TRANSPARENT));
        adapter = new PhotoGridAdapter(EditPhotoGridActivity.this, dataList,
                mHandler);
        gridView.setAdapter(adapter);
        // adapter.setTextCallback(new TextCallback() {
        // public void onListen(int count) {
        // if (Bimp.drr.size() <= 0) {
        // tips.setText("完成");
        // } else {
        // tips.setText("完成");
        // }
        // }
        // });
        gridView.setOnItemClickListener(new OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view,
                                    int position, long id) {
                if (position >= 1) {
                    adapter.notifyDataSetChanged();
                } else {
                    if (ContextCompat.checkSelfPermission(EditPhotoGridActivity.this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
                        checkSelfPermissionUtils.checkPermission(EditPhotoGridActivity.this, Manifest.permission.CAMERA);
                    } else {
                        photo();
                    }
                }
            }
        });
    }

    /**
     * 选择拍照按钮
     */
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
        if (dataList != null && dataList.size() > 0) {
            dataList.clear();
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    protected void onRestart() {

        tips.setText(getString(R.string.complete));

        super.onRestart();
    }

    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 1: // 确定
                String sdStatus = Environment.getExternalStorageState();
                if (!sdStatus.equals(Environment.MEDIA_MOUNTED)) {
                    ToastUtil.showInfo(getString(R.string.storage_space_not_use));
                    return;
                }
                if (Bimp.drr.size() < 1 && resultCode == -1) {
                    Bimp.drr.add(path);
                    Intent mIntent = new Intent(getBaseContext(), ImageCropActivity.class);
                    mIntent.putExtra(Global.LISTVIEW_ITEM_TAG, tag);
                    mIntent.putExtra("path", Bimp.drr.get(0));
                    startActivityForResult(mIntent, 520);
                    // finish();
                }
                break;
            case 520:
                if (resultCode == RESULT_OK) {
                    Intent intent = getIntent();
                    intent.putExtra("path", data.getStringExtra("path"));
                    setResult(RESULT_OK, intent);
                    finish();
                }

                break;
            default:
                break;
        }
    }
}
