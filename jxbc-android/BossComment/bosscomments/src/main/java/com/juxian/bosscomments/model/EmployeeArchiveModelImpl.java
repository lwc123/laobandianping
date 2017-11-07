package com.juxian.bosscomments.model;

import android.app.Dialog;

import com.juxian.bosscomments.R;
import com.juxian.bosscomments.models.EmployeArchiveEntity;
import com.juxian.bosscomments.models.ResultEntity;
import com.juxian.bosscomments.repositories.EmployeArchiveRepository;
import com.juxian.bosscomments.ui.AddBossCommentActivity;
import com.juxian.bosscomments.ui.AddDepartureReportActivity;

import net.juxian.appgenome.utils.AsyncRunnable;
import net.juxian.appgenome.widget.DialogUtil;
import net.juxian.appgenome.widget.ToastUtil;

/**
 * Created by nene on 2016/12/13.
 *
 * @Author: [ZZQ]
 * @CreateDate: [2016/12/13 17:16]
 * @Version: [v1.0]
 */
public class EmployeeArchiveModelImpl implements EmployeeArchiveModel {
    @Override
    public void checkIDCard(final EmployeArchiveEntity entity, final CheckIDCardListener listener){
        new AsyncRunnable<ResultEntity>() {
            @Override
            protected ResultEntity doInBackground(Void... params) {
                ResultEntity resultEntity = EmployeArchiveRepository.checkIDCard(entity.CompanyId,entity.IDCard);
                return resultEntity;
            }

            @Override
            protected void onPostExecute(ResultEntity result) {
                listener.onCheckIDCardSuccess(result,entity);
            }

            protected void onPostError(Exception ex) {
                listener.onCheckIDCardFailure(null,ex);
            }
        }.execute();
    }

    @Override
    public void addEmployeeArchive(final EmployeArchiveEntity entity, final AddEmployeeArchiveListener listener) {
        new AsyncRunnable<ResultEntity>() {
            @Override
            protected ResultEntity doInBackground(Void... params) {
                ResultEntity resultEntity = EmployeArchiveRepository.addEmployeArchive(entity);
                return resultEntity;
            }

            @Override
            protected void onPostExecute(ResultEntity resultEntity) {
                listener.onAddEmployeeArchiveSuccess(resultEntity);
            }

            protected void onPostError(Exception ex) {
                listener.onAddEmployeeArchiveFailure(null,ex);
            }
        }.execute();
    }

    @Override
    public void getArchiveDetail(final long CompanyId,final long ArchiveId, final GetArchiveDetailListener listener) {
        new AsyncRunnable<EmployeArchiveEntity>() {
            @Override
            protected EmployeArchiveEntity doInBackground(Void... params) {
                EmployeArchiveEntity entity = EmployeArchiveRepository.getArchiveDetail(CompanyId,ArchiveId);
                return entity;
            }

            @Override
            protected void onPostExecute(EmployeArchiveEntity entity) {
                listener.onGetArchiveDetailSuccess(entity);
            }

            protected void onPostError(Exception ex) {
                listener.onGetArchiveDetailFailure(null,ex);
            }
        }.execute();
    }

    @Override
    public void updateEmployeeArchive(final EmployeArchiveEntity entity, final UpdateEmployeeArchiveListener listener) {
        new AsyncRunnable<ResultEntity>() {
            @Override
            protected ResultEntity doInBackground(Void... params) {
                ResultEntity resultEntity = EmployeArchiveRepository.updateEmployeeArchive(entity);
                return resultEntity;
            }

            @Override
            protected void onPostExecute(ResultEntity resultEntity) {
                listener.onUpdateEmployeeArchiveSuccess(resultEntity);
            }

            protected void onPostError(Exception ex) {
                listener.onUpdateEmployeeArchiveFailure(null,ex);
            }
        }.execute();
    }

    public interface CheckIDCardListener {
        void onCheckIDCardSuccess(ResultEntity checkResult,EmployeArchiveEntity entity);
        void onCheckIDCardFailure(String msg, Exception e);
    }

    public interface AddEmployeeArchiveListener {
        void onAddEmployeeArchiveSuccess(ResultEntity resultEntity);
        void onAddEmployeeArchiveFailure(String msg, Exception e);
    }

    public interface GetArchiveDetailListener {
        void onGetArchiveDetailSuccess(EmployeArchiveEntity resultEntity);
        void onGetArchiveDetailFailure(String msg, Exception e);
    }

    public interface UpdateEmployeeArchiveListener {
        void onUpdateEmployeeArchiveSuccess(ResultEntity resultEntity);
        void onUpdateEmployeeArchiveFailure(String msg, Exception e);
    }
}
