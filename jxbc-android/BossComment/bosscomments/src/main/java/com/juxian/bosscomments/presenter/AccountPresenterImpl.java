package com.juxian.bosscomments.presenter;

import android.content.Context;

import com.juxian.bosscomments.model.AccountModel;
import com.juxian.bosscomments.model.AccountModelImpl;
import com.juxian.bosscomments.model.AccountModelImpl.OnLoadAccountSummaryListener;
import com.juxian.bosscomments.models.CompanyEntity;
import com.juxian.bosscomments.view.AccountView;

public class AccountPresenterImpl implements AccountPresenter,OnLoadAccountSummaryListener {

    private Context mContent;
    private AccountView mAccountView;
    private AccountModel mAccountModel;

    public AccountPresenterImpl(Context mContent, AccountView mAccountView){
        this.mContent = mContent;
        this.mAccountView = mAccountView;
        mAccountModel = new AccountModelImpl();
    }

    @Override
    public void loadAccountSummary(long CompangyId) {
        mAccountView.showProgress();
        mAccountModel.loadAccountSummary(CompangyId,this);
    }

    @Override
    public void onSuccess(CompanyEntity entity) {
        mAccountView.showAccountMessage(entity);
        mAccountView.hideProgress();
    }

    @Override
    public void onEmpty(String msg) {
        mAccountView.hideProgress();
    }

    @Override
    public void onFailure(String msg, Exception e) {
        mAccountView.hideProgress();
    }
}
