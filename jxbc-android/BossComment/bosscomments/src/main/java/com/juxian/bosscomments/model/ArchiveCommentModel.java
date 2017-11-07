package com.juxian.bosscomments.model;

import android.content.Context;

import com.juxian.bosscomments.model.ArchiveCommentModelImpl.AddArchiveCommentListener;
import com.juxian.bosscomments.model.ArchiveCommentModelImpl.GetCommentDetailListener;
import com.juxian.bosscomments.model.ArchiveCommentModelImpl.ChangeArchiveCommentListener;
import com.juxian.bosscomments.models.ArchiveCommentEntity;

import java.util.ArrayList;

/**
 * Created by nene on 2016/12/13.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/13 17:12]
 * @Version: [v1.0]
 */
public interface ArchiveCommentModel {
    void addArchiveComment(Context context, ArrayList<String> mSelectImage, ArchiveCommentEntity entity, AddArchiveCommentListener listener);
    void getCommentDetail(long CompanyId,long CommentId,GetCommentDetailListener listener);
    void changeArchiveComment(Context context, ArrayList<String> mNetImage, ArrayList<String> mSelectImage, ArchiveCommentEntity entity,ChangeArchiveCommentListener listener);
}
