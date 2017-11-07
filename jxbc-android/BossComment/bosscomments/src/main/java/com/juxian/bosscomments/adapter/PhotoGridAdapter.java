package com.juxian.bosscomments.adapter;

import android.app.Activity;
import android.graphics.Bitmap;
import android.os.Handler;
import android.os.Message;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;


import com.juxian.bosscomments.utils.Bimp;
import com.juxian.bosscomments.utils.BitmapCache;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.ImageItem;
import com.juxian.bosscomments.utils.Dp2pxUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PhotoGridAdapter extends BaseAdapter {

    private TextCallback textcallback = null;
    final String TAG = getClass().getSimpleName();
    Activity act;
    List<ImageItem> dataList;
    public Map<String, String> map = new HashMap<String, String>();
    public ImageItem singleData;
    BitmapCache cache;
    private Handler mHandler;
    private int selectTotal = 0;
    private boolean showCamera = true;
    private static final int TYPE_CAMERA = 0;
    private static final int TYPE_NORMAL = 1;

    BitmapCache.ImageCallback callback = new BitmapCache.ImageCallback() {
        @Override
        public void imageLoad(ImageView imageView, Bitmap bitmap,
                              Object... params) {
            if (imageView != null && bitmap != null) {
                String url = (String) params[0];
                if (url != null && url.equals((String) imageView.getTag())) {
                    ((ImageView) imageView).setImageBitmap(bitmap);
                } else {
                }
            } else {
            }
        }
    };

    public static interface TextCallback {
        public void onListen(int count);
    }

    public void setTextCallback(TextCallback listener) {
        textcallback = listener;
    }

    public PhotoGridAdapter() {
        super();
    }

    public PhotoGridAdapter(Activity act, List<ImageItem> list, Handler mHandler) {
        this.act = act;
        dataList = list;
        cache = new BitmapCache();
        this.mHandler = mHandler;
    }

    @Override
    public int getCount() {
        int count = 0;
        if (dataList != null) {
            count = dataList.size() + 1;
        }
        return count;
    }

    @Override
    public Object getItem(int position) {
        if (dataList == null || dataList.size() == 0) {
            return null;
        }
        return dataList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    class Holder {
        private ImageView iv;
        private ImageView selected;
        private TextView text;
    }

    public DisplayMetrics getMetrics() {
        WindowManager manager = act.getWindowManager();
        DisplayMetrics outMetrics = new DisplayMetrics();
        manager.getDefaultDisplay().getMetrics(outMetrics);
        return outMetrics;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        int type = getItemViewType(position);
        if (type == TYPE_CAMERA) {
            convertView = View.inflate(act, R.layout.item_image_grid, null);
            convertView.setTag(null);
            int width = (getMetrics().widthPixels - Dp2pxUtil.dp2px(36, act)) / 3;
            GridView.LayoutParams lp = new GridView.LayoutParams(width, Dp2pxUtil.dp2px(115, act));
            convertView.setLayoutParams(lp);
        } else if (type == TYPE_NORMAL) {
            final Holder holder;
            if (convertView == null) {
                holder = new Holder();
                convertView = View.inflate(act, R.layout.item_image_grid, null);
                holder.iv = (ImageView) convertView.findViewById(R.id.image);
                holder.selected = (ImageView) convertView.findViewById(R.id.isselected);
                holder.text = (TextView) convertView.findViewById(R.id.item_image_grid_text);
                convertView.setTag(holder);
            } else {
                holder = (Holder) convertView.getTag();
            }
            // -------------------------
//            if ((position) == 0) {
//                holder.iv.setVisibility(View.VISIBLE);
            // holder.image.setImageBitmap(BitmapFactory.decodeResource(
            // getResources(), R.drawable.icon_addpic_unfocused));
            // if (position == 9) {
            // holder.image.setVisibility(View.GONE);
            // }
//            } else if (position >= 0) {
            final ImageItem item = dataList.get(position - 1);
            holder.iv.setTag(item.imagePath);
            cache.displayBmp(holder.iv, item.thumbnailPath, item.imagePath,
                    callback);
            if (item.isSelected) {
                holder.selected.setImageResource(R.drawable.icon_data_select);
                // holder.text.setBackgroundResource(R.drawable.bgd_relatly_line);
            } else {
                // holder.selected.setImageResource(-1);
                holder.selected
                        .setImageResource(R.drawable.icon_data_unselected);
                holder.text.setBackgroundColor(0x00000000);
            }
            holder.iv.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {

                    String path = dataList.get(position - 1).imagePath;

                    if ((Bimp.drr.size() + selectTotal) < 1) {
                        item.isSelected = !item.isSelected;
                        if (item.isSelected) {
                            holder.selected
                                    .setImageResource(R.drawable.icon_data_select);
                            // holder.text
                            // .setBackgroundResource(R.drawable.bgd_relatly_line);
                            selectTotal++;
                            if (textcallback != null)
                                textcallback.onListen(selectTotal);
                            map.put(path, path);
                            singleData = item;
                        } else if (!item.isSelected) {
                            holder.selected
                                    .setImageResource(R.drawable.icon_data_unselected);
                            // holder.selected.setImageResource(-1);
                            holder.text.setBackgroundColor(0x00000000);
                            selectTotal--;
                            if (textcallback != null)
                                textcallback.onListen(selectTotal);
                            map.remove(path);
                            singleData = null;
                        }
                    } else if ((Bimp.drr.size() + selectTotal) >= 1) {
                        if (item.isSelected == true) {
                            item.isSelected = !item.isSelected;
                            holder.selected.setImageResource(-1);
                            selectTotal--;
                            if (textcallback != null)
                                textcallback.onListen(selectTotal);
                            map.remove(path);
                            singleData = null;
                        } else {
                            Message message = Message.obtain(mHandler, 0);
                            message.sendToTarget();
                        }
                    }
                }

            });
//            }
        }

        // -------------------------

        return convertView;
    }

    @Override
    public int getItemViewType(int position) {
        if (showCamera && position == 0) {
            return TYPE_CAMERA;
        }
        return TYPE_NORMAL;
    }

    @Override
    public int getViewTypeCount() {
        return 2;
    }
}
