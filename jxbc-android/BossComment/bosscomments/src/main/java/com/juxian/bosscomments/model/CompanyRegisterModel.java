package com.juxian.bosscomments.model;

import android.os.Handler;

import com.juxian.bosscomments.model.CompanyRegisterModelImpl.OnLoadValidationCodeListener;
import com.juxian.bosscomments.model.CompanyRegisterModelImpl.CompanyRegisterListener;
import com.juxian.bosscomments.models.AccountSign;

/**
 * Created by nene on 2016/11/9.
 *
 * @ProjectName: [BossComment]
 * @Package: [com.juxian.bosscomments.model]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/9 10:31]
 * @Version: [v1.0]
 */
public interface CompanyRegisterModel {
    void loadValidationCode(String phone, OnLoadValidationCodeListener listener);
    void signUp(AccountSign accountSign, Handler myHandler, CompanyRegisterListener listener);
}
