package com.juxian.bosscomments.ui;

import android.Manifest;
import android.app.Dialog;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.BossCircleAddPhotoGridAdapter;
import com.juxian.bosscomments.models.BossDynamicEntity;
import com.juxian.bosscomments.models.ImageBucket;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.repositories.BossCircleRepository;
import com.juxian.bosscomments.utils.AlbumHelper;
import com.juxian.bosscomments.utils.Bimp;
import com.juxian.bosscomments.utils.PermissionUtils;
import com.juxian.bosscomments.utils.checkSelfPermissionUtils;
import com.juxian.bosscomments.widget.EditText;
import com.juxian.bosscomments.widget.NoScrollGridView;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.utils.ImageUtil;
import net.juxian.appgenome.utils.ImageUtils;
import net.juxian.appgenome.utils.JsonUtil;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import me.nereo.multi_image_selector.MultiImageSelector;

/**
 * Created by Tam on 2016/12/24.
 */
public class BossCirclePostMsgActivity extends BaseActivity implements BossCircleAddPhotoGridAdapter.ImageDeleteListener {
    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    @BindView(R.id.include_head_title_tab2)
    TextView include_head_title_tab2;
    @BindView(R.id.boss_circle_post_msg_addImg)
    ImageView mAddImage;
    @BindView(R.id.img_gridview)
    NoScrollGridView mImageViewsGridView;
    @BindView(R.id.include_button_button)
    com.juxian.bosscomments.widget.Button mBt;
    @BindView(R.id.feedback_content)
    EditText mContent;
    private List<String> imgs;
    private BossCircleAddPhotoGridAdapter mAdapter;
    private ArrayList<String> mSelectPath;

    @Override
    public int getContentViewId() {
        return R.layout.activity_boss_circle_post_msg;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void initPage() {
        super.initPage();
        ButterKnife.bind(this);
        setSystemBarTintManager(this);
        initViewsData();
        initListener();
    }

    @Override
    public void initViewsData() {
        super.initViewsData();
        title.setText("老板圈");
        mBt.setText("发布");
        include_head_title_tab2.setVisibility(View.VISIBLE);
        include_head_title_tab2.setText("发布");
        imgs = new ArrayList<>();
        if (Bimp.drr.size() != 0) {
            Bimp.drr.clear();
        }
        if (ImageUtils.saveFilePaths.size() != 0) {
            ImageUtils.saveFilePaths.clear();
        }
        mAdapter = new BossCircleAddPhotoGridAdapter(imgs, this, this);
        mImageViewsGridView.setAdapter(mAdapter);
    }

    @Override
    public void initListener() {
        super.initListener();
        back.setOnClickListener(this);
        mAddImage.setOnClickListener(this);
        mBt.setOnClickListener(this);
        include_head_title_tab2.setOnClickListener(this);

    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        switch (v.getId()) {
            case R.id.include_head_title_lin:
                for (int i = 0; i < ImageUtils.saveFilePaths.size(); i++) {
                    File imageFile = new File(ImageUtils.saveFilePaths.get(i));
                    if (imageFile.exists()) {
                        imageFile.delete();
                    }
                }
                imgs.clear();
                ImageUtils.saveFilePaths.clear();
                finish();
                break;
            case R.id.boss_circle_post_msg_addImg:
                if (Build.VERSION.SDK_INT < 23) {
                    try {
                        AlbumHelper helper = AlbumHelper.getHelper();
                        helper.init(getApplicationContext());
                        List<ImageBucket> dataList1 = helper.getImagesBucketList(false);
                    } catch (Exception e) {

                    } finally {
                        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                            checkSelfPermissionUtils.checkPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE);
                        }
                    }
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
                        if (imgs.size() >= 9) {
                            ToastUtil.showInfo(getString(R.string.max_select_nine_picture));
                            return;
                        }
                        // 修改时，还得传入当前内容所拥有的图片数量
//                        Intent ChangeAvatar1 = new Intent(getApplicationContext(), ImageGridActivity.class);
//                        ChangeAvatar1.putExtra("Tag", "nine");
//                        startActivityForResult(ChangeAvatar1, 520);
                        MultiImageSelector selector = MultiImageSelector.create(BossCirclePostMsgActivity.this);
                        selector.showCamera(true);
                        selector.count(9);
                        selector.multi();
                        selector.origin(mSelectPath);
                        selector.start(BossCirclePostMsgActivity.this, 520);
                    }
                } else {
                    if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                        PermissionUtils.requestPermission(this, PermissionUtils.CODE_READ_EXTERNAL_STORAGE, mPermissionGrant);
                    } else {
                        if (imgs.size() >= 9) {
                            ToastUtil.showInfo(getString(R.string.max_select_nine_picture));
                            return;
                        }
                        // 修改时，还得传入当前内容所拥有的图片数量
//                        Intent ChangeAvatar1 = new Intent(getApplicationContext(), ImageGridActivity.class);
//                        ChangeAvatar1.putExtra("Tag", "nine");
//                        startActivityForResult(ChangeAvatar1, 520);
                        MultiImageSelector selector = MultiImageSelector.create(BossCirclePostMsgActivity.this);
                        selector.showCamera(true);
                        selector.count(9);
                        selector.multi();
                        selector.origin(mSelectPath);
                        selector.start(BossCirclePostMsgActivity.this, 520);
                    }
                }

                break;
            case R.id.include_button_button:
                postMessage();
                break;
            case R.id.include_head_title_tab2:
                postMessage();
                break;
            default:
                break;
        }
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
                    break;
                case PermissionUtils.CODE_ACCESS_FINE_LOCATION:
                    break;
                case PermissionUtils.CODE_ACCESS_COARSE_LOCATION:
                    break;
                case PermissionUtils.CODE_READ_EXTERNAL_STORAGE:
                    if (imgs.size() >= 9) {
                        ToastUtil.showInfo(getString(R.string.max_select_nine_picture));
                        return;
                    }
                    // 修改时，还得传入当前内容所拥有的图片数量
//                    Intent ChangeAvatar1 = new Intent(getApplicationContext(), ImageGridActivity.class);
//                    ChangeAvatar1.putExtra("Tag", "nine");
//                    startActivityForResult(ChangeAvatar1, 520);
                    MultiImageSelector selector = MultiImageSelector.create(BossCirclePostMsgActivity.this);
                    selector.showCamera(true);
                    selector.count(9);
                    selector.multi();
                    selector.origin(mSelectPath);
                    selector.start(BossCirclePostMsgActivity.this, 520);
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

    private void postMessage() {
        if (TextUtils.isEmpty(mContent.getText().toString().trim())) {
            ToastUtil.showInfo("您还没有写内容");
            return;
        }

        BossDynamicEntity entity = new BossDynamicEntity();
        entity.CompanyId = AppConfig.getCurrentUseCompany();
        MemberEntity memberEntity = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);
        entity.PassportId = memberEntity.PassportId;
//        if (imgs.size() > 0) {
//            entity.Img = new String[imgs.size()];
//            for (int i = 0; i < imgs.size(); i++) {
//                entity.Img[i] = ImageUtil.toUploadBase64(imgs.get(i));
//            }
//        }
        entity.Content = mContent.getText().toString().trim();
        PostAddCircleDynamic(entity, imgs);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case 520:
                if (resultCode == RESULT_OK) {
                    mSelectPath = data.getStringArrayListExtra(MultiImageSelector.EXTRA_RESULT);
                    imgs.clear();
                    imgs.addAll(mSelectPath);
                    if (imgs.size() > 0) {
                        mImageViewsGridView.setVisibility(View.VISIBLE);
                    }
                    mAdapter.notifyDataSetChanged();
                }
                break;
        }
    }

    @Override
    public void onDeleteImage(int position) {
        imgs.remove(position);
//        Bimp.drr.remove(position);
        mSelectPath.remove(position);
        if (imgs.size() == 0) {
            mImageViewsGridView.setVisibility(View.GONE);
        }
        mAdapter.notifyDataSetChanged();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (Bimp.drr.size() != 0) {
            Bimp.drr.clear();
        }
    }

    @Override
    public void onBackPressed() {
        for (int i = 0; i < imgs.size(); i++) {
            File imageFile = new File(imgs.get(i));
            if (imageFile.exists()) {
                imageFile.delete();
            }
        }
        imgs.clear();
        ImageUtils.saveFilePaths.clear();
        super.onBackPressed();
    }

    private void PostAddCircleDynamic(final BossDynamicEntity entity, final List<String> imgs) {
        final Dialog dialog = DialogUtil.showLoadingDialog();
        new AsyncRunnable<Long>() {
            @Override
            protected Long doInBackground(Void... params) {
                for (int i = 0; i < imgs.size(); i++) {
                    ImageUtils.writeToFile(BossCirclePostMsgActivity.this, ImageUtils.getSmallBitmap(BossCirclePostMsgActivity.this, imgs.get(i)), "com.juxian.bosscomments/OutImage", System.currentTimeMillis() + "");
                }
                if (ImageUtils.saveFilePaths.size() > 0) {
                    entity.Img = new String[ImageUtils.saveFilePaths.size()];
                    for (int i = 0; i < ImageUtils.saveFilePaths.size(); i++) {
                        entity.Img[i] = ImageUtil.toUploadBase64(ImageUtils.saveFilePaths.get(i));
                    }
                }
//                if (imgs.size() > 0) {
//                    entity.Img = new String[imgs.size()];
//                    for (int i = 0; i < imgs.size(); i++) {
//                        entity.Img[i] = ImageUtil.toUploadBase64(imgs.get(i));
//                    }
//                }
                long id = BossCircleRepository.postBossCircleAddDynamic(entity);
                return id;
            }

            @Override
            protected void onPostExecute(Long id) {
                if (dialog != null)
                    dialog.dismiss();
                if (id > 0) {
                    setResult(10086);
                    ToastUtil.showInfo("发布成功");
                    finish();
                } else {
                    ToastUtil.showInfo("发布失败");
                }
            }

            protected void onPostError(Exception ex) {
                if (dialog != null)
                    dialog.dismiss();
                ToastUtil.showError(getString(R.string.net_false_hint));
            }
        }.execute();
    }
}
