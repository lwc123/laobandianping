package com.juxian.bosscomments.view;

import com.juxian.bosscomments.models.ArchiveCommentEntity;
/**
 * Created by nene on 2016/12/13.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/13 17:37]
 * @Version: [v1.0]
 */
public interface DepartureReportView {

    void callBackDepartureReportArchive(Long archiveId, ArchiveCommentEntity entity);
    void callBaceDepartureReportDetail(ArchiveCommentEntity entity);
    void callBaceUpdateDepartureReport(Boolean isSuccess,ArchiveCommentEntity entity);

    void callBackDepartureReportArchiveFailure(String msg,Exception e);
    void callBaceDepartureReportDetailFailure(String msg,Exception e);
    void callBaceUpdateDepartureReportFailure(String msg,Exception e);

    void showProgress();

    void hideProgress();
}
