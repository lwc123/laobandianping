package com.juxian.bosscomments.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.PaymentEntity;
import com.juxian.bosscomments.models.TradeJournalEntity;
import com.juxian.bosscomments.modules.PaymentEngine;
import com.juxian.bosscomments.utils.TimeUtil;

import java.util.List;

/**
 * Created by nene on 2016/10/25.
 *
 * @ProjectName: [LaoBanDianPing]
 * @Package: [com.juxian.bosscomments.adapter]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/10/25 10:17]
 * @Version: [v1.0]
 */
public class RechargeRecordAdapter extends MyBaseAdapter<TradeJournalEntity> {

    private String mTag;

    public RechargeRecordAdapter(List<TradeJournalEntity> list, Context context, String tag) {
        super(list, context);
        mTag = tag;
    }

    @Override
    public View createView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;
        if (convertView == null){
            viewHolder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_recharge_record,null);

            viewHolder.TradeType = (TextView) convertView.findViewById(R.id.trade_type);
            viewHolder.RechargeTime = (TextView) convertView.findViewById(R.id.recharge_time);
            viewHolder.RechargeMoney = (TextView) convertView.findViewById(R.id.recharge_money);
            viewHolder.PayWay = (TextView) convertView.findViewById(R.id.pay_way);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        TradeJournalEntity entity = list.get(position);
        viewHolder.TradeType.setText(entity.CommoditySubject);
        viewHolder.RechargeTime.setText(TimeUtil.parserTime4(entity.ModifiedTime.getTime()+""));
        if (entity.TradeMode == PaymentEngine.TradeMode_Payoff){
            // 收益
            if ("Personal".equals(mTag)){
                viewHolder.RechargeMoney.setText(entity.TotalFee+"元");
            } else {
                viewHolder.RechargeMoney.setText(entity.TotalFee+"金币");
            }
            viewHolder.PayWay.setText(entity.CommoditySummary);
        } else if (entity.TradeMode == PaymentEngine.TradeMode_Payout){
            // 支出
            if ("Personal".equals(mTag)){
                viewHolder.RechargeMoney.setText(entity.TotalFee+"元");
            } else {
                viewHolder.RechargeMoney.setText(entity.TotalFee+"金币");
            }
            if (PaymentEngine.PayWays_Wallet.equals(entity.PayWay))
                viewHolder.PayWay.setText("企业金库支付");
            else if (PaymentEngine.PayWays_Alipay.equals(entity.PayWay))
                viewHolder.PayWay.setText("支付宝支付");
            else if (PaymentEngine.PayWays_AppleIAP.equals(entity.PayWay))
                viewHolder.PayWay.setText("App内购");
            else
                viewHolder.PayWay.setText("微信支付");
        } else {

        }

        return convertView;
    }

    class ViewHolder{
        TextView TradeType;
        TextView RechargeTime;
        TextView RechargeMoney;
        TextView PayWay;
    }
}
