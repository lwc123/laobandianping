package com.juxian.bosscomments.models;

import java.util.Date;

/**
 * Created by nene on 2016/12/8.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/8 12:03]
 * @Version: [v1.0]
 */
public class WorkItemEntity extends BaseEntity {
    public long ItemId;
    public long ArchiveId;
    public long DeptId;
    public String Department;
    public String PostTitle;
    public String Salary;
    public Date PostStartTime;
    public Date PostEndTime;
    public Date CreatedTime;
    public Date ModifiedTime;
}
