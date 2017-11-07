package com.juxian.bosscomments.models;

import java.util.Date;

/**
 * Created by nene on 2017/1/4.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/1/4 14:13]
 * @Version: [v1.0]
 */
public class PriceStrategyEntity {

    public final int PriceStrategyAuditStatus_PriceStrategyClose = 1;
    public final int PriceStrategyAuditStatus_AuditStatusWait = 2;
    public final int PriceStrategyAuditStatus_AuditStatusUnderway = 3;
    public final int PriceStrategyAuditStatus_AuditStatusStale = 4;

    public final int ActivityType_CompanyOpen = 1;// 公司开户费
    public final int ActivityType_PrivateOpen  = 2;// 个人开户费
    public final int ActivityType_BoughtComment  = 3;// 购买档案

    public long ActivityId;
    public int ActivityType;
    public String ActivityName;
    public double AndroidOriginalPrice;
    public double AndroidPreferentialPrice;
    public double IosOriginalPrice;
    public double IosPreferentialPrice;
    public String ActivityDescription;
    public String AndroidActivityDescription;
    public String ActivityHeadFigure;
    public String ActivityIcon;
    public int AuditStatus;
    public boolean IsOpen;
    public Date ActivityStartTime;
    public Date ActivityEndTime;
    public Date CreatedTime;
    public Date ModifiedTime;
    public boolean IsActivity;
}
