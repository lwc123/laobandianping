package com.juxian.bosscomments.presenter;

import android.content.Context;
import android.os.Handler;

import com.juxian.bosscomments.model.CompanyRegisterModel;
import com.juxian.bosscomments.model.CompanyRegisterModelImpl;
import com.juxian.bosscomments.model.CompanyRegisterModelImpl.OnLoadValidationCodeListener;
import com.juxian.bosscomments.model.CompanyRegisterModelImpl.CompanyRegisterListener;
import com.juxian.bosscomments.models.AccountSign;
import com.juxian.bosscomments.view.CompanyRegisterView;
import com.juxian.bosscomments.view.LoadValidationCodeView;

import net.juxian.appgenome.models.SignResult;

/**
 * Created by nene on 2016/11/9.
 *
 * @ProjectName: [BossComment]
 * @Package: [com.juxian.bosscomments.presenter]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/9 10:43]
 * @Version: [v1.0]
 */
public class CompanyRegisterPresenterImpl implements CompanyRegisterPresenter,CompanyRegisterListener,OnLoadValidationCodeListener {

    private Context mContext;
    private CompanyRegisterView mCompanyRegisterView;
    private LoadValidationCodeView mLoadValidationCodeView;
    private CompanyRegisterModel mCompanyRegisterModel;

    public CompanyRegisterPresenterImpl(Context mContext, CompanyRegisterView mCompanyRegisterView, LoadValidationCodeView mLoadValidationCodeView){
        this.mContext = mContext;
        this.mCompanyRegisterView = mCompanyRegisterView;
        this.mLoadValidationCodeView = mLoadValidationCodeView;
        mCompanyRegisterModel = new CompanyRegisterModelImpl();
    }

    @Override
    public void loadValidationCode(String phone) {
        mLoadValidationCodeView.showLoadValidationCodeProgress();
        mCompanyRegisterModel.loadValidationCode(phone,this);
    }

    @Override
    public void signUp(AccountSign accountSign, Handler myHandler) {
        mCompanyRegisterView.showOpenAccountProgress();
        mCompanyRegisterModel.signUp(accountSign,myHandler,this);
    }

    @Override
    public void onLoadValidationCodeSuccess(Integer result) {
        mLoadValidationCodeView.returnLoadValidationCode(result);
        mLoadValidationCodeView.hideLoadValidationCodeProgress();
    }

    @Override
    public void onLoadValidationCodeEmpty(String msg) {
        mLoadValidationCodeView.hideLoadValidationCodeProgress();
    }

    @Override
    public void onLoadValidationCodeFailure(String msg, Exception e) {
        mLoadValidationCodeView.hideLoadValidationCodeProgress();
        mLoadValidationCodeView.returnLoadValidationCodeFailure(msg,e);
    }

    @Override
    public void onCompanyRegisterSuccess(SignResult signResult) {
        mCompanyRegisterView.CompanyRegisterResult(signResult);
        mCompanyRegisterView.hideOpenAccountProgress();
    }

    @Override
    public void onCompanyRegisterEmpty(String msg) {
        mCompanyRegisterView.hideOpenAccountProgress();
    }

    @Override
    public void onCompanyRegisterFailure(String msg, Exception e) {
        mCompanyRegisterView.CompanyRegisterFailture(msg,e);
        mCompanyRegisterView.hideOpenAccountProgress();
    }
}
