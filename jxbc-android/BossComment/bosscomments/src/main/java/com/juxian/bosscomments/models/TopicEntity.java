package com.juxian.bosscomments.models;

import java.util.Date;
import java.util.List;

/**
 * Created by nene on 2017/4/17.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2017/4/17 16:09]
 * @Version: [v1.0]
 */
public class TopicEntity extends BaseEntity {
    public long TopicId;
    public String TopicName;
    public String HeadFigure;
    public String BannerPicture;
    public int IsOpen;
    public int TopicOrder;
    public Date CreatedTime;
    public Date ModifiedTime;
    public List<CCompanyEntity> Companys;
}
