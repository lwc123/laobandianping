package com.juxian.bosscomments.presenter;

import android.content.Context;
import android.os.Handler;
import com.juxian.bosscomments.model.CompanyAuthenticationModelImpl.CompanyAuthenticationListener;
import com.juxian.bosscomments.model.CompanyAuthenticationModel;
import com.juxian.bosscomments.model.CompanyAuthenticationModelImpl;
import com.juxian.bosscomments.model.CompanyRegisterModelImpl;
import com.juxian.bosscomments.models.AccountSign;
import com.juxian.bosscomments.models.CompanyAuditEntity;
import com.juxian.bosscomments.models.ResultEntity;
import com.juxian.bosscomments.view.CompanyAuthenticationView;
import com.juxian.bosscomments.model.CompanyRegisterModelImpl.OnLoadValidationCodeListener;
import com.juxian.bosscomments.view.LoadValidationCodeView;

import net.juxian.appgenome.models.SignResult;

import java.util.ArrayList;

/**
 * Created by nene on 2016/11/9.
 *
 * @Description: 认证
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/9 10:43]
 * @Version: [v1.0]
 */
public class CompanyAuthenticationPresenterImpl implements CompanyAuthenticationPresenter,CompanyAuthenticationListener,OnLoadValidationCodeListener {

    private Context mContext;
    private CompanyAuthenticationView mCompanyAuthenticationView;
    private LoadValidationCodeView mLoadValidationCodeView;
    private CompanyAuthenticationModel mCompanyAuthenticationModel;

    public CompanyAuthenticationPresenterImpl(Context mContext,CompanyAuthenticationView mCompanyInformationView, LoadValidationCodeView mLoadValidationCodeView){
        this.mContext = mContext;
        this.mCompanyAuthenticationView = mCompanyInformationView;
        this.mLoadValidationCodeView = mLoadValidationCodeView;
        mCompanyAuthenticationModel = new CompanyAuthenticationModelImpl();
    }

    @Override
    public void loadValidationCode(String phone) {
        mLoadValidationCodeView.showLoadValidationCodeProgress();
        mCompanyAuthenticationModel.loadValidationCode(phone,this);
    }

    @Override
    public void submitAuthentication(String Licence,ArrayList<String> mNetImage, ArrayList<String> mSelectImage, CompanyAuditEntity entity) {
        mCompanyAuthenticationView.showOpenAccountProgress();
        mCompanyAuthenticationModel.submitAuthentication(mContext, Licence,mNetImage,mSelectImage,entity,this);
    }

    @Override
    public void onCompanyAuthenticationSuccess(ResultEntity resultEntity) {
        mCompanyAuthenticationView.CompanyAuthenticationSignResult(resultEntity);
        mCompanyAuthenticationView.hideOpenAccountProgress();
    }

    @Override
    public void onCompanyAuthenticationEmpty(String msg) {
        mCompanyAuthenticationView.hideOpenAccountProgress();
    }

    @Override
    public void onCompanyAuthenticationFailure(String msg, Exception e) {
        mCompanyAuthenticationView.hideOpenAccountProgress();
        mCompanyAuthenticationView.CompanyAuthenticationSignResultFailture(msg,e);
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
    }
}
