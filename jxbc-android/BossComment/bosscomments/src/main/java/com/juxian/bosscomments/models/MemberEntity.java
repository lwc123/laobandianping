package com.juxian.bosscomments.models;

import java.util.Date;

/**
 * Created by nene on 2016/12/2.
 * 角色实体
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/2 18:23]
 * @Version: [v1.0]
 */
public class MemberEntity extends BaseEntity {

    public static int CompanyMember_Role_Boss = 1;
    public static int CompanyMember_Role_Admin = 2;
    public static int CompanyMember_Role_Senior = 3;
    public static int CompanyMember_Role_XiaoMi = 4;

    public long CompanyId;
    public long MemberId;
    public long PassportId;//审核者
    public long PresenterId;//提交者
    public long ModifiedId;
    public String RealName;
    public String JobTitle;
    public int Role;
    public Date CreatedTime;
    public Date ModifiedTime;
    public CompanyEntity myCompany;
    public int UnreadMessageNum;
    public String MobilePhone;

}
