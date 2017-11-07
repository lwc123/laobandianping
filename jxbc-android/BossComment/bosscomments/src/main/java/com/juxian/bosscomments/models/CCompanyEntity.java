package com.juxian.bosscomments.models;

import java.util.Date;
import java.util.List;

/**
 * Created by nene on 2017/4/18.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/18 13:51]
 * @Version: [v1.0]
 */
public class CCompanyEntity {
    public long CompanyId;
    public long ClaimCompanyId;
    public long CollectionCompanyId;
    public String CompanyName;
    public String CompanyAbbr;
    public String CompanyCEO;
    public String CompanyLogo;
    public boolean IsCloseComment;
    public double Score;
    public int Recommend;
    public int Optimistic;
    public int SupportCEO;
    public String Region;
    public String CompanySize;
    public String Industry;
    public List<String> Labels;
    public String Products;
    public String Photos;
    public String BriefIntroduction;
    public String Introduction;
    public String Address;
    public int LikedCount;
    public int ReadCount;
    public int CommentCount;
    public int StaffCount;
    public Date EstablishedTime;
    public Date ModifiedTime;
    public Date CreatedTime;
    public boolean IsFormerClub;
    public boolean IsConcerned;
    public boolean IsClaim;
    public List<OpinionEntity> Opinions;
    public boolean IsRedDot;
    public String ShareLink;
}
