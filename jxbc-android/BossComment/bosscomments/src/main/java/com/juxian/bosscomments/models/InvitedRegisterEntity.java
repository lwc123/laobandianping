package com.juxian.bosscomments.models;

import java.util.Date;

/**
 * Created by nene on 2016/12/29.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/29 17:39]
 * @Version: [v1.0]
 */
public class InvitedRegisterEntity extends BaseEntity {
    public long InvitedId;
    public long CompanyId;
    public long PassportId;
    public String InviterCode;
    public String InviteRegisterQrcode;
    public String InvitePremium;
    public String InviteRegisterUrl;
    public Date ExpirationTime;
    public Date CreatedTime;
    public Date ModifiedTime;
}
