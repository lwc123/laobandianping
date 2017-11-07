package com.juxian.bosscomments.presenter;

import android.content.Context;
import android.os.Handler;

import com.juxian.bosscomments.models.AccountSign;
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
public interface CompanyAuthenticationPresenter {
    void loadValidationCode(String phone);
    void submitAuthentication(String Licence,ArrayList<String> mNetImage, ArrayList<String> mSelectImage, CompanyAuditEntity entity);
}
