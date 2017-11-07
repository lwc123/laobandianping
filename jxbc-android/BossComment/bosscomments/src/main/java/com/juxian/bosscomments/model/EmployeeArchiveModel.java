package com.juxian.bosscomments.model;

import com.juxian.bosscomments.models.EmployeArchiveEntity;
import com.juxian.bosscomments.model.EmployeeArchiveModelImpl.CheckIDCardListener;
import com.juxian.bosscomments.model.EmployeeArchiveModelImpl.AddEmployeeArchiveListener;
import com.juxian.bosscomments.model.EmployeeArchiveModelImpl.GetArchiveDetailListener;
import com.juxian.bosscomments.model.EmployeeArchiveModelImpl.UpdateEmployeeArchiveListener;

/**
 * Created by nene on 2016/12/13.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/13 17:12]
 * @Version: [v1.0]
 */
public interface EmployeeArchiveModel {
    void checkIDCard(EmployeArchiveEntity entity, CheckIDCardListener listener);
    void addEmployeeArchive(EmployeArchiveEntity entity, AddEmployeeArchiveListener listener);
    void getArchiveDetail(long CompanyId,long ArchiveId,GetArchiveDetailListener listener);
    void updateEmployeeArchive(EmployeArchiveEntity entity,UpdateEmployeeArchiveListener listener);
}
