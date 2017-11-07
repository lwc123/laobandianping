package com.juxian.bosscomments.models;

import java.util.Date;
import java.util.List;

/**
 * Created by Tam on 2016/12/23.
 */
public class BossDynamicEntity extends BaseEntity {
    public long DynamicId;//动态id
    public long CompanyId;
    public long PassportId; //发表评论的用户id
    public String[] Img;
    public String Content;
    public Date CreatedTime;
    public int CommentCount;
    public int LikedNum;
    public boolean IsLiked;
    public String CompanyAbbr;
    public List<BossDynamicCommentEntity> Comment;
    public CompanyEntity Company;
}
