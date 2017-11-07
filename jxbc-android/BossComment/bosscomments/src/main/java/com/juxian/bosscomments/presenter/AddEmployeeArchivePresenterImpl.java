package com.juxian.bosscomments.presenter;

import android.content.Context;

import com.juxian.bosscomments.model.EmployeeArchiveModel;
import com.juxian.bosscomments.model.EmployeeArchiveModelImpl;
import com.juxian.bosscomments.models.EmployeArchiveEntity;
import com.juxian.bosscomments.model.EmployeeArchiveModelImpl.CheckIDCardListener;
import com.juxian.bosscomments.model.EmployeeArchiveModelImpl.AddEmployeeArchiveListener;
import com.juxian.bosscomments.model.EmployeeArchiveModelImpl.GetArchiveDetailListener;
import com.juxian.bosscomments.model.EmployeeArchiveModelImpl.UpdateEmployeeArchiveListener;
import com.juxian.bosscomments.models.ResultEntity;
import com.juxian.bosscomments.view.AddEmployeeArchiveView;

/**
 * Created by nene on 2016/12/13.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/13 17:34]
 * @Version: [v1.0]
 */
public class AddEmployeeArchivePresenterImpl implements AddEmployeeArchivePresenter,CheckIDCardListener,AddEmployeeArchiveListener,GetArchiveDetailListener,UpdateEmployeeArchiveListener {

    private Context mContext;
    private AddEmployeeArchiveView mAddEmployeeArchiveView;
    private EmployeeArchiveModel mEmployeeArchiveModel;
    public AddEmployeeArchivePresenterImpl(Context mContext,AddEmployeeArchiveView mAddEmployeeArchiveView){
        this.mContext = mContext;
        this.mAddEmployeeArchiveView = mAddEmployeeArchiveView;
        mEmployeeArchiveModel = new EmployeeArchiveModelImpl();
    }

    @Override
    public void checkIDCard(EmployeArchiveEntity entity) {
        mAddEmployeeArchiveView.showAddEmployeeArchiveProgress();
        mEmployeeArchiveModel.checkIDCard(entity,this);
    }

    @Override
    public void addEmployeeArchive(EmployeArchiveEntity entity) {
        mAddEmployeeArchiveView.showAddEmployeeArchiveProgress();
        mEmployeeArchiveModel.addEmployeeArchive(entity,this);
    }

    @Override
    public void getArchiveDetail(long CompanyId,long ArchiveId) {
        mAddEmployeeArchiveView.showAddEmployeeArchiveProgress();
        mEmployeeArchiveModel.getArchiveDetail(CompanyId,ArchiveId,this);
    }

    @Override
    public void updateEmployeeArchive(EmployeArchiveEntity entity) {
        mAddEmployeeArchiveView.showAddEmployeeArchiveProgress();
        mEmployeeArchiveModel.updateEmployeeArchive(entity,this);
    }

    @Override
    public void onAddEmployeeArchiveSuccess(ResultEntity resultEntity) {
        mAddEmployeeArchiveView.hideAddEmployeeArchiveProgress();
        mAddEmployeeArchiveView.callBackAddEmployeeArchive(resultEntity);
    }

    @Override
    public void onAddEmployeeArchiveFailure(String msg, Exception e) {
        mAddEmployeeArchiveView.hideAddEmployeeArchiveProgress();
        mAddEmployeeArchiveView.callBackAddEmployeeArchiveFailure(msg,e);
    }

    @Override
    public void onCheckIDCardSuccess(ResultEntity checkResult,EmployeArchiveEntity entity) {
        mAddEmployeeArchiveView.hideAddEmployeeArchiveProgress();
        mAddEmployeeArchiveView.callBackcheckIDCard(checkResult,entity);
    }

    @Override
    public void onCheckIDCardFailure(String msg, Exception e) {
        mAddEmployeeArchiveView.hideAddEmployeeArchiveProgress();
    }

    @Override
    public void onGetArchiveDetailSuccess(EmployeArchiveEntity resultEntity) {
        mAddEmployeeArchiveView.hideAddEmployeeArchiveProgress();
        mAddEmployeeArchiveView.callBackGetArchiveDetail(resultEntity);
    }

    @Override
    public void onGetArchiveDetailFailure(String msg, Exception e) {
        mAddEmployeeArchiveView.hideAddEmployeeArchiveProgress();
        mAddEmployeeArchiveView.callBackGetArchiveDetailFailure(msg,e);
    }

    @Override
    public void onUpdateEmployeeArchiveSuccess(ResultEntity resultEntity) {
        mAddEmployeeArchiveView.callBackUpdateEmployeeArchive(resultEntity);
        mAddEmployeeArchiveView.hideAddEmployeeArchiveProgress();
    }

    @Override
    public void onUpdateEmployeeArchiveFailure(String msg, Exception e) {
        mAddEmployeeArchiveView.hideAddEmployeeArchiveProgress();
        mAddEmployeeArchiveView.callBackUpdateEmployeeArchiveFailure(msg,e);
    }
}
