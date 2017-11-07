package com.juxian.bosscomments.models;

import java.util.Date;
import java.util.List;

/**
 * Created by nene on 2017/4/17.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/17 11:08]
 * @Version: [v1.0]
 */
public class OpinionEntity extends BaseEntity {
    public long OpinionId;
    public long CompanyId;
    public long PassportId;
    public long ModifiedId;
    public String NickName;
    public String Avatar;
    public String MobilePhone;
    public int AuditStatus;
    public Date EntryTime;
    public Date DimissionTime;
    public int WorkingYears;
    public String Region;
    public List<String> Labels;
    public String Title;
    public String Content;
    public int Scoring;
    public int Recommend;
    public int Optimistic;
    public int SupportCEO;
    public int LikedCount ;
    public int ReadCount;
    public int ReplyCount;
    public Date LastReplyTime ;
    public Date ModifiedTime;
    public Date CreatedTime;
    public CCompanyEntity Company;
    public boolean IsLiked;
    public List<OpinionReplyEntity> Replies;
    public boolean isSelectOpinion;
}
