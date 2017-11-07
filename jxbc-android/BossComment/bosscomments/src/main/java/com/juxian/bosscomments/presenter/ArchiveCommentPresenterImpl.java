package com.juxian.bosscomments.presenter;

import android.content.Context;

import com.juxian.bosscomments.model.ArchiveCommentModel;
import com.juxian.bosscomments.model.ArchiveCommentModelImpl;
import com.juxian.bosscomments.model.ArchiveCommentModelImpl.AddArchiveCommentListener;
import com.juxian.bosscomments.model.ArchiveCommentModelImpl.GetCommentDetailListener;
import com.juxian.bosscomments.model.ArchiveCommentModelImpl.ChangeArchiveCommentListener;
import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.view.ArchiveCommentView;

import java.util.ArrayList;

/**
 * Created by nene on 2016/12/13.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/13 17:34]
 * @Version: [v1.0]
 */
public class ArchiveCommentPresenterImpl implements ArchiveCommentPresenter,AddArchiveCommentListener,GetCommentDetailListener,ChangeArchiveCommentListener {

    private Context mContext;
    private ArchiveCommentView mArchiveCommentView;
    private ArchiveCommentModel mArchiveCommentModel;
    public ArchiveCommentPresenterImpl(Context mContext, ArchiveCommentView mArchiveCommentView){
        this.mContext = mContext;
        this.mArchiveCommentView = mArchiveCommentView;
        mArchiveCommentModel = new ArchiveCommentModelImpl();
    }

    @Override
    public void onArchiveCommentSuccess(Long archiveId, ArchiveCommentEntity entity) {
        mArchiveCommentView.hideProgress();
        mArchiveCommentView.callBackAddArchiveComment(archiveId,entity);
    }

    @Override
    public void onArchiveCommentSuccess(Boolean isSuccess, ArchiveCommentEntity entity) {
        mArchiveCommentView.hideProgress();
        mArchiveCommentView.callBaceUpdateArchiveComment(isSuccess,entity);
    }

    @Override
    public void onArchiveCommentFailure(String msg, Exception e) {
        mArchiveCommentView.hideProgress();
        mArchiveCommentView.callBackArchiveComment(msg,e);
    }

    @Override
    public void addArchiveComment(ArrayList<String> mSelectImage, ArchiveCommentEntity entity) {
        mArchiveCommentView.showProgress();
        mArchiveCommentModel.addArchiveComment(mContext,mSelectImage,entity,this);
    }

    @Override
    public void getCommentDetail(long CompanyId,long CommentId) {
        mArchiveCommentView.showProgress();
        mArchiveCommentModel.getCommentDetail(CompanyId,CommentId,this);
    }

    @Override
    public void updateArchiveComment(ArrayList<String> mNetImage,ArrayList<String> mSelectImage,ArchiveCommentEntity entity) {
        mArchiveCommentView.showProgress();
        mArchiveCommentModel.changeArchiveComment(mContext,mNetImage,mSelectImage,entity,this);
    }

    @Override
    public void onGetCommentDetailSuccess(ArchiveCommentEntity entity) {
        mArchiveCommentView.hideProgress();
        mArchiveCommentView.callBaceArchiveCommentDetail(entity);
    }

    @Override
    public void onGetCommentDetailFailure(String msg, Exception e) {
        mArchiveCommentView.hideProgress();
        mArchiveCommentView.callBaceArchiveCommentDetailFailure(msg,e);
    }
}
