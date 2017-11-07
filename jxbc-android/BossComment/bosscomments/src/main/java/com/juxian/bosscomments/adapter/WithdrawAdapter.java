package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.CompanyBankCardEntity;

import java.util.List;

/**
 * Created by Tam on 2016/12/16.
 */
public class WithdrawAdapter extends MyBaseAdapter<CompanyBankCardEntity> implements View.OnClickListener {
    public int posSelected;

    public WithdrawAdapter(List<CompanyBankCardEntity> list, Context context) {
        super(list, context);
    }

    @Override
    public View createView(final int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null) {
            viewHolder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_public_bank_info, null);
            viewHolder.companyName = (TextView) convertView.findViewById(R.id.public_bank_info_company_name);
            viewHolder.bankCount = (TextView) convertView.findViewById(R.id.public_bank_info_bank_count);
            viewHolder.bankName = (TextView) convertView.findViewById(R.id.public_bank_info_bank_name);
            viewHolder.mRadioButton = (CheckBox) convertView.findViewById(R.id.isselected);
            convertView.setTag(viewHolder);

        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        viewHolder.companyName.setText(list.get(position).CompanyName);
        viewHolder.bankCount.setText(list.get(position).BankCard);
        viewHolder.bankName.setText(list.get(position).BankName);

        viewHolder.mRadioButton.setChecked(list.get(position).isChecked);

        viewHolder.mRadioButton.setChecked(list.get(position).isChecked ? true : false);
        viewHolder.mRadioButton.setTag(position);
        viewHolder.mRadioButton.setOnClickListener(this);
        return convertView;
    }

    public int getSelectedItem() {
        return posSelected;
    }

    @Override
    public void onClick(View view) {
        posSelected = (int) view.getTag();
        //重置
        for (int i = 0; i < list.size(); i++) {
            if (list.get(i).isChecked) {
                list.get(i).isChecked = false;
            }
            if (posSelected == i) {
                list.get(i).isChecked = true;
            } else {
                list.get(i).isChecked = false;
            }
        }
        notifyDataSetChanged();
    }

    public class ViewHolder {
        TextView companyName;
        TextView bankCount;
        TextView bankName;
        CheckBox mRadioButton;
    }
}
