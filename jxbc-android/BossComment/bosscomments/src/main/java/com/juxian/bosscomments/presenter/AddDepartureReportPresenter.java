package com.juxian.bosscomments.presenter;

import com.juxian.bosscomments.models.ArchiveCommentEntity;

import java.util.ArrayList;

/**
 * Created by nene on 2016/12/13.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/13 17:34]
 * @Version: [v1.0]
 */
public interface AddDepartureReportPresenter {

    void addDepartureReport(ArrayList<String> imgs, ArchiveCommentEntity entity);
    void getDepartureReportDetail(long CompanyId,long CommentId);
    void updateDepartureReport(ArrayList<String> mNetImage,ArrayList<String> mSelectImage,ArchiveCommentEntity entity);
}
