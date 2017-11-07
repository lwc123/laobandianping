package com.juxian.bosscomments.models;

public class PaymentEntity extends BaseEntity  {
	public String TradeCode;
	public long OwnerId;
	public int TradeType;
	public long BuyerId;// 买家标识(对私交易：当前用户PassportId, 不需要设置；对公交易：所属机构的机构Id),必须传入该值
	public long SellerId;// 卖家标识(对私交易：目标用户PassportId；;对公交易：目标用户所属机构的机构Id)
	public int TradeMode;
	public String PayWay;
	public String BizSource;
	public double TotalFee;
	public String CommodityCategory;// 商品类型
	public String CommodityCode;// 商品标识
	public int CommodityQuantity;// 商品数量
	public String CommoditySubject;// 商品标题
	public String CommoditySummary;// 商品摘要描述
	public String CommodityExtension;// 商品扩展信息(JSON),OpenEnterpriseRequestEntity对象的Json字符串
	public String SignedParams;
	public String ClientIP;
}
