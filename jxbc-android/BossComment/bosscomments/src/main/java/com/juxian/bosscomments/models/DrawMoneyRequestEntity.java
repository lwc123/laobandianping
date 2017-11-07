package com.juxian.bosscomments.models;

/**
 * Created by Tam on 2016/12/20.
 */
public class DrawMoneyRequestEntity {
    public long ApplyId;
    public long CompanyId;
    public String CompanyName;
    public long PresenterId;//提交人ID
    public String BankCard;//银行账号
    public String BankName;
    public double MoneyNumber;//提现金额
    public int AuditStatus;//提现状态，0未申请，1申请中，2已完成，9被拒绝
    public String CreatedTime;
    public String ModifiedTime;
}
