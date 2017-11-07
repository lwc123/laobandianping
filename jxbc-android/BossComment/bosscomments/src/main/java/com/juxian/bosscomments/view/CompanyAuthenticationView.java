package com.juxian.bosscomments.view;

import com.juxian.bosscomments.models.ResultEntity;

import net.juxian.appgenome.models.SignResult;

/**
 * Created by nene on 2016/11/9.
 *
 * @ProjectName: [BossComment]
 * @Package: [com.juxian.bosscomments.view]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/9 10:42]
 * @Version: [v1.0]
 */
public interface CompanyAuthenticationView {
    void CompanyAuthenticationSignResult(ResultEntity resultEntity);
    void CompanyAuthenticationSignResultFailture(String msg, Exception e);
    void showOpenAccountProgress();

    void hideOpenAccountProgress();
}
