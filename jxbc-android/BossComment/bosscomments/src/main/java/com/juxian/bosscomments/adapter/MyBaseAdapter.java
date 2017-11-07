package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import java.util.List;

/**
 * @param <T>
 * @author 付晓龙
 * @ClassName: MyBaseAdapter
 * @说明:
 * @date 2015-7-21 下午4:58:19
 */

public abstract class MyBaseAdapter<T> extends BaseAdapter {
    public List<T> list;
    public Context context;
    public String tag;
    public LayoutInflater inflater;

    public MyBaseAdapter(List<T> list, Context context) {
        // TODO Auto-generated constructor stub
        super();
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);
    }

    public MyBaseAdapter(List<T> list, Context context, String tag) {
        // TODO Auto-generated constructor stub
        super();
        this.list = list;
        this.context = context;
        this.tag = tag;
//		inflater = LayoutInflater.from(context);
    }

    @Override
    public int getCount() {
        // TODO Auto-generated method stub
        return list != null && !list.isEmpty() ? list.size() : 0;
    }

    @Override
    public Object getItem(int position) {
        // TODO Auto-generated method stub
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        // TODO Auto-generated method stub
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        // TODO Auto-generated method stub
        return createView(position, convertView, parent);
    }

    public abstract View createView(int position, View convertView,
                                    ViewGroup parent);

    public void setList(List<T> list){
        this.list = list;
        notifyDataSetChanged();
    }
}
