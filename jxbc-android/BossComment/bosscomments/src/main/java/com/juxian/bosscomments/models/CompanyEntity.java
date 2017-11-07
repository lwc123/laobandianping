package com.juxian.bosscomments.models;

import java.util.Date;

/**
 * Created by nene on 2016/12/2.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/2 18:28]
 * @Version: [v1.0]
 */
public class CompanyEntity extends BaseEntity {

    public static final int AttestationStatus_None = 0;
    public static final int AttestationStatus_Submited = 1;
    public static final int AttestationStatus_Passed = 2;
    public static final int AttestationStatus_Rejected = 9;

    public long CompanyId;
    public long PassportId;
    public String CompanyName;
    public String CompanyAbbr;
    public String LegalName;
    public String Region;// 省市城市
    public String RegionText;
    public String CompanySize;
    public String CompanySizeText;
    public String Industry;
    public String CompanyLogo;
    public int AuditStatus;
    public int ContractStatus;// 合同状态 1无付费  2是已付费
    public Date CreatedTime;
    public Date ModifiedTime;
    public int DimissionNum;
    public int EmployedNum;
    public int StageEvaluationNum;
    public int DepartureReportNum;
    public Date ServiceEndTime;//合同终止时间
    public int UnreadMessageNum;
    public String PromptInfo;
    public MemberEntity BossInformation;
    public MemberEntity MyInformation;// 当前使用用户的信息
    public WalletEntity Wallet;
    public boolean ExistBankCard;
    public int myCompanys;
}
