package com.juxian.bosscomments.models;

/**
 * Created by Tam on 2016/12/20.
 */
public class CompanyBankCardEntity extends BaseEntity {
    public long AccountId;
    public long CompanyId;
    public String CompanyName;
    public long PresenterId;
    public String BankCard;
    public String UseTime;
    public String BankName;

    public String CreatedTime;
    public String ModifiedTime;

    public boolean isChecked;
}
