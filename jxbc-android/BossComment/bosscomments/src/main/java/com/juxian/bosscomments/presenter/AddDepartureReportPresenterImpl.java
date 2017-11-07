package com.juxian.bosscomments.presenter;

import android.content.Context;

import com.juxian.bosscomments.model.DepartureReportModel;
import com.juxian.bosscomments.model.DepartureReportModelImpl;
import com.juxian.bosscomments.model.DepartureReportModelImpl.AddDepartureReportListener;
import com.juxian.bosscomments.model.DepartureReportModelImpl.getDepartureReportListener;
import com.juxian.bosscomments.model.DepartureReportModelImpl.UpdateDepartureReportListener;
import com.juxian.bosscomments.models.ArchiveCommentEntity;
import com.juxian.bosscomments.view.DepartureReportView;

import java.util.ArrayList;

/**
 * Created by nene on 2016/12/13.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/13 17:34]
 * @Version: [v1.0]
 */
public class AddDepartureReportPresenterImpl implements AddDepartureReportPresenter,AddDepartureReportListener,getDepartureReportListener,UpdateDepartureReportListener {

    private Context mContext;
    private DepartureReportView mDepartureReportView;
    private DepartureReportModel mDepartureReportModel;

    public AddDepartureReportPresenterImpl(Context mContext, DepartureReportView mDepartureReportView){
        this.mContext = mContext;
        this.mDepartureReportView = mDepartureReportView;
        mDepartureReportModel = new DepartureReportModelImpl();
    }

    @Override
    public void addDepartureReport(ArrayList<String> imgs,ArchiveCommentEntity entity) {
        mDepartureReportView.showProgress();
        mDepartureReportModel.addDepartureReport(mContext,imgs,entity,this);
    }

    @Override
    public void getDepartureReportDetail(long CompanyId,long CommentId) {
        mDepartureReportView.showProgress();
        mDepartureReportModel.getDepartureReportDetail(CompanyId,CommentId,this);
    }

    @Override
    public void updateDepartureReport(ArrayList<String> mNetImage,ArrayList<String> mSelectImage,ArchiveCommentEntity entity) {
        mDepartureReportView.showProgress();
        mDepartureReportModel.changeDepartureReport(mContext,mNetImage,mSelectImage,entity,this);
    }

    @Override
    public void onAddDepartureReportSuccess(Long archiveId, ArchiveCommentEntity entity) {
        mDepartureReportView.callBackDepartureReportArchive(archiveId,entity);
        mDepartureReportView.hideProgress();
    }

    @Override
    public void onAddDepartureReportFailure(String msg, Exception e) {
        mDepartureReportView.callBackDepartureReportArchiveFailure(msg,e);
        mDepartureReportView.hideProgress();
    }

    @Override
    public void onUpdateDepartureReportSuccess(Boolean isSuccess, ArchiveCommentEntity entity) {
        mDepartureReportView.callBaceUpdateDepartureReport(isSuccess,entity);
        mDepartureReportView.hideProgress();
    }

    @Override
    public void onUpdateDepartureReportFailure(String msg, Exception e) {
        mDepartureReportView.callBaceUpdateDepartureReportFailure(msg,e);
        mDepartureReportView.hideProgress();
    }

    @Override
    public void onGetDepartureReportSuccess(ArchiveCommentEntity entity) {
        mDepartureReportView.callBaceDepartureReportDetail(entity);
        mDepartureReportView.hideProgress();
    }

    @Override
    public void onGetDepartureReportFailure(String msg, Exception e) {
        mDepartureReportView.callBaceDepartureReportDetailFailure(msg,e);
        mDepartureReportView.hideProgress();
    }
}
