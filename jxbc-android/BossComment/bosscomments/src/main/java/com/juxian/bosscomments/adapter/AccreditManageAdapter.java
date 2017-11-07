package com.juxian.bosscomments.adapter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.juxian.bosscomments.AppConfig;
import com.juxian.bosscomments.R;
import com.juxian.bosscomments.common.Global;
import com.juxian.bosscomments.models.MemberEntity;
import com.juxian.bosscomments.ui.AddAccreditPersonActivity;

import net.juxian.appgenome.utils.JsonUtil;

import java.util.List;

/**
 * Created by nene on 2016/10/25.
 *
 * @ProjectName: [LaoBanDianPing]
 * @Package: [com.juxian.bosscomments.adapter]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/25 11:28]
 * @Version: [v1.0]
 */
public class AccreditManageAdapter extends MyBaseAdapter<MemberEntity> implements View.OnClickListener {

    private AccreditOperationListener listener;

    public AccreditManageAdapter(List<MemberEntity> list, Context context, AccreditOperationListener listener) {
        super(list, context);
        this.listener = listener;
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null) {
            viewHolder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_accredit_manage, null);
            viewHolder.person = (TextView) convertView.findViewById(R.id.item_accredit_manager_person);
            viewHolder.role = (TextView) convertView.findViewById(R.id.item_accredit_manager_role);
            viewHolder.change = (TextView) convertView.findViewById(R.id.item_accredit_manager_change);
            viewHolder.delete = (TextView) convertView.findViewById(R.id.item_accredit_manager_delete);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        //这里判断一下身份，做相应的按钮切换隐藏操作。
        MemberEntity entity = list.get(position);
        if (TextUtils.isEmpty(entity.RealName)) {
            viewHolder.person.setText("");
        } else {
            viewHolder.person.setText(entity.RealName);
        }
        MemberEntity currentEntity = JsonUtil.ToEntity(AppConfig.getCurrentUserInformation(), MemberEntity.class);

        if (currentEntity.Role == MemberEntity.CompanyMember_Role_Admin) {
            if (entity.MemberId == currentEntity.MemberId) {
                viewHolder.change.setVisibility(View.VISIBLE);
                viewHolder.delete.setVisibility(View.GONE);
            } else {
                if (entity.Role == MemberEntity.CompanyMember_Role_Admin || entity.Role == MemberEntity.CompanyMember_Role_Boss) {
                    viewHolder.change.setVisibility(View.GONE);
                    viewHolder.delete.setVisibility(View.GONE);
                } else {
                    viewHolder.change.setVisibility(View.VISIBLE);
                    viewHolder.delete.setVisibility(View.VISIBLE);
                }
            }
        } else if (currentEntity.Role == MemberEntity.CompanyMember_Role_Boss) {
            viewHolder.change.setVisibility(View.VISIBLE);
            viewHolder.delete.setVisibility(View.VISIBLE);
        } else if (currentEntity.Role == MemberEntity.CompanyMember_Role_Senior || currentEntity.Role == MemberEntity.CompanyMember_Role_XiaoMi) {
            if (entity.MemberId != currentEntity.MemberId) {
                viewHolder.change.setVisibility(View.GONE);
                viewHolder.delete.setVisibility(View.GONE);
            } else {
                viewHolder.change.setVisibility(View.VISIBLE);
                viewHolder.delete.setVisibility(View.GONE);
            }
        }
        if (entity.Role == MemberEntity.CompanyMember_Role_Admin) {
            viewHolder.role.setText("管理员");
        } else if (entity.Role == MemberEntity.CompanyMember_Role_Boss) {
            viewHolder.role.setText("公司法人");
            viewHolder.change.setVisibility(View.GONE);
            viewHolder.delete.setVisibility(View.GONE);
        } else if (entity.Role == MemberEntity.CompanyMember_Role_Senior) {
            viewHolder.role.setText("高管");
        } else {
            viewHolder.role.setText("建档员");
        }
        viewHolder.change.setTag(position);
        viewHolder.delete.setTag(position);
        viewHolder.change.setOnClickListener(this);
        viewHolder.delete.setOnClickListener(this);
        return convertView;
    }

    @Override
    public void onClick(View view) {
        int position = (int) view.getTag();
        switch (view.getId()) {
            case R.id.item_accredit_manager_delete:
                listener.deleteClick(list.get(position), position);

                break;
            case R.id.item_accredit_manager_change:
                Intent intent = new Intent(context, AddAccreditPersonActivity.class);
                intent.putExtra(Global.LISTVIEW_ITEM_TAG, "change");
                intent.putExtra("MemberEntity", JsonUtil.ToJson(list.get(position)));
                ((Activity) context).startActivity(intent);
                break;
        }
    }

    class ViewHolder {
        TextView person;
        TextView role;
        TextView change;
        TextView delete;
    }

    public interface AccreditOperationListener {
        void deleteClick(MemberEntity entity, int Position);
    }
}
