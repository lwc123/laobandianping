package com.juxian.bosscomments.model;

import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.repositories.CompanyRepository;
import net.juxian.appgenome.utils.AsyncRunnable;

public class AccountModelImpl implements AccountModel {

    @Override
    public void loadAccountSummary(final long CompanyId,final OnLoadAccountSummaryListener listener) {
        // 获取企业信息，根据之前保存的企业id查询
        new AsyncRunnable<CompanyEntity>() {
            @Override
            protected CompanyEntity doInBackground(Void... params) {
                CompanyEntity entity = CompanyRepository.getMine(CompanyId);
                return entity;
            }

            @Override
            protected void onPostExecute(CompanyEntity entity) {
                listener.onSuccess(entity);
            }

            protected void onPostError(Exception ex) {
                listener.onFailure(null,ex);
            }
        }.execute();
    }

    public interface OnLoadAccountSummaryListener {
        void onSuccess(CompanyEntity entity);
        void onEmpty(String msg);
        void onFailure(String msg, Exception e);
    }
}
