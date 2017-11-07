package com.juxian.bosscomments.models;

import java.util.Date;
import java.util.List;

/**
 * Created by nene on 2016/11/3.
 *
 * @ProjectName: [BossComment]
 * @Package: [com.juxian.bosscomments.models]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/3 14:39]
 * @Version: [v1.0]
 */
public class TargetEmploye {
    public long Id;
    public int PersistentState;
    public long EmployeId;
    public long PassportId;
    public String RealName;
    public String IDCard;
    public String[] Tags;
    public Date CreatedTime;
    public Date ModifiedTime;
    public List<BossCommentEntity> Comments;
}
