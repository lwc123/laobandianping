package com.juxian.bosscomments.presenter;

import com.juxian.bosscomments.models.EmployeArchiveEntity;

/**
 * Created by nene on 2016/12/13.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/13 17:34]
 * @Version: [v1.0]
 */
public interface AddEmployeeArchivePresenter {
    void checkIDCard(EmployeArchiveEntity entity);
    void addEmployeeArchive(EmployeArchiveEntity entity);
    void getArchiveDetail(long CompanyId,long ArchiveId);
    void updateEmployeeArchive(EmployeArchiveEntity entity);
}
