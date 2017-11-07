package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.juxian.bosscomments.R;

import java.util.List;

/**
 * Created by nene on 2016/10/25.
 *
 * @ProjectName: [LaoBanDianPing]
 * @Package: [com.juxian.bosscomments.adapter]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/25 14:14]
 * @Version: [v1.0]
 */
public class MySearchRecordAdapter extends MyBaseAdapter<String> {

    public MySearchRecordAdapter(List<String> list, Context context) {
        super(list, context);
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null){
            viewHolder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_my_search_record,null);

            viewHolder.SearchTime = (TextView) convertView.findViewById(R.id.search_time);
            viewHolder.Name = (TextView) convertView.findViewById(R.id.name);
            viewHolder.IdentityNumber = (TextView) convertView.findViewById(R.id.identity_number);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        String str = list.get(position);
        viewHolder.Name.setText(str);
        return convertView;
    }

    class ViewHolder{
        TextView SearchTime;
        TextView Name;
        TextView IdentityNumber;
    }
}
