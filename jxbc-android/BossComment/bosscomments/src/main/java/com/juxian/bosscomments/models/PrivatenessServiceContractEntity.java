package com.juxian.bosscomments.models;

import java.util.Date;

/**
 * Created by nene on 2016/12/26.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/26 17:02]
 * @Version: [v1.0]
 */
public class PrivatenessServiceContractEntity extends BaseEntity {

    public static final int Personal_Contract_Status_Ineffective = 1;
    public static final int Personal_Contract_Status_Effective = 2;
    public static final int Personal_Contract_Status_Overdue = 3;

    public long ContractId;
    public long PassportId;
    public String RealName;
    public String IDCard;
    public int ContractStatus;
    public String ServiceBeginTime;
    public String ServiceEndTime;
    public double TotalFee;
    public String PaidWay;
    public String TradeCode;
    public String AdditionalInfo;
    public Date CreatedTime;
    public Date ModifiedTime;
}
