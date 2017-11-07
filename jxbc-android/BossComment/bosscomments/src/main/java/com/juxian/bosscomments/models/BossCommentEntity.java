package com.juxian.bosscomments.models;

import java.util.Date;

/**
 * Created by nene on 2016/11/1.
 *
 * @ProjectName: [BossComment]
 * @Package: [com.juxian.bosscomments.models]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/1 17:48]
 * @Version: [v1.0]
 */
public class BossCommentEntity extends BaseEntity {

    public String EntName;
    public long Id;
    public int PersistentState;
    public long CommentId;
    public long EmployeId;
    public long CommentEntId;
    public long CommentatorId;
    public String CommentatorName;
    public String CommentatorJobTitle;
    public String TargetName;
    public String TargetIDCard;
    public String TargetJobTitle;
    public int WorkAbility;
    public int WorkManner;
    public int WorkAchievement;
    public String Text;
    public String Voice;
    public String[] Images;
    public Date CreatedTime;
    public Date ModifiedTime;
}
