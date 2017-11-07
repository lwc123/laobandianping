package com.juxian.bosscomments.models;

import java.util.Date;

/**
 * Created by nene on 2017/2/9.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/2/9 17:54]
 * @Version: [v1.0]
 */
public class ArchiveCommentLogEntity {
    public long LogId;
    public long CompanyId;
    public long PresenterId;
    public long CommentId;
    public Date CreatedTime;
    public Date ModifiedTime;
    public MemberEntity CompanyMember;
}
