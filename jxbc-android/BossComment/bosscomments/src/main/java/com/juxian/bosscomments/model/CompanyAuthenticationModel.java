package com.juxian.bosscomments.model;

import android.content.Context;
import android.os.Handler;

import com.juxian.bosscomments.models.AccountSign;
import com.juxian.bosscomments.model.CompanyAuthenticationModelImpl.CompanyAuthenticationListener;
import com.juxian.bosscomments.models.CompanyAuditEntity;

import java.util.ArrayList;

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
public interface CompanyAuthenticationModel {
    void loadValidationCode(String phone, CompanyRegisterModelImpl.OnLoadValidationCodeListener listener);
    void submitAuthentication(Context context, String Licence, ArrayList<String> mNetImage, ArrayList<String> mSelectImage, CompanyAuditEntity entity, CompanyAuthenticationListener listener);
}
