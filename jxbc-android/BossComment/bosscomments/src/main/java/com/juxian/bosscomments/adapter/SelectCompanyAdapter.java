package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.utils.TimeUtil;

import net.juxian.appgenome.widget.ToastUtil;

import java.util.Date;
import java.util.List;

/**
 * Created by nene on 2016/10/25.
 *
 * @Description: 选择公司adapter
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/25 11:28]
 * @Version: [v1.0]
 */
public class SelectCompanyAdapter extends MyBaseAdapter<MemberEntity> {

    private String mTag;

    public SelectCompanyAdapter(List<MemberEntity> list, Context context, String mTag) {
        super(list, context);
        this.mTag = mTag;
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null) {
            viewHolder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_select_company, null);
            viewHolder.company_name = (TextView) convertView.findViewById(R.id.company_name);
            viewHolder.number = (TextView) convertView.findViewById(R.id.number);
            viewHolder.login_status = (TextView) convertView.findViewById(R.id.login_status);
            viewHolder.jiantou = (ImageView) convertView.findViewById(R.id.jiantou);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        MemberEntity entity = list.get(position);
        if (!TextUtils.isEmpty(entity.myCompany.CompanyName)) {
            viewHolder.company_name.setText(entity.myCompany.CompanyName);
        } else {
            viewHolder.company_name.setText("");
        }

        if (entity.myCompany.AuditStatus == CompanyEntity.AttestationStatus_Passed) {
            viewHolder.number.setVisibility(View.VISIBLE);
            viewHolder.login_status.setVisibility(View.GONE);
            if (entity.UnreadMessageNum > 0) {
                viewHolder.number.setText(entity.UnreadMessageNum + "条待审核评价");
            } else {
                viewHolder.number.setText("");
            }
            if (entity.myCompany.ServiceEndTime != null) {
                int TimeDifferenceValue = TimeUtil.getGapCount(new Date(), entity.myCompany.ServiceEndTime);
                if (TimeDifferenceValue < 0) {
                    viewHolder.number.setVisibility(View.VISIBLE);
                    viewHolder.number.setText("服务到期");
                    viewHolder.number.setTextColor(context.getResources().getColor(R.color.juxian_red));
                } else if (TimeDifferenceValue > 0 && TimeDifferenceValue <= 30) {
                    viewHolder.number.setVisibility(View.VISIBLE);
                    viewHolder.number.setTextColor(context.getResources().getColor(R.color.menu_color));
                    viewHolder.number.setText("剩余" + TimeDifferenceValue + "天");
                }
            }
        } else {
            viewHolder.number.setVisibility(View.VISIBLE);
            viewHolder.login_status.setVisibility(View.GONE);
            viewHolder.number.setTextColor(context.getResources().getColor(R.color.menu_color));
            if (entity.myCompany.AuditStatus == CompanyEntity.AttestationStatus_Submited) {
                viewHolder.number.setText("审核中");
            } else if (entity.myCompany.AuditStatus == CompanyEntity.AttestationStatus_Rejected) {
                viewHolder.number.setText("审核不通过");
            } else {
                viewHolder.number.setText("未提交认证");
            }
        }
        if ("login".equals(mTag)) {
            viewHolder.number.setVisibility(View.VISIBLE);
            viewHolder.login_status.setVisibility(View.GONE);
            viewHolder.jiantou.setVisibility(View.VISIBLE);
        } else {
            if (AppConfig.getCurrentUseCompany() == entity.CompanyId) {
                viewHolder.login_status.setVisibility(View.VISIBLE);
                viewHolder.login_status.setText("登录中");
                viewHolder.number.setVisibility(View.GONE);
                viewHolder.jiantou.setVisibility(View.INVISIBLE);
            } else {
                viewHolder.number.setVisibility(View.VISIBLE);
                viewHolder.login_status.setVisibility(View.GONE);
                viewHolder.jiantou.setVisibility(View.VISIBLE);
            }
        }

        return convertView;
    }

    class ViewHolder {
        TextView company_name;
        TextView number;
        TextView login_status;
        ImageView jiantou;
    }
}
