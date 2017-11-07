package com.juxian.bosscomments.models;

import java.util.Date;

/**
 * Created by nene on 2016/12/8.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/8 20:30]
 * @Version: [v1.0]
 */
public class DepartmentEntity extends BaseEntity {
    public long DeptId;
    public long CompanyId;
    public long PresenterId;
    public int StaffNumber;
    public String DeptName;
    public int DeptSort;
    public Date CreatedTime;
    public Date ModifiedTime;
}
