package com.juxian.bosscomments.models;

import java.util.List;

/**
 * Created by nene on 2016/12/9.
 * 档案列表实体
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/9 9:42]
 * @Version: [v1.0]
 */
public class EmployeArchiveListEntity extends BaseEntity {
    public List<DepartmentEntity> Departments;
    public List<EmployeArchiveEntity> ArchiveLists;
}
