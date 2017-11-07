package com.juxian.bosscomments.models;

/**
 * Created by nene on 2016/12/6.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/6 14:30]
 * @Version: [v1.0]
 */
public class CompanyAuditEntity extends BaseEntity {
    public long ApplyId;
    public long ApplicantId;
    public long CompanyId;
    public String RejectReason;
    public int AuditStatus;
    public String MobilePhone;
    public String IDCard;
    public String Licence;
    public String[] Images;
    public CompanyEntity Company;
    public String ValidationCode;
}
