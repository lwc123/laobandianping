package com.juxian.bosscomments.view;

import com.juxian.bosscomments.models.ArchiveCommentEntity;

/**
 * Created by nene on 2016/12/13.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/13 17:37]
 * @Version: [v1.0]
 */
public interface ArchiveCommentView {

    void callBackAddArchiveComment(Long archiveId, ArchiveCommentEntity entity);
    void callBaceArchiveCommentDetail(ArchiveCommentEntity entity);
    void callBaceArchiveCommentDetailFailure(String msg,Exception e);
    void callBaceUpdateArchiveComment(Boolean isSuccess,ArchiveCommentEntity entity);
    void callBackArchiveComment(String msg,Exception e);

    void showProgress();

    void hideProgress();
}
