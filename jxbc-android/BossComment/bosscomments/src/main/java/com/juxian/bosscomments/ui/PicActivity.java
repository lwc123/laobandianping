package com.juxian.bosscomments.ui;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.juxian.bosscomments.adapter.ImageBucketAdapter;
import com.juxian.bosscomments.models.ImageBucket;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.adapter.PicCustomsListAdapter;
import com.juxian.bosscomments.utils.AlbumHelper;

import java.io.Serializable;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

public class PicActivity extends Activity {

    @BindView(R.id.include_head_title_lin)
    LinearLayout back;
    @BindView(R.id.include_head_title_title)
    TextView title;
    public static final String EXTRA_IMAGE_LIST = "imagelist";
    public static Bitmap bimap;
    // private ImageView image_bucket_exit;
    // private XListView pic_customsListView;
    private ListView pic_customsListView;
    List<ImageBucket> dataList;
    ImageBucketAdapter adapter;// 自定义的适配器
    PicCustomsListAdapter picCustomsListAdapter;
    AlbumHelper helper;
    private Context context;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_image_bucket);
        ButterKnife.bind(this);
        context = PicActivity.this;
        title.setText(getString(R.string.photo_album));
        back.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                finish();
            }
        });
        helper = AlbumHelper.getHelper();
        helper.init(getApplicationContext());
        initData();
        initView();
    }

    /**
     * 初始化数据
     */
    private void initData() {
        dataList = helper.getImagesBucketList(false);
        // bimap = BitmapFactory.decodeResource(getResources(),
        // R.drawable.icon_addpic_unfocused);
    }

    /**
     * 初始化view视图
     */
    private void initView() {
        // image_bucket_exit = (ImageView) findViewById(R.id.image_bucket_exit);
        // pic_customsListView = (ListView)
        // findViewById(R.id.pic_customsListView);
        // picCustomsListAdapter = new PicCustomsListAdapter(PicActivity.this,
        // dataList);
        // adapter = new ImageBucketAdapter(PicActivity.this, dataList);
        // 跳转
        Intent intent = new Intent(context, ImageGridActivity.class);
        intent.putExtra(PicActivity.EXTRA_IMAGE_LIST,
                (Serializable) dataList.get(0).imageList);
        context.startActivity(intent);

        // pic_customsListView.setAdapter(picCustomsListAdapter);

        // image_bucket_exit.setOnClickListener(new OnClickListener() {
        // @Override
        // public void onClick(View v) {
        // finish();
        // }
        // });
    }

    @Override
    protected void onStop() {

        super.onStop();
    }

}
