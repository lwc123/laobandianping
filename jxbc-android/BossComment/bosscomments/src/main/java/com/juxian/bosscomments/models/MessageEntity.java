package com.juxian.bosscomments.models;

import java.util.Date;

/**
 * Created by Tam on 2016/12/17.
 */
public class MessageEntity {
    public long MessageId;
    public long ToPassportId;
    public long ToCompanyId;
    public long FromCompanyId;
    public long FromPassportId;
    public String Subject;// 消息标题
    public String Picture;// 消息头像
    public String Url;
    public String Content;
    public String ExtendParams;
    public String EventCode;
    public Date ReadTime;
    public Date CreatedTime;
    public Date ModifiedTime;
    public int BizType;//业务类型
    public long BizId;// 业务id
    public int IsRead;// 0是未读
    public int MessageType;

}
