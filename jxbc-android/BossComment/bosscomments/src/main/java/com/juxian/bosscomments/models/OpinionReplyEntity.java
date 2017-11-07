package com.juxian.bosscomments.models;

import java.util.Date;

/**
 * Created by nene on 2017/4/17.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/17 11:52]
 * @Version: [v1.0]
 */
public class OpinionReplyEntity extends BaseEntity {
    public long ReplyId;
    public long OpinionId;
    public long CompanyId;// 口碑公司ID
    public long OpinionCompanyId;// 公司ID
    public long PassportId;
    public long ModifiedId;
    public int ReplyType;
    public String NickName;
    public String Avatar;
    public int AuditStatus;
    public String Content;
    public Date LeadingTime;
    public Date ModifiedTime;
    public Date CreatedTime;
}
