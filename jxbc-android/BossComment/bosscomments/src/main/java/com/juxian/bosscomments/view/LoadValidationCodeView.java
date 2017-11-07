package com.juxian.bosscomments.view;

/**
 * Created by nene on 2016/11/9.
 *
 * @ProjectName: [BossComment]
 * @Package: [com.juxian.bosscomments.view]
 * @Description: [一句话描述该类的功能]
 * @Author: [ZZQ]
 * @CreateDate: [2016/11/9 10:40]
 * @Version: [v1.0]
 */
public interface LoadValidationCodeView {
    void returnLoadValidationCode(Integer result);
    void returnLoadValidationCodeFailure(String msg, Exception e);
    void showLoadValidationCodeProgress();

    void hideLoadValidationCodeProgress();
}
