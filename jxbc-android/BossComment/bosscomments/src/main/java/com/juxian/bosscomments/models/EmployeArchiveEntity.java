package com.juxian.bosscomments.models;

import java.util.Date;
import java.util.List;

/**
 * Created by nene on 2016/12/8.
 * 档案实体
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/8 12:05]
 * @Version: [v1.0]
 */
public class EmployeArchiveEntity extends BaseEntity {
    public String CompanyName;
    public int StageEvaluationNum;
    public int DepartureReportNum;
    public List<WorkItemEntity> WorkItems;
    public long ArchiveId;
    public long CompanyId;
    public long PresenterId;
    public long ModifiedId;
    public long DeptId;
    public int IsDimission;//0在职，1离任
    public String RealName;
    public String IDCard;
    public String Gender;
    public Date Birthday;
    public String Picture;
    public String Email;
    public String MobilePhone;
    public Date EntryTime;
    public Date DimissionTime;
    public Date CreatedTime;
    public Date ModifiedTime;
    public String GraduateSchool;
    public String Education;
    public String EducationText;
    public int CommentsNum;
    public WorkItemEntity WorkItem;
    public boolean IsSendSms;
}
