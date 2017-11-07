package com.juxian.bosscomments.models;

public class PaymentResult extends BaseEntity {
	public String TradeCode;
	public String TargetBizTradeCode;
	public boolean Success;
	public String PayWay;
	public String PaidDetail;
	public String ErrorCode;
	public String ErrorMessage;
	public String SignedParams;
}
