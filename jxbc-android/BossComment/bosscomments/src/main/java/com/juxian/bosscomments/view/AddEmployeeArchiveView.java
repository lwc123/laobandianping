package com.juxian.bosscomments.view;

import com.juxian.bosscomments.models.EmployeArchiveEntity;
import com.juxian.bosscomments.models.ResultEntity;

/**
 * Created by nene on 2016/12/13.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/13 17:37]
 * @Version: [v1.0]
 */
public interface AddEmployeeArchiveView {
    void callBackcheckIDCard(ResultEntity checkResult,EmployeArchiveEntity entity);

    void callBackAddEmployeeArchive(ResultEntity resultEntity);

    void callBackAddEmployeeArchiveFailure(String msg, Exception e);

    void callBackGetArchiveDetail(EmployeArchiveEntity resultEntity);

    void callBackGetArchiveDetailFailure(String msg, Exception e);

    void callBackUpdateEmployeeArchive(ResultEntity resultEntity);

    void callBackUpdateEmployeeArchiveFailure(String msg, Exception e);

    void showAddEmployeeArchiveProgress();

    void hideAddEmployeeArchiveProgress();
}
