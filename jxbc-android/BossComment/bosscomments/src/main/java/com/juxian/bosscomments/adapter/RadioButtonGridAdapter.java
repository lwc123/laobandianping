package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.text.Html;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.RadioButton;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.DepartureTagEntity;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import java.util.HashMap;
import java.util.List;

/**
 * Created by nene on 2016/10/31.
 *
 * @ProjectName: [BossComment]
 * @Package: [com.juxian.bosscomments.adapter]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/31 17:49]
 * @Version: [v1.0]
 */
public class RadioButtonGridAdapter extends MyBaseAdapter<DepartureTagEntity> {

    private HashMap<Integer,RadioButton> radioButtonMap = new HashMap<>();
    private DepartureTagEntity mCurrentSelect;

    public RadioButtonGridAdapter(List<DepartureTagEntity> list, Context context) {
        super(list, context);
    }

    public void setDatas(List<DepartureTagEntity> list){
        this.list = list;
        radioButtonMap.clear();
        notifyDataSetChanged();
    }

    @Override
    public View createView(final int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null){
            viewHolder = new ViewHolder();

            convertView = inflater.inflate(R.layout.item_gridview_radiobutton,null);

            viewHolder.radioButton = (RadioButton) convertView.findViewById(R.id.rb_tab);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        DepartureTagEntity entity = list.get(position);
        viewHolder.radioButton.setText(entity.TagName);

        viewHolder.radioButton.setChecked(entity.isChecked);
        viewHolder.radioButton.setTag(position);
        if (position == (int) viewHolder.radioButton.getTag()) {
            if (radioButtonMap.get(position)==null) {
                radioButtonMap.put(position, viewHolder.radioButton);
            }
        }
        if (entity.isChecked){
            mCurrentSelect = entity;
        }
        viewHolder.radioButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                int tag = (int) view.getTag();
                if (tag == position) {
                    for (int i = 0; i < list.size(); i++) {
                        if (i!=tag)
                            radioButtonMap.get(i).setChecked(false);
                    }
                    radioButtonMap.get(tag).setChecked(true);
                    mCurrentSelect = list.get(tag);
                }
            }
        });
        return convertView;
    }

    public DepartureTagEntity getCurrentSelect(){
        return mCurrentSelect;
    }

    class ViewHolder{
        RadioButton radioButton;
    }
}
