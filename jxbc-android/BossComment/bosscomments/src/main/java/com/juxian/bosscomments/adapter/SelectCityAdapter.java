package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.juxian.bosscomments.R;

import java.util.List;

/**
 * Created by nene on 2017/2/10.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/2/10 17:23]
 * @Version: [v1.0]
 */
public class SelectCityAdapter extends MyBaseAdapter<String> {

    public SelectCityAdapter(List<String> list, Context context) {
        super(list, context);
    }

    @Override
    public View createView(final int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null){
            viewHolder = new ViewHolder();

            convertView = inflater.inflate(R.layout.flow_city_tv,null);
            viewHolder.tv = (TextView) convertView.findViewById(R.id.tv);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        String string = list.get(position);
        viewHolder.tv.setText(string);
        return convertView;
    }

    class ViewHolder {
        TextView tv;
    }
}