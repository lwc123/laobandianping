package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.CCompanyEntity;

import java.util.List;

/**
 * Created by nene on 2017/4/21.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/21 11:43]
 * @Version: [v1.0]
 */
public class SearchCompanyAdapter extends MyBaseAdapter<CCompanyEntity> {

    public SearchCompanyAdapter(List<CCompanyEntity> list, Context context) {
        super(list, context);
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null){
            viewHolder = new ViewHolder();

            convertView = inflater.inflate(R.layout.item_change_list,null);

            viewHolder.mChangeItemText = (TextView) convertView.findViewById(R.id.item_change_text);
            viewHolder.mJianTou = (ImageView) convertView.findViewById(R.id.jiantou);
            viewHolder.view = convertView.findViewById(R.id.view);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        CCompanyEntity entity = list.get(position);
        viewHolder.mChangeItemText.setText(entity.CompanyName);
        viewHolder.view.setVisibility(View.GONE);
        viewHolder.mJianTou.setVisibility(View.GONE);
        return convertView;
    }

    class ViewHolder{
        TextView mChangeItemText;
        ImageView mJianTou;
        View view;
    }
}
