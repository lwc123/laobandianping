package com.juxian.bosscomments.models;

import java.util.Date;

/**
 * Created by nene on 2016/12/17.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/17 9:47]
 * @Version: [v1.0]
 */
public class WalletEntity {
    public long WalletId;
    public int WalletType;
    public long OwnerId;
    public double AvailableBalance; //金库
    public double CanWithdrawBalance;//可提现
    public double FreezeFee;
    public Date CreatedTime;
    public Date ModifiedTime;
}
