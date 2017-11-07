package com.juxian.bosscomments.model;

import android.content.Context;

import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.model.DepartureReportModelImpl.AddDepartureReportListener;
import com.juxian.bosscomments.model.DepartureReportModelImpl.getDepartureReportListener;
import com.juxian.bosscomments.model.DepartureReportModelImpl.UpdateDepartureReportListener;

import java.util.ArrayList;

/**
 * Created by nene on 2016/12/13.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/13 17:12]
 * @Version: [v1.0]
 */
public interface DepartureReportModel {
    void addDepartureReport(Context context, ArrayList<String> imgs, ArchiveCommentEntity entity, AddDepartureReportListener listener);
    void getDepartureReportDetail(long CompanyId,long CommentId,getDepartureReportListener listener);
    void changeDepartureReport(Context context, ArrayList<String> mNetImage,ArrayList<String> mSelectImage,ArchiveCommentEntity entity,UpdateDepartureReportListener listener);
}
