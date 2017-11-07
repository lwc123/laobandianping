package com.juxian.bosscomments.models;

import java.util.Date;

public class ServiceContractEntity extends BaseEntity {
	public static final int ContractStatus_Paid_ = -1;
	public static final int ContractStatus_Servicing_ = 1;
	public static final int ContractStatus_ServiceEnd_ = 2;
	public static final int ContractStatus_RateCompleted_ = 3;
	public static final int ContractStatus_Reject_ = 99;

	public String Id;
	public String ContractCode;
	public long BuyerId;
	public int ContractStatus;
	public Date ServiceBeginTime;
	public Date ServiceEndTime;
	public int ServicePeriod;
	public double TotalFee;
	public String PaidWay;
	public String TradeCode;
	public int RatedLevel;
	public Date CreatedTime;
	public Date ModifiedTime;
	public int PersistentState;
    
    @SuppressWarnings("deprecation")
	public int getServiceMonths() {
		if ((this.ServiceEndTime.getYear() - this.ServiceBeginTime.getYear()) == 0) {
			return this.ServiceEndTime.getMonth() - this.ServiceBeginTime.getMonth();
		} else {
			return (this.ServiceEndTime.getYear() - this.ServiceBeginTime.getYear())*12 + (this.ServiceEndTime.getMonth() - this.ServiceBeginTime.getMonth());
		}
	}
}
