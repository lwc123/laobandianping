package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.BizDictEntity;
import com.juxian.bosscomments.widget.RoundImageView;

import java.util.List;

/**
 * Created by nene on 2016/11/28.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/28 14:34]
 * @Version: [v1.0]
 */
public class SearchCityAdapter extends MyBaseAdapter<BizDictEntity> {

    public SearchCityAdapter(List<BizDictEntity> list, Context context) {
        super(list, context);
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {

        ViewHolder viewHolder = null;
        if (convertView == null){
            viewHolder = new ViewHolder();

            convertView = inflater.inflate(R.layout.item_city,null);
            viewHolder.city = (TextView) convertView.findViewById(R.id.city);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        BizDictEntity city = list.get(position);
        viewHolder.city.setText(city.Name);
        return convertView;
    }

    class ViewHolder{
        TextView city;
    }
}
